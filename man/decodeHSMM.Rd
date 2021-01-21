\name{decodeHSMM}
\alias{decodeHSMM}
\title{State decoding}
\description{
HSMM state decoding based on the Viterbi algorithm and the corresponding HMM model representation.}
\usage{
decodeHSMM(y,mod)
}
\arguments{
  \item{y}{vector containing the observed time series.}
  \item{mod}{model object as returned by \code{pmleHSMM}.}
}
\value{
 returns a vector containing the decoded states.
}
\references{
For more details about the Viterbi algorithm, see for example:

Zucchini W., MacDonald, I.L. and Langrock, R. (2016): \emph{Hidden Markov models for time series:
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
# fit HSMM with state-dependent gamma distributions,
# lambda=c(1000,1000) and difference order of 3
PHSMM<-pmleHSMM(y=muskox$step,N=3,p_list=p_list0,mu=mu0,sigma=sigma0,
  omega=omega0,lambda=c(1000,1000,1000),order_diff=3,y_dist='gamma')
# state decoding
s_HSMM<-decodeHSMM(muskox$step,mod=PHSMM)
# plot sequence of the decoded time series
plot(muskox$step[1:1000],type='h',xlab='time (h)',ylab='step (m)',main='',col=s_HSMM)
legend('topright',c('state 1','state 2', 'state 3'),lwd=2,col=1:3)
}
