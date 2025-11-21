# Generate a shell script to run cutadapt to remove primer sequences

Generate a shell script to run cutadapt to remove primer sequences

## Usage

``` r
cutadapt_helper(
  example = FALSE,
  where = NULL,
  FWD = "CCTACGGGNGGCWGCAG",
  REV = "GACTACHVGGGTATCTAATCC",
  patternF = "R1_001.fastq.gz",
  patternR = "R2_001.fastq.gz",
  chatty = TRUE
)
```

## Arguments

- example:

  set to TRUE to run the example

- where:

  where to look for your fastq files

- FWD:

  forward primer sequence

- REV:

  reverse primer sequence

- patternF:

  pattern to identify the forward reads

- patternR:

  pattern to identify the reverse reads

- chatty:

  how verbose to be

## Value

a shell script for you to run to remove adapter/primer sequences
