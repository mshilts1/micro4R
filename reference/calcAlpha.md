# Calculate standard alpha diversity indices

Calculate standard alpha diversity indices

## Usage

``` r
calcAlpha(
  asvtable = NULL,
  metadata = NULL,
  numRare = 0,
  method = "standard",
  minReads = 1
)
```

## Arguments

- asvtable:

  ASV table

- metadata:

  metadata

- numRare:

  optional number of rarefactions to perform on ASV table

- method:

  doesn't do anything yet; may end up removing

- minReads:

  minimum number of reads to keep a sample. default is 1 to discard
  samples with no read, but you may set it higher if desired. if you use
  rarefaction, it's recommended to set this to be at least 1000.

## Value

returns a tibble of the calculated values for each sample.

## Examples

``` r
asvtable <- unsampled_example()$asvtable
metadata <- unsampled_example()$metadata
calcAlpha(asvtable = asvtable, metadata = metadata)
#> # A tibble: 6 × 6
#>   SampleID                       Sprichness Shannon Simpson InvSimpson Abundance
#>   <chr>                               <int>   <dbl>   <dbl>      <dbl>     <int>
#> 1 5080-MS-1_307-ATAGTACC-ACGTCT…          6   1.67    0.792       1.26        71
#> 2 5080-MS-1_328-GATCTACG-TCGACG…         22   0.440   0.173       5.78     38883
#> 3 5080-MS-1_339-ACTCACTG-GATCGT…         32   1.13    0.524       1.91     32919
#> 4 5348-MS-1_162-ACGTGCGC-GGATAT…        169   2.51    0.807       1.24    149613
#> 5 5348-MS-1_297-GTCTGCTA-ACGTCT…         20   0.451   0.210       4.76    134566
#> 6 5348-MS-1_381-TGCTCGTA-GTCAGA…         20   2.11    0.869       1.15     67717
```
