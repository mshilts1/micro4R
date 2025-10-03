#' Decontam
#'
#' @param asvtable asvtable
#' @param taxa taxa
#' @param metadata metadata
#' @param ... allow arguments to be passed to nested functions
#'
#' @returns asvtable, taxa table, and metadata with potential contaminants removed
#' @export
#' @import decontam
#' @import phyloseq
#' @import ggplot2
#'
#' @examples
#' train <- "inst/extdata/db/EXAMPLE_silva_nr99_v138.2_toGenus_trainset.fa.gz"
#' species <- "inst/extdata/db/EXAMPLE_silva_v138.2_assignSpecies.fa.gz"
#'
#' # the example ASV table is too small for decontam to work properly
#' # to get around this, we deliberately "contaminate" the ASV table with
#' # the contaminate() command. this requires us to use the matched metadata
#' # file created with contaminate()
#' asvtable <- converter(contaminate()$asvtable)
#' taxa <- dada2_taxa(asvtable = asvtable, train = train, species = species)
#' metadata <- contaminate()$metadata
#' decontam_wrapper(asvtable = asvtable, taxa = taxa, metadata = metadata, logfile = FALSE)
decontam_wrapper <- function(asvtable = NULL, taxa = NULL, metadata = NULL, ...) {
  passed_args <- list(...)

  metadata_orig <- metadata

  if (tibble::is_tibble(metadata)) {
    metadata <- metadata %>%
      as.data.frame() %>%
      tibble::column_to_rownames(var = "SampleID")
    # return(invisible(metadata))
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
  print(ggplot2::ggplot(data = df, ggplot2::aes(x = .data$Index, y = .data$LibrarySize, color = .data$neg)) +
    ggplot2::geom_point())
  grDevices::dev.off()

  contamdf.prev <- decontam::isContaminant(ps, neg = "neg")

  if (all(!contamdf.prev$contaminant)) {
    print("No contaminants were detected. Returning your original ASV and taxa tables.")
    return(invisible(list("asvtable" = converter(asvtable, out = "tibble"), "taxa" = converter(taxa, out = "tibble", id = "ASV"), "metadata" = metadata_orig)))
  }

  if (any(contamdf.prev$contaminant)) {
    table(contamdf.prev$contaminant)
    head(which(contamdf.prev$contaminant))

    ps.pa <- transform_sample_counts(ps, function(abund) 1 * (abund > 0))

    ps.pa.neg <- prune_samples(sample_data(ps.pa)$neg == TRUE, ps.pa)
    ps.pa.pos <- prune_samples(sample_data(ps.pa)$neg == FALSE, ps.pa)
    # print(ps.pa.neg)
    df.pa <- data.frame(pa.pos = taxa_sums(ps.pa.pos), pa.neg = taxa_sums(ps.pa.neg), contaminant = contamdf.prev$contaminant)

    # pdf("Prevalence in positive and negative samples.pdf")
    # ggplot(data=df.pa, aes(x=pa.neg, y=pa.pos, color=contaminant)) + geom_point() + xlab("Prevalence (Negative Controls)") + ylab("Prevalence (True Samples)")
    # prune contaminant ASVs
    ps.noncontam <- prune_taxa(!contamdf.prev$contaminant, ps)
    seqtab.nochim.noncontam <- as(otu_table(ps.noncontam), "matrix")

    if (taxa_are_rows(ps.noncontam)) {
      seqtab.nochim.noncontam <- t(seqtab.nochim.noncontam)
    }
    seqtab.nochim.noncontam.df <- as.data.frame(seqtab.nochim.noncontam)

    # write.csv(seqtab.nochim.noncontam.df, file="seqtab.nochim.noncontam.csv")

    taxa.noncontam <- as(tax_table(ps.noncontam), "matrix")
    taxa.noncontam.df <- as.data.frame(taxa.noncontam)
    # write.csv(taxa.noncontam.df, file="taxa.noncontam.csv")

    return(invisible(list("asvtable" = seqtab.nochim.noncontam.df, "taxa" = taxa.noncontam.df, "metadata" = metadata_orig)))
  }
}
