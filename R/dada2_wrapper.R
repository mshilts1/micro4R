#' Dada2 Wrapper
#'
#' @param where Path to your fastq files. Run `dada2_wrapper(path = "example")` if you want to run the example data.
#'
#' @returns dada2 ASV table and taxonomy table
#' @export
#' @import dada2
#'
#' @examples
#' dada2_wrapper()
dada2_wrapper <- function(where = NULL){
  if(is.null(where)){
    where <- findUserCD()
    #print(where)
    #sprintf("anything %s", where)
    print(sprintf("As no argument was provided for the 'path' of your fastq files, this wrapper will assume you want to work in your current directory, %s", where))
  }

  if(where == "example"){
    fnFs <- system.file("extdata", package = "micro4R") %>% list.files("*_R1_001.fastq.gz")
    fnRs <- system.file("extdata", package = "micro4R") %>% list.files("*_R2_001.fastq.gz")
  }
  #print(fnFs)
  #print(fnRs)

  #print(where)

}

