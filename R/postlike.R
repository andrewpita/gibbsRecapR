#' calculate the posterior likelihood for betahyperMH Metropolis update
#' 
#' @description calculate the posterior likelihood for betahyperMH
#' @param x log(a/(a+b)) calculated in betahyperMH
#' @param y log(a+b) calculated in betahyperMH
#' @param phivec vector of current values of phi for each location
#' 
#' @return a single numeric value
#' 
#' @importFrom stats dbeta
#' @export

## posterior likelihood ##
postlike=function(x,y,phivec){
  sum(sapply(phivec,dbeta,exp(x+y),(1-exp(x))*exp(y),log=TRUE))+x
}