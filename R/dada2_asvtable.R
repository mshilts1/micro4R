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
#' @param output For non-example runs, path to where you'd like output files to be stored. Defaults to a folder where your fastq files are stored.
#' @param truncLenPass pass to truncLen
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
dada2_asvtable <- function(where = NULL,
                           example = FALSE,
                           patternF = "_R1_001.fastq.gz",
                           patternR = "_R2_001.fastq.gz",
                           multi = FALSE,
                           chatty = TRUE,
                           logfile = TRUE,
                           output = NULL,
                           truncLenPass = c(240, 200),
                           ...) {
  is_true <- function(x) isTRUE(x)

  # Back-compat: allow where = "inst/extdata/f" to trigger example mode
  if (!is.null(where) && identical(where, "inst/extdata/f")) {
    example <- TRUE
    where <- NULL
  }

  if (is_true(example) && !is.null(where)) {
    stop("You can either run with example = TRUE or set a path to your fastq files with 'where'. You cannot do both.")
  }

  # Example runs never write logs to user machine
  if (is_true(example)) logfile <- FALSE

  # Resolve input directory for non-example run
  if (!is_true(example) && is.null(where)) {
    where <- getwd()
    if (is_true(chatty)) {
      message(sprintf(
        "No 'where' provided; using current working directory: %s",
        where
      ))
    }
  }

  # Resolve output base
  base_out <- if (is_true(example)) tempdir() else if (is.null(output)) where else output

  out_dir <- file.path(base_out, "dada2_out")
  figs_dir <- file.path(out_dir, "figs")
  filt_dir <- file.path(out_dir, "filtered")

  dir.create(figs_dir, recursive = TRUE, showWarnings = FALSE)
  dir.create(filt_dir, recursive = TRUE, showWarnings = FALSE)

  if (is_true(example) && is_true(chatty)) {
    message(sprintf(
      "Example run: outputs will be written under %s (temp).",
      out_dir
    ))
  }

  # Logfile handling (ensure cleanup always runs)
  if (is_true(logfile)) {
    functionname <- as.character(sys.call()[[1]])
    log_path <- file.path(
      out_dir,
      sprintf("%s_%s.log", format(Sys.time(), "%Y-%m-%d_%H-%M-%S"), functionname)
    )
    log_file_conn <- file(log_path, open = "wt")
    sink(log_file_conn, split = TRUE)
    on.exit(
      {
        try(sink(), silent = TRUE)
        try(close(log_file_conn), silent = TRUE)
      },
      add = TRUE
    )

    message(sprintf("Run with function %s started at %s", functionname, Sys.time()))
  }

  # Validate FASTQ presence for user runs
  if (!is_true(example)) {
    whereFastqs(where, chatty = chatty)
  }

  # Discover FASTQs
  if (is_true(example)) {
    fnFs <- list.files(
      system.file("extdata/f", package = "micro4R", mustWork = TRUE),
      pattern = "*_R1_001.fastq.gz",
      full.names = TRUE
    )
    fnRs <- list.files(
      system.file("extdata/f", package = "micro4R", mustWork = TRUE),
      pattern = "*_R2_001.fastq.gz",
      full.names = TRUE
    )
  } else {
    fnFs <- sort(list.files(where, pattern = patternF, full.names = TRUE))
    fnRs <- sort(list.files(where, pattern = patternR, full.names = TRUE))

    if (rlang::is_empty(fnFs)) {
      stop(sprintf(
        "No fastq files were found matching pattern '%s'! Check directory and filename pattern.",
        patternF
      ))
    }
    if (rlang::is_empty(fnRs)) {
      stop(sprintf(
        "No fastq files were found matching pattern '%s'! Check directory and filename pattern.",
        patternR
      ))
    }
  }

  sample.names <- gsub(patternF, "", basename(fnFs))

  # Filtered output paths
  filtFs <- file.path(filt_dir, paste0(sample.names, "_F_filt.fastq.gz"))
  filtRs <- file.path(filt_dir, paste0(sample.names, "_R_filt.fastq.gz"))

  if (is_true(chatty)) {
    message(sprintf("truncLen = c(%s)", paste(truncLenPass, collapse = ", ")))
  }

  out <- dada2::filterAndTrim(
    fwd = fnFs, filt = filtFs,
    rev = fnRs, filt.rev = filtRs,
    compress = TRUE,
    truncLen = truncLenPass,
    maxN = 0, maxEE = c(2, 2), truncQ = 2,
    rm.phix = TRUE,
    multithread = multi,
    matchIDs = TRUE,
    verbose = chatty
  )

  # Handle samples that were fully filtered out
  exists <- file.exists(filtFs) & file.exists(filtRs)
  filtFs2 <- filtFs[exists]
  filtRs2 <- filtRs[exists]
  samp2 <- sample.names[exists]

  if (length(filtFs2) == 0L) {
    stop("All samples were filtered out (no filtered FASTQs remain). Consider adjusting truncLen/maxEE.")
  }

  errF <- dada2::learnErrors(filtFs2, multithread = multi, verbose = chatty)
  errR <- dada2::learnErrors(filtRs2, multithread = multi, verbose = chatty)

  # Plots only for non-example (preserving your current behavior)
  if (!is_true(example)) {
    grDevices::pdf(file.path(figs_dir, "plotQualityProfileForwardReads_first10_samples.pdf"))
    print(dada2::plotQualityProfile(fnFs[1:min(10, length(fnFs))]))
    grDevices::dev.off()

    grDevices::pdf(file.path(figs_dir, "plotQualityProfileReverseReads_first10_samples.pdf"))
    print(dada2::plotQualityProfile(fnRs[1:min(10, length(fnRs))]))
    grDevices::dev.off()

    grDevices::pdf(file.path(figs_dir, "plotQualityProfileForwardReads_aggregate_all.pdf"))
    print(dada2::plotQualityProfile(fnFs, aggregate = TRUE))
    grDevices::dev.off()

    grDevices::pdf(file.path(figs_dir, "plotQualityProfileReverseReads_aggregate_all.pdf"))
    print(dada2::plotQualityProfile(fnRs, aggregate = TRUE))
    grDevices::dev.off()

    grDevices::pdf(file.path(figs_dir, "plotErrorsForward.pdf"))
    suppressWarnings(print(dada2::plotErrors(errF, nominalQ = TRUE)))
    grDevices::dev.off()

    grDevices::pdf(file.path(figs_dir, "plotErrorsReverse.pdf"))
    suppressWarnings(print(dada2::plotErrors(errR, nominalQ = TRUE)))
    grDevices::dev.off()
  }

  derepFs <- dada2::derepFastq(filtFs2, verbose = chatty)
  derepRs <- dada2::derepFastq(filtRs2, verbose = chatty)
  names(derepFs) <- samp2
  names(derepRs) <- samp2

  dadaFs <- dada2::dada(derepFs, err = errF, multithread = multi, verbose = chatty)
  dadaRs <- dada2::dada(derepRs, err = errR, multithread = multi, verbose = chatty)

  mergers <- dada2::mergePairs(dadaFs, derepFs, dadaRs, derepRs, verbose = chatty)
  seqtab <- dada2::makeSequenceTable(mergers)

  # Keep your V4 length filtering approach
  seqtab2 <- seqtab[, nchar(colnames(seqtab)) %in% seq(240, 260)]
  seqtab.nochim <- dada2::removeBimeraDenovo(
    seqtab2,
    method = "consensus",
    multithread = multi,
    verbose = chatty
  )

  getN <- function(x) sum(dada2::getUniques(x))

  track <- cbind(
    out[exists, , drop = FALSE],
    sapply(dadaFs, getN),
    sapply(dadaRs, getN),
    sapply(mergers, getN),
    rowSums(seqtab.nochim)
  )
  colnames(track) <- c("input", "filtered", "denoisedF", "denoisedR", "merged", "nonchim")
  rownames(track) <- samp2

  if (is_true(chatty)) {
    print(utils::head(track))
  }

  # Write outputs
  track.tibble <- tibble::as_tibble(track, rownames = "SampleID")
  asv.tibble <- tibble::as_tibble(seqtab.nochim, rownames = "SampleID") # FIX: nochim

  utils::write.csv(track.tibble, file = file.path(out_dir, "track_seqcounts.csv"), row.names = FALSE)
  utils::write.csv(asv.tibble, file = file.path(out_dir, "asvtable.csv"), row.names = FALSE)

  # Safe cleanup for example: delete only the created folder
  if (is_true(example)) {
    on.exit(unlink(out_dir, recursive = TRUE, force = TRUE), add = TRUE)
  }

  # Return as tibble via your converter()
  seqtab.nochim_tbl <- converter(seqtab.nochim, out = "tibble")

  if (is_true(logfile)) {
    message(sprintf("Run ended at %s", Sys.time()))
  }

  if (is_true(chatty)) {
    return(seqtab.nochim_tbl)
  }
  invisible(seqtab.nochim_tbl)
}
