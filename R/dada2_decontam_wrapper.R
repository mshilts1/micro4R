#' Wrapper of entire dada2/decontam process
#'
#' @param ... Arguments to pass to nested functions
#' @param passedargs List passed arguments. Using only for troubleshooting during development; not expected to have any use to end user
#' @param example Set to TRUE to run example
#'
#' @returns A list of the new ASV table, taxa table, and metadata object
#' @export
#'
#' @examples
#' dada2_decontam_wrapper(example = TRUE)
dada2_decontam_wrapper <- function(example = FALSE, passedargs = FALSE, ...) {
  passed_args <- list(...) # get a list of all arguments from user that we want/need to pass to nested functions. not doing anything with this yet. actual functionality to be added

  if(example == FALSE) {
    if(is.null(train)){
      stop("You must provide the path to a taxonomic reference database. See here for options and more info: https://benjjneb.github.io/dada2/training.html")
    }
    if(!is.null(train)){
      ref_db(train)
    }
  }

  if (passedargs == TRUE) {
    print(passed_args)
  }

  if (passedargs == FALSE) {

    if (example == TRUE) {
      dada2_out <- dada2_wrapper(example = TRUE, full.wrapper = TRUE, ...)
      asvtable <- converter(dada2_out$asvtable)
      taxa <- converter(dada2_out$taxa, id = "ASV")
      # metadata <- NULL
      # metadata <- dada2_out$metadata
      metadata <- example_metadata()
      all <- list("asvtable" = asvtable, "taxa" = taxa, "metadata" = metadata)
    }

    if (example == FALSE) {
      dada2_out <- dada2_wrapper(full.wrapper = TRUE, ...)
      asvtable <- converter(dada2_out$asvtable)
      taxa <- converter(dada2_out$taxa, id = "ASV")
      # metadata <- NULL
      # metadata <- dada2_out$metadata
      # metadata <- example_metadata()
      all <- list("asvtable" = asvtable, "taxa" = taxa)
    }

    if (example == TRUE) {
    decontam_out <- decontam_wrapper(asvtable = all$asvtable, taxa = all$taxa, metadata = all$metadata, ...)
    }
    if (example == FALSE) {
      decontam_out <- decontam_wrapper(asvtable = all$asvtable, taxa = all$taxa, ...)
    }
  }
}
