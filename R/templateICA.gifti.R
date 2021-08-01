#' Template ICA for GIFTI
#'
#' Run template ICA based on GIFTI-format BOLD data and GIFTI-based template
#' Assumes we are NOT using the spatial model
#'
#' @param gifti_fname File path of GIFTI-format timeseries data (ending in .func.gii).
#' @param template_mean Mean of ICA components computed using estimate_template.gifti.R
#' @param template_var Variance of ICA components computed using estimate_template.gifti.R
#' @param scale Logical indicating whether BOLD data should be scaled by the spatial
#' standard deviation before model fitting. If done when estimating templates, should be done here too.
#' @param Q2 The number of nuisance ICs to identify. If NULL, will be estimated. Only provide \eqn{Q2} or \eqn{maxQ} but not both.
#' @param maxQ Maximum number of ICs (template+nuisance) to identify (L <= maxQ <= T). Only provide \eqn{Q2} or \eqn{maxQ} but not both.
#' @param maxiter Maximum number of EM iterations. Default: 100.
#' @param epsilon Smallest proportion change between iterations. Default: 0.001.
#' @param verbose If \code{TRUE} (default), display progress of algorithm.
#' @param kappa_init Starting value for kappa.  Default: \code{0.2}.
# @param common_smoothness If \code{TRUE}. use the common smoothness version of the spatial template ICA model, which assumes that all IC's have the same smoothness parameter, \eqn{\kappa}
#' @param write_dir Where should any output files be written? \code{NULL} (default) will write them to the current working directory

# @importFrom INLA inla.pardiso.check inla.setOption
#' @importFrom gifti read_gifti
#'
#' @return A list containing the subject IC mean estimates (class 'gifti'), the subject IC variance estimates (class 'gifti'), and the result of the model call to \code{templateICA} (class 'dICA')
#'
#' @export
#'
templateICA.gifti <- function(gifti_fname,
                              template_mean,
                              template_var,
                              mwall,
                              scale=TRUE,
                              Q2=NULL,
                              maxQ=NULL,
                              maxiter=100,
                              epsilon=0.001,
                              verbose=TRUE,
                              #common_smoothness=TRUE,
                              kappa_init=0.2,
                              write_dir=NULL){

  if (is.null(write_dir)) { write_dir <- getwd() }

  # READ THE MEDIAL WALL FILE
  if(!file.exists(mwall)) stop(paste0('The medial wall file ', mwall, ' does not exist.'))
  if(verbose) cat('Reading the medial wall file.')
  mwall <- as.matrix(read.table(mwall))

  # GET TEMPLATE MEAN AND VARIANCE (xifti objects)
  template_mean <- read_gifti(template_mean)
  icaMean <- do.call(cbind, template_mean$data)
  icaMean <- icaMean[mwall,]

  V <- nrow(icaMean); Q <- ncol(icaMean)

  template_var <- read_gifti(template_var)
  icaVar <- do.call(cbind, template_var$data)
  icaVar <- icaVar[mwall,]

  # READ IN BOLD TIMESERIES DATA
  if(!file.exists(gifti_fname)) stop(paste0('The BOLD timeseries file ', gifti_fname,' does not exist.'))
  if(verbose) cat('Reading in BOLD timeseries data.\n')

  BOLD_gifti <- read_gifti(gifti_fname)
  BOLD_mat <- do.call(cbind, BOLD_gifti$data)
  BOLD_mat <- BOLD_mat[mwall,]

  # compute templated ICA for subject
  result <- templateICA(template_mean = icaMean,
                        template_var = icaVar,
                        BOLD = BOLD_mat,
                        scale = scale,
                        meshes = NULL,
                        Q2 = Q2,
                        maxQ=maxQ,
                        maxiter=maxiter,
                        epsilon=epsilon,
                        verbose=verbose,
                        kappa_init=kappa_init)

  est_mean <- est_var <- template_mean
  for (i in 1:Q) { est_mean$data[[i]] = result$subjICmean[,i] }
  for (i in 1:Q) { est_var$data[[i]] = result$subjICvar[,i] }

  RESULT <- list(
    subjICmean_gifti = est_mean,
    subjICvar_gifti = est_var,
    model_result = result
  )

  class(RESULT) <- 'templateICA.gifti'

  return(RESULT)

}