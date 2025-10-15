#' dada2 taxa
#'
#' @param asvtable A file containing your sequences; most commonly the ASV table output from dada2.
#' @param train Path to database that you'd like to use for taxonomic assignment.
#' @param species OPTIONAL: path to database if you'd like to use assignSpecies() function
#' @param chatty Set to FALSE for less text to print to screen
#' @param multi Set to TRUE to use mutithreading where possible
#' @param example Run example data. Default is FALSE
#' @param ... Allows passing of arguments to nested functions
#'
#' @returns A tibble of taxonomic assigments
#' @export
#'
#' @examples
#' asvtable <- dada2_asvtable(example = TRUE)
#' train <- "inst/extdata/db/EXAMPLE_silva_nr99_v138.2_toGenus_trainset.fa.gz"
#' species <- "inst/extdata/db/EXAMPLE_silva_v138.2_assignSpecies.fa.gz"
#' dada2_taxa(asvtable = asvtable, train = train, species = species)
dada2_taxa <- function(asvtable = NULL, train = NULL, species = NULL, chatty = TRUE, multi = FALSE, example = FALSE, ...) {
  # if (is.null(passed_args$db)) {
  #  db <- readline(sprintf("What is the full file path to the reference taxonomic database you'll be using? Don't use quotes. \n\n"))
  #  tax_db <- ref_db(db)
  # }

  if (example == TRUE) {
    asvtable <- dada2_asvtable(example = TRUE, logfile = FALSE)
    train <- test_dbs()$train
    species <- test_dbs()$species
  }

  if (example == FALSE & is.null(asvtable)) {
    stop("You must provide an ASV count table. Typically, this would be the output of dada2_wrapper.")
  }

  if (example == FALSE & is.null(train)) {
    stop("You must provide the path to a taxonomic reference database. See here for options and more info: https://benjjneb.github.io/dada2/training.html")
  }

  # if (!is.matrix(asvtable)) {
  #    asvtable <- matrixify(asvtable)
  #  }

  train_db <- ref_db(train, chatty = chatty)
  asvtable <- converter(asvtable, out = "matrix", id = "SampleID")

  if (chatty == TRUE) {
    taxa <- dada2::assignTaxonomy(seqs = asvtable, refFasta = train_db, multithread = multi, verbose = chatty)
    #return(taxa)
    taxa
  }

  if (chatty == FALSE) {
    taxa <- dada2::assignTaxonomy(seqs = asvtable, refFasta = train_db, multithread = multi, verbose = chatty)
    invisible(taxa)
  }


  if (!is.null(species)) {
    species_db <- ref_db(species, chatty = chatty)
    taxa <- dada2::addSpecies(taxtab = taxa, refFasta = species_db, allowMultiple = FALSE, tryRC = FALSE, verbose = chatty)
    if (chatty == TRUE) {
      #return(taxa)
      taxa
    }
    if (chatty == FALSE) {
      #return(invisible(taxa))
      invisible(taxa)
    }
  }

  # as_tibble(taxa, rownames = "ASV", .name_repair = "unique")
  taxa_tbl <- converter(taxa, out = "tibble", id = "ASV")

  #  if (where == "example" | where == "inst/extdata/f") {
  #    write.csv(track.tibble, file = sprintf("%s/dada2_out/track_seqcounts.csv", outdir), row.names = FALSE)
  outdir <- tempdir()
  write.csv(taxa_tbl, file = sprintf("%s/dada2_out/taxa.csv", outdir), row.names = FALSE)
  on.exit(unlink(outdir), add = TRUE)
  #  }

  if (chatty == FALSE) {
    #return(invisible(taxa))
    invisible(return(taxa_tbl))
  }

  if (chatty == TRUE) {
    #return(invisible(taxa))
    return(taxa_tbl)
  }

}
