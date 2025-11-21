# Check metadata file to identify potential downstream issues. DEPRECATED

Check metadata file to identify potential downstream issues. DEPRECATED

## Usage

``` r
checkMeta(df, ids = "SampleID")
```

## Arguments

- df:

  A data frame or tibble containing your sample metadata.

- ids:

  The column name in your data frame that identifies the sample IDs.

## Value

Returns warnings or errors with your metadata object that may cause
downstream problems.

## Examples

``` r
metadata <- data.frame(
  SampleIDs = c("Sample1", "Sample2", "Sample3"),
  Age       = c(34, 58, 21),
  Health    = c("Healthy", "Sick", NA)
)
checkMeta(metadata, "SampleIDs")
#> Warning: `checkMeta()` was deprecated in micro4R 0.0.0.9000.
#> ℹ Please use `checkAll()` instead.
#> Warning: As least 1 NA or empty cell was detected in 1 sample(s) in your metadata object. This is not necessarily bad or wrong, but if you were not expecting this, check your metadata object again. Sample(s) Sample3 were detected to have NAs or empty cells.
```
