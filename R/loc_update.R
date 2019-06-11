#' Workhouse function that updates previous iterations estimates for a single location
#' 
#' @description updates parameters for a single location
#' @param locList list containing a data frame and current parameters for each location
#' @param a.phi alpha hyperparameter for beta prior for overall phi
#' @param b.phi beta hyperparameter for beta prior for overall phi
#' 
#' @return a numeric matrix
#' 
#' @importFrom extraDistr rmvhyper
#' @importFrom stats rnbinom rbeta rhyper runif rbinom
#' 
#' @export


loc_update = function(locList, a.phi, b.phi) {
  
  #grab the number of listings including survey
  nListings = nrow(locList[[1]])
  
  
  ##### calculate x for phi and N update
  #x = phi.location * (1 - inclusion prob)
  x = locList[[6]] * (1 - locList[[1]][1,3])
  
  for (i in 2:nListings) {
    
    x = x*(1 - locList[[1]][i,3])
    
  }
  
  ######
  
  ###### calculate r for N update
  
  if (nListings == 2) {
    
    A = locList[[1]][2,1] #source beside survey
    B = locList[[1]][1,1] # survey
    AB = locList[[1]][2,2] #overlap between survey and other source
    
    r = A + B - AB
    
  } else if (nListings == 3) {
    
    A = locList[[1]][2,1] #source beside survey
    B = locList[[1]][3,1] #other source beside survey
    C = locList[[1]][1,1] #the survey
    ABC = locList[[1]][1,2] #all three sources
    BC = locList[[1]][3,2] #B and C overlap
    AC = locList[[1]][2,2] #A and C overlap
    
    nA.BC = BC - ABC
    nA = locList[[2]] - A
    
    #### calculate r for N update
    
    #vector containing AB, not A B = c(ABC, notA BC) + 1 draw from multivariate hyper of
    #B - (ABC + notA BC balls), with A - ABC balls of one color, and not A - ABC balls of another
    AB.nAB.vec = c(ABC, nA.BC) + 
      rmvhyper(1, 
               k = B - ABC - nA.BC,
               n = c(A - ABC, 
                     nA - ABC))
    
    #r = A + B + C - AC - BC - (AB - ABC)
    r = A + B + C - AC - BC - (AB.nAB.vec[1] - ABC)
    
    #####
    
    
  }
  
  
  #### update N
  locList[[2]] = r + rbinom(1, locList[[3]] - r, x/(1 - locList[[6]] + x))
  
  #### update inclusion probs
  
  for (i in 1:nListings) {
    
    locList[[1]][i,3] = rbeta(1, locList[[4]] + locList[[1]][i,1], 
                              locList[[5]] + locList[[2]] - locList[[1]][i,1])
  }
  
  #### update phi
  
  locList[[6]] = rbeta(1,a.phi + locList[[2]], b.phi + locList[[3]] - locList[[2]])
  
  ####
  
  return(locList)
  
}