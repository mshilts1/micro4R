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
