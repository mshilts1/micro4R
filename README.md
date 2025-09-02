
<!-- README.md is generated from README.Rmd. Please edit that file -->

# micro4R

Microbiome data analysis tools for R

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/micro4R)](https://CRAN.R-project.org/)
<!-- badges: end -->

The goal of `micro4R` was to create an R package with a low barrier to
entry. I started my career in microbiome research at the bench and had
to
[ELI5](https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExY3hrYzg1a2I2eGtuNWIwYTRqNDMzNGE0cWlkNGE5OXB4ZHV1YXY4dCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/WsNbxuFkLi3IuGI9NU/giphy.gif)
to myself how to process and analyze “big data”. I’ve spent a ton of
time poring over and experimenting with \[others’ code\]UPDATE URL, and
want to pass it on. \# micro4R
<a href="https://mshilts1.github.io/micro4R/"><img src="man/figures/logo.png" align="right" height="139" alt="micro4R website" /></a>

Likely, the ideal candidate to benefit from `micro4R` would be a bench
scientist without much formal statistics or bioinformatics training.
Fair warning, if you already have a strong stats/informatics background,
this may not be of much use for you!

This package does not create any brand new functionality and was built
on the great work of \[others\]UPDATE URL. Much of what it does can be
accomplished with other packages, such as
[phyloseq](https://bioconductor.org/packages/release/bioc/html/phyloseq.html),
[QIIME 2](https://qiime2.org), and
[MicrobiomeAnalyst](https://www.microbiomeanalyst.ca). One of these may
be better for your purposes, and I’d encourage anyone new to the field
to explore multiple tools.

## Installation

You can install the development version of micro4R like so:

``` r
# install.packages("pak")
pak::pak("mshilts1/micro4R")
```

## Example

I’ll run through the smallest and simplest possible use case below. For
more detailed help and documentation, please explore the vignettes
*(link(s) TBA)*.

Included with the package is an extremely tiny toy example to
demonstrate its major functionality, using subsampled publicly available
[data](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA726992).

The first thing we’ll do on these files is run ‘dada2_wrapper’. This
wrapper can take a number of arguments, but the most important one is
‘where’, which is the path to where your FASTQ files are located. For
demonstration purposes, it’s been set to the path of the the example
FASTQ files included with the package.

``` r
library(micro4R)

dada2_wrapper(where = "inst/extdata/f", chatty = FALSE)
#> [1] "The total number of potential FASTQ files detected in the directory was 14, and the number of potential forward reads and reverse reads was 7. Please note that this is only performing simple pattern matching to look for standard Illumina-named files, and is only provided as a simple sanity check for you!"
#> Creating output directory: /var/folders/pp/15rq6p297j18gk2xt39kdmm40000gp/T//RtmpXymNGe/dada2_out/filtered
#> 59520 total bases in 248 reads from 7 samples will be used for learning the error rates.
#> 49600 total bases in 248 reads from 7 samples will be used for learning the error rates.
```

You can see the full path of where these are:

``` r

normalizePath("inst/extdata/f")
#> [1] "/Users/meghanshilts/Library/CloudStorage/Dropbox/Mac/Desktop/micro4R/inst/extdata/f"
```

If you’re running this with your own data, set ‘where’ to the path where
your fastq files are stored. If you leave it empty (e.g., run
`dada2_wrapper()`, it will default to your current working directory.)
‘chatty’ was set to FALSE because tons of information gets printed to
the console otherwise; I’d recommend setting it to TRUE (the default)
when you’re processing data for real, as the information is useful, just
too much here.

Next, we want to assign taxonomy to the reads.

Move information to the bottom for anyone who wants more details

subsampled FASTQ files from a
[manuscript](https://pmc.ncbi.nlm.nih.gov/articles/PMC8819187/) I
co-authored with my colleagues, for which the raw data is publicly
available under bioproject ID
[PRJNA726992](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA726992). From
seven samples from this study, using
[seqtk](https://github.com/lh3/seqtk), I randomly sampled **only 50
reads** from each FASTQ file so that the files would take up minimal
space and the example would run quickly.

Skip to the next section if you don’t care. If you’d like to run through
this the full fastq files can be downloaded from SRA or as a zipped
bolus
[here](https://drive.google.com/file/d/1NOvmsxFxWb1Vigq8rdb5SCfLLNu-Qjy8/view?usp=sharing)

Link to dada2-ified reference databases
<https://benjjneb.github.io/dada2/training.html>

- logo made by me using artwork from [Canva](https://www.canva.com/)
  (©[iconbunny11](https://www.canva.com/p/id/BAClqvm1MBE/)) followed by
  [hexSticker](https://github.com/GuangchuangYu/hexSticker) to get it
  into the typical hex logo format.

Not going to keep this on the readme, but want to hold onto the logo
code until I put it somewhere else.  
s \<- sticker(image_path, package=“micro4R”, p_size=15, p_family =
“Comfortaa”, p_fontface = “bold”, p_y = 1.5, s_x=1, s_y=.75, s_width=.5,
s_height = .5, p_color = “black”, h_fill = “\#6ed5f5”, h_color=
“\#16bc93”, h_size = 2, filename=“inst/figures/imgfile.png”).

built R 4.5.1  
RStudio Version 2025.05.1+513 (2025.05.1+513) macOS Sequoia Version
15.6.1
