#' Decontam
#'
#' @param asvtable asvtable
#' @param taxa taxa
#' @param metadata metadata
#' @param ... allow arguments to be passed to nested functions
#'
#' @returns asvtable with potential contaminants removed
#' @export
#' @import decontam
#'
#' @examples
#' asvtable <- dada2_asvtable("example")
#' metadata <- example_metadata()
#' decontam_wrapper(asvtable = asvtable, metadata = metadata)
decontam_wrapper <- function(asvtable = NULL, taxa = NULL, metadata = NULL, ...){
  contamdf.prev <- decontam::isContaminant(asvtable, neg = metadata$neg, ...)
}
