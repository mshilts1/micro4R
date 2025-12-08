#' Calculate beta diversity dissimilarities with or without rarefaction
#'
#' @param asvtable Input ASV table. Can be filtered with filtering()
#' @param numRare Number of rarefactions to perform. Set to 0 if you do not want to do any rarefication.
#' @param method Dissimilarity index to use. See ?vegan::vegdist for more information. Default is Bray-Curtis.
#' @param metadata Metadata input object
#' @param category Name in metadata column that you'd like to use
#' @param minReads Minimum number of reads to keep a sample
#' @param ... allow passed arguments to nested functions
#' @param makeFigs make some basic figures
#'
#' @returns A dissimilarity matrix
#' @export
#' @import vegan
#' @importFrom reshape2 melt
#'
#' @examples
#' asvtable <- unsampled_example()$asvtable
#' metadata <- unsampled_example()$metadata
#' calcBeta(asvtable = asvtable, metadata = metadata, category = "host_sex", method = "bray")
calcBeta <- function(asvtable = NULL, metadata = NULL, numRare = 400, method = "bray", category = NULL, minReads = 1000, makeFigs = FALSE, ...) {
  averagedbc <- NULL

  asvtable <- filtering(asvtable, minDepth = minReads)

  # if(!is.null(metadata)){
  # asv_tib <- converter(asvtable, out = "tibble", id = "SampleID")
  kept_after_filtering <- asvtable %>% dplyr::select("SampleID")
  metadata <- metadata %>% dplyr::filter(!is.na(.data[[category]])) # if there are any NAs in metadata, they'll be thrown out later anyway
  metadata <- dplyr::inner_join(kept_after_filtering, metadata, by = "SampleID")
  kept_after_filtering <- metadata %>% dplyr::select("SampleID")
  asvtable <- dplyr::inner_join(kept_after_filtering, asvtable, by = "SampleID")
  # merging <- list("merged" = merged, "asvs" = colnames(asv_tib), "meta" = colnames(metadata))
  # }

  # asvtable <- converter(asvtable, out = "data.frame")

  minlibrary <- min(rowSums(asvtable[-1]))



  if (numRare > 0) {
    rarefactions <- lapply(as.list(1:numRare), function(x) vegan::rrarefy(asvtable[-1], minlibrary))
    braycurtis <- lapply(rarefactions, function(x) vegan::vegdist(x, method = method, binary = TRUE))
    averagedbc <- Reduce("+", braycurtis) / length(braycurtis)
  } else {
    averagedbc <- vegan::vegdist(asvtable[-1], method = method, binary = TRUE)
  }

  mod <- vegan::betadisper(averagedbc, metadata[[category]])
  vctrs <- mod$vectors
  centroids <- data.frame(grps = rownames(mod$centroids), data.frame(mod$centroids))
  pcoa_metadata <- cbind(metadata, as.data.frame(vctrs))
  pcoa_metadata_tib <- converter(pcoa_metadata, out = "tibble")

  if(makeFigs == TRUE){
    grDevices::pdf(sprintf("calcBeta_ggplot2_pcoa_plot_%s_%s.pdf", method, category))
    print(ggplot(pcoa_metadata, aes(x=.data$PCoA1, y=.data$PCoA2)) + geom_point(shape=21, size=3, alpha=0.7, aes(fill=.data[[category]])) + stat_ellipse(geom="polygon", alpha=0.2, level=0.9, aes(colour=.data[[category]], fill=.data[[category]])) + geom_point(data=centroids, size=5, shape=23, aes(x=.data$PCoA1, y=.data$PCoA2, fill=.data$grps)) + scale_colour_brewer(palette="Set1") + scale_fill_brewer(palette="Set1") + theme(strip.background = element_rect(fill="black")) + theme(strip.text = element_text(colour="white", face="bold")) + theme(legend.title=element_blank()) + xlab("PCoA 1") + ylab("PCoA 2")) #+ facet_wrap(~.data[[category]])
    dev.off()

    eigtab<-matrix(c(mod$eig[1]/sum(mod$eig)*100, mod$eig[2]/sum(mod$eig)*100, mod$eig[3]/sum(mod$eig)*100, mod$eig[4]/sum(mod$eig)*100, mod$eig[5]/sum(mod$eig)*100, mod$eig[6]/sum(mod$eig)*100, mod$eig[7]/sum(mod$eig)*100, mod$eig[8]/sum(mod$eig)*100, mod$eig[9]/sum(mod$eig)*100, mod$eig[10]/sum(mod$eig)*100), ncol=10)
    colnames(eigtab) <- c('PCoA1','PCoA2','PCoA3','PCoA4','PCoA5','PCoA6','PCoA7','PCoA8','PCoA9','PCoA10')
    rownames(eigtab) <- c('eigperc')
    eigtab_l<-reshape2::melt(eigtab)
    grDevices::pdf(sprintf("calcBeta_scree_plot_%s_%s.pdf", method, category))
    print(ggplot(eigtab_l, aes(x=.data$Var2, y=.data$value)) + geom_bar(stat="identity") + xlab("\nPCoA axis") + ylab("Eigenvalue %") + theme_bw())
    dev.off()
  }

  return(list("dissimilarities" = averagedbc, "betadisper_res" = mod, "pcoa_metadata" = pcoa_metadata_tib))
}
