# Title

Title

## Usage

``` r
calcAlpha(
  asvtable = NULL,
  metadata = NULL,
  numRare = 400,
  method = "standard",
  category = NULL,
  minReads = 1000
)
```

## Arguments

- asvtable:

  ASV table

- metadata:

  metadata

- numRare:

  optional number of rarefactions to perform on data

- method:

  doesn't do anything yet; may remove

- category:

  category to use for grouping data

- minReads:

  minimum number of reads to keep a sample

## Value

a list of

## Examples

``` r
asvtable <- unsampled_example()$asvtable
metadata <- unsampled_example()$metadata
calcAlpha(asvtable = asvtable, metadata = metadata, category = "SampleType")
#> $by_sample
#> # A tibble: 7 × 6
#>   SampleID                       Sprichness Shannon Simpson InvSimpson Abundance
#>   <chr>                               <int>   <dbl>   <dbl>      <dbl>     <int>
#> 1 5080-MS-1_307-ATAGTACC-ACGTCT…          6   1.67    0.792       1.26        71
#> 2 5080-MS-1_313-GACATAGT-TCGACG…          0   0       1           1            0
#> 3 5080-MS-1_328-GATCTACG-TCGACG…         22   0.440   0.173       5.78     38883
#> 4 5080-MS-1_339-ACTCACTG-GATCGT…         32   1.13    0.524       1.91     32919
#> 5 5348-MS-1_162-ACGTGCGC-GGATAT…        169   2.51    0.807       1.24    149613
#> 6 5348-MS-1_297-GTCTGCTA-ACGTCT…         20   0.451   0.210       4.76    134566
#> 7 5348-MS-1_381-TGCTCGTA-GTCAGA…         20   2.11    0.869       1.15     67717
#> 
#> $by_category
#> # A tibble: 3 × 6
#>   SampleType       Sprichness Shannon Simpson InvSimpson Abundance
#>   <chr>                 <int>   <dbl>   <dbl>      <dbl>     <int>
#> 1 Homo sapiens            243    2.57   0.839       1.19    355981
#> 2 negative control          6    1.67   0.792       1.26        71
#> 3 positive control         20    2.11   0.869       1.15     67717
#> 
```
