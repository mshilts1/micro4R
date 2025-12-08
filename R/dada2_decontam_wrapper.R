#' Wrapper of entire dada2/decontam process
#'
#' @param ... Arguments to pass to nested functions
#' @param passedargs List passed arguments. Using only for troubleshooting during development; not expected to have any use to end user
#' @param example Set to TRUE to run example
#' @param path path to your fastq files
#' @param train_db path to your training reference database
#' @param species_db path to your species database. OPTIONAL
#' @param metadata_obj your metadata object
#'
#' @returns A list of the new ASV table, taxa table, and metadata object
#' @export
#'
#' @examples
#' dada2_decontam_wrapper(example = TRUE)
dada2_decontam_wrapper <- function(example = FALSE, path = NULL, train_db = NULL, species_db = NULL, metadata_obj = NULL, passedargs = FALSE, ...) {
  passed_args <- list(...) # get a list of all arguments from user that we want/need to pass to nested functions. not doing anything with this yet. actual functionality to be added

  if (example == FALSE) {
    if (missing(path)) {
      stop("Argument 'path', with the path to your fastq files, is required.")
    }
    if (!missing(path)) {
      fastqs <- whereFastqs(path, return_tibble_or_path = "tibble", chatty = TRUE)
      # print(fastqs)
    }
    if (missing(train_db)) {
      stop("Argument 'train_db', with the path to the training database, is required.")
    }
    if (!missing(train_db)) {
      ref_db(train_db)
    }
    if (missing(metadata_obj)) {
      stop("Argument 'metadata_obj', with your metadata object, is required.")
    }
    # if (!missing(metadata_obj)) {
    # merged <- dplyr::inner_join(metadata_obj, fastqs, by = "SampleID", relationship = "one-to-one")
    # if(nrow(merged == 0) == 0){
    #  stop("There were zero matches between the SampleIDs that will be derived from your fastq files and the SampleIDs in your metadata object. Fix now as otherwise you'll get an error once it gets to decontam.")
    # }
    # }
  }

  if (passedargs == TRUE) {
    print(passed_args)
  }

  if (passedargs == FALSE) {
    if (example == TRUE) {
      dada2_out <- dada2_wrapper(example = TRUE, full.wrapper = TRUE, ...)
      asvtable <- converter(dada2_out$asvtable)
      taxa <- converter(dada2_out$taxa, id = "ASV")
      # metadata <- NULL
      # metadata <- dada2_out$metadata
      metadata <- example_metadata()
      all <- list("asvtable" = asvtable, "taxa" = taxa, "metadata" = metadata)
    }

    if (example == FALSE) {
      dada2_out <- dada2_wrapper(where = path, train = train_db, species = species_db, metadata = metadata_obj) # , full.wrapper = TRUE, ...)
      asvtable <- dada2_out$asvtable
      taxa <- dada2_out$taxa
      # metadata <- NULL
      metadata <- dada2_out$metadata
      # metadata <- example_metadata()
      all <- list("asvtable" = asvtable, "taxa" = taxa, "metadata" = metadata)
    }

    if (example == TRUE) {
      decontam_out <- decontam_wrapper(asvtable = all$asvtable, taxa = all$taxa, metadata = all$metadata, ...)
    }

    if (example == FALSE) {
      print(all)
      print(all$metadata)
      decontam_out <- decontam_wrapper(asvtable = all$asvtable, taxa = all$taxa, metadata = all$metadata, ...)
      asvtable <- converter(dada2_out$asvtable, out = "tibble", id = "SampleID")
      taxa <- converter(dada2_out$taxa, out = "tibble", id = "ASV")
      # metadata <- NULL
      #metadata <- converter(dada2_out$metadata, out = "tibble", id = "SampleID")
      all <- list("asvtable" = asvtable, "taxa" = taxa, "metadata" = metadata)
    }
  }
}
