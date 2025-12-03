#' Calculate standard alpha diversity indices
#'
#' @param asvtable ASV table
#' @param metadata metadata
#' @param numRare optional number of rarefactions to perform on ASV table
#' @param method doesn't do anything yet; may end up removing
#' @param minReads minimum number of reads to keep a sample. default is 1 to discard samples with no read, but you may set it higher if desired. if you use rarefaction, it's recommended to set this to be at least 1000.
#'
#' @returns returns a tibble of the calculated values for each sample.
#' @export
#'
#' @examples
#' asvtable <- unsampled_example()$asvtable
#' metadata <- unsampled_example()$metadata
#' calcAlpha(asvtable = asvtable, metadata = metadata)
calcAlpha <- function(asvtable = NULL, metadata = NULL, numRare = 0, method = "standard", minReads = 1){

  asvtable <- filtering(asvtable, minDepth = minReads)
  minlibrary <- min(rowSums(asvtable[-1]))

  if(numRare > 0 & minReads < 100){
    print(sprintf("You requested to rarefy the ASV table before calculations, but have set the minimum reads required for a sample to be retained to %s. Rarefaction will be done to your minimum library depth, which is %s. You may get very strange results! It's recommended you either do not rarefy, or set minReads to be higher.", minReads, minlibrary))
  }

  calculations <- function(df){
    all <-  df %>%
      dplyr::group_by(.data$SampleID) %>%
      dplyr::summarise(Sprichness = vegan::specnumber(.data$value),
                       Shannon = vegan::diversity(.data$value, index = "shannon"),
                       Simpson = vegan::diversity(.data$value, index = "simpson"),
                       InvSimpson = 1/.data$Simpson,
                       Abundance = sum(.data$value))
    all
  }

  if(numRare == 0){
    merged <- dplyr::left_join(asvtable, metadata %>% select(c(.data$SampleID)), by = "SampleID")
    merged <- tidyr::pivot_longer(merged, cols = !c(.data$SampleID), names_to = "ASV", values_to = "value")
    out <- calculations(df = merged)
  }

  if(numRare > 0){ # doing a bunch of lapply's is dumb and inelegant, but whatever, it works for now. may clean up later when i have more time.
    rarefactions1 <- lapply(as.list(1:numRare), function(x) vegan::rrarefy(asvtable[-1], minlibrary))
    rarefactions2 <- lapply(rarefactions1, converter, out = "tibble")
    rarefactions3 <- lapply(rarefactions2, function(df) {df[, names(df) != "SampleID"]})
    rarefactions4 <- lapply(rarefactions3, function(df) {dplyr::bind_cols(asvtable[1], df)})
    rarefactions5 <- lapply(rarefactions4, function(df) {tidyr::pivot_longer(df, cols = !c(.data$SampleID), names_to = "ASV", values_to = "value")})
    rarefactions6 <- lapply(rarefactions5, calculations)
    out <- dplyr::bind_rows(rarefactions6) %>% dplyr::group_by(.data$SampleID) %>%
      dplyr::summarise(Sprichness = mean(.data$Sprichness, na.rm = TRUE),
                       Shannon = mean(.data$Shannon, na.rm = TRUE),
                       Simpson = mean(.data$Simpson, na.rm = TRUE),
                       InvSimpson = mean(.data$InvSimpson, na.rm = TRUE),
                       Abundance = mean(.data$Abundance, na.rm = TRUE))
  }

return(out)
}
