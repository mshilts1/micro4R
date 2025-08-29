#' Dada2 Wrapper
#'
#' @param where Path to your fastq files. Run `dada2_wrapper(path = "example")` if you want to run the example data.
#' @param patternF Pattern of the forward/R1 reads
#' @param patternR Pattern of the reverse/R2 reads
#'
#' @returns dada2 ASV table and taxonomy table
#' @export
#' @import dada2
#' @import rlang
#'
#' @examples
#' dada2_wrapper(where = "example")
dada2_wrapper <- function(where = NULL, patternF ="_R1_001.fastq.gz", patternR = "_R2_001.fastq.gz"){
  if(is.null(where)){
    where <- findUserCD()
    print(sprintf("As no argument was provided for the 'path' of your fastq files, this wrapper will assume you want to work in your current directory, %s", where))
  }

  if(where == "example"){
    fnFs <- system.file("extdata", package = "micro4R") %>% list.files("*_R1_001.fastq.gz")
    fnRs <- system.file("extdata", package = "micro4R") %>% list.files("*_R2_001.fastq.gz")
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

  print(fnFs)

}



