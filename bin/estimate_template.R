library('optparse')
library('gifti')
library('templateICAr')

option_list = list(
    make_option(c("-b", "--bold-files"), 
                type="character", 
                default=NULL,
                help="Path to list of BOLD images.", 
                metavar="character"),
    make_option(c("-g", "--group-components"),
                type="character",
                default=NULL,
                help="Path to group-ICA components.",
                metavar="character"),
    make_option(c("-o", "--out-names"),
                type="character",
                default=NULL,
                help="Output base name for mean and variance template estimates.",
                metavar="character")
);

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);