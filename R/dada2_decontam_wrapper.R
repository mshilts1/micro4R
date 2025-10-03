#' Wrapper of entire dada2/decontam process
#'
#' @param ... Arguments to pass to nested functions
#'
#' @returns A list of the new ASV table, taxa table, and metadata object
#' @export
#'
#' @examples
#' dada2_decontam_wrapper(example = TRUE)
dada2_decontam_wrapper <- function(...) {
  dada2_out <- dada2_wrapper(...)
  asvtable <- converter(dada2_out$asvtable)
  taxa <- converter(dada2_out$taxa, id = "ASV")
  #metadata <- NULL
  #metadata <- dada2_out$metadata

  print(example)
  #if (example == TRUE) {
  #  metadata <- example_metadata()
  #}

  decontam_out <- decontam_wrapper(asvtable = asvtable, taxa = taxa, ...)
}
