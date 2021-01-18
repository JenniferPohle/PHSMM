\name{pmleHSMM}
\alias{pmleHSMM}
\title{HSMM penalised maximum likelihood estimation}
\description{
  Estimates the parameters of a hidden semi-Markov model (HSMM) for univariate time series using numerical penalised maximum likelihood estimation. The dwell times are modelled using distributions with an unstructured start and a geometric tail. During the estimation, (higher-order) differences between adjacent dwell-time probabilities are penalised to derive smooth and flexible estimates. The function allows for normal-, gamma-, Poisson- or Bernoulli-distributions in the state-dependent process.
}
\usage{
pmleHSMM(y,N,p_list,mu,sigma=NULL,omega=NULL,delta=NULL,lambda,order_diff,y_dist=c("norm","gamma","pois","bern"),stationary=TRUE,p_ref=2,...)
}
\arguments{
  \item{y}{vector containing the observed time series.}
  \item{N}{number of states of the HSMM, integer greater than 1.}
  \item{p_list}{list of vectors containing the starting values for the state dwell-time distributions. Each of the N vectors contains the dwell-time probabilities for the unstructured start and, as last element, the probability mass captured in the geometric tail. Thus, each vector must sum to one and automatically determines the length of the unstructured start of the according state dwell-time distribution.}
  \item{mu}{starting values for the state-dependent mean values if normal, gamma or Poisson distributions are used to model the state-dependent observations. State-dependent probabilities if Bernoulli distributions are chosen. The vector is of length N and the values must be sorted in an ascending order (to avoid label switching).}
  \item{sigma}{starting values for the state-dependent standard deviations if gamma or normal state-dependent distributions are used. In that case, \code{sigma} is a vector of length N, otherwise it is \code{NULL} (default).}
  \item{omega}{starting values for the conditional transition probability matrix of the underlying semi-Markov chain. Only needed if the number of states exceeds 2, otherwise it is \code{NULL} (default). In the former case, \code{omega} is a matrix with N rows and N columns, its diagonal elements must be zero and its rows must sum to one.}
  \item{delta}{starting values for the initial distribution of the underlying semi-Markov chain if \code{stationary=FALSE}. In that case, \code{delta} is a vector of dimension N and its elements must sum to one. For \code{stationary=TRUE}, delta is ignored and can be set to \code{NULL} (default).}
  \item{lambda}{vector of length N containing the smoothing parameter values to weight the penalty term.}
  \item{order_diff}{order of the differences used for the penalty term, positive integer which does not exceed the length of the unstructured starts (as determined by \code{p_list}).}
  \item{y_dist}{character determining the class of state-dependent distributions used to model the observations. Supported values are \code{"norm"} (normal distribution), \code{"gamma"} (gamma distribution), \code{"pois"} (Poisson distribution) and \code{"bern"} (Bernoulli distribution).}
  \item{stationary}{Logical, if \code{TRUE} (default), stationarity is assumed, if \code{FALSE}, an initial distribution is estimated and the underlying state-sequence is assumed to enter a new state at time t=1.}
  \item{p_ref}{positive integer determining the reference dwell-time probability used for the multinomial logit parameter transformation. Default value is 2. Only needs to be changed if the dwell-time probability for dwell time r=2 is estimated very close to zero in order to avoid numerical problems.}
  \item{...}{settings for the optimisation procedure \code{nlm}. Default settings are \code{print.level=0}, \code{iterlim=10000}, \code{stepmax=NULL} (corresponding to the \code{nlm} default), \code{hessian=FALSE} and \code{gradtol=10^(-6)}. See \code{\link[stats]{nlm}} for details.}
}
\value{
an HSMM model object, i.e. a list containing:
  \item{p_list}{list containing the penalised maximum likelihood estimates for the state dwell-time distributions.}
  \item{mu}{vector containing the penalised maximum likelihood estimates for the state-dependent mean values or state-dependent probabilities, depending on the chosen class of state-dependent distributions.}
  \item{sigma}{vector containing the penalised maximum likelihood estimates for the state-dependent standard deviations. Only returned for state-dependent gamma or normal distributions.}
  \item{delta}{vector containing the equilibrium distribution if \code{stationary=TRUE}, otherwise vector of the estimated initial distribution.}
  \item{omega}{penalised maximum likelihood estimate of the conditional transition probability matrix.}
  \item{Gamma}{transition probability matrix corresponding to the HMM representation of the estimated HSMM.}
  \item{npll}{minimum negative penalised log likelihood value as found by nlm.}
  \item{gradient}{gradient of the negative penalised log-likelihood function as returned by nlm.}
  \item{iterations}{number of iterations until convergence.}
  \item{code_conv}{convergence code as returned by nlm.}
  \item{w_parvect}{vector of the penalised maximum likelihood working parameters.}
  \item{stationary}{Logical, as specified for the estimation.}
  \item{y_dist}{state-dependent distribution specified for the estimation.}
}
\details{
The numerical penalised maximum likelihood estimation requires starting values for each HSMM parameter. If these starting values are poorly chosen, the algorithm might fail in finding the global optimum of the penalised log-likelihood function. Therefore, it is highly recommended to repeat the estimation several times using different sets of starting values.

The maximisation of the penalised log-likelihood function is carried out using the optimisation routine \code{nlm}. The likelihood evaluation is written in \code{C++} to speed up the estimation.
}
\references{
See \code{\link{nlm}} for further details on the numerical optimisation routine.

For details on the model formulation and likelihood function, see:

Langrock, R. and Zucchini W. (2011): Hidden Markov models with arbitrary state dwell-time distributions. \emph{Computational Statistics and Data Analysis}, \strong{55}, p. 715--724.

Zucchini, W., MacDonald, I.L. and Langrock, R. (2016): \emph{Hidden Markov models for time series:
An introduction using R}. 2nd edition. Chapman & Hall/CRC, Boca Raton.
}
\examples{
# fit 3-state HSMM to hourly muskox step length
# initial values
p_list0<-list()
p_list0[[1]]<-c(dgeom(0:9,0.2),1-pgeom(9,0.2))
p_list0[[2]]<-c(dgeom(0:9,0.2),1-pgeom(9,0.2))
p_list0[[3]]<-c(dgeom(0:9,0.2),1-pgeom(9,0.2))
omega0<-matrix(0.5,3,3)
diag(omega0)<-0
mu0<-c(5,100,350)
sigma0<-c(3,90,300)
# fit HSMM with state-dependent gamma distributions, lambda=c(1000,1000,1000) and difference order of 3
PHSMM<-pmleHSMM(y=muskox$step,N=3,p_list=p_list0,mu=mu0,sigma=sigma0,omega=omega0,lambda=c(1000,1000,1000),order_diff=3,y_dist='gamma')
}

