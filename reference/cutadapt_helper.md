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

## Examples

``` r
cutadapt_helper(example = TRUE)
#> Creating output directory: /tmp/RtmpX1cvbD/filtN
#>                  Forward Complement Reverse RevComp
#> FWD.ForwardReads       0          0       0       0
#> FWD.ReverseReads       0          0       0       0
#> REV.ForwardReads       0          0       0       0
#> REV.ReverseReads       2          0       0       0
```
