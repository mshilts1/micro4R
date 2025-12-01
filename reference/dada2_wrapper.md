# dada2 wrapper

dada2 wrapper

## Usage

``` r
dada2_wrapper(
  example = FALSE,
  metadata = NULL,
  listargs = FALSE,
  full.wrapper = FALSE,
  log = TRUE,
  ...
)
```

## Arguments

- example:

  Set to TRUE to run an example

- metadata:

  OPTIONAL. Can pass your associated metadata object to this function so
  it packages it all up for you for downstream steps

- listargs:

  List passed arguments. Using only for troubleshooting during
  development; shouldn't have any use to end user

- full.wrapper:

  TRUE by default, but must be sent to FALSE when using
  dada2_decontam_wrapper as otherwise metadata objects collide

- log:

  Produce a log file

- ...:

  Allows passing of arguments to nested functions

## Value

a list of dada2 ASV table and taxonomy table (and metadata, optionally)

## Examples

``` r
dada2_wrapper(example = TRUE)
#> [1] 240 200
#> [1] "Because you're running the example, any output files will go to a temporary directory, /tmp/RtmpX1cvbD/dada2_out. To avoid cluttering your computer, this folder and its contents should all be deleted at the end of your R session."
#> [1] "Because you're running the example, any output files will go to a temporary directory, /tmp/RtmpX1cvbD/dada2_out. To avoid cluttering your computer, this folder and its contents should all be deleted at the end of your R session."
#> [1] 240 200
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_307-ATAGTACC-ACGTCTCG_S307_L001_F_filt.fastq.gz
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_307-ATAGTACC-ACGTCTCG_S307_L001_R_filt.fastq.gz
#> Read in 50 paired-sequences, output 11 (22%) filtered paired-sequences.
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_313-GACATAGT-TCGACGAG_S313_L001_F_filt.fastq.gz
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_313-GACATAGT-TCGACGAG_S313_L001_R_filt.fastq.gz
#> Read in 50 paired-sequences, output 26 (52%) filtered paired-sequences.
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_328-GATCTACG-TCGACGAG_S328_L001_F_filt.fastq.gz
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_328-GATCTACG-TCGACGAG_S328_L001_R_filt.fastq.gz
#> Read in 50 paired-sequences, output 46 (92%) filtered paired-sequences.
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_339-ACTCACTG-GATCGTGT_S339_L001_F_filt.fastq.gz
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_339-ACTCACTG-GATCGTGT_S339_L001_R_filt.fastq.gz
#> Read in 50 paired-sequences, output 41 (82%) filtered paired-sequences.
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_162-ACGTGCGC-GGATATCT_S162_L001_F_filt.fastq.gz
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_162-ACGTGCGC-GGATATCT_S162_L001_R_filt.fastq.gz
#> Read in 50 paired-sequences, output 37 (74%) filtered paired-sequences.
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_297-GTCTGCTA-ACGTCTCG_S297_L001_F_filt.fastq.gz
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_297-GTCTGCTA-ACGTCTCG_S297_L001_R_filt.fastq.gz
#> Read in 50 paired-sequences, output 44 (88%) filtered paired-sequences.
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_381-TGCTCGTA-GTCAGATA_S381_L001_F_filt.fastq.gz
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_381-TGCTCGTA-GTCAGATA_S381_L001_R_filt.fastq.gz
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
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_307-ATAGTACC-ACGTCTCG_S307_L001_F_filt.fastq.gz
#> Encountered 11 unique sequences from 11 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_313-GACATAGT-TCGACGAG_S313_L001_F_filt.fastq.gz
#> Encountered 25 unique sequences from 26 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_328-GATCTACG-TCGACGAG_S328_L001_F_filt.fastq.gz
#> Encountered 37 unique sequences from 46 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_339-ACTCACTG-GATCGTGT_S339_L001_F_filt.fastq.gz
#> Encountered 36 unique sequences from 41 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_162-ACGTGCGC-GGATATCT_S162_L001_F_filt.fastq.gz
#> Encountered 30 unique sequences from 37 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_297-GTCTGCTA-ACGTCTCG_S297_L001_F_filt.fastq.gz
#> Encountered 33 unique sequences from 44 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_381-TGCTCGTA-GTCAGATA_S381_L001_F_filt.fastq.gz
#> Encountered 36 unique sequences from 43 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_307-ATAGTACC-ACGTCTCG_S307_L001_R_filt.fastq.gz
#> Encountered 11 unique sequences from 11 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_313-GACATAGT-TCGACGAG_S313_L001_R_filt.fastq.gz
#> Encountered 23 unique sequences from 26 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_328-GATCTACG-TCGACGAG_S328_L001_R_filt.fastq.gz
#> Encountered 35 unique sequences from 46 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_339-ACTCACTG-GATCGTGT_S339_L001_R_filt.fastq.gz
#> Encountered 35 unique sequences from 41 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_162-ACGTGCGC-GGATATCT_S162_L001_R_filt.fastq.gz
#> Encountered 31 unique sequences from 37 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_297-GTCTGCTA-ACGTCTCG_S297_L001_R_filt.fastq.gz
#> Encountered 32 unique sequences from 44 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_381-TGCTCGTA-GTCAGATA_S381_L001_R_filt.fastq.gz
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
#> [1] 240 200
#> [1] "Because you're running the example, any output files will go to a temporary directory, /tmp/RtmpX1cvbD/dada2_out. To avoid cluttering your computer, this folder and its contents should all be deleted at the end of your R session."
#> [1] "Because you're running the example, any output files will go to a temporary directory, /tmp/RtmpX1cvbD/dada2_out. To avoid cluttering your computer, this folder and its contents should all be deleted at the end of your R session."
#> [1] 240 200
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_307-ATAGTACC-ACGTCTCG_S307_L001_F_filt.fastq.gz
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_307-ATAGTACC-ACGTCTCG_S307_L001_R_filt.fastq.gz
#> Read in 50 paired-sequences, output 11 (22%) filtered paired-sequences.
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_313-GACATAGT-TCGACGAG_S313_L001_F_filt.fastq.gz
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_313-GACATAGT-TCGACGAG_S313_L001_R_filt.fastq.gz
#> Read in 50 paired-sequences, output 26 (52%) filtered paired-sequences.
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_328-GATCTACG-TCGACGAG_S328_L001_F_filt.fastq.gz
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_328-GATCTACG-TCGACGAG_S328_L001_R_filt.fastq.gz
#> Read in 50 paired-sequences, output 46 (92%) filtered paired-sequences.
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_339-ACTCACTG-GATCGTGT_S339_L001_F_filt.fastq.gz
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_339-ACTCACTG-GATCGTGT_S339_L001_R_filt.fastq.gz
#> Read in 50 paired-sequences, output 41 (82%) filtered paired-sequences.
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_162-ACGTGCGC-GGATATCT_S162_L001_F_filt.fastq.gz
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_162-ACGTGCGC-GGATATCT_S162_L001_R_filt.fastq.gz
#> Read in 50 paired-sequences, output 37 (74%) filtered paired-sequences.
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_297-GTCTGCTA-ACGTCTCG_S297_L001_F_filt.fastq.gz
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_297-GTCTGCTA-ACGTCTCG_S297_L001_R_filt.fastq.gz
#> Read in 50 paired-sequences, output 44 (88%) filtered paired-sequences.
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_381-TGCTCGTA-GTCAGATA_S381_L001_F_filt.fastq.gz
#> Overwriting file:/tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_381-TGCTCGTA-GTCAGATA_S381_L001_R_filt.fastq.gz
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
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_307-ATAGTACC-ACGTCTCG_S307_L001_F_filt.fastq.gz
#> Encountered 11 unique sequences from 11 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_313-GACATAGT-TCGACGAG_S313_L001_F_filt.fastq.gz
#> Encountered 25 unique sequences from 26 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_328-GATCTACG-TCGACGAG_S328_L001_F_filt.fastq.gz
#> Encountered 37 unique sequences from 46 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_339-ACTCACTG-GATCGTGT_S339_L001_F_filt.fastq.gz
#> Encountered 36 unique sequences from 41 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_162-ACGTGCGC-GGATATCT_S162_L001_F_filt.fastq.gz
#> Encountered 30 unique sequences from 37 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_297-GTCTGCTA-ACGTCTCG_S297_L001_F_filt.fastq.gz
#> Encountered 33 unique sequences from 44 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_381-TGCTCGTA-GTCAGATA_S381_L001_F_filt.fastq.gz
#> Encountered 36 unique sequences from 43 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_307-ATAGTACC-ACGTCTCG_S307_L001_R_filt.fastq.gz
#> Encountered 11 unique sequences from 11 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_313-GACATAGT-TCGACGAG_S313_L001_R_filt.fastq.gz
#> Encountered 23 unique sequences from 26 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_328-GATCTACG-TCGACGAG_S328_L001_R_filt.fastq.gz
#> Encountered 35 unique sequences from 46 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5080-MS-1_339-ACTCACTG-GATCGTGT_S339_L001_R_filt.fastq.gz
#> Encountered 35 unique sequences from 41 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_162-ACGTGCGC-GGATATCT_S162_L001_R_filt.fastq.gz
#> Encountered 31 unique sequences from 37 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_297-GTCTGCTA-ACGTCTCG_S297_L001_R_filt.fastq.gz
#> Encountered 32 unique sequences from 44 total sequences read.
#> Dereplicating sequence entries in Fastq file: /tmp/RtmpX1cvbD/dada2_out/filtered/SAMPLED_5348-MS-1_381-TGCTCGTA-GTCAGATA_S381_L001_R_filt.fastq.gz
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
#> [1] "CAUTION: You're using the provided micro4R EXAMPLE reference databases. These are extremely tiny and unrealistic and meant only for testing and demonstration purposes. DO NOT use them with your real data."
#> Finished processing reference fasta.[1] "CAUTION: You're using the provided micro4R EXAMPLE reference databases. These are extremely tiny and unrealistic and meant only for testing and demonstration purposes. DO NOT use them with your real data."
#> 1 out of 6 were assigned to the species level.
#> Of which 1 had genera consistent with the input table.[1] "As least 1 NA or empty cell was detected in 3 sample(s) in your metadata object. This is not necessarily bad or wrong, but if you were not expecting this, check your metadata object again. Sample(s) SAMPLED_5080-MS-1_307-ATAGTACC-ACGTCTCG_S307_L001, SAMPLED_5080-MS-1_313-GACATAGT-TCGACGAG_S313_L001, SAMPLED_5348-MS-1_381-TGCTCGTA-GTCAGATA_S381_L001 were detected to have NAs or empty cells."
#> [1] "No errors or warnings identified."
#> $asvtable
#> # A tibble: 7 × 7
#>   SampleID  TACGTAGGTGGCAAGCGTTA…¹ TACGGAGGGTGCAAGCGTTA…² TACGTAGGGTGCGAGCGTTG…³
#>   <chr>                      <int>                  <int>                  <int>
#> 1 SAMPLED_…                      0                      0                      0
#> 2 SAMPLED_…                      0                      0                      0
#> 3 SAMPLED_…                     44                      0                      0
#> 4 SAMPLED_…                     24                      0                      0
#> 5 SAMPLED_…                      0                      0                     12
#> 6 SAMPLED_…                      0                     35                      6
#> 7 SAMPLED_…                      0                      0                      0
#> # ℹ abbreviated names:
#> #   ¹​TACGTAGGTGGCAAGCGTTATCCGGAATTATTGGGCGTAAAGCGCGCGTAGGCGGTTTTTTAAGTCTGATGTGAAAGCCCACGGCTCAACCGTGGAGGGTCATTGGAAACTGGAAAACTTGAGTGCAGAAGAGGAAAGTGGAATTCCATGTGTAGCGGTGAAATGCGCAGAGATATGGAGGAACACCAGTGGCGAAGGCGACTTTCTGGTCTGTAACTGACGCTGATGTGCGAAAGCGTGGGGATCAAACAGG,
#> #   ²​TACGGAGGGTGCAAGCGTTAATCGGAATTACTGGGCGTAAAGCGCACGCAGGCGGTCTGTCAAGTCGGATGTGAAATCCCCGGGCTCAACCTGGGAACTGCATTCGAAACTGGCAGGCTAGAGTCTTGTAGAGGGGGGTAGAATTCCAGGTGTAGCGGTGAAATGCGTAGAGATCTGGAGGAATACCGGTGGCGAAGGCGGCCCCCTGGACAAAGACTGACGCTCAGGTGCGAAAGCGTGGGGAGCAAACAGG,
#> #   ³​TACGTAGGGTGCGAGCGTTGTCCGGAATTACTGGGCGTAAAGGGCTCGTAGGTGGTTTGTCGCGTCGTCTGTGAAATTCTGGGGCTTAACTCCGGGCGTGCAGGCGATACGGGCATAACTTGAGTGCTGTAGGGGTAACTGGAATTCCTGGTGTAGCGGTGAAATGCGCAGATATCAGGAGGAACACCGATGGCGAAGGCAGGTTACTGGGCAGTTACTGACGCTGAGGAGCGAAAGCATGGGTAGCGAACAGG
#> # ℹ 3 more variables:
#> #   TACGTAGGGTGCAAGCGTTGTCCGGAATTACTGGGCGTAAAGAGCTCGTAGGTGGTTTGTCACGTCGTCTGTGAAATTCCACAGCTTAACTGTGGGCGTGCAGGCGATACGGGCTGACTTGAGTACTGTAGGGGTAACTGGAATTCCTGGTGTAGCGGTGAAATGCGCAGATATCAGGAGGAACACCGATGGCGAAGGCAGGTTACTGGGCAGTTACTGACGCTGAGGAGCGAAAGCATGGGTAGCAAACAGG <int>,
#> #   TACGTAGGTGACAAGCGTTGTCCGGATTTATTGGGCGTAAAGGGAGCGCAGGCGGTCTGTTTAGTCTAATGTGAAAGCCCACGGCTTAACCGTGGAACGGCATTGGAAACTGACAGACTTGAATGTAGAAGAGGAAAATGGAATTCCAAGTGTAGCGGTGGAATGCGTAGATATTTGGAGGAACACCAGTGGCGAAGGCGATTTTCTGGTCTAACATTGACGCTGAGGCTCGAAAGCGTGGGGAGCGAACAGG <int>, …
#> 
#> $taxa
#> # A tibble: 6 × 8
#>   ASV                            Kingdom Phylum Class Order Family Genus Species
#>   <chr>                          <chr>   <chr>  <chr> <chr> <chr>  <chr> <chr>  
#> 1 TACGTAGGTGGCAAGCGTTATCCGGAATT… Bacter… Bacil… Baci… Stap… Staph… Stap… NA     
#> 2 TACGGAGGGTGCAAGCGTTAATCGGAATT… Bacter… Pseud… Gamm… Ente… Enter… Kleb… NA     
#> 3 TACGTAGGGTGCGAGCGTTGTCCGGAATT… Bacter… Actin… Acti… Myco… Coryn… Cory… NA     
#> 4 TACGTAGGGTGCAAGCGTTGTCCGGAATT… Bacter… Actin… Acti… Myco… Coryn… Cory… NA     
#> 5 TACGTAGGTGACAAGCGTTGTCCGGATTT… Bacter… Bacil… Baci… Lact… Carno… Dolo… pigrum 
#> 6 TACGTAGGTCCCGAGCGTTGTCCGGATTT… Bacter… Bacil… Baci… Lact… Strep… Stre… NA     
#> 
#> $metadata
#> # A tibble: 7 × 7
#>   SampleID                 LabID SampleType host_age host_sex Host_disease neg  
#>   <chr>                    <chr> <chr>         <int> <chr>    <chr>        <lgl>
#> 1 SAMPLED_5080-MS-1_328-G… part… Homo sapi…       33 female   healthy      FALSE
#> 2 SAMPLED_5080-MS-1_339-A… part… Homo sapi…       25 male     healthy      FALSE
#> 3 SAMPLED_5348-MS-1_162-A… part… Homo sapi…       27 male     COVID-19     FALSE
#> 4 SAMPLED_5348-MS-1_297-G… part… Homo sapi…       26 female   COVID-19     FALSE
#> 5 SAMPLED_5080-MS-1_307-A… CTRL… negative …       NA NA       NA           TRUE 
#> 6 SAMPLED_5080-MS-1_313-G… CTRL… negative …       NA NA       NA           TRUE 
#> 7 SAMPLED_5348-MS-1_381-T… CTRL… positive …       NA NA       NA           FALSE
#> 
```
