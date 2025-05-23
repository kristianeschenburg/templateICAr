% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/templateICA.gifti.R
\name{templateICA.gifti}
\alias{templateICA.gifti}
\title{Template ICA for GIFTI}
\usage{
templateICA.gifti(
  gifti_fname,
  template_mean,
  template_var,
  mwall,
  scale = TRUE,
  Q2 = NULL,
  maxQ = NULL,
  maxiter = 100,
  epsilon = 0.001,
  verbose = TRUE,
  kappa_init = 0.2,
  write_dir = NULL
)
}
\arguments{
\item{gifti_fname}{File path of GIFTI-format timeseries data (ending in .func.gii).}

\item{template_mean}{Mean of ICA components computed using estimate_template.gifti.R}

\item{template_var}{Variance of ICA components computed using estimate_template.gifti.R}

\item{scale}{Logical indicating whether BOLD data should be scaled by the spatial
standard deviation before model fitting. If done when estimating templates, should be done here too.}

\item{Q2}{The number of nuisance ICs to identify. If NULL, will be estimated. Only provide \eqn{Q2} or \eqn{maxQ} but not both.}

\item{maxQ}{Maximum number of ICs (template+nuisance) to identify (L <= maxQ <= T). Only provide \eqn{Q2} or \eqn{maxQ} but not both.}

\item{maxiter}{Maximum number of EM iterations. Default: 100.}

\item{epsilon}{Smallest proportion change between iterations. Default: 0.001.}

\item{verbose}{If \code{TRUE} (default), display progress of algorithm.}

\item{kappa_init}{Starting value for kappa.  Default: \code{0.2}.}

\item{write_dir}{Where should any output files be written? \code{NULL} (default) will write them to the current working directory}
}
\value{
A list containing the subject IC mean estimates (class 'gifti'), the subject IC variance estimates (class 'gifti'), and the result of the model call to \code{templateICA} (class 'dICA')
}
\description{
Run template ICA based on GIFTI-format BOLD data and GIFTI-based template
Assumes we are NOT using the spatial model
}
