# Assess sequencing results

Assess sequencing results

## Usage

``` r
assess_run(
  metadata = NULL,
  asvtable = NULL,
  taxa = NULL,
  wells = "Well",
  plate = NULL,
  category = NULL,
  minReadCount = 0,
  pcoa = FALSE,
  corrplot = FALSE,
  ...
)
```

## Arguments

- metadata:

  metadata object

- asvtable:

  asvtable object

- taxa:

  taxa object

- wells:

  wells for each sample. Expecting A01, A02, etc.

- plate:

  plate samples were on. Can be left as NULL if there's only one plate.

- category:

  Variable to classify the samples. Makes the most sense if positive and
  negative controls are labeled.

- minReadCount:

  Minimum number of total reads for sample to be kept. Recommend to keep
  it at 0, but can change that if you want.

- pcoa:

  Include PCoA data (can significantly increase run time, so set to
  FALSE by default)

- corrplot:

  Generate correlation plots. Set to FALSE by default as for now not
  sure how helpful it actually is

- ...:

  Allows passing of arguments to nested functions. not being used at the
  moment.

## Value

HTML report summarizing results

## Examples

``` r
out <- micro4R::assess_example
m <- out$metadata
a <- out$asvtable
t <- out$taxa
c <- "SampleType"

assess_run(metadata = m, asvtable = a, taxa = t, wells = "well", plate = "Plate", category = c)
#> 
#> 
#> processing file: Run_assessment.Rmd
#> 1/20                     
#> 2/20 [setup]             
#> 3/20                     
#> 4/20 [example]           
#> 5/20                     
#> 6/20 [readcounts]        
#> 7/20                     
#> 8/20 [readcounts_boxplot]
#> 9/20                     
#> 10/20 [poscontrol]        
#> 11/20                     
#> 12/20 [readcount_id_map]  
#> 13/20                     
#> 14/20 [empty]             
#> 15/20                     
#> 16/20 [heatmap_plots]     
#> 17/20                     
#> 18/20 [heatmap_plots_pcoa]
#> 19/20                     
#> 20/20 [heatmap_corrplot]  
#> output file: Run_assessment.knit.md
#> /opt/hostedtoolcache/pandoc/3.1.11/x64/pandoc +RTS -K512m -RTS Run_assessment.knit.md --to html4 --from markdown+autolink_bare_uris+tex_math_single_backslash --output Run_assessment.html --lua-filter /home/runner/work/_temp/Library/rmarkdown/rmarkdown/lua/pagebreak.lua --lua-filter /home/runner/work/_temp/Library/rmarkdown/rmarkdown/lua/latex-div.lua --embed-resources --standalone --variable bs3=TRUE --section-divs --table-of-contents --toc-depth 4 --variable toc_float=1 --variable toc_selectors=h1,h2,h3,h4 --variable toc_collapsed=1 --variable toc_smooth_scroll=1 --variable toc_print=1 --template /home/runner/work/_temp/Library/rmarkdown/rmd/h/default.html --highlight-style tango --number-sections --variable theme=cosmo --mathjax --variable 'mathjax-url=https://mathjax.rstudio.com/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML' --include-in-header /tmp/RtmpaIs71o/rmarkdown-str19ea2e2a3a95.html 
#> 
#> Output created: Run_assessment.html
```
