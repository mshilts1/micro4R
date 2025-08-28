
<!-- README.md is generated from README.Rmd. Please edit that file -->

# micro4R

Microbiome data analysis tools for R

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/micro4R)](https://CRAN.R-project.org/)
[![R-CMD-check](https://github.com/extrasmallwinnie/micro4R/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/extrasmallwinnie/micro4R/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

# micro4R <a href="https://extrasmallwinnie.github.io/micro4R/"><img src="man/figures/logo.png" align="right" height="139" alt="micro4R website" /></a>

The goal of `micro4R` was to create an R package for essentially a past
version of myself. I started my career in microbiome research at the
bench and had to
[ELI5](https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExY3hrYzg1a2I2eGtuNWIwYTRqNDMzNGE0cWlkNGE5OXB4ZHV1YXY4dCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/WsNbxuFkLi3IuGI9NU/giphy.gif)
to myself how to process and analyze “big data”. I’ve spent a ton of
time poring over and experimenting with \[others’ code\]UPDATE URL.
Likely, the ideal candidate to benefit from `micro4R` would be another
bench scientist without much formal statistics or bioinformatics
training. Fair warning, if you already have a strong stats/informatics
background, this may not be of much use for you!

This package does not create any brand new functionality and was built
on the great work of \[others\]UPDATE URL. Much of what it does can be
accomplished with other packages. For example,
[phyloseq](https://bioconductor.org/packages/release/bioc/html/phyloseq.html)
provides many similar tools, and is very well-documented and commonly
used (I use it myself!) and so may be better for your purposes.

Other R packages heavily used here include:  
1. [tidyverse](https://tidyverse.tidyverse.org) ecosystem  
2. [vegan](https://cran.r-project.org/web/packages/vegan/index.html)  
3. [dada2](https://benjjneb.github.io/dada2/)  
4. [maaslin3](https://huttenhower.sph.harvard.edu/maaslin3/)

add MMUPHin?

## Installation

You can install the development version of micro4R like so:

``` r
# install.packages("pak")
pak::pak("extrasmallwinnie/micro4R")
```

## Example

I’ll run through the smallest and simplest possible use case below. For
more detailed help and documentation, please explore the vignettes (link
TBA)

``` r
library(micro4R)
## basic example code
```

testing
