#' Metropolis-Hastings update for the beta prior hyper parameters
#' 
#' @description Metropolis-Hastings update for beta prior hyper-parameters
#' @param a current a.phi parameter to be updated
#' @param b current b.phi parameter to be updated
#' @param atune Tuning parameter one
#' @param btune Tuning parameter two
#' @param phivec vector of current values of phi for each location
#' 
#' @return a numeric vector
#' 
#' @importFrom truncnorm rtruncnorm
#' @importFrom stats runif
#' 
#' @export



betahyperMH=function(a,b,atune,btune,phivec){
  #print(phivec)
  x=log(a/(a+b))
  y=log(a+b)
  
  xnew=rtruncnorm(1,a=-y,b=log(1-exp(-y)),x,atune)
  rx=postlike(xnew,y,phivec)-postlike(x,y,phivec)
  #print(xnew)
  
  ux=runif(1,0,1)
  if(rx>log(ux)) x=xnew
  
  ynew=rtruncnorm(1,a=max(-x,-log(1-exp(x))),b=Inf,y,btune)
  ry=postlike(x,ynew,phivec)-postlike(x,y,phivec)
  #print(ynew)
  
  uy=runif(1,0,1)
  if(ry>log(uy)) y=ynew
  
  #print(c(x,y))
  c(exp(x+y),(1-exp(x))*exp(y))
  
}