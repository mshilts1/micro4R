# Converts tibbles, data frames, and matrices to each other as needed by the specific function

Converts tibbles, data frames, and matrices to each other as needed by
the specific function

## Usage

``` r
converter(x = NULL, out = "matrix", id = "SampleID")
```

## Arguments

- x:

  A tibble, data frame, or matrix that you want to convert

- out:

  What you want to conver it to out (tibble, data_frame, or matrix)

- id:

  ID column, if relevant

## Value

A tibble, data frame, or matrix

## Examples

``` r
converter(contaminate()$asvtable)
```
