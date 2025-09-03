
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

The first thing we’ll do on these files is run ‘dada2_asvtable()’. This
function can take a number of arguments, but the most important one is
‘where’, which is the path to where your FASTQ files are located.  
For demonstration purposes, it’s been set to the relative path of the
the example FASTQ files that are included with the package:

``` r
library(micro4R)

asvtable <- dada2_asvtable(where = "inst/extdata/f", chatty = FALSE)
#> Creating output directory: /var/folders/pp/15rq6p297j18gk2xt39kdmm40000gp/T//Rtmp8ajRV1/dada2_out/filtered
#> 59520 total bases in 248 reads from 7 samples will be used for learning the error rates.
#> 49600 total bases in 248 reads from 7 samples will be used for learning the error rates.
tibble::as_tibble(asvtable, rownames = "SampleID")
#> # A tibble: 7 × 7
#>   SampleID  TACGTAGGTGGCAAGCGTTA…¹ TACGGAGGGTGCAAGCGTTA…² TACGTAGGGTGCGAGCGTTG…³
#>   <chr>                      <int>                  <int>                  <int>
#> 1 SAMPLED_…                      0                      0                      0
#> 2 SAMPLED_…                      0                      0                      0
#> 3 SAMPLED_…                     44                      0                      0
#> 4 SAMPLED_…                     24                      0                      0
#> 5 SAMPLED_…                      0                      0                     12
#> 6 SAMPLED_…                      0                     35                      6
#> 7 SAMPLED_…                      0                      0                      0
#> # ℹ abbreviated names:
#> #   ¹​TACGTAGGTGGCAAGCGTTATCCGGAATTATTGGGCGTAAAGCGCGCGTAGGCGGTTTTTTAAGTCTGATGTGAAAGCCCACGGCTCAACCGTGGAGGGTCATTGGAAACTGGAAAACTTGAGTGCAGAAGAGGAAAGTGGAATTCCATGTGTAGCGGTGAAATGCGCAGAGATATGGAGGAACACCAGTGGCGAAGGCGACTTTCTGGTCTGTAACTGACGCTGATGTGCGAAAGCGTGGGGATCAAACAGG,
#> #   ²​TACGGAGGGTGCAAGCGTTAATCGGAATTACTGGGCGTAAAGCGCACGCAGGCGGTCTGTCAAGTCGGATGTGAAATCCCCGGGCTCAACCTGGGAACTGCATTCGAAACTGGCAGGCTAGAGTCTTGTAGAGGGGGGTAGAATTCCAGGTGTAGCGGTGAAATGCGTAGAGATCTGGAGGAATACCGGTGGCGAAGGCGGCCCCCTGGACAAAGACTGACGCTCAGGTGCGAAAGCGTGGGGAGCAAACAGG,
#> #   ³​TACGTAGGGTGCGAGCGTTGTCCGGAATTACTGGGCGTAAAGGGCTCGTAGGTGGTTTGTCGCGTCGTCTGTGAAATTCTGGGGCTTAACTCCGGGCGTGCAGGCGATACGGGCATAACTTGAGTGCTGTAGGGGTAACTGGAATTCCTGGTGTAGCGGTGAAATGCGCAGATATCAGGAGGAACACCGATGGCGAAGGCAGGTTACTGGGCAGTTACTGACGCTGAGGAGCGAAAGCATGGGTAGCGAACAGG
#> # ℹ 3 more variables:
#> #   TACGTAGGGTGCAAGCGTTGTCCGGAATTACTGGGCGTAAAGAGCTCGTAGGTGGTTTGTCACGTCGTCTGTGAAATTCCACAGCTTAACTGTGGGCGTGCAGGCGATACGGGCTGACTTGAGTACTGTAGGGGTAACTGGAATTCCTGGTGTAGCGGTGAAATGCGCAGATATCAGGAGGAACACCGATGGCGAAGGCAGGTTACTGGGCAGTTACTGACGCTGAGGAGCGAAAGCATGGGTAGCAAACAGG <int>,
#> #   TACGTAGGTGACAAGCGTTGTCCGGATTTATTGGGCGTAAAGGGAGCGCAGGCGGTCTGTTTAGTCTAATGTGAAAGCCCACGGCTTAACCGTGGAACGGCATTGGAAACTGACAGACTTGAATGTAGAAGAGGAAAATGGAATTCCAAGTGTAGCGGTGGAATGCGTAGATATTTGGAGGAACACCAGTGGCGAAGGCGATTTTCTGGTCTAACATTGACGCTGAGGCTCGAAAGCGTGGGGAGCGAACAGG <int>, …
```

If you’re running this with your own data, set ‘where’ to the path where
your fastq files are stored. If you leave it empty (e.g., run
`dada2_asvtable()`, it will default to your current working directory.)
(‘chatty’ was set to FALSE because tons of information gets printed to
the console otherwise; I’d recommend setting it to TRUE (the default)
when you’re processing data for real, as the information is useful, but
just too much here.)

Now we have a bunch of literal DNA sequences. That’s great, but what are
they? The next step will take the sequences and compare them against a
database or two of sequences with known taxonomy:

``` r
train <- "inst/extdata/db/EXAMPLE_silva_nr99_v138.2_toGenus_trainset.fa.gz"
species <- "inst/extdata/db/EXAMPLE_silva_v138.2_assignSpecies.fa.gz"
dada2_taxa(asvtable = asvtable, train = train, species = species, chatty = FALSE)
```

There are two databases that we’re using for taxonomic assignment
here:  
1. ‘train’ needs to be the path to whatever you’d like to use as the
“training set of reference sequences with known taxonomy”.  
2. ‘species’ is OPTIONAL. If you’d like to use this option, provide the
path to a specifically formatted species assignment database. (Read more
[here](https://benjjneb.github.io/dada2/assign.html#species-assignment).)

**The two databases used in the example here are comically small and
artificial, and should only ever be used for testing and demonstration
purposes.** You’ll definitely want/need to download the real
[databases](https://benjjneb.github.io/dada2/training.html) for your
actual data!

There are many options for taxonomic databases you can use; the major
players are SILVA, RDP, GreenGenes, and UNITE. Please go
[here](https://benjjneb.github.io/dada2/training.html) for details and
links. I tend to usually use the SILVA databases, but you don’t have to.

------------------------------------------------------------------------

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
