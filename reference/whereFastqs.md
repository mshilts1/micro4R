# Collection of helper/utility functions not really intended to be directly used by end user Path to user's fastq file folder

Collection of helper/utility functions not really intended to be
directly used by end user Path to user's fastq file folder

## Usage

``` r
whereFastqs(path = NULL, chatty = TRUE, return_tibble_or_path = "path")
```

## Arguments

- path:

  Path to folder containing fastq files

- chatty:

  If set to FALSE, don't print as much to console.

- return_tibble_or_path:

  Default is 'path', but instead can have it return a tibble of the
  files it found. should only ever be used for troubleshooting.

## Value

file path to a folder

## Examples

``` r
whereFastqs(".")
#> # A tibble: 31 × 1
#>    value               
#>    <chr>               
#>  1 allOrients.html     
#>  2 assess_example.html 
#>  3 assess_run.html     
#>  4 calcBeta.html       
#>  5 checkAll.html       
#>  6 checkMeta.html      
#>  7 checkSampleID.html  
#>  8 contaminate.html    
#>  9 converter.html      
#> 10 cutadapt_helper.html
#> # ℹ 21 more rows
#> [1] "The total number of potential FASTQ files detected in the directory was 0, and the number of potential forward reads and reverse reads was 0. Please note that this is only performing simple pattern matching to look for standard Illumina-named files, and is only provided as a simple sanity check for you!"
#> [1] "."
```
