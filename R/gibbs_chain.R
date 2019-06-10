#' Runs a gibbs sampler chain for capture recapture data
#' 
#' @description Runs a gibbs chain for capture recapture data 
#' 
#' @param dataList list containing a locList for each location
#' @param seed a seed
#' @param N number of iterations for the gibbs sampler, default is 10,000
#' @param atune Tuning parameter for the Metropolis-Hastings update of beta hyperparameters. Default is 0.25.
#' @param btune Tuning parameter for Metropolis-Hastings update of beta hyperparamters. Defaults is 1. 
#' 
#' @return a numeric matrix
#' 
#' 
#' @export


gibbs_chain = function(dataList, seed, N = 10000, 
                       atune = 0.25,btune = 1) {
  
    
    #set arbitrary initial starting values for each N.location
    #calculate dimensions for matrix to store each iteration's values
    num_cols = 0
  
    for (i in 1:length(dataList)) {
      
      num_cols = num_cols + nrow(dataList[[i]][[1]]) + 2
      dataList[[i]][[2]] = round(dataList[[i]][[3]] * dataList[[i]][[6]])
    }
  
    #create empty matrix for to store values
    M = matrix(0, N, num_cols)
    
    #emtpy matrix for a.phi and b.phi
    M.phi = matrix(0,N,2)
    
    #arbitary initial values for a.phi and b.phi
  
    a.phi = b.phi = 1.5
    
    set.seed(seed)

    
    #update each location iteratively N times
    
    for (i in 1:N) {
      
      #for each j locations update parameters with loc_update
      #store updated phi in phi.vec
      
      phi.vec = rep(NA, length(dataList))
      
      for (j in 1:length(dataList)) {
        
        dataList[[j]] = loc_update(dataList[[j]], a.phi, b.phi)
        
        phi.vec[j] = dataList[[j]][[6]]
        
      }
      
      #after each location is updated, update phi 
      
      abphi=betahyperMH(a.phi,b.phi,atune,btune,phi.vec)
      #print(abphi)
      a.phi=abphi[1]
      b.phi=abphi[2]
      M.phi[i,] = c(a.phi,b.phi)
      
      #grab all relevant parameters for this iteration
      #to be stored in matrix M
      
      row.vec = c(dataList[[1]][[1]][,3],
                  dataList[[1]][[2]],
                  dataList[[1]][[6]])
      
      if (length(dataList) > 1) {
        
        for (j in 2:length(dataList)) {
          
          row.vec = c(row.vec,c(dataList[[j]][[1]][,3],
                                dataList[[j]][[2]],
                                dataList[[j]][[6]]))
        }
        
      }
      
      M[i,] = row.vec
    }
  
    M = cbind(M, M.phi)
    
    #burn first half of observations
    M.burn = M[round((nrow(M)/2)):nrow(M),]
    
    return(M.burn)
}