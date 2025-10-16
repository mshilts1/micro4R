#' Calculate beta diversity dissimilarities with or without rarefaction
#'
#' @param asvtable Input ASV table. Can be filtered with filtering()
#' @param numRare Number of rarefactions to perform. Set to 0 if you do not want to do any rarefication.
#' @param method Dissimilarity index to use. See ?vegan::vegdist for more information.
#' @param metadata Metadata input object
#' @param category Name in metadata column that you'd like to use
#' @param minReads Minimum number of reads to keep a sample
#' @param ... allow passed arguments to nested functions
#'
#' @returns A dissimilarity matrix
#' @export
#' @import vegan
#'
#' @examples
#' asvtable <- unsampled_example()$asvtable
#' metadata <- unsampled_example()$metadata
#' calcBeta(asvtable = asvtable, metadata = metadata, category = "host_sex", method = "bray")
calcBeta <- function(asvtable = NULL, metadata = NULL, numRare = 400, method = "bray", category = NULL, minReads = 1000, ...) {

  averagedbc <- NULL

  asvtable <- filtering(asvtable, minDepth = minReads)

  #if(!is.null(metadata)){
    #asv_tib <- converter(asvtable, out = "tibble", id = "SampleID")
    kept_after_filtering <- asvtable %>% dplyr::select("SampleID")
    metadata <- metadata %>% dplyr::filter(!is.na(.data[[category]]))  # if there are any NAs in metadata, they'll be thrown out later anyway
    metadata <- dplyr::inner_join(kept_after_filtering, metadata, by = "SampleID")
    kept_after_filtering <- metadata %>% dplyr::select("SampleID")
    asvtable <- dplyr::inner_join(kept_after_filtering, asvtable, by = "SampleID")
    #merging <- list("merged" = merged, "asvs" = colnames(asv_tib), "meta" = colnames(metadata))
  #}

  #asvtable <- converter(asvtable, out = "data.frame")

  minlibrary <- min(rowSums(asvtable[-1]))



  if (numRare > 0) {
    rarefactions <- lapply(as.list(1:numRare), function(x) vegan::rrarefy(asvtable[-1], minlibrary))
    braycurtis <- lapply(rarefactions, function(x) vegan::vegdist(x, method = method, binary = TRUE))
    averagedbc <- Reduce("+", braycurtis) / length(braycurtis)
  } else {
    averagedbc <- vegan::vegdist(asvtable[-1], method = method, binary = TRUE)
  }

  mod<-vegan::betadisper(averagedbc, metadata[[category]])
  vctrs<-mod$vectors
  centroids<-data.frame(grps=rownames(mod$centroids),data.frame(mod$centroids))
  pcoa_metadata<-cbind(metadata, as.data.frame(vctrs))
  pcoa_metadata_tib <- converter(pcoa_metadata, out = "tibble")

  return(list("dissimilarities" = averagedbc, "betadisper_res" = mod, "pcoa_metadata" = pcoa_metadata_tib))
}
