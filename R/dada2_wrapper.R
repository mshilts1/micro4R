#' dada2 wrapper
#'
#' @param ... Allows passing of arguments to nested functions
#' @param metadata OPTIONAL. Can pass your associated metadata object to this function so it packages it all up for you for downstream steps
#' @param example Set to TRUE to run an example
#'
#' @returns a list of dada2 ASV table and taxonomy table (and metadata, optionally)
#' @export
#'
#' @examples
#' dada2_wrapper(example = TRUE)
dada2_wrapper <- function(example = FALSE, metadata = NULL, ...) {
  passed_args <- list(...) # get a list of all arguments from user that we want/need to pass to nested functions. not doing anything with this yet. actual functionality to be added

  if(example == TRUE){
    metadata <- example_metadata()
  }

  if(example == TRUE){
  asvtable <- dada2_asvtable(example = TRUE, logfile = FALSE, ...)
  }

  if(example == FALSE){
    asvtable <- dada2_asvtable(example = FALSE, ...)
  }
  # return(asvtable)

  if(example == TRUE){
    taxa <- dada2_taxa(example = TRUE, ...)
  }

  if(example == FALSE){
    taxa <- dada2_taxa(example = FALSE, ...)
  }



  asvtable <- as_tibble(asvtable, rownames = "SampleID")
  taxa <- as_tibble(taxa, rownames = "ASV")

  if (is.null(metadata)) {
    return(list("asvtable" = asvtable, "taxa" = taxa))
    checkASV(asvtable = asvtable, taxa = taxa)
  }
  if (!is.null(metadata)) {
    return(list("asvtable" = asvtable, "taxa" = taxa, "metadata" = metadata))
    checkASV(asvtable = asvtable, taxa = taxa, metadata = metadata)
  }
}
