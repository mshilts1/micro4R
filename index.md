# micro4R

Microbiome data analysis tools for R

The goal of `micro4R` was to create an R package for microbiome data
processing with a low barrier to entry. I started my career in
microbiome research at the bench and had to
[ELI5](https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExY3hrYzg1a2I2eGtuNWIwYTRqNDMzNGE0cWlkNGE5OXB4ZHV1YXY4dCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/WsNbxuFkLi3IuGI9NU/giphy.gif)
to myself how to process and analyze “big data”. I’ve spent a ton of
time poring over and experimenting with [others’
code](https://github.com/mshilts1/micro4R?tab=readme-ov-file#acknowledgements),
and want to pass it on. [![micro4R
website](reference/figures/logo.png)](https://mshilts1.github.io/micro4R/)

Likely, the ideal person to benefit from `micro4R` would be a bench
scientist without much formal statistics or bioinformatics training.
Fair warning, if you already have a strong stats/informatics background,
this may not be of much use for you!

This package does not create any brand new functionality and is
essentially a wrapper of and/or inspired by existing tools
[others](https://github.com/mshilts1/micro4R?tab=readme-ov-file#acknowledgements)
have already created. Much of what it does can be accomplished with
other packages, such as
[phyloseq](https://bioconductor.org/packages/release/bioc/html/phyloseq.html),
[QIIME 2](https://qiime2.org), and
[MicrobiomeAnalyst](https://www.microbiomeanalyst.ca). One of these may
be better for your purposes, and I’d encourage anyone new to the field
to explore multiple tools!

## Installation

All you really need is [R](https://cran.rstudio.com), but I’d recommend
also downloading and working in
[RStudio](https://posit.co/download/rstudio-desktop/). If you’re a true
newbie to R, there’s tons of free
[content](https://www.reddit.com/user/jjkraker/comments/zfhe1e/i_want_to_learn_basics_of_r_if_so_heres_a_reading/)
to help you learn the basics.

Once you’re set in R/RStudio, you can install the development version of
micro4R like so:

``` r
# install.packages("pak") # uncomment to install pak package
pak::pak("mshilts1/micro4R")
```

## My Usual Workflow

I’ve listed the steps that I usually take with 16S data:

1.  Do the lab work to extract DNA, make libraries, submit for
    sequencing, etc. [Go
    ↓](https://github.com/mshilts1/micro4R?tab=readme-ov-file#step-1-the-lab-work)  
2.  Get the data from the sequencing core. [Go
    ↓](https://github.com/mshilts1/micro4R?tab=readme-ov-file#step-2-sequencing)  
3.  Process the data through [dada2](https://benjjneb.github.io/dada2/)
    to generate an amplicon sequence variant (ASV) table and its
    associated taxonomy table. [Go
    ↓](https://github.com/mshilts1/micro4R?tab=readme-ov-file#step-3-data-processing)  
4.  Create a “metadata” file with pertinent information on the samples
    and controls in your run. [Go
    ↓](https://github.com/mshilts1/micro4R?tab=readme-ov-file#step-4-metadata)
5.  Use
    [decontam](https://benjjneb.github.io/decontam/vignettes/decontam_intro.html)
    to bioinformatically remove suspected contaminants. [Go
    ↓](https://github.com/mshilts1/micro4R/tree/main?tab=readme-ov-file#step-5-bioinformatic-decontamination).  
6.  Do some basic sanity checking on the metadata, ASV, and taxonomy
    objects. [Go
    ↓](https://github.com/mshilts1/micro4R/tree/main?tab=readme-ov-file#step-6-sanity-check)  
7.  Check the quality of the sequencing data by examining the positive
    and negative controls. [Go
    ↓](https://github.com/mshilts1/micro4R/tree/main?tab=readme-ov-file#step-7-quality-check)  
8.  Alpha diversity. [Go
    ↓](https://github.com/mshilts1/micro4R/tree/main?tab=readme-ov-file#step-8-alpha-diversity)  
9.  Beta diversity. [Go
    ↓](https://github.com/mshilts1/micro4R/tree/main?tab=readme-ov-file#step-9-beta-diversity)  
10. Additional statistical analysis, including differential abundance
    testing (maaslin3). [Go
    ↓](https://github.com/mshilts1/micro4R/tree/main?tab=readme-ov-file#step-10-additional-analysis)

## Example

I’ll run through a VERY small and simple possible use case below. For
more detailed help and documentation, please explore the vignettes
*(TBA)*.

### Step 1: the lab work

I’m not going to get into much detail here, but everything you or your
colleagues do in the lab matters and can influence your results. You’ll
need to be thoughtful about everything from how exactly samples will be
collected, storage conditions, DNA extraction method, library prep
method, and more. It’s not my place to tell you what to do here, but
carefully consider and document every step along the say.

However, I will strongly tell you that including both negative and
positive controls is very important! Why, and what are those? Read more
here:
^([1](https://pubmed.ncbi.nlm.nih.gov/25387460/),[2](https://pubmed.ncbi.nlm.nih.gov/27239228/),[3](https://bmcmicrobiol.biomedcentral.com/articles/10.1186/s12866-020-01839-y),[4](https://bmcmicrobiol.biomedcentral.com/articles/10.1186/s12866-016-0738-z),[5](https://journals.asm.org/doi/10.1128/msystems.00062-16))

### Step 2: Sequencing

You’ll need to follow your own desired protocol to perform the
sequencing, and get the data back. Most likely, you’ll use the services
of a sequencing core, so follow their instructions.

Included with the package is an extremely and unnaturally tiny toy
example to demonstrate its major functionality, using subsampled
publicly available nasal swab 16S microbiome sequencing
[data](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA726992) that I
generated along with many
[colleagues](https://pmc.ncbi.nlm.nih.gov/articles/PMC8819187/).

The example files were generated by amplifying the V4 hypervariable
region of the 16S gene and were sequenced on an Illumina MiSeq machine
with 2x250 bp reads.

### Step 3: Data processing

The files received from the sequencer will most likely be FASTQ files.
These are files with DNA sequences generated by the sequencer along with
quality score information (putting the “Q” in FASTQ). In the age of
next-generation sequencing, you could easily get millions of these
sequences per each sequencing run. Our poor human brains can’t really
comprehend or do anything with this data as it is. So what we’re going
to do is process this data to eventually turn it into two tables that we
humans can make sense of and analyze.

We’re going to use the R package `dada2` to turn the FASTQ files into
matching amplicon sequence variant (ASV) count and taxonomy tables. If
you don’t know what an ASV is, please go
[here](https://benjjneb.github.io/dada2/index.html) first.

The first thing we’ll do on these files is run
[`dada2_asvtable()`](https://mshilts1.github.io/micro4R/reference/dada2_asvtable.md),
which is essentially a wrapper to generate an ASV count table by
following a workflow similar to the [dada2
tutorial](https://benjjneb.github.io/dada2/tutorial.html).

This function can take a number of arguments, but the most important one
is ‘where’, which is the path to the folder where your FASTQ files are
located.

For demonstration purposes, it’s been set to the relative path of the
example FASTQ files that are included with the package:

``` r
library(micro4R)
#> This is version 0.0.0.9000 of micro4R. CAUTION: This is package is under active development and its functions may change at any time, without warning! Please visit https://github.com/mshilts1/micro4R to see recent changes.

asvtable <- dada2_asvtable(where = "inst/extdata/f", chatty = FALSE, logfile = FALSE)
#> [1] 240 200
#> [1] 240 200
#> Creating output directory: /var/folders/9p/n0xwyqzs4j3b_1gkzsm7b_xw0000gn/T//Rtmp0LPj4Y/dada2_out/filtered
#> 59520 total bases in 248 reads from 7 samples will be used for learning the error rates.
#> 49600 total bases in 248 reads from 7 samples will be used for learning the error rates.
```

If you’re running this with your own data, set ‘where’ to the path of
the folder where your FASTQ files are stored. If you leave it empty
(e.g., run
[`dada2_asvtable()`](https://mshilts1.github.io/micro4R/reference/dada2_asvtable.md)),
it will default to searching in your current working directory.
(‘chatty’ was set to FALSE because tons of information gets printed to
the console otherwise; I’d recommend setting it to TRUE (the default)
when you’re processing data for real, as the information is useful, but
just too much here.)

Let’s take a quick look at what this asvtable object looks like:

``` r
asvtable
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
```

This is just a count table of the number of ASVs detected in each
sample.

Let’s look what the column names (AKA the names of the ASVs) look like:

``` r
colnames(asvtable)
#> [1] "SampleID"                                                                                                                                                                                                                                                      
#> [2] "TACGTAGGTGGCAAGCGTTATCCGGAATTATTGGGCGTAAAGCGCGCGTAGGCGGTTTTTTAAGTCTGATGTGAAAGCCCACGGCTCAACCGTGGAGGGTCATTGGAAACTGGAAAACTTGAGTGCAGAAGAGGAAAGTGGAATTCCATGTGTAGCGGTGAAATGCGCAGAGATATGGAGGAACACCAGTGGCGAAGGCGACTTTCTGGTCTGTAACTGACGCTGATGTGCGAAAGCGTGGGGATCAAACAGG" 
#> [3] "TACGGAGGGTGCAAGCGTTAATCGGAATTACTGGGCGTAAAGCGCACGCAGGCGGTCTGTCAAGTCGGATGTGAAATCCCCGGGCTCAACCTGGGAACTGCATTCGAAACTGGCAGGCTAGAGTCTTGTAGAGGGGGGTAGAATTCCAGGTGTAGCGGTGAAATGCGTAGAGATCTGGAGGAATACCGGTGGCGAAGGCGGCCCCCTGGACAAAGACTGACGCTCAGGTGCGAAAGCGTGGGGAGCAAACAGG" 
#> [4] "TACGTAGGGTGCGAGCGTTGTCCGGAATTACTGGGCGTAAAGGGCTCGTAGGTGGTTTGTCGCGTCGTCTGTGAAATTCTGGGGCTTAACTCCGGGCGTGCAGGCGATACGGGCATAACTTGAGTGCTGTAGGGGTAACTGGAATTCCTGGTGTAGCGGTGAAATGCGCAGATATCAGGAGGAACACCGATGGCGAAGGCAGGTTACTGGGCAGTTACTGACGCTGAGGAGCGAAAGCATGGGTAGCGAACAGG"
#> [5] "TACGTAGGGTGCAAGCGTTGTCCGGAATTACTGGGCGTAAAGAGCTCGTAGGTGGTTTGTCACGTCGTCTGTGAAATTCCACAGCTTAACTGTGGGCGTGCAGGCGATACGGGCTGACTTGAGTACTGTAGGGGTAACTGGAATTCCTGGTGTAGCGGTGAAATGCGCAGATATCAGGAGGAACACCGATGGCGAAGGCAGGTTACTGGGCAGTTACTGACGCTGAGGAGCGAAAGCATGGGTAGCAAACAGG" 
#> [6] "TACGTAGGTGACAAGCGTTGTCCGGATTTATTGGGCGTAAAGGGAGCGCAGGCGGTCTGTTTAGTCTAATGTGAAAGCCCACGGCTTAACCGTGGAACGGCATTGGAAACTGACAGACTTGAATGTAGAAGAGGAAAATGGAATTCCAAGTGTAGCGGTGGAATGCGTAGATATTTGGAGGAACACCAGTGGCGAAGGCGATTTTCTGGTCTAACATTGACGCTGAGGCTCGAAAGCGTGGGGAGCGAACAGG" 
#> [7] "TACGTAGGTCCCGAGCGTTGTCCGGATTTATTGGGCGTAAAGCGAGCGCAGGCGGTTAGATAAGTCTGAAGTTAAAGGCTGTGGCTTAACCATAGTACGCTTTGGAAACTGTTTAACTTGAGTGCAAGAGGGGAGAGTGGAATTCCATGTGTAGCGGTGAAATGCGTAGATATATGGAGGAACACCGGTGGCGAAAGCGGCTCTCTGGCTTGTAACTGACGCTGAGGCTCGAAAGCGTGGGGAGCAAACAGG"
```

Our ASVs are by default just named after their literal DNA sequences.
Since you’re (probably?) not a computer, a string of hundreds of
nucletotides is likely not something you can make much sense of by
yourself. The next step will take those nucleotide sequences and compare
them against a database (or two) of sequences with known taxonomy:

``` r
train <- "inst/extdata/db/EXAMPLE_silva_nr99_v138.2_toGenus_trainset.fa.gz" # set training database
species <- "inst/extdata/db/EXAMPLE_silva_v138.2_assignSpecies.fa.gz" # set species database

taxa <- dada2_taxa(asvtable = asvtable, train = train, species = species, chatty = FALSE)
```

There are two databases that we’re using for taxonomic assignment
here:  
1. ‘train’ needs to be the path to whatever database you’d like to use
as the “training set of reference sequences with known taxonomy”.  
2. ‘species’ is OPTIONAL. If you’d like to use this option, provide the
path to a specifically formatted species assignment database. (Read more
[here](https://benjjneb.github.io/dada2/assign.html#species-assignment).)

**CAUTION: The two databases used in the example here are comically
small and artificial subsamples of the real SILVA databases, and should
only ever be used for testing and demonstration purposes!** You’ll
definitely need to download and use the real
[databases](https://benjjneb.github.io/dada2/training.html) for your
actual data! If you try to use these with real data, you’ll get very
weird results that will make no sense.

There are many options for taxonomic databases you can use; the major
players are SILVA, RDP, GreenGenes, and UNITE. Please go
[here](https://benjjneb.github.io/dada2/training.html) for details and
download links. I usually prefer to use the SILVA databases, but you
don’t have to!

Let’s take a look at the taxonomy assignment table:

``` R
#> # A tibble: 6 × 9
#>   ASV   ASV                      Kingdom Phylum Class Order Family Genus Species
#>   <chr> <chr>                    <chr>   <chr>  <chr> <chr> <chr>  <chr> <chr>  
#> 1 1     TACGTAGGTGGCAAGCGTTATCC… Bacter… Bacil… Baci… Stap… Staph… Stap… <NA>   
#> 2 2     TACGGAGGGTGCAAGCGTTAATC… Bacter… Pseud… Gamm… Ente… Enter… Kleb… <NA>   
#> 3 3     TACGTAGGGTGCGAGCGTTGTCC… Bacter… Actin… Acti… Myco… Coryn… Cory… <NA>   
#> 4 4     TACGTAGGGTGCAAGCGTTGTCC… Bacter… Actin… Acti… Myco… Coryn… Cory… <NA>   
#> 5 5     TACGTAGGTGACAAGCGTTGTCC… Bacter… Bacil… Baci… Lact… Carno… Dolo… pigrum 
#> 6 6     TACGTAGGTCCCGAGCGTTGTCC… Bacter… Bacil… Baci… Lact… Strep… Stre… <NA>
```

It’s a bit squished, but you can see this information is more
human-friendly here. Each ASV has been given a taxonomic assignment to
the lowest taxonomic level the taxonomy assigner was confident of.

### Step 4: Metadata

Next, we need to load in some metadata about our samples.

``` r
metadata <- example_metadata()

metadata
#> # A tibble: 7 × 7
#>   SampleID                 LabID SampleType host_age host_sex Host_disease neg  
#>   <chr>                    <chr> <chr>         <int> <chr>    <chr>        <lgl>
#> 1 SAMPLED_5080-MS-1_328-G… part… Homo sapi…       33 female   healthy      FALSE
#> 2 SAMPLED_5080-MS-1_339-A… part… Homo sapi…       25 male     healthy      FALSE
#> 3 SAMPLED_5348-MS-1_162-A… part… Homo sapi…       27 male     COVID-19     FALSE
#> 4 SAMPLED_5348-MS-1_297-G… part… Homo sapi…       26 female   COVID-19     FALSE
#> 5 SAMPLED_5080-MS-1_307-A… CTRL… negative …       NA <NA>     <NA>         TRUE 
#> 6 SAMPLED_5080-MS-1_313-G… CTRL… negative …       NA <NA>     <NA>         TRUE 
#> 7 SAMPLED_5348-MS-1_381-T… CTRL… positive …       NA <NA>     <NA>         FALSE
```

Let’s look at the ‘SampleID’ field, which is what is sound like, and
uniquely identifies each sample:

``` r
metadata$SampleID
#> [1] "SAMPLED_5080-MS-1_328-GATCTACG-TCGACGAG_S328_L001"
#> [2] "SAMPLED_5080-MS-1_339-ACTCACTG-GATCGTGT_S339_L001"
#> [3] "SAMPLED_5348-MS-1_162-ACGTGCGC-GGATATCT_S162_L001"
#> [4] "SAMPLED_5348-MS-1_297-GTCTGCTA-ACGTCTCG_S297_L001"
#> [5] "SAMPLED_5080-MS-1_307-ATAGTACC-ACGTCTCG_S307_L001"
#> [6] "SAMPLED_5080-MS-1_313-GACATAGT-TCGACGAG_S313_L001"
#> [7] "SAMPLED_5348-MS-1_381-TGCTCGTA-GTCAGATA_S381_L001"
```

The first thing you may notice is the ‘SampleIDs’ here are the kinds of
IDs that only a computer could love. For my standard workflow, I like to
keep the SampleIDs as the FASTQ file names because they will by default
automatically match the SampleIDs generated with dada2_asvtable().

In this example, there is also a ‘LabID’ field, which is an ID that
could have been used all through specimen processing, as it is much more
human-friendly:

``` r
metadata$LabID
#> [1] "participant01" "participant02" "participant03" "participant04"
#> [5] "CTRL_neg_ext"  "CTRL_neg_pcr"  "CTRL_pos_pcr"
```

To seamlessly use this package, you MUST have a column called
‘SampleID’, and those IDs must exactly match between your metadata and
ASV count table objects. But otherwise, you’re free to name your samples
whatever you want.

### Step 5: Bioinformatic Decontamination

What kind of information you’ll need to have in your metadata object is
HIGHLY dependent on your study, but there’s some information that we
must have for the optional (but highly recommended!) processing of your
ASV table through [decontam](https://github.com/benjjneb/decontam).

What does `decontam` need to know?  
1. To use the “prevalence” method: which samples are the negative
controls.  
2. To use the “frequency” method: the DNA concentration in each sample
prior to sequencing.  
3. To use both of the “prevalence” and “frequency” methods, you need all
the above.

Don’t have any negative controls? You won’t be able to run `decontam`,
and I strongly recommend you include some next time! Both negative and
positive controls are very important! Read more here:
^([1](https://pubmed.ncbi.nlm.nih.gov/25387460/),[2](https://pubmed.ncbi.nlm.nih.gov/27239228/),[3](https://bmcmicrobiol.biomedcentral.com/articles/10.1186/s12866-020-01839-y),[4](https://bmcmicrobiol.biomedcentral.com/articles/10.1186/s12866-016-0738-z),[5](https://journals.asm.org/doi/10.1128/msystems.00062-16))

In our example data, we only are able to use the “prevalence” method,
because we know which samples were negative controls, but we don’t have
DNA concentration data. That information is in our column called “neg”,
where TRUE means it was a negative control:

``` r
metadata$neg
#> [1] FALSE FALSE FALSE FALSE  TRUE  TRUE FALSE
```

Next, let’s run the
[`decontam_wrapper()`](https://mshilts1.github.io/micro4R/reference/decontam_wrapper.md)
on the example data we’ve generated so far:

``` r
# decontam_wrapper(asvtable = asvtable, taxa = taxa, metadata = metadata, logfile = FALSE)
```

You’ll see several messages, including one at the bottom that tells us
“No contaminants were detected. Exiting function and returning your
original ASV and taxa tables.” With real data with proper controls, you
should not expect to ever see this message. Our example data set was
just too stupidly small for `decontam` to work properly!

So that I can demonstrate `decontam` actually doing something, we’ll
deliberately “contaminate” the ASV table with the
[`contaminate()`](https://mshilts1.github.io/micro4R/reference/contaminate.md)
command. All we’re doing is artificially adding counts to one of the
ASVs, and throwing in a few more negative controls for good measure.
This data is now even more fake and made up than it was previously, so
don’t use it for anything other than learning how this R package works!
The command
[`contaminate()`](https://mshilts1.github.io/micro4R/reference/contaminate.md)
will also simultaneously create a matched metadata object containing
information on the additional made up negative controls.

``` r
contaminated_asvtable <- converter(contaminate()$asvtable)
contaminated_taxa <- dada2_taxa(asvtable = contaminated_asvtable, train = train, species = species) # we don't actually have to re-run this command with this specific example, but it's good practice to always ensure your asvtable and taxa tables match.
#> [1] "CAUTION: You're using the provided micro4R EXAMPLE reference databases. These are extremely tiny and unrealistic and meant only for testing and demonstration purposes. DO NOT use them with your real data."
#> Finished processing reference fasta.[1] "CAUTION: You're using the provided micro4R EXAMPLE reference databases. These are extremely tiny and unrealistic and meant only for testing and demonstration purposes. DO NOT use them with your real data."
#> 1 out of 6 were assigned to the species level.
#> Of which 1 had genera consistent with the input table.
contaminated_metadata <- contaminate()$metadata
decontaminated <- decontam_wrapper(asvtable = contaminated_asvtable, taxa = contaminated_taxa, metadata = contaminated_metadata, logfile = FALSE)
#> [1] "CLASS OF METADATA IS data.frame"
#> Warning in .is_contaminant(seqtab, conc = conc, neg = neg, method = method, :
#> Removed 1 samples with zero total counts (or frequency).
#> Warning in .is_contaminant(seqtab, conc = conc, neg = neg, method = method, :
#> Removed 1 samples with zero total counts (or frequency).
```

The object “decontaminated” contains a list of the… decontaminated… ASV
table, taxa table, and for our convenience also includes the metadata
table.

``` r
nrow(contaminated_taxa) # number of rows corresponds to number of ASVs
#> [1] 6
nrow(decontaminated$taxa)
#> [1] 5

ncol(contaminated_asvtable) # number of columns corresponds to number of ASVs
#> [1] 6
ncol(decontaminated$asvtable)
#> [1] 5
```

The decontaminated version of both the ASV and taxa tables have one
fewer ASV than the originals, as I artifically added a bunch of counts
to one of the ASVs to the contaminated version of the ASV table.
`decontam` rightfully thinks that ASV is likely a background contaminant
due to its prevalence in the negative controls, and has now removed it,
to make our data cleaner and more reliable. Why is this so
important?^\[Negative controls are especially important with 16S data
due the nature of the process: 1) bacteria and their DNA are ubiquitous
and can live even in environments hostile to most other life, 2) the PCR
protocol deliberately enriches for all bacteria in a semi-universal way.
This means the data can be extremely susceptible to contamination. The
details of this are out of the scope of this document, but your FIRST
step should be improving your lab methods to reduce contamination
potential as much as possible.

However, no matter how amazing you (or your colleagues) are in the lab,
you’ll probably still have at least some contamination. That’s where the
negative controls come in. I would recommend having at least one
negative extraction control (e.g., “extract” DNA from some ultraclean
water or sample buffer) per every extraction batch, and a PCR negative
control for every PCR master mix batch.)

### Step 6: Sanity Check

``` r
checkAll(asvtable = asvtable, taxa = taxa, metadata = metadata)
#> [1] "As least 1 NA or empty cell was detected in 3 sample(s) in your metadata object. This is not necessarily bad or wrong, but if you were not expecting this, check your metadata object again. Sample(s) SAMPLED_5080-MS-1_307-ATAGTACC-ACGTCTCG_S307_L001, SAMPLED_5080-MS-1_313-GACATAGT-TCGACGAG_S313_L001, SAMPLED_5348-MS-1_381-TGCTCGTA-GTCAGATA_S381_L001 were detected to have NAs or empty cells."
#> [1] "No errors or warnings identified."
```

### Step 7: Quality Check

Since we’re done with the basic sanity checks, now we can do an actual
more interesting quality check of our data.

As mentioned numerous times, lab positive and negative controls are VERY
important and should be included at minimum in every single sequencing
run. If you haven’t included either of these, you won’t be able to do
the full quality checks here.

The example data that we’ve used so far won’t be useful for this, so
let’s load in some example data that I’ve created specifically to
demonstrate the kind of data quality checking that I reguarly do for
every single sequencing run.

Included with the package is processed data from a single typical
fictional 16S MiSeq run (`assess_example`). There are 384 samples on
this run, including a number of negative and positive controls. I
personally like to assess the level of background contamination in the
negative controls *before* `decontam`.

``` r
#out <- micro4R::assess_example

#assess_run(metadata = out$metadata, asvtable = out$asvtable, wells = "well", plate = "Plate", category = "SampleType")
```

### Step 8: Alpha diversity

### Step 9: Beta diversity

### Step 10: Additional analysis

------------------------------------------------------------------------

Move information to the bottom for anyone who wants more details

subsampled FASTQ files from a
[manuscript](https://pmc.ncbi.nlm.nih.gov/articles/PMC8819187/) I
co-authored with my colleagues, for which the raw data is publicly
available under bioproject ID
[PRJNA726992](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA726992). From
seven samples from this study, using
[seqtk](https://github.com/lh3/seqtk), I randomly sampled **only 50
reads** from each FASTQ file so that the files would take up minimal
space and the example would run quickly.

If you’d like to run through this the full fastq files can be downloaded
from SRA or as a zipped bolus
[here](https://drive.google.com/file/d/1NOvmsxFxWb1Vigq8rdb5SCfLLNu-Qjy8/view?usp=sharing)

Here is some body text that needs a footnote.[¹](#fn1)

- logo made by me using artwork from [Canva](https://www.canva.com/)
  (©[iconbunny11](https://www.canva.com/p/id/BAClqvm1MBE/)) followed by
  [hexSticker](https://github.com/GuangchuangYu/hexSticker) to get it
  into the typical hex logo format.

Not going to keep this on the readme, but want to hold onto the logo
code until I put it somewhere else.  
s \<- sticker(image_path, package=“micro4R”, p_size=15, p_family =
“Comfortaa”, p_fontface = “bold”, p_y = 1.5, s_x=1, s_y=.75, s_width=.5,
s_height = .5, p_color = “black”, h_fill = “#6ed5f5”, h_color=
“#16bc93”, h_size = 2, filename=“inst/figures/imgfile.png”).

built R 4.5.1  
RStudio Version 2025.05.1+513 (2025.05.1+513) macOS Sequoia Version
15.6.1

# Acknowledgements

As mentioned above, I could not have done any of this without the
benefit of what the work of others. These tools below were especially
important, as they were either extremely influential in helping me learn
how to do these analyses, and/or are directly used here:

- [mothur](https://mothur.org)  
- [qiime](https://qiime2.org)  
- [mgsat](https://github.com/andreyto/mgsat)  
- maaslin[2](https://huttenhower.sph.harvard.edu/maaslin/)/[3](https://huttenhower.sph.harvard.edu/maaslin3/)  
- [vegan](https://cran.r-project.org/web/packages/vegan/index.html)
- [tidyverse](https://tidyverse.tidyverse.org), especially
  [dplyr](https://dplyr.tidyverse.org) and
  [ggplot2](https://ggplot2.tidyverse.org). In addition to these
  packages, Hadley Wickham and team have written several extremely
  helpful [guides and tutorials](https://hadley.nz) on data science.
- [dada2 and decontam](https://callahanlab.cvm.ncsu.edu/software/)
- [Suite from Dr. Frank Harrell](https://hbiostat.org), especially
  [rms](https://cran.r-project.org/web/packages/rms/index.html) and
  [Hmisc](https://cran.r-project.org/web/packages/Hmisc/index.html).
- Colleague and physician-scientist [Dr. Christian
  Rosas-Salazar](https://pediatrics.vumc.org/person/christian-rosas-salazar-md-mph)
  is talented at many things, but has an especial knack for creating
  figures that are both beautiful and informative.

More acknowledgements and more details to be added later

------------------------------------------------------------------------

1.  This is the content of the footnote.
