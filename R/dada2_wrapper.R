#' dada2 wrapper
#'
#' @param ... Allows passing of arguments to nested functions
#' @param metadata OPTIONAL. Can pass your associated metadata object to this function so it packages it all up for you for downstream steps
#'
#' @returns a list of dada2 ASV table and taxonomy table (and metadata, optionally)
#' @export
#'
#' @examples
#' train <- "inst/extdata/db/EXAMPLE_silva_nr99_v138.2_toGenus_trainset.fa.gz"
#' species <- "inst/extdata/db/EXAMPLE_silva_v138.2_assignSpecies.fa.gz"
#' dada2_wrapper(where = "example", train = train, species = species, logfile = FALSE)
dada2_wrapper <- function(metadata = NULL, ...) {
  passed_args <- list(...) # get a list of all arguments from user that we want/need to pass to nested functions. not doing anything with this yet. actual functionality to be added

  asvtable <- dada2_asvtable(...)
  # return(asvtable)
  taxa <- dada2_taxa(asvtable, ...)

  asvtable <- as_tibble(asvtable, rownames = "SampleID")

  if (is.null(metadata)) {
    return(list("asvtable" = asvtable, "taxa" = taxa))
  }
  if (!is.null(metadata)) {
    return(list("asvtable" = asvtable, "taxa" = taxa, "metadata" = metadata))
  }
}
