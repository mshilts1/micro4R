#' Wrapper of entire dada2/decontam process
#'
#' @param ... Arguments to pass to nested functions
#' @param passedargs List passed arguments. Using only for troubleshooting during development; shouldn't have any use to end user
#'
#' @returns A list of the new ASV table, taxa table, and metadata object
#' @export
#'
#' @examples
#' dada2_decontam_wrapper(example = TRUE)
dada2_decontam_wrapper <- function(example = FALSE, passedargs = FALSE, ...) {
  passed_args <- list(...) # get a list of all arguments from user that we want/need to pass to nested functions. not doing anything with this yet. actual functionality to be added

  if (passedargs == TRUE) {
    print(passed_args)
  }

  if (passedargs == FALSE) {
    if (example == TRUE) {
      dada2_out <- dada2_wrapper(full.wrapper = TRUE, ...)
      asvtable <- converter(dada2_out$asvtable)
      taxa <- converter(dada2_out$taxa, id = "ASV")
      # metadata <- NULL
      # metadata <- dada2_out$metadata
      metadata <- example_metadata()
      all <- list("asvtable" = asvtable, "taxa" = taxa, "metadata" = metadata)
    }

    decontam_out <- decontam_wrapper(asvtable = asvtable, taxa = taxa, metadata = metadata, ...)
  }
}
