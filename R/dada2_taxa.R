dada2_taxa <- function(asvtable = NULL, train = NULL, species = NULL, chatty = TRUE, multi = FALSE, ...) {
  # if (is.null(passed_args$db)) {
  #  db <- readline(sprintf("What is the full file path to the reference taxonomic database you'll be using? Don't use quotes. \n\n"))
  #  tax_db <- ref_db(db)
  # }

  if (is.null(asvtable)) {
    stop("You must provide an ASV count table. Typically, this would be the output of dada2_wrapper.")
  }

  if (is.null(train)) {
    stop("You must provide the path to a taxonomic reference database. See here for options and more info: https://benjjneb.github.io/dada2/training.html")
  }

  train_db <- ref_db(train, chatty = chatty)

  taxa <- dada2::assignTaxonomy(seqs = asvtable, refFasta = train_db, multithread = multi, verbose = chatty)

  if (!is.null(species)) {
  species_db <- ref_db(species, chatty = chatty)
  taxa <- dada2::addSpecies(taxtab = taxa, refFasta = species_db, allowMultiple = FALSE, tryRC = FALSE, verbose = chatty)
  }

  tibblefy(taxa)

  if (chatty == TRUE) {
    return(taxa)
  }

  if (chatty == FALSE) {
    return(invisible(taxa))
  }
}
