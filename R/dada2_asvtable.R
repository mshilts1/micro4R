#' dada2 workflow to generate ASV table
#'
#' @param where Path to your fastq files.
#' @param patternF Pattern of the forward/R1 reads. Default is Illumina standard.
#' @param patternR Pattern of the reverse/R2 reads. Default is Illumina standard
#' @param multi Should multithreading be done? Can use this to set to TRUE or FALSE for entire wrapper.
#' @param ... Allows passing of arguments to nested functions
#' @param chatty How chatty should code be? Default is TRUE, but set to FALSE if you don't want so much text going to the console.
#' @param logfile Write a logfile to user's computer. Default is TRUE
#' @param example Set to TRUE to run example
#'
#' @returns dada2 ASV table
#' @export
#' @import dada2
#' @import rlang
#' @import utils
#' @import grDevices
#'
#' @examples
#' dada2_asvtable(example = TRUE)
dada2_asvtable <- function(where = NULL, example = FALSE, patternF = "_R1_001.fastq.gz", patternR = "_R2_001.fastq.gz", multi = FALSE, chatty = TRUE, logfile = TRUE, ...) {
  if (!is.null(where)) {
    if (where == "inst/extdata/f") {
      example <- TRUE
      where <- NULL
    }
  }

  if (example == TRUE) {
    logfile <- FALSE
  }

  if (example == TRUE & !is.null(where)) {
    stop("You can either run with example = TRUE or set a path to your fastq files with 'where'. You cannot do both.")
  }

  if (example == FALSE & is.null(where)) {
    where <- getwd()
    if (chatty == TRUE) {
      print(sprintf("As no argument was provided for the 'path' of your fastq files, this wrapper will assume you want to work in your current directory, %s", where))
    }
  }

  if (example == TRUE) {
    outdir <- tempdir()
    if (chatty == TRUE) {
      print(sprintf("Because you're running the example, any output files will go to a temporary directory, %s/dada2_out. To avoid cluttering your computer, this folder and its contents should all be deleted at the end of your R session.", outdir))
    }
    if (!dir.exists(sprintf("%s/dada2_out/figs", outdir))) {
      # If it doesn't exist, create it
      dir.create(sprintf("%s/dada2_out/figs", outdir), recursive = TRUE) # recursive = TRUE creates parent directories if needed
    }
  }


  if (example == FALSE) {
    if (!dir.exists(sprintf("%s/dada2_out/figs", where))) {
      # If it doesn't exist, create it
      dir.create(sprintf("%s/dada2_out/figs", where), recursive = TRUE) # recursive = TRUE creates parent directories if needed
    }
  }

  if (logfile) {
    functionname <- as.character(sys.call()[[1]])
    log_file_conn <- NULL
    if (example == TRUE) {
      log_file_conn <- file(sprintf("%s/dada2_out/%s_%s.log", outdir, format(Sys.time(), "%Y-%m-%d_%H-%M-%S"), functionname), open = "wt")
    }
    if (example == FALSE) {
      log_file_conn <- file(sprintf("%s/dada2_out/%s_%s.log", where, format(Sys.time(), "%Y-%m-%d_%H-%M-%S"), functionname), open = "wt")
    }
    sink(log_file_conn, split = TRUE)
    print(sprintf("Run with function %s started at %s", functionname, Sys.time()))
  }

  passed_args <- list(...) # get a list of all arguments from user that we want/need to pass to nested functions. not doing anything with this yet. actual functionality to be added



  if (example == FALSE) {
    whereFastqs(where, chatty = chatty)
  }

  if (example == TRUE) {
    outdir <- tempdir()
    if (chatty == TRUE) {
      print(sprintf("Because you're running the example, any output files will go to a temporary directory, %s/dada2_out. To avoid cluttering your computer, this folder and its contents should all be deleted at the end of your R session.", outdir))
    }
  }


  if (example == TRUE) {
    fnFs <- system.file("extdata/f", package = "micro4R", mustWork = TRUE) %>% list.files("*_R1_001.fastq.gz", full.names = TRUE)
    fnRs <- system.file("extdata/f", package = "micro4R", mustWork = TRUE) %>% list.files("*_R2_001.fastq.gz", full.names = TRUE)
  }

  if (example == FALSE) {
    fnFs <- sort(list.files(where, pattern = patternF, full.names = TRUE))
    fnRs <- sort(list.files(where, pattern = patternR, full.names = TRUE))
    if (rlang::is_empty(fnFs)) {
      stop(sprintf("No fastq files were found matching pattern '%s'! Check that 1) you're looking for the files the correct directory, and 2) you're looking for the right file name pattern.", patternF))
    }
    if (rlang::is_empty(fnRs)) {
      stop(sprintf("No fastq files were found matching pattern '%s'! Check that 1) you're looking for the files the correct directory, and 2) you're looking for the right file name pattern.", patternR))
    }
  }

  sample.names <- gsub(patternF, "", basename(fnFs)) # create simplified sample names by stripping out the forward read pattern specified by user. *should* match reverse reads, unless something really weird going on with file names.

  if (example == FALSE) {
    filtFs <- file.path(where, "dada2_out/filtered", paste0(sample.names, "_F_filt.fastq.gz"))
    filtRs <- file.path(where, "dada2_out/filtered", paste0(sample.names, "_R_filt.fastq.gz"))
  }

  if (example == TRUE) {
    filtFs <- file.path(outdir, "dada2_out/filtered", paste0(sample.names, "_F_filt.fastq.gz"))
    filtRs <- file.path(outdir, "dada2_out/filtered", paste0(sample.names, "_R_filt.fastq.gz"))
  }

  out <- dada2::filterAndTrim(fwd = fnFs, filt = filtFs, rev = fnRs, filt.rev = filtRs, compress = TRUE, truncLen = c(240, 200), maxN = 0, maxEE = c(2, 2), truncQ = 2, rm.phix = TRUE, multithread = multi, matchIDs = TRUE, verbose = chatty)

  # why add the next three lines in? sometimes samples with few reads to start with may get entirely filtered out and cause a fatal error during the error rate learning step. so we need to make sure files still exist first.
  exists <- file.exists(filtFs) & file.exists(filtRs)
  filtFs <- filtFs[exists]
  filtRs <- filtRs[exists]

  errF <- dada2::learnErrors(filtFs, multithread = multi, verbose = chatty)
  errR <- dada2::learnErrors(filtRs, multithread = multi, verbose = chatty)

  if (example == FALSE) { # create some dada2 figs

    if (!dir.exists(sprintf("%s/dada2_out/figs", where))) {
      # If it doesn't exist, create it
      dir.create(sprintf("%s/dada2_out/figs", where), recursive = TRUE) # recursive = TRUE creates parent directories if needed
    }

    grDevices::pdf(sprintf("%s/dada2_out/figs/plotQualityProfileForwardReads_first10_samples.pdf", where))
    print(dada2::plotQualityProfile(fnFs[1:10]))
    grDevices::dev.off()
    grDevices::pdf(sprintf("%s/dada2_out/figs/plotQualityProfileReverseReads_first10_samples.pdf", where))
    print(dada2::plotQualityProfile(fnRs[1:10]))
    grDevices::dev.off()

    grDevices::pdf(sprintf("%s/dada2_out/figs/plotQualityProfileForwardReads_aggregate_all.pdf", where))
    print(dada2::plotQualityProfile(fnFs, aggregate = TRUE))
    grDevices::dev.off()
    grDevices::pdf(sprintf("%s/dada2_out/figs/plotQualityProfileReverseReads_aggregate_all.pdf", where))
    print(dada2::plotQualityProfile(fnRs, aggregate = TRUE))
    grDevices::dev.off()
    grDevices::pdf(sprintf("%s/dada2_out/figs/plotErrorsForward.pdf", where))
    suppressWarnings(print(dada2::plotErrors(errF, nominalQ = TRUE)))
    grDevices::dev.off()

    grDevices::pdf(sprintf("%s/dada2_out/figs/plotErrorsReverse.pdf", where))
    suppressWarnings(print(dada2::plotErrors(errR, nominalQ = TRUE)))
    grDevices::dev.off()
  }

  derepFs <- dada2::derepFastq(filtFs, verbose = chatty)
  derepRs <- dada2::derepFastq(filtRs, verbose = chatty)

  if (example == FALSE) {
    names(derepFs) <- sample.names[exists]
    names(derepRs) <- sample.names[exists]
  }

  dadaFs <- dada2::dada(derepFs, err = errF, multithread = multi, verbose = chatty)
  dadaRs <- dada2::dada(derepRs, err = errR, multithread = multi, verbose = chatty)

  mergers <- dada2::mergePairs(dadaFs, derepFs, dadaRs, derepRs, verbose = chatty)

  seqtab <- dada2::makeSequenceTable(mergers)

  rownames(seqtab) <- gsub("_F_filt.fastq.gz", "", rownames(seqtab))

  # V4 region is ~250 bp, so sequences over this length are probably something else; we will get rid of anything > 260 bp
  sizedist <- data.frame(t(table(nchar(dada2::getSequences(seqtab)))))
  filtseqs <- sum(sizedist[, 3]
  [which(as.numeric(as.character(sizedist[, 2])) > 260)])
  filtseqs / sum(sizedist[, 3])
  seqtab2 <- seqtab[, nchar(colnames(seqtab)) %in% seq(240, 260)]
  # table(nchar(getSequences(seqtab2)))
  seqtab.nochim <- dada2::removeBimeraDenovo(seqtab2, method = "consensus", multithread = multi, verbose = chatty)
  # dim(seqtab.nochim)
  sum(seqtab.nochim) / sum(seqtab)
  getN <- function(x) sum(getUniques(x))
  track <- cbind(out, sapply(dadaFs, getN), sapply(dadaRs, getN), sapply(mergers, getN), rowSums(seqtab.nochim))
  colnames(track) <- c("input", "filtered", "denoisedF", "denoisedR", "merged", "nonchim")
  rownames(track) <- sample.names
  if (chatty == TRUE) {
    head(track)
  }

  seqtab.nochim.tibble <- as_tibble(seqtab, rownames = "SampleID")
  track.tibble <- as_tibble(track, rownames = "SampleID")

  if (example == FALSE) {
    write.csv(track.tibble, file = sprintf("%s/dada2_out/track_seqcounts.csv", where), row.names = FALSE)
    write.csv(seqtab.nochim.tibble, file = sprintf("%s/dada2_out/seqtab.nochim.csv", where), row.names = FALSE)
  }

  if (example == TRUE) {
    write.csv(track.tibble, file = sprintf("%s/dada2_out/track_seqcounts.csv", outdir), row.names = FALSE)
    write.csv(seqtab.nochim.tibble, file = sprintf("%s/dada2_out/asvtable.csv", outdir), row.names = FALSE)
    on.exit(unlink(outdir), add = TRUE)
  }

  # converter(seqtab.nochim, out = "tibble")

  seqtab.nochim <- converter(seqtab.nochim, out = "tibble")

  if (chatty == TRUE) {
    return(seqtab.nochim)
  }

  if (chatty == FALSE) {
    return(invisible(seqtab.nochim))
  }

  if (logfile) {
    print(sprintf("Run with function %s ended at %s", functionname, Sys.time()))
    on.exit(sink(), add = TRUE)
    on.exit(close(log_file_conn), add = TRUE)
  }
}
