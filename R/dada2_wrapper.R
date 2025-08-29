#' Dada2 Wrapper
#'
#' @param where Path to your fastq files. Run `dada2_wrapper(path = "example")` if you want to run the example data.
#' @param patternF Pattern of the forward/R1 reads
#' @param patternR Pattern of the reverse/R2 reads
#' @param ... Can alter parameters of dada2 functions if needed
#'
#' @returns dada2 ASV table and taxonomy table
#' @export
#' @import dada2
#' @import rlang
#' @import utils
#' @import grDevices
#'
#' @examples
#' dada2_wrapper("example")
dada2_wrapper <- function(where = NULL, patternF = "_R1_001.fastq.gz", patternR = "_R2_001.fastq.gz", ...) {
  if (is.null(where)) {
    where <- findUserCD()
    print(sprintf("As no argument was provided for the 'path' of your fastq files, this wrapper will assume you want to work in your current directory, %s", where))
  }

  if (where == "example") {
    fnFs <- system.file("extdata/f", package = "micro4R", mustWork = TRUE) %>% list.files("*_R1_001.fastq.gz", full.names = TRUE)
    fnRs <- system.file("extdata/f", package = "micro4R", mustWork = TRUE) %>% list.files("*_R2_001.fastq.gz", full.names = TRUE)

    filtFs <- system.file("extdata/f/filtered", package = "micro4R", mustWork = TRUE) %>% list.files("*_F_filt.fastq.gz", full.names = TRUE)
    filtRs <- system.file("extdata/f/filtered", package = "micro4R", mustWork = TRUE) %>% list.files("*_R_filt.fastq.gz", full.names = TRUE)
  }

  if (where != "example") {
    fnFs <- sort(list.files(where, pattern = patternF, full.names = TRUE))
    fnRs <- sort(list.files(where, pattern = patternR, full.names = TRUE))
    if (rlang::is_empty(fnFs)) {
      stop(sprintf("No fastq files were found matching pattern '%s'! Check that 1) you're looking for the files the correct directory, and 2) you're looking for the right file name pattern.", patternF))
    }
    if (rlang::is_empty(fnRs)) {
      stop(sprintf("No fastq files were found matching pattern '%s'! Check that 1) you're looking for the files the correct directory, and 2) you're looking for the right file name pattern.", patternR))
    }
  }

  sample.names <- gsub(patternF, "", basename(fnFs)) # create simplified sample names by stripped out the forward read pattern specified by user
  # print(sample.names)

  if (where != "example") {
    filtFs <- file.path(where, "filtered", paste0(sample.names, "_F_filt.fastq.gz"))
    filtRs <- file.path(where, "filtered", paste0(sample.names, "_R_filt.fastq.gz"))
    out <- dada2::filterAndTrim(fnFs, filtFs, fnRs, filtRs, truncLen = c(240, 200), maxN = 0, maxEE = c(2, 2), truncQ = 2, rm.phix = TRUE, compress = TRUE, multithread = TRUE)

    # why add the next three lines in? all reads negative controls and samples that amplified poorly with very few reads to start with may get entirely filtered out and cause a fatal error during the error rate learning step. so we need to make sure files still exist first.
    exists <- file.exists(filtFs) & file.exists(filtRs)
    filtFs <- filtFs[exists]
    filtRs <- filtRs[exists]
    # print(exists)
    # return(filtFs)
  }

  if (where == "example") {
    #cat("\nPlease note that, because the main goal of dada2::filterAndTrim is to *write* filtered fastq files to the user's computer, and you chose to use the 'example' data, this function was NOT run. The filtered fastq reads already exist as example data for this package, so this package won't try to write the any data to your computer. With your own data, dada2::filterAndTrim will actually run, and make take some time, depending on the size of your input data!\n\n")

    out <- dada2::filterAndTrim(fnFs, filtFs, fnRs, filtRs, truncLen = c(240, 200), maxN = 0, maxEE = c(2, 2), truncQ = 2, rm.phix = TRUE, compress = TRUE, multithread = TRUE)

  }


  errF <- dada2::learnErrors(filtFs, multithread = TRUE)
  errR <- dada2::learnErrors(filtRs, multithread = TRUE)

  if (where != "example") { # create some dada2 figs

    if (!dir.exists(sprintf("%s/dada2_figs", where))) {
      # If it doesn't exist, create it
      dir.create(sprintf("%s/dada2_figs", where), recursive = TRUE) # recursive = TRUE creates parent directories if needed
    }

    grDevices::pdf(sprintf("%s/dada2_figs/plotQualityProfileForwardReads_first10_samples.pdf", where))
    print(dada2::plotQualityProfile(fnFs[1:10]))
    grDevices::dev.off()
    grDevices::pdf(sprintf("%s/dada2_figs/plotQualityProfileReverseReads_first10_samples.pdf", where))
    print(dada2::plotQualityProfile(fnRs[1:10]))
    grDevices::dev.off()

    grDevices::pdf(sprintf("%s/dada2_figs/plotQualityProfileForwardReads_aggregate_all.pdf", where))
    print(dada2::plotQualityProfile(fnFs, aggregate = TRUE))
    grDevices::dev.off()
    grDevices::pdf(sprintf("%s/dada2_figs/plotQualityProfileReverseReads_aggregate_all.pdf", where))
    print(dada2::plotQualityProfile(fnRs, aggregate = TRUE))
    grDevices::dev.off()
    grDevices::pdf(sprintf("%s/dada2_figs/plotErrorsForward.pdf", where))
    suppressWarnings(print(dada2::plotErrors(errF, nominalQ = TRUE)))
    grDevices::dev.off()

    grDevices::pdf(sprintf("%s/dada2_figs/plotErrorsReverse.pdf", where))
    suppressWarnings(print(dada2::plotErrors(errR, nominalQ = TRUE)))
    grDevices::dev.off()
  }

  derepFs <- dada2::derepFastq(filtFs, verbose = TRUE)
  derepRs <- dada2::derepFastq(filtRs, verbose = TRUE)

  if (where != "example"){
  names(derepFs) <- sample.names[exists]
  names(derepRs) <- sample.names[exists]
  }

  dadaFs <- dada2::dada(derepFs, err=errF, multithread=TRUE)
  dadaRs <- dada2::dada(derepRs, err=errR, multithread=TRUE)

  mergers <- dada2::mergePairs(dadaFs, derepFs, dadaRs, derepRs, verbose=TRUE)

  seqtab <- dada2::makeSequenceTable(mergers)

  # V4 region is ~250 bp, so sequences over this length are probably something else; we will get rid of anything > 260 bp
  sizedist<-data.frame(t(table(nchar(dada2::getSequences(seqtab)))))
  filtseqs<-sum(sizedist[,3]
                [which(as.numeric(as.character(sizedist[,2]))>260)])
  filtseqs/sum(sizedist[,3])
  seqtab2 <- seqtab[,nchar(colnames(seqtab)) %in% seq(240,260)]
  table(nchar(getSequences(seqtab2)))
  seqtab.nochim <- dada2::removeBimeraDenovo(seqtab2, method="consensus", multithread=TRUE, verbose=TRUE)
  dim(seqtab.nochim)
  sum(seqtab.nochim)/sum(seqtab)
  getN <- function(x) sum(getUniques(x))
  track <- cbind(out, sapply(dadaFs, getN), sapply(dadaRs, getN), sapply(mergers, getN), rowSums(seqtab.nochim))
  colnames(track) <- c("input", "filtered", "denoisedF", "denoisedR", "merged", "nonchim")
  rownames(track) <- sample.names
  head(track)

}
