#!/usr/bin/env Rscript

library('optparse')
library('gifti')
library('templateICAr')

option_list = list(
    make_option(c("-b", "--boldFile"), 
                type="character", 
                default=NULL,
                help="Path to subject-level BOLD image.", 
                metavar="character"),

    make_option(c("--templateMean"),
                type="character",
                default=NULL,
                help="Path to template mean.",
                metavar="character"),

    make_option(c("--templateVariance"),
                type="character",
                default=NULL,
                help="Path to template variance.",
                metavar="character"),

    make_option(c("-w", "--mwall"),
                type="character",
                default=NULL,
                help="Path to medial wall components.",
                metavar="character"),

    make_option(c("--iters"), 
                type="integer", 
                default=500,
                help="Number of random normals to generate [default %default]",
                metavar="character"),
                
    make_option(c("--scale"), 
                action="store_true", 
                default=False,
                help="Scale BOLD data by spatial standard deviation."),

    make_option(c("-o", "--outBase"),
                type="character",
                default=NULL,
                help="Output name subject-level dual regression output.",
                metavar="character")
);

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

print(opt)

output_dir=dirname(opt$outBase)
if (!file.exists(output_dir)) {dir.create(output_dir)}

# READ THE MEDIAL WALL FILE
if(!file.exists(opt$mwall)) stop(paste0('The medial wall file ', opt$mwall, ' does not exist.'))
cat('Reading the medial wall file.\n')
mwall <- as.matrix(read.table(opt$mwall))

# GET TEMPLATE MEAN AND VARIANCE (xifti objects)
if(!file.exists(opt$templateMean)) stop(paste0('The mean estimate file ', opt$templateMean, ' does not exist.'))
cat('Reading mean estimate file.\n')
template_mean <- read_gifti(opt$templateMean)
tempMean <- do.call(cbind, template_mean$data)
V <- nrow(tempMean); Q <- ncol(tempMean)
tempMean <- tempMean[mwall,]

if(!file.exists(opt$templateVariance)) stop(paste0('The mean estimate file ', opt$templateVariance, ' does not exist.'))
cat('Reading mean estimate file.\n')
template_variance <- read_gifti(opt$templateVariance)
tempVar <- do.call(cbind, template_variance$data)
tempVar <- tempVar[mwall,]

# READ IN BOLD TIMESERIES DATA
if(!file.exists(opt$boldFile)) stop(paste0('The BOLD timeseries file ', opt$boldFile,' does not exist.'))
cat('Reading in BOLD timeseries data.\n')

BOLD_gifti <- read_gifti(opt$boldFile)
BOLD_mat <- do.call(cbind, BOLD_gifti$data)
BOLD_mat <- BOLD_mat[mwall,]

cat('Estimating templateICA on subject-level BOLD data with ', Q, 'components.\n')
result <- templateICA(template_mean = tempMean,
                        template_var = tempVar,
                        BOLD = BOLD_mat,
                        scale = opt$scale,
                        meshes = NULL,
                        maxiter=opt$iters)

est_mean <- est_sigma <- template_mean
mu <- sigma<- matrix(0,V,Q)

cat('Saving estimated subject mean.\n')
mu[mwall,] = as.matrix(result$subjICmean)
for (i in 1:Q) { est_mean$data[[i]] = mu[,i] }
out_fname_mean = paste0(opt$outBase,".templateICA.Mean.func.gii")
write_gifti(gii=est_mean, out_file=out_fname_mean)

cat('Saving estimated subject variance.\n')
sigma[mwall,] = as.matrix(result$subjICvar)
for (i in 1:Q) { est_sigma$data[[i]] = sigma[,i] }
out_fname_variance = paste0(opt$outBase,".templateICA.Variance.func.gii")
write_gifti(gii=est_sigma, out_file=out_fname_variance)