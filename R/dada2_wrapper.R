#' dada2 wrapper
#'
#' @param ... Allows passing of arguments to nested functions
#' @param metadata OPTIONAL. Can pass your associated metadata object to this function so it packages it all up for you for downstream steps
#' @param example Set to TRUE to run an example
#' @param listargs List passed arguments. Using only for troubleshooting during development; shouldn't have any use to end user
#' @param full.wrapper TRUE by default, but must be sent to FALSE when using dada2_decontam_wrapper as otherwise metadata objects collide
#' @param log Produce a log file
#'
#' @returns a list of dada2 ASV table and taxonomy table (and metadata, optionally)
#' @export
#'
#' @examples
#' dada2_wrapper(example = TRUE)
dada2_wrapper <- function(example = FALSE, metadata = NULL, listargs = FALSE, full.wrapper = FALSE, log = TRUE,...) {
  passed_args <- list(...) # get a list of all arguments from user that we want/need to pass to nested functions. not doing anything with this yet. actual functionality to be added


  if (listargs == TRUE) {
    print(passed_args)
    return(passed_args)
  }

  if (listargs == FALSE) {
    if (example == TRUE & full.wrapper == FALSE) {
      metadata <- example_metadata()
    }

    if (example == TRUE) {
      asvtable <- dada2_asvtable(example = TRUE, ...)
    }
    if (example == TRUE) {
      taxa <- dada2_taxa(example = TRUE, ...)
    }

    if (example == FALSE) {
      asvtable <- dada2_asvtable(example = FALSE, ...)# logfile = log, ...)
      # return(invisible(asvtable))
    }

    if (example == FALSE) {
      taxa <- dada2_taxa(asvtable = asvtable, example = FALSE, ...)
      # return(invisible(taxa))
    }

    #asvtable <- converter(asvtable, out = "tibble")
    #taxa <- as_tibble(taxa, rownames = "ASV")

    if (is.null(metadata) | full.wrapper == TRUE) {
      checkAll(asvtable = asvtable, taxa = taxa)
      return(list("asvtable" = asvtable, "taxa" = taxa))
    }
    if (!is.null(metadata) & full.wrapper == FALSE) {
      checkAll(asvtable = asvtable, taxa = taxa, metadata = metadata)
      return(list("asvtable" = asvtable, "taxa" = taxa, "metadata" = metadata))
    }
  }
}
