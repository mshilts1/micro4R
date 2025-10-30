#' Assess sequencing results
#'
#' @param metadata metadata object
#' @param asvtable asvtable object
#' @param wells wells for each sample. Expecting A01, A02, etc.
#' @param plate plate samples were on. Can be left as NULL if there's only one plate.
#' @param category Varible to label wells by. Makes the most sense if positive and negative controls are labeled.
#' @param minReadCount Minimum number of total reads for sample to be kept. Recommend to keep it at 0, but can change that if you want.
#' @param pcoa Include PCoA data (can significantly increase run time, so set to FALSE by default)
#' @param ... Allows passing of arguments to nested functions. not being used at the moment.
#' @param corrplot Generate correlation plots. Set to FALSE by default as for now not sure how helpful it actually is
#' @param taxa taxa object
#'
#' @returns figures visualizing results
#' @importFrom tidyr separate
#' @importFrom corrplot corrplot
#' @importFrom gt gt
#' @export
#'
#' @examples
#' out <- micro4R::assess_example
#' met <- out$metadata
#' asv <- out$asvtable
#' tax <- out$taxa
#' assess_run(metadata = met, asvtable = asv, taxa = tax, wells = "well", plate = "Plate", category = "SampleType")
assess_run <- function(metadata = NULL, asvtable = NULL, taxa = NULL, wells = "Well", plate = NULL, category = NULL, minReadCount = 0, pcoa = FALSE, corrplot = FALSE, ...){

  output_path <- tempdir()

  #if (example == TRUE) {
  output_path <- tempdir()
    if (!dir.exists(sprintf("%s/dada2_out/assess_run", output_path))) {
      # If it doesn't exist, create it
      dir.create(sprintf("%s/dada2_out/assess_run", output_path), recursive = TRUE) # recursive = TRUE creates parent directories if needed
    }

  cat("---
title: \"Run Assessment\"
date: \'", format(Sys.Date(), '%B %d, %Y'), "\'
output:
  html_document:
    toc: true
    toc_depth: 4
    toc_float: true
    number_sections: true
---

\`\`\`{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
\`\`\`

### Plots
\`\`\`{r example, echo=FALSE}


  metadata <- converter(metadata, out = \"tibble\")
  asvtable <- converter(asvtable, out = \"tibble\")
  taxa <- converter(taxa, out = \"tibble\")

  asv_rel <-normalize(asvtable)

  negative_vector <- c(\"negative\", \"neg\")
  negatives <- NULL
  negatives <- metadata %>% dplyr::mutate(isNeg = dplyr::case_when(
    .data[[category]] %in% negative_vector ~ 1,
    !(.data[[category]] %in% negative_vector) ~ 0
  ))

  if (!category %in% names(metadata)) {
    stop(sprintf(\"'category' column '%s' was not found in your input object.\", category))
  }

  if (!wells %in% names(metadata)) {
    stop(sprintf(\"'wells' column '%s' was not found in your input object.\", wells))
  }

  asvtable <- asvtable %>% dplyr::rowwise() %>% dplyr::mutate(\"ReadCount\" = sum(dplyr::c_across(where(is.numeric)))) %>%
    dplyr::filter(.data$ReadCount >= minReadCount)

  metadata <- metadata %>% tidyr::separate(.data[[wells]], into = c('row_name', 'column_name'), sep = 1, remove=FALSE)

 # both <- dplyr::inner_join(metadata, asvtable, by = \"SampleID\")
  both <- dplyr::inner_join(metadata, asvtable %>% select(.data$SampleID, .data$ReadCount), by = \"SampleID\")
  both2 <- dplyr::inner_join(metadata %>% select(.data$SampleID, .data[[plate]]), asvtable %>% select(-.data$ReadCount), by = \"SampleID\")
\`\`\`

### Read Count Summary

\`\`\`{r readcounts, echo=FALSE}
  read_counts_table<-both %>% group_by(.data[[category]]) %>% dplyr::summarize(mean=mean(ReadCount),
min=min(ReadCount), max=max(ReadCount), median=median(ReadCount), q1=quantile(ReadCount, 0.25), q3=quantile(ReadCount,0.75), LessThan1000=sum(ReadCount<1000), TotalCategory=sum(ReadCount>=0))

read_counts_table %>% gt::gt(caption = \"Read Counts Summary\") %>% gt::fmt_number(decimals = 0)

ggplot(both, aes(x=.data[[category]], y = .data$ReadCount, fill = .data[[category]])) + geom_boxplot() + theme_bw()
\`\`\`

### Positive Control(s) Assessment
\`\`\`{r poscontrol, echo=FALSE}
  positive_vector <- c(\"positive\", \"pos\")
  positives <- NULL
  positives <- metadata %>% dplyr::mutate(isPos = dplyr::case_when(
    .data[[category]] %in% positive_vector ~ 1,
    !(.data[[category]] %in% positive_vector) ~ 0
  )) %>%
  dplyr::filter(.data$isPos == 1) %>%
  dplyr::select(.data$SampleID)

  positive_seqs <- dplyr::left_join(positives, asvtable, by = \"SampleID\") %>% dplyr::select_if(function(col) !all(col == 0)) %>% dplyr::select(-.data$ReadCount)

  positive_seqs_rel <- normalize(positive_seqs) %>% tidyr::pivot_longer(!.data$SampleID, names_to = \"ASV\", values_to = \"value\")

  positive_seqs_rel <- dplyr::left_join(positive_seqs_rel, taxa, by = \"ASV\")


  positive_seqs_rel_genus <- positive_seqs_rel %>% dplyr::select(.data$SampleID, .data$Genus, .data$value)
  positive_seqs_rel_genus <- dplyr::bind_rows(positive_seqs_rel_genus, create_pos(zymo_opt = \"B\")$freqs)

  ncols<-length(unique(positive_seqs_rel_genus$Genus))
  mycolors <- colorRampPalette(RColorBrewer::brewer.pal(8, \"Set2\"))(ncols)

print(ggplot(positive_seqs_rel_genus, aes(x=SampleID, y=value, fill=Genus)) + geom_bar(stat=\"identity\") + scale_fill_manual(values=mycolors, name=\"Genus\") + theme_bw() + xlab(\"\nSample ID\") + ylab(\"Relative abundance\")) #+ theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))

  positive_seqs_counts <- positive_seqs %>% dplyr::select(-c(.data$SampleID)) %>% dplyr::select_if(colSums(.) != 0)

  match.ref <- sum(sapply(names(positive_seqs), function(x) any(grepl(x, create_pos()$seqs))))

  no.match <- sapply(names(positive_seqs), function(x) any(grepl(x, create_pos()$seqs)))

  no.match.df <- as.data.frame(no.match)
  no.match.tib <- converter(no.match.df, out = \"tibble\", id = \"ASV\")
  no.match.tib <- no.match.tib %>% dplyr::filter(.data$no.match == FALSE)
  no.match.tib <- dplyr::left_join(no.match.tib, taxa, by = \"ASV\")

  refs <- create_pos()$seqs_tib

  no.match.tib$Genus %in% create_pos()$seqs_tib$ind
\`\`\`

dada2 inferred `r ncol(positive_seqs_counts)` sample sequences present in the mock community sample(s). Of those, `r sum(match.ref)` were exact matches to the expected reference sequences.

\`\`\`{r empty, echo=FALSE}
\`\`\`

### Well Heatmap Plots {.tabset}

#### Well Heatmap Read Counts

\`\`\`{r heatmap_plots, echo=FALSE}
  #if (example == FALSE) {
  output_path <- tempdir()
    if (!dir.exists(sprintf(\"%s/dada2_out/assess_run\", output_path))) {
      # If it doesn't exist, create it
      dir.create(sprintf(\"%s/dada2_out/assess_run\", output_path), recursive = TRUE) # recursive = TRUE creates parent directories if needed
    }
  #}

  #return(metadata)



  if(is.null(plate)){
    allplates <- 1
  }

  if(!is.null(plate)){
    #platenum <- length(unique(metadata[[plate]]))
    allplates <- unique(metadata[[plate]])
  }


  #### heatmap by read counts
  for(j in allplates) {
    writeLines(\"\n    \")
    cat(sprintf(\"Plate %s\", j))
    df_filter <- both %>% dplyr::filter(.data[[plate]]==j) %>% droplevels()

    p <- print(ggplot(df_filter, aes(y=.data$row_name, x = .data$column_name, label = .data[[category]])) + geom_point(aes(colour = .data$ReadCount), size = 18) + theme_bw() + labs(x=NULL, y = NULL) + scale_y_discrete(limits = rev) + geom_text() + scale_colour_gradient2(low=\"darkblue\", high = \"darkgreen\", guide=\"colorbar\"))

    #mid <- median(df_filter$ReadCount)
    #grDevices::pdf(sprintf(\"%s/dada2_out/assess_run/reads_plate%s_heatmap.pdf\", output_path, j), width = 9, height = 9)
    #p
    #grDevices::dev.off()

    #print(p)
  }

  #return(asvtable)

\`\`\`

#### Well Heatmap PCoA

\`\`\`{r heatmap_plots_pcoa, echo=FALSE}

  #### heatmap by pcoa1
  if(pcoa == TRUE){

  pcoa_out <- calcBeta(asvtable = asvtable, metadata = metadata, numRare = 0, minReads = 1, category = category)

  for(j in allplates) {
    writeLines(\"\n    \")
    cat(sprintf(\"Plate %s\", j))
    df_filter <- pcoa_out$pcoa_metadata %>% dplyr::filter(.data[[plate]]==j) %>% droplevels()

    p <- print(ggplot(df_filter, aes(y=.data$row_name, x = .data$column_name, label = .data[[category]])) + geom_point(aes(colour = .data$PCoA1), size = 18) + theme_bw() + labs(x=NULL, y = NULL) + scale_y_discrete(limits = rev) + geom_text() + scale_colour_gradient2(low=\"darkblue\", high = \"darkgreen\", guide=\"colorbar\"))

    #mid <- median(df_filter$ReadCount)
    grDevices::pdf(sprintf(\"%s/dada2_out/assess_run/PCoA1_plate%s_heatmap.pdf\", output_path, j), width = 9, height = 9)
    p
    grDevices::dev.off()
  }
  }

  #### corrplot
  if(corrplot==TRUE){
    #platenum <- length(unique(df_table$Plate))
    writeLines(\"\n    \")
    cat(\"Correlation plot\")
    for(j in allplates) {
      writeLines(\"\n    \")
      cat(sprintf(\"Plate %s\", j))
      df_filter <- both2 %>% filter(.data[[plate]]==j) %>% droplevels()

      #df_filter <- df_filter[colnames(asvtable)]
      df_filter1 <- df_filter %>% select(-c(.data$SampleID, .data[[plate]]))
      df_filter1_t <- as.data.frame(t(df_filter1))
      rownames(df_filter1_t)<-NULL

      corr = stats::cor(df_filter1_t)

      p <- corrplot::corrplot(corr, method = 'square', diag = FALSE, addrect = 3, rect.col = 'blue', rect.lwd = 3, tl.pos = 'd')

      #print(corrplot(corr))
      grDevices::pdf(sprintf(\"%s/dada2_out/assess_run/corrplot_plate%s_heatmap.pdf\", output_path, j), width = 9, height = 9)
      p
      grDevices::dev.off()

    }
  }

\`\`\`",
      file = sprintf("%s/dada2_out/assess_run/Run_assessment.Rmd", output_path))
  rmarkdown::render(sprintf("%s/dada2_out/assess_run/Run_assessment.Rmd", output_path))
}
