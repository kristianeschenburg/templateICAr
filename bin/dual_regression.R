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

    make_option(c("-g", "--gICA"),
                type="character",
                default=NULL,
                help="Path to group-ICA components.",
                metavar="character"),

    make_option(c("-w", "--mwall"),
                type="character",
                default=NULL,
                help="Path to medial wall components.",
                metavar="character"),

    make_option(c("-o", "--outBase"),
                type="character",
                default=NULL,
                help="Output name subject-level dual regression output.",
                metavar="character")
);

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

print(opt)

if(!file.exists(mwall)) stop(paste0('The bold image file ', opt$boldFile, ' does not exist.'))
if(verbose) cat('Reading the bold image file.\n')
bold_img = read_gifti(opt$boldFile)
bold_mat = do.call(cbind, bold_img$data)

if(!file.exists(mwall)) stop(paste0('The template networks file ', opt$gICA, ' does not exist.'))
if(verbose) cat('Reading the tempalte ICA networks file.\n')
template_img = read_gifti(opt$gICA)
template = do.call(cbind, template_img$data)

V<-nrow(template); Q<-ncol(template)

if(!file.exists(mwall)) stop(paste0('The medial wall file ', opt$mwall, ' does not exist.'))
if(verbose) cat('Reading the medial wall file.\n')
mwall <- as.matrix(read.table(opt$mwall))

DR = dual_reg(bold_mat[mwall,], template[mwall,])
estimates <- matrix(0,V,Q)
estimates[mwall,] = t(DR$S)
for (i in 1:Q) { template_img$data[[i]] = estimates[,i] }