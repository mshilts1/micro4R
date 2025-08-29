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
    fnFs <- system.file("extdata/f", package = "micro4R", mustWork = TRUE) %>% list.files("*_R1_001.fastq.gz")
    fnRs <- system.file("extdata/f", package = "micro4R", mustWork = TRUE) %>% list.files("*_R2_001.fastq.gz")
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

  utils::head(out)
  }

  if(where == "example") {
    #don't run filterAndTrim so that we don't try to write anything to user's computer
  }

  #print(filtFs)

}



