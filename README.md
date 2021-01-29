
<!-- README.md is generated from README.Rmd. Please edit that file -->

# templaceICAr

<!-- badges: start -->

[![Travis build
status](https://travis-ci.com/mandymejia/templateICAr.svg?branch=master)](https://travis-ci.com/mandymejia/templateICAr)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/mandymejia/templateICAr?branch=master&svg=true)](https://ci.appveyor.com/project/mandymejia/templateICAr)
[![Coveralls test
coverage](https://coveralls.io/repos/github/mandymejia/templateICAr/badge.svg)](https://coveralls.io/github/mandymejia/templateICAr)
<!-- badges: end -->

This package contains functions implementing the template ICA model
proposed in Mejia et al. (2019) and the spatial template ICA model
proposed in proposed in Mejia et al. (2020+). For both models,
subject-level brain networks are estimated as deviations from known
population-level networks, which can be estimated using standard ICA
algorithms. Both models employ an expectation-maximization algorithm for
estimation of the latent brain networks and unknown model parameters.

Template ICA consists of three steps. The main functions associated with each step are listed below.  Functions ending in `.cifti` or `.nifti` are designed to work directly with CIFTI or NIFTI-format fMRI data.
1. Template estimation (functions: `estimate_template.cifti` and `estimate_template.nifti`)
2. Template ICA model estimation (single-subject) (functions: `templateICA`, `templateICA.cifti` and `templateICA.nifti`)
3. Identification of areas of engagement in each IC (or deviation from the template mean) (functions: `activations`, `activations.cifti`)



## Installation

You can install the development version of `templaceICAr` from Github with:

``` r
# install.packages("devtools")
devtools::install_github("templaceICAr")
```


## Important Notes on Dependencies:

To analyze or visualize CIFTI-format data, `templateICAr` depends on the `ciftiTools` package, which requires an installation of Connectome Workbench.  It can be installed from the [HCP website](https://www.humanconnectome.org/software/get-connectome-workbench).

For fitting *spatial* template ICA model, an installation of INLA is required.  INLA is NOT required for running standard template ICA.
 Due to a CRAN policy, INLA cannot be installed automatically. You can obtain it by running `install.packages("INLA", repos=c(getOption("repos"), INLA="https://inla.r-inla-download.org/R/stable"), dep=FALSE)`.  The default R-INLA binaries are built on Ubuntu1604. Instructions on how to obtain binaries for other Linux builds are available at http://www.r-inla.org/events/alternativelinuxbuilds.



