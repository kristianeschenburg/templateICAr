#!/usr/bin/env Rscript

library('optparse')
library('gifti')
library('templateICAr')

option_list = list(
    make_option(c("-b", "--boldFiles"), 
                type="character", 
                default=NULL,
                help="Path to list of BOLD images.", 
                metavar="character"),

    make_option(c("-g", "--gICA"),
                type="character",
                default=NULL,
                help="Path to group-ICA components.",
                metavar="character"),

    make_option(c("-o", "--outBase"),
                type="character",
                default=NULL,
                help="Output base name for mean and variance template estimates.",
                metavar="character")
);

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

print(opt)

print('Estimating templateICA mean and variance.')
estimate_template.gifti(gifti_fnames=opt$boldFiles, 
                        GICA_fname=opt$gICA,
                        out_fname=opt$outBase)