#' Create posterior distribution for parameters by combining all gibbs chains
#' 
#' @description Create posterior distribution for parameters by combining all gibbs chains
#' 
#' @param chainList list where each element is an output chain from gibbs_chain()
#' 
#' @export

make_posterior = function(chainList) {
  
  posterior = chainList[[1]]
  
  for (i in 2:length(chainList)) {
    
    posterior = rbind(posterior, chainList[[i]])
    
  }
  
}