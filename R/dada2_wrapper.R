#' dada2 wrapper
#'
#' @param ... Allows passing of arguments to nested functions
#' @param metadata OPTIONAL. Pass associated metadata to include in output list.
#' @param example Set to TRUE to run an example
#' @param listargs List passed arguments (dev/troubleshooting)
#' @param full.wrapper FALSE by default; must be FALSE when using
#'   dada2_decontam_wrapper as otherwise metadata objects collide
#' @param log Produce a log file (currently not wired through)
#'
#' @returns a list with ASV table + taxonomy table (+ metadata, optionally)
#' @export
#' @examples
#' dada2_wrapper(example = TRUE)
dada2_wrapper <- function(example = FALSE,
                          metadata = NULL,
                          listargs = FALSE,
                          full.wrapper = FALSE,
                          log = TRUE,
                          ...) {
  passed_args <- list(...)

  if (isTRUE(listargs)) {
    print(passed_args)
    return(passed_args)
  }

  # If running the example and we are NOT in the "full wrapper" scenario,
  # attach example metadata unless user supplied metadata explicitly.
  if (isTRUE(example) && !isTRUE(full.wrapper) && is.null(metadata)) {
    metadata <- example_metadata()
  }

  # Build core objects
  asvtable <- dada2_asvtable(example = isTRUE(example), ...)
  taxa <- dada2_taxa(asvtable = asvtable, example = isTRUE(example), ...)

  # Validate
  if (is.null(metadata) || isTRUE(full.wrapper)) {
    checkAll(asvtable = asvtable, taxa = taxa)
    return(list(asvtable = asvtable, taxa = taxa))
  }

  checkAll(asvtable = asvtable, taxa = taxa, metadata = metadata)
  list(asvtable = asvtable, taxa = taxa, metadata = metadata)
}
