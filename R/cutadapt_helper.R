#' Generate a shell script to run cutadapt to remove primer sequences
#'
#' @param FWD forward primer sequence
#' @param REV reverse primer sequence
#' @param example set to TRUE to run the example
#' @param where where to look for your fastq files
#' @param patternF pattern to identify the forward reads
#' @param patternR pattern to identify the reverse reads
#' @param chatty how verbose to be
#'
#' @returns a shell script for you to run to remove adapter/primer sequences
#' @export
#' @importFrom Biostrings DNAString
#' @importFrom Biostrings complement
#' @importFrom Biostrings reverse
#' @importFrom Biostrings reverseComplement
#' @importFrom Biostrings matchPattern
#' @importFrom ShortRead sread
#' @importFrom ShortRead readFastq
#'
#'
#' @examples
cutadapt_helper <- function(example = FALSE, where = NULL, FWD = "CCTACGGGNGGCWGCAG", REV = "GACTACHVGGGTATCTAATCC", patternF = "R1_001.fastq.gz", patternR = "R2_001.fastq.gz", chatty = TRUE) {
  if (!is.null(where)) {
    if (where == "inst/extdata/f2") {
      example <- TRUE
      where <- NULL
    }
  }

  if (example == TRUE & !is.null(where)) {
    stop("You can either run with example = TRUE or set a path to your fastq files with 'where'. You cannot do both.")
  }

  if (example == FALSE & is.null(where)) {
    where <- getwd()
    if (chatty == TRUE) {
      print(sprintf("As no argument was provided for the 'path' of your fastq files, this wrapper will assume you want to work in your current directory, %s", where))
    }
  }

  if (example == FALSE) {
    whereFastqs(where, chatty = chatty)
  }

  if (example == TRUE) {
    fnFs <- system.file("extdata/f2", package = "micro4R", mustWork = TRUE) %>% list.files("*_R1_001.fastq.gz", full.names = TRUE)
    fnRs <- system.file("extdata/f2", package = "micro4R", mustWork = TRUE) %>% list.files("*_R2_001.fastq.gz", full.names = TRUE)
  }

  if (example == FALSE) {
    fnFs <- sort(list.files(where, pattern = patternF, full.names = TRUE))
    fnRs <- sort(list.files(where, pattern = patternR, full.names = TRUE))
    if (rlang::is_empty(fnFs)) {
      stop(sprintf("No fastq files were found matching pattern '%s'! Check that 1) you're looking for the files the correct directory, and 2) you're looking for the right file name pattern.", patternF))
    }
    if (rlang::is_empty(fnRs)) {
      stop(sprintf("No fastq files were found matching pattern '%s'! Check that 1) you're looking for the files the correct directory, and 2) you're looking for the right file name pattern.", patternR))
    }
  }

  path <- where

  fnFs <- sort(list.files(path, pattern = "R1_001.fastq.gz", full.names = TRUE))
  fnRs <- sort(list.files(path, pattern = "R2_001.fastq.gz", full.names = TRUE))

  FWD.orients <- allOrients(FWD)
  REV.orients <- allOrients(REV)

  fnFs.filtN <- file.path(path, "filtN", basename(fnFs)) # Put N-filtered files in filtN/ subdirectory
  fnRs.filtN <- file.path(path, "filtN", basename(fnRs))
  dada2::filterAndTrim(fnFs, fnFs.filtN, fnRs, fnRs.filtN, maxN = 0, multithread = TRUE)

  rbind(FWD.ForwardReads = sapply(FWD.orients, primerHits, fn = fnFs.filtN[[1]]), FWD.ReverseReads = sapply(FWD.orients, primerHits, fn = fnRs.filtN[[1]]), REV.ForwardReads = sapply(REV.orients, primerHits, fn = fnFs.filtN[[1]]), REV.ReverseReads = sapply(REV.orients, primerHits, fn = fnRs.filtN[[1]]))
}

#' all possible orientations of a DNA string
#' Code was pulled from dada2 document https://benjjneb.github.io/dada2/ITS_workflow.html
#' Benjamin Callahan gets all the credit
#'
#' @param primer DNA sequence
#'
#' @returns all possible orientations of a DNA sequence (forward, reverse, complement, reverse complement)
allOrients <- function(primer) {
  # Create all orientations of the input sequence
  dna <- Biostrings::DNAString(primer) # The Biostrings works w/ DNAString objects rather than character vectors
  orients <- c(
    Forward = dna, Complement = Biostrings::complement(dna), Reverse = Biostrings::reverse(dna),
    RevComp = Biostrings::reverseComplement(dna)
  )
  return(sapply(orients, toString)) # Convert back to character vector
}
#' primer hits
#' Code was pulled from dada2 document https://benjjneb.github.io/dada2/ITS_workflow.html
#' Benjamin Callahan gets all the credit
#' @param primer DNA sequence to search for
#' @param fn sequences to search in
#'
#' @returns number of hits for DNA sequence of interest in fastq file
primerHits <- function(primer, fn) {
  # Counts number of reads in which the primer is found
  nhits <- Biostrings::vcountPattern(primer, ShortRead::sread(readFastq(fn)), fixed = FALSE)
  return(sum(nhits > 0))
}
