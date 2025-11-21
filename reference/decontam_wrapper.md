# Decontam

Decontam

## Usage

``` r
decontam_wrapper(asvtable = NULL, taxa = NULL, metadata = NULL, ...)
```

## Arguments

- asvtable:

  asvtable

- taxa:

  taxa

- metadata:

  metadata

- ...:

  allow arguments to be passed to nested functions

## Value

asvtable, taxa table, and metadata with potential contaminants removed

## Examples

``` r
train <- "inst/extdata/db/EXAMPLE_silva_nr99_v138.2_toGenus_trainset.fa.gz"
species <- "inst/extdata/db/EXAMPLE_silva_v138.2_assignSpecies.fa.gz"

# the example ASV table is too small for decontam to work properly
# to get around this, we deliberately "contaminate" the ASV table with
# the contaminate() command. this requires us to use the matched metadata
# file created with contaminate()
asvtable <- converter(contaminate()$asvtable)
taxa <- dada2_taxa(asvtable = asvtable, train = train, species = species)
#> [1] "CAUTION: You're using the provided micro4R EXAMPLE reference databases. These are extremely tiny and unrealistic and meant only for testing and demonstration purposes. DO NOT use them with your real data."
#> Finished processing reference fasta.[1] "CAUTION: You're using the provided micro4R EXAMPLE reference databases. These are extremely tiny and unrealistic and meant only for testing and demonstration purposes. DO NOT use them with your real data."
#> 1 out of 6 were assigned to the species level.
#> Of which 1 had genera consistent with the input table.
metadata <- contaminate()$metadata
decontam_wrapper(asvtable = asvtable, taxa = taxa, metadata = metadata, logfile = FALSE)
#> [1] "CLASS OF METADATA IS data.frame"
#> Warning: Removed 1 samples with zero total counts (or frequency).
#> Warning: Removed 1 samples with zero total counts (or frequency).
```
