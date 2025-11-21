# A simple tibble of the names of maintained dada2-formatted taxonomy reference databases

A simple tibble of the names of maintained dada2-formatted taxonomy
reference databases

## Usage

``` r
known_dada2_dbs(what = "list")
```

## Arguments

- what:

  A keypair listing the expected pattern name or a vector of the known
  names.

## Value

A tibble

## Examples

``` r
known_dada2_dbs()
#> # A tibble: 8 × 2
#>   database   database_file_name                        
#>   <chr>      <chr>                                     
#> 1 GreenGenes gg2_2024_09_toGenus_trainset.fa.gz        
#> 2 GreenGenes gg2_2024_09_toSpecies_trainset.fa.gz      
#> 3 RDP        rdp_19_toGenus_trainset.fa.gz             
#> 4 RDP        rdp_19_toSpecies_trainset.fa.gz           
#> 5 UNITE      sh_general_release_all_19.02.2025.tgz     
#> 6 SILVA      silva_nr99_v138.2_toGenus_trainset.fa.gz  
#> 7 SILVA      silva_nr99_v138.2_toSpecies_trainset.fa.gz
#> 8 SILVA      silva_v138.2_assignSpecies.fa.gz          
```
