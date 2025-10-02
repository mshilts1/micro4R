dada2_decontam_wrapper <- function(...) {
  dada2_out <- dada2_wrapper(...)

  decontam_out <- decontam_wrapper(asvtable = converter(dada2_out$asvtable), taxa = converter(dada2_out$taxa, id = "ASV"), metadata = dada2_out$metadata, ...)
}
