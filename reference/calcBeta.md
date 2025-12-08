# Calculate beta diversity dissimilarities with or without rarefaction

Calculate beta diversity dissimilarities with or without rarefaction

## Usage

``` r
calcBeta(
  asvtable = NULL,
  metadata = NULL,
  numRare = 400,
  method = "bray",
  category = NULL,
  minReads = 1000,
  makeFigs = FALSE,
  ...
)
```

## Arguments

- asvtable:

  Input ASV table. Can be filtered with filtering()

- metadata:

  Metadata input object

- numRare:

  Number of rarefactions to perform. Set to 0 if you do not want to do
  any rarefication.

- method:

  Dissimilarity index to use. See ?vegan::vegdist for more information.
  Default is Bray-Curtis.

- category:

  Name in metadata column that you'd like to use

- minReads:

  Minimum number of reads to keep a sample

- makeFigs:

  make some basic figures

- ...:

  allow passed arguments to nested functions

## Value

A dissimilarity matrix

## Examples

``` r
asvtable <- unsampled_example()$asvtable
metadata <- unsampled_example()$metadata
calcBeta(asvtable = asvtable, metadata = metadata, category = "host_sex", method = "bray")
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> Warning: function should be used for observed counts, but smallest count is 2
#> $dissimilarities
#>           1         2         3
#> 2 0.8518449                    
#> 3 0.9360732 0.9089611          
#> 4 0.7920104 0.8349737 0.9249667
#> 
#> $betadisper_res
#> 
#>  Homogeneity of multivariate dispersions
#> 
#> Call: vegan::betadisper(d = averagedbc, group = metadata[[category]])
#> 
#> No. of Positive Eigenvalues: 3
#> No. of Negative Eigenvalues: 0
#> 
#> Average distance to median:
#> female   male 
#> 0.3960 0.4545 
#> 
#> Eigenvalues for PCoA axes:
#>  PCoA1  PCoA2  PCoA3 
#> 0.4743 0.3652 0.3125 
#> 
#> $pcoa_metadata
#> # A tibble: 4 × 10
#>   SampleID  LabID SampleType host_age host_sex Host_disease neg     PCoA1  PCoA2
#>   <chr>     <chr> <chr>         <int> <chr>    <chr>        <lgl>   <dbl>  <dbl>
#> 1 5080-MS-… part… Homo sapi…       33 female   healthy      FALSE  0.273   0.257
#> 2 5080-MS-… part… Homo sapi…       25 male     healthy      FALSE  0.0668 -0.515
#> 3 5348-MS-… part… Homo sapi…       27 male     COVID-19     FALSE -0.581   0.119
#> 4 5348-MS-… part… Homo sapi…       26 female   COVID-19     FALSE  0.241   0.139
#> # ℹ 1 more variable: PCoA3 <dbl>
#> 
```
