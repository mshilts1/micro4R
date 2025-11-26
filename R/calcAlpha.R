#' Title
#'
#' @param asvtable ASV table
#' @param metadata metadata
#' @param numRare optional number of rarefactions to perform on data
#' @param method doesn't do anything yet; may remove
#' @param category category to use for grouping data
#' @param minReads minimum number of reads to keep a sample
#'
#' @returns a list of
#' @export
#'
#' @examples
#' asvtable <- unsampled_example()$asvtable
#' metadata <- unsampled_example()$metadata
#' calcAlpha(asvtable = asvtable, metadata = metadata, category = "SampleType")
calcAlpha <- function(asvtable = NULL, metadata = NULL, numRare = 400, method = "standard", category = NULL, minReads = 1000){


  merged <- dplyr::left_join(asvtable, metadata %>% select(c(.data$SampleID, .data[[category]])), by = "SampleID")

  merged <- tidyr::pivot_longer(merged, cols = !c(.data$SampleID, .data[[category]]), names_to = "ASV", values_to = "value")

by_cat <-  merged %>%
    dplyr::group_by(.data[[category]]) %>%
    dplyr::summarise(Sprichness = vegan::specnumber(.data$value),
              Shannon = vegan::diversity(.data$value, index = "shannon"),
              Simpson = vegan::diversity(.data$value, index = "simpson"),
              InvSimpson = 1/.data$Simpson,
              Abundance = sum(.data$value))

all <-  merged %>%
    dplyr::group_by(.data$SampleID) %>%
    dplyr::summarise(Sprichness = vegan::specnumber(.data$value),
                     Shannon = vegan::diversity(.data$value, index = "shannon"),
                     Simpson = vegan::diversity(.data$value, index = "simpson"),
                     InvSimpson = 1/.data$Simpson,
                     Abundance = sum(.data$value))
return(list("by_sample" = all, "by_category" = by_cat))

}
