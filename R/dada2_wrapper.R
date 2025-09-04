#' dada2 wrapper
#'
#' @param ... Allows passing of arguments to nested functions
#'
#' @returns dada2 ASV table and taxonomy table
#' @export
#'
#' @examples
#' train <- "inst/extdata/db/EXAMPLE_silva_nr99_v138.2_toGenus_trainset.fa.gz"
#' species <- "inst/extdata/db/EXAMPLE_silva_v138.2_assignSpecies.fa.gz"
#' dada2_wrapper(where = "example", train = train, species = species)
dada2_wrapper <- function(...) {
  passed_args <- list(...) # get a list of all arguments from user that we want/need to pass to nested functions. not doing anything with this yet. actual functionality to be added

  asvtable <- dada2_asvtable(...)
  #return(asvtable)
  taxa <- dada2_taxa(asvtable, ...)

  asvtable <- as_tibble(asvtable, rownames = "SampleID")
  return(list("asvtable" = asvtable, "taxa" = taxa))




}
