# dada2 taxa

dada2 taxa

## Usage

``` r
dada2_taxa(
  asvtable = NULL,
  train = NULL,
  species = NULL,
  chatty = TRUE,
  multi = FALSE,
  example = FALSE,
  output_file = NULL,
  ...
)
```

## Arguments

- asvtable:

  A file containing your sequences; most commonly the ASV table output
  from dada2.

- train:

  Path to database that you'd like to use for taxonomic assignment.

- species:

  OPTIONAL: path to database if you'd like to use assignSpecies()
  function

- chatty:

  Set to FALSE for less text to print to screen

- multi:

  Set to TRUE to use mutithreading where possible

- example:

  Run example data. Default is FALSE

- output_file:

  For non-example runs, path to where you'd like output files to be
  stored. Defaults to a folder where your fastq files are stored.

- ...:

  Allows passing of arguments to nested functions

## Value

A tibble of taxonomic assigments

## Examples

``` r
asvtable <- dada2_asvtable(example = TRUE)
#> [1] 240 200
#> [1] "Because you're running the example, any output files will go to a temporary directory, /tmp/RtmpuSWOIw/dada2_out. To avoid cluttering your computer, this folder and its contents should all be deleted at the end of your R session."
#> [1] "Because you're running the example, any output files will go to a temporary directory, /tmp/RtmpuSWOIw/dada2_out. To avoid cluttering your computer, this folder and its contents should all be deleted at the end of your R session."
#> [1] 240 200
#> Overwriting file:/tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5080-MS-1_307-ATAGTACC-ACGTCTCG_S307_L001_F_filt.fastq.gz
#> Overwriting file:/tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5080-MS-1_307-ATAGTACC-ACGTCTCG_S307_L001_R_filt.fastq.gz
#> Read in 50 paired-sequences, output 11 (22%) filtered paired-sequences.
#> Overwriting file:/tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5080-MS-1_313-GACATAGT-TCGACGAG_S313_L001_F_filt.fastq.gz
#> Overwriting file:/tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5080-MS-1_313-GACATAGT-TCGACGAG_S313_L001_R_filt.fastq.gz
#> Read in 50 paired-sequences, output 26 (52%) filtered paired-sequences.
#> Overwriting file:/tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5080-MS-1_328-GATCTACG-TCGACGAG_S328_L001_F_filt.fastq.gz
#> Overwriting file:/tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5080-MS-1_328-GATCTACG-TCGACGAG_S328_L001_R_filt.fastq.gz
#> Read in 50 paired-sequences, output 46 (92%) filtered paired-sequences.
#> Overwriting file:/tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5080-MS-1_339-ACTCACTG-GATCGTGT_S339_L001_F_filt.fastq.gz
#> Overwriting file:/tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5080-MS-1_339-ACTCACTG-GATCGTGT_S339_L001_R_filt.fastq.gz
#> Read in 50 paired-sequences, output 41 (82%) filtered paired-sequences.
#> Overwriting file:/tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5348-MS-1_162-ACGTGCGC-GGATATCT_S162_L001_F_filt.fastq.gz
#> Overwriting file:/tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5348-MS-1_162-ACGTGCGC-GGATATCT_S162_L001_R_filt.fastq.gz
#> Read in 50 paired-sequences, output 37 (74%) filtered paired-sequences.
#> Overwriting file:/tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5348-MS-1_297-GTCTGCTA-ACGTCTCG_S297_L001_F_filt.fastq.gz
#> Overwriting file:/tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5348-MS-1_297-GTCTGCTA-ACGTCTCG_S297_L001_R_filt.fastq.gz
#> Read in 50 paired-sequences, output 44 (88%) filtered paired-sequences.
#> Overwriting file:/tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5348-MS-1_381-TGCTCGTA-GTCAGATA_S381_L001_F_filt.fastq.gz
#> Overwriting file:/tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5348-MS-1_381-TGCTCGTA-GTCAGATA_S381_L001_R_filt.fastq.gz
#> Read in 50 paired-sequences, output 43 (86%) filtered paired-sequences.
#> 59520 total bases in 248 reads from 7 samples will be used for learning the error rates.
#> Initializing error rates to maximum possible estimate.
#> selfConsist step 1 .......
#>    selfConsist step 2
#> Convergence after  2  rounds.
#> 49600 total bases in 248 reads from 7 samples will be used for learning the error rates.
#> Initializing error rates to maximum possible estimate.
#> selfConsist step 1 .......
#>    selfConsist step 2
#> Convergence after  2  rounds.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5080-MS-1_307-ATAGTACC-ACGTCTCG_S307_L001_F_filt.fastq.gz
#> Encountered 11 unique sequences from 11 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5080-MS-1_313-GACATAGT-TCGACGAG_S313_L001_F_filt.fastq.gz
#> Encountered 25 unique sequences from 26 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5080-MS-1_328-GATCTACG-TCGACGAG_S328_L001_F_filt.fastq.gz
#> Encountered 37 unique sequences from 46 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5080-MS-1_339-ACTCACTG-GATCGTGT_S339_L001_F_filt.fastq.gz
#> Encountered 36 unique sequences from 41 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5348-MS-1_162-ACGTGCGC-GGATATCT_S162_L001_F_filt.fastq.gz
#> Encountered 30 unique sequences from 37 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5348-MS-1_297-GTCTGCTA-ACGTCTCG_S297_L001_F_filt.fastq.gz
#> Encountered 33 unique sequences from 44 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5348-MS-1_381-TGCTCGTA-GTCAGATA_S381_L001_F_filt.fastq.gz
#> Encountered 36 unique sequences from 43 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5080-MS-1_307-ATAGTACC-ACGTCTCG_S307_L001_R_filt.fastq.gz
#> Encountered 11 unique sequences from 11 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5080-MS-1_313-GACATAGT-TCGACGAG_S313_L001_R_filt.fastq.gz
#> Encountered 23 unique sequences from 26 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5080-MS-1_328-GATCTACG-TCGACGAG_S328_L001_R_filt.fastq.gz
#> Encountered 35 unique sequences from 46 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5080-MS-1_339-ACTCACTG-GATCGTGT_S339_L001_R_filt.fastq.gz
#> Encountered 35 unique sequences from 41 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5348-MS-1_162-ACGTGCGC-GGATATCT_S162_L001_R_filt.fastq.gz
#> Encountered 31 unique sequences from 37 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5348-MS-1_297-GTCTGCTA-ACGTCTCG_S297_L001_R_filt.fastq.gz
#> Encountered 32 unique sequences from 44 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpuSWOIw/dada2_out/filtered/SAMPLED_5348-MS-1_381-TGCTCGTA-GTCAGATA_S381_L001_R_filt.fastq.gz
#> Encountered 37 unique sequences from 43 total sequences read.
#> Sample 1 - 11 reads in 11 unique sequences.
#> Sample 2 - 26 reads in 25 unique sequences.
#> Sample 3 - 46 reads in 37 unique sequences.
#> Sample 4 - 41 reads in 36 unique sequences.
#> Sample 5 - 37 reads in 30 unique sequences.
#> Sample 6 - 44 reads in 33 unique sequences.
#> Sample 7 - 43 reads in 36 unique sequences.
#> Sample 1 - 11 reads in 11 unique sequences.
#> Sample 2 - 26 reads in 23 unique sequences.
#> Sample 3 - 46 reads in 35 unique sequences.
#> Sample 4 - 41 reads in 35 unique sequences.
#> Sample 5 - 37 reads in 31 unique sequences.
#> Sample 6 - 44 reads in 32 unique sequences.
#> Sample 7 - 43 reads in 37 unique sequences.
#> 0 paired-reads (in 0 unique pairings) successfully merged out of 1 (in 1 pairings) input.
#> 0 paired-reads (in 0 unique pairings) successfully merged out of 10 (in 1 pairings) input.
#> 44 paired-reads (in 1 unique pairings) successfully merged out of 44 (in 1 pairings) input.
#> 37 paired-reads (in 2 unique pairings) successfully merged out of 37 (in 2 pairings) input.
#> 28 paired-reads (in 3 unique pairings) successfully merged out of 28 (in 3 pairings) input.
#> 41 paired-reads (in 2 unique pairings) successfully merged out of 41 (in 2 pairings) input.
#> 0 paired-reads (in 0 unique pairings) successfully merged out of 31 (in 3 pairings) input.
#> Identified 0 bimeras out of 6 input sequences.
train <- "inst/extdata/db/EXAMPLE_silva_nr99_v138.2_toGenus_trainset.fa.gz"
species <- "inst/extdata/db/EXAMPLE_silva_v138.2_assignSpecies.fa.gz"
dada2_taxa(asvtable = asvtable, train = train, species = species)
#> [1] "CAUTION: You're using the provided micro4R EXAMPLE reference databases. These are extremely tiny and unrealistic and meant only for testing and demonstration purposes. DO NOT use them with your real data."
#> Finished processing reference fasta.[1] "CAUTION: You're using the provided micro4R EXAMPLE reference databases. These are extremely tiny and unrealistic and meant only for testing and demonstration purposes. DO NOT use them with your real data."
#> 1 out of 6 were assigned to the species level.
#> Of which 1 had genera consistent with the input table.
#> # A tibble: 6 × 8
#>   ASV                            Kingdom Phylum Class Order Family Genus Species
#>   <chr>                          <chr>   <chr>  <chr> <chr> <chr>  <chr> <chr>  
#> 1 TACGTAGGTGGCAAGCGTTATCCGGAATT… Bacter… Bacil… Baci… Stap… Staph… Stap… NA     
#> 2 TACGGAGGGTGCAAGCGTTAATCGGAATT… Bacter… Pseud… Gamm… Ente… Enter… Kleb… NA     
#> 3 TACGTAGGGTGCGAGCGTTGTCCGGAATT… Bacter… Actin… Acti… Myco… Coryn… Cory… NA     
#> 4 TACGTAGGGTGCAAGCGTTGTCCGGAATT… Bacter… Actin… Acti… Myco… Coryn… Cory… NA     
#> 5 TACGTAGGTGACAAGCGTTGTCCGGATTT… Bacter… Bacil… Baci… Lact… Carno… Dolo… pigrum 
#> 6 TACGTAGGTCCCGAGCGTTGTCCGGATTT… Bacter… Bacil… Baci… Lact… Strep… Stre… NA     
```
