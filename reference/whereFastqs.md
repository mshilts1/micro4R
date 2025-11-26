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
#> # A tibble: 32 × 1
#>    value              
#>    <chr>              
#>  1 allOrients.html    
#>  2 assess_example.html
#>  3 assess_run.html    
#>  4 calcAlpha.html     
#>  5 calcBeta.html      
#>  6 checkAll.html      
#>  7 checkMeta.html     
#>  8 checkSampleID.html 
#>  9 contaminate.html   
#> 10 converter.html     
#> # ℹ 22 more rows
#> [1] "The total number of potential FASTQ files detected in the directory was 0, and the number of potential forward reads and reverse reads was 0. Please note that this is only performing simple pattern matching to look for standard Illumina-named files, and is only provided as a simple sanity check for you!"
#> [1] "."
```
