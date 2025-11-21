# Simple function to check for a column called SampleID

Simple function to check for a column called SampleID

## Usage

``` r
checkSampleID(df)
```

## Arguments

- df:

  Your ASV table or metadata object

## Value

Your ASV table or metadata object with your sample IDs column named
'SampleID'

## Examples

``` r
checkSampleID(example_metadata())
#> [1] "Looks good"
```
