#' Dada2 Wrapper
#'
#' @param where Path to your fastq files. Run `dada2_wrapper(path = "example")` if you want to run the example data.
#' @param patternF Pattern of the forward/R1 reads
#' @param patternR Pattern of the reverse/R2 reads
#' @param ... Can alter defaults of dada2 functions if needed
#'
#' @returns dada2 ASV table and taxonomy table
#' @export
#' @import dada2
#' @import rlang
#' @import utils
#'
#' @examples
#' dada2_wrapper(where = "example")
dada2_wrapper <- function(where = NULL, patternF ="_R1_001.fastq.gz", patternR = "_R2_001.fastq.gz", ...){
  if(is.null(where)){
    where <- findUserCD()
    print(sprintf("As no argument was provided for the 'path' of your fastq files, this wrapper will assume you want to work in your current directory, %s", where))
  }

  if(where == "example"){
    fnFs <- system.file("extdata/f", package = "micro4R", mustWork = TRUE) %>% list.files("*_R1_001.fastq.gz", full.names = TRUE)
    fnRs <- system.file("extdata/f", package = "micro4R", mustWork = TRUE) %>% list.files("*_R2_001.fastq.gz", full.names = TRUE)

    filtFs <- system.file("extdata/f/filtered", package = "micro4R", mustWork = TRUE) %>% list.files("*_F_filt.fastq.gz", full.names = TRUE)
    filtRs <- system.file("extdata/f/filtered", package = "micro4R", mustWork = TRUE) %>% list.files("*_R_filt.fastq.gz", full.names = TRUE)
  }

  if(where != "example") {
    fnFs <- sort(list.files(where, pattern=patternF, full.names = TRUE))
    fnRs <- sort(list.files(where, pattern=patternR, full.names = TRUE))
    if (rlang::is_empty(fnFs)) {
      stop(sprintf("No fastq files were found matching pattern '%s'! Check that 1) you're looking for the files the correct directory, and 2) you're looking for the right file name pattern.", patternF))
    }
    if (rlang::is_empty(fnRs)) {
      stop(sprintf("No fastq files were found matching pattern '%s'! Check that 1) you're looking for the files the correct directory, and 2) you're looking for the right file name pattern.", patternR))
    }
  }

  sample.names <- gsub(patternF, "", basename(fnFs)) # create simplified sample names by stripped out the forward read pattern specified by user
  #print(sample.names)

  if(where != "example") {
  filtFs <- file.path(where, "filtered", paste0(sample.names, "_F_filt.fastq.gz"))
  filtRs <- file.path(where, "filtered", paste0(sample.names, "_R_filt.fastq.gz"))
  out <- dada2::filterAndTrim(fnFs, filtFs, fnRs, filtRs, truncLen=c(240,200), maxN=0, maxEE=c(2,2), truncQ=2, rm.phix=TRUE, compress=TRUE, multithread=TRUE)

  # why add the next three lines in? all reads negative controls and samples that amplified poorly with very few reads to start with may get entirely filtered out and cause a fatal error during the error rate learning step. so we need to make sure files still exist first.
  exists <- file.exists(filtFs) & file.exists(filtRs)
  filtFs <- filtFs[exists]
  filtRs <- filtRs[exists]
  #print(exists)
  #return(filtFs)
  }

  if(where == "example") {
    cat("\nPlease note that, because the main goal of dada2::filterAndTrim is to *write* filtered fastq files to the user's computer, and you chose to use the 'example' data, this function was NOT run. The filtered fastq reads already exist as example data for this package, so this package won't try to write the any data to your computer. With your own data, dada2::filterAndTrim will actually run, and make take some time, depending on the size of your input data!\n\n")
  }

  #print(filtFs)

  errF <- dada2::learnErrors(filtFs, multithread=TRUE)
  errR <- dada2::learnErrors(filtRs, multithread=TRUE)

}



