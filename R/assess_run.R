#' Assess sequencing results
#'
#' @param metadata metadata object
#' @param asvtable asvtable object
#' @param wells wells for each sample. Expecting A01, A02, etc.
#' @param plate plate samples were on. Can be left as NULL if there's only one plate.
#' @param category Varible to label wells by. Makes the most sense if positive and negative controls are labeled.
#' @param minReads Minimum number of total reads for sample to be kept. Recommend to keep it at 1
#' @param ... Allows passing of arguments to nested functions. not being used at the moment.
#'
#' @returns figures visualizing results
#' @export
#' @importFrom tidyr separate
#'
#' @examples
#' out <- micro4R::assess_example
#' met <- out$metadata
#' asv <- out$asvtable
#' assess_run(metadata = met, asvtable = asv, wells = "well", plate = "Plate", category = "SampleType")
assess_run <- function(metadata = NULL, asvtable = NULL, wells = "Well", plate = NULL, category = NULL, minReads = 1, ...){

  metadata <- converter(metadata, out = "tibble")
  asvtable <- converter(asvtable, out = "tibble")

  if (!category %in% names(metadata)) {
    stop(sprintf("'category' column '%s' was not found in your input object.", category))
  }

  if (!wells %in% names(metadata)) {
    stop(sprintf("'wells' column '%s' was not found in your input object.", category))
  }

  asvtable <- asvtable %>% dplyr::rowwise() %>% dplyr::mutate("ReadCount" = sum(dplyr::c_across(where(is.numeric)))) %>%
    dplyr::filter(.data$ReadCount >= minReads)

  metadata <- metadata %>% tidyr::separate(.data[[wells]], into = c('row_name', 'column_name'), sep = 1, remove=FALSE)

 # both <- dplyr::inner_join(metadata, asvtable, by = "SampleID")
  both <- dplyr::inner_join(metadata, asvtable %>% select(.data$SampleID, .data$ReadCount), by = "SampleID")

  #return(metadata)

  if(is.null(plate)){
    allplates <- 1
  }

  if(!is.null(plate)){
    #platenum <- length(unique(metadata[[plate]]))
    allplates <- unique(metadata[[plate]])
  }

  for(j in allplates) {
    writeLines("\n    ")
    cat(sprintf("Plate %s", j))
    df_filter <- metadata %>% dplyr::filter(.data[[plate]]==j) %>% droplevels()

    print(ggplot(both, aes(y=.data$row_name, x = .data$column_name, label = .data[[category]])) + geom_point(aes(colour = .data$ReadCount), size = 18) + theme_bw() + labs(x=NULL, y = NULL) + scale_y_discrete(limits = rev) + geom_text() + scale_colour_gradient2(low="darkblue", high = "darkgreen", guide="colorbar"))
  }

  #return(asvtable)

}
