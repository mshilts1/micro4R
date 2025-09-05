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
#' @import phyloseq
#' @import ggplot2
#'
#' @examples
#' train <- "inst/extdata/db/EXAMPLE_silva_nr99_v138.2_toGenus_trainset.fa.gz"
#' species <- "inst/extdata/db/EXAMPLE_silva_v138.2_assignSpecies.fa.gz"
#' dada2_wrapper(where = "example", train = train, species = species)
#' metadata <- example_metadata()
#' decontam_wrapper(asvtable = asvtable, metadata = metadata)
decontam_wrapper <- function(asvtable = NULL, taxa = NULL, metadata = NULL, ...) {
  if (tibble::is_tibble(metadata)) {
    metadata <- metadata %>%
      as.data.frame() %>%
      tibble::column_to_rownames(var = "SampleID")
    return(invisible(metadata))
  }

  ps <- phyloseq::phyloseq(phyloseq::otu_table(asvtable, taxa_are_rows = FALSE), phyloseq::sample_data(metadata), phyloseq::tax_table(taxa))

  df <- as.data.frame(sample_data(ps))
  LibrarySize <- NULL
  df$LibrarySize <- sample_sums(ps)

  where <- tempdir() # getwd()
  # if (where != "example" & where != "inst/extdata/f") {
  if (!dir.exists(sprintf("%s/dada2_out/figs", where))) {
    # If it doesn't exist, create it
    dir.create(sprintf("%s/dada2_out/figs", where), recursive = TRUE) # recursive = TRUE creates parent directories if needed
  }
  # }

  df <- df[order(df$LibrarySize), ]
  Index <- NULL
  df$Index <- seq(nrow(df))
  grDevices::pdf(sprintf("%s/dada2_out/figs/Library_sizes_pre_decontam.pdf", where))
  print(ggplot2::ggplot(data = df, ggplot2::aes(x = .data[Index], y = .data[LibrarySize], color = .data$neg)) +
    ggplot2::geom_point())
  grDevices::dev.off()

  contamdf.prev <- decontam::isContaminant(ps, neg = "neg")

  if (all(!contamdf.prev$contaminant)) {
    print("No contaminants were detected. Existing function.")
  }

  if (any(contamdf.prev$contaminant)) {
    table(contamdf.prev$contaminant)
    head(which(contamdf.prev$contaminant))

    ps.pa <- transform_sample_counts(ps, function(abund) 1 * (abund > 0))

    ps.pa.neg <- prune_samples(sample_data(ps.pa)$neg == "yes", ps.pa)
    print(ps.pa.neg)
  }
}
