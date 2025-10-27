#' Collection of helper/utility functions not really intended to be directly used by end user
#' Path to user's fastq file folder
#'
#' @param path Path to folder containing fastq files
#' @param chatty If set to FALSE, don't print as much to console.
#' @param return_tibble_or_path Default is 'path', but instead can have it return a tibble of the files it found. should only ever be used for troubleshooting.
#'
#' @returns file path to a folder
#' @export
#' @import stringr
#'
#' @examples
#' whereFastqs(".")
whereFastqs <- function(path = NULL, chatty = TRUE, return_tibble_or_path = "path") {
  # Check if the folder exists first
  if (!file.exists(path)) {
    stop("Error: The folder you provided does not exist at the provided path.")
  }

  # Check if the file is a directory (not a file)
  if (!file_test("-d", path)) {
    stop("Error: You provided a path to a file; provide path to the directory where your fastq files are located.")
  }

  files <- tibble::as_tibble(list.files(path, pattern = "\\."))
  if (return_tibble_or_path == "tibble") {
    files <- files %>%
      dplyr::rename(SampleID = .data$value) %>%
      dplyr::filter(stringr::str_detect(.data$SampleID, "R1"))
    if (chatty == TRUE) {
      return(files)
    }
    if (chatty == FALSE) {
      return(invisible(files))
    }
  }
  if (chatty == TRUE & return_tibble_or_path != "tibble") { # if chatty is false, do nothing
    print(files)
  }


  if (return_tibble_or_path != "tribble") {
    fastq_filename_patterns <- tibble::tribble(
      ~pattern,
      "fastq",
      "fq",
      "R1",
      "R2"
    )

    files <- files %>%
      dplyr::mutate(
        fastq = stringr::str_count(.data$value, regex("fastq", ignore_case = TRUE)),
        fq = stringr::str_count(.data$value, regex("fq", ignore_case = TRUE)),
        R1 = stringr::str_count(.data$value, regex("R1", ignore_case = TRUE)),
        R2 = stringr::str_count(.data$value, regex("R2", ignore_case = TRUE)),
      ) %>%
      rowwise() %>%
      dplyr::mutate(any_fq = sum(c_across(c(.data$fastq, .data$fq)))) %>%
      ungroup()

    fastq_sum <- files %>%
      summarise(total_value = sum(.data$any_fq)) %>%
      as.numeric()
    r1_sum <- files %>%
      summarise(total_value = sum(.data$R1)) %>%
      as.numeric()
    r2_sum <- files %>%
      summarise(total_value = sum(.data$R2)) %>%
      as.numeric()

    if (r1_sum == r2_sum & r1_sum * 2 == fastq_sum) {
      print(sprintf("The total number of potential FASTQ files detected in the directory was %s, and the number of potential forward reads and reverse reads was %s. Please note that this is only performing simple pattern matching to look for standard Illumina-named files, and is only provided as a simple sanity check for you!", fastq_sum, r1_sum))
    }

    if (r1_sum != r2_sum) {
      print(sprintf("CAUTION: the number of forward reads and reverse reads does not appear to match! The total number of potential FASTQ files detected in the directory was %s, the number of potential forward reads was %s and reverse reads was %s. Please note that this is only performing simple pattern matching to look for standard Illumina-named files, and is only provided as a simple sanity check for you! If you're sure everything is OK, then carry on.", fastq_sum, r1_sum, r2_sum))
    }

    if (r1_sum * 2 != fastq_sum | r2_sum * 2 != fastq_sum) {
      print(sprintf("CAUTION: the number of total reads detected is not double the number of either forward or reverse reads. The total number of potential FASTQ files detected in the directory was %s, the number of potential forward reads was %s, and reverse reads was %s. Please note that this is only performing simple pattern matching to look for standard Illumina-named files, and is only provided as a simple sanity check for you!", fastq_sum, r1_sum, r2_sum))
    }


    if (chatty == TRUE) {
      return(path)
    }

    if (chatty == FALSE) {
      return(invisible(path))
    }
  }
}
#' A simple tibble of the names of maintained dada2-formatted taxonomy reference databases
#'
#' @param what A keypair listing the expected pattern name or a vector of the known names.
#'
#' @returns A tibble
#' @export
#'
#' @examples
#' known_dada2_dbs()
known_dada2_dbs <- function(what = "list") {
  if (what != "keypair" & what != "list" & !is.null(what)) {
    stop("You did not provide a valid value. Valid options are 'list' or 'keypair'.")
  }

  if (what == "keypair") { # i wasn't smart enough to get this to work properly, but saving in case i ever do figure it out
    return_value <- tibble::tribble(
      ~db, ~pattern,
      "silva", "^silva_.*fa.gz$",
      "rdp", "^rdp_.*trainset.fa.gz$",
      "greengenes", "^gg2_trainset.fa.gz$",
      "unite", "sh_general_release_all_.*tgz"
    )
  }

  if (what == "list") {
    return_value <- tibble::tribble(
      ~database, ~database_file_name,
      "GreenGenes", "gg2_2024_09_toGenus_trainset.fa.gz",
      "GreenGenes", "gg2_2024_09_toSpecies_trainset.fa.gz",
      "RDP", "rdp_19_toGenus_trainset.fa.gz",
      "RDP", "rdp_19_toSpecies_trainset.fa.gz",
      "UNITE", "sh_general_release_all_19.02.2025.tgz",
      "SILVA", "silva_nr99_v138.2_toGenus_trainset.fa.gz",
      "SILVA", "silva_nr99_v138.2_toSpecies_trainset.fa.gz",
      "SILVA", "silva_v138.2_assignSpecies.fa.gz",
    )
  }
  return(return_value)
}
#' Set a reference database for taxonomy assignment
#'
#' @param db File path to the reference database to use
#' @param chatty Set to FALSE for less text printed to console
#'
#' @returns The file path of the database
#' @export
#'
ref_db <- function(db, chatty = TRUE) {
  # db <- normalizePath(db)

  if (db == "inst/extdata/db/EXAMPLE_silva_nr99_v138.2_toGenus_trainset.fa.gz") {
    db <- system.file("extdata/db", package = "micro4R", "EXAMPLE_silva_nr99_v138.2_toGenus_trainset.fa.gz", mustWork = TRUE)
  }

  if (db == "inst/extdata/db/EXAMPLE_silva_v138.2_assignSpecies.fa.gz") {
    db <- system.file("extdata/db", package = "micro4R", "EXAMPLE_silva_v138.2_assignSpecies.fa.gz", mustWork = TRUE)
  }

  # Check if the file exists first
  if (!file.exists(db)) {
    stop("Error: The file name you provided does not exist at the provided path.")
  }

  # Check if the file is a file (not a directory)
  if (!file_test("-f", db)) {
    stop("Error: You provided a path to a directory. Provide the file name too. E.g., instead of /path/to/reference, use /path/to/reference/database.gz.")
  }

  filename <- basename(db)

  # Check if the file name matches *known* patterns:
  if (grepl("^silva_.*fa.gz$", filename) & chatty == TRUE) {
    print("Your reference taxonomic database is suspected to be one of the SILVA databases. If that does not seem correct to you, please check!")
  }
  if (grepl("^rdp_.*trainset.fa.gz$", filename) & chatty == TRUE) {
    print("Your reference taxonomic database is suspected to be one of the RDP databases. If that does not seem correct to you, please check!")
  }
  if (grepl("^gg2_.*trainset.fa.gz$", filename) & chatty == TRUE) {
    print("Your reference taxonomic database is suspected to be one of the greengenes databases. If that does not seem correct to you, please check!")
  }
  if (grepl("^sh_general_release_all_.*tgz", filename) & chatty == TRUE) {
    print("Your reference taxonomic database is suspected to be one of the UNITE all eukaryotes databases. If that does not seem correct to you, please check!")
  }
  if ((grepl("EXAMPLE_silva_nr99_v138.2_toGenus_trainset.fa.gz", filename) | grepl("EXAMPLE_silva_v138.2_assignSpecies.fa.gz", filename)) & chatty == TRUE) {
    print("CAUTION: You're using the provided micro4R EXAMPLE reference databases. These are extremely tiny and unrealistic and meant only for testing and demonstration purposes. DO NOT use them with your real data.")
  }
  if (!grepl("^silva_.*fa.gz$", filename) & !grepl("^rdp_.*trainset.fa.gz$", filename) & !grepl("^gg2_.*trainset.fa.gz$", filename) & !grepl("^sh_general_release_all_.*tgz", filename) & !grepl("EXAMPLE_silva_nr99_v138.2_toGenus_trainset.fa.gz", filename) & !grepl("EXAMPLE_silva_v138.2_assignSpecies.fa.gz", filename)) {
    print("The file name of your reference database did not match any of the known maintained dada2-formatted taxonomic databases. This does not mean your database is wrong! Just that it's not on my known list. Check below to see the names of all known databases:")
    print(known_dada2_dbs("list"))
  }

  if (chatty == TRUE) {
    return(db)
  }

  if (chatty == FALSE) {
    return(invisible(db))
  }
}
#' Converts tibbles, data frames, and matrices to each other as needed by the specific function
#'
#' @param x A tibble, data frame, or matrix that you want to convert
#' @param out What you want to conver it to out (tibble, data_frame, or matrix)
#' @param id ID column, if relevant
#'
#' @returns A tibble, data frame, or matrix
#' @export
#'
#' @examples
#' converter(contaminate()$asvtable)
#'
converter <- function(x = NULL, out = "matrix", id = "SampleID") {
  # quietly correct common possible typos

  if (out == "data_frame" | out == "df") {
    out <- "data.frame"
  }

  if (out == "tbl_df" | out == "tbl") {
    out <- "tibble"
  }

  if (out == "array") {
    out <- "matrix"
  }

  # stop if something is really wrong
  validout <- c("tibble", "data.frame", "matrix")
  if (!out %in% validout) stop("Invalid 'out' value. Valid options are 'tibble', 'data.frame', or 'matrix'.")

  if (!tibble::is_tibble(x) & !is.data.frame(x) & !is.matrix(x)) {
    stop("Input object is not a tibble, data frame, or matrix.")
  }

  # tibble converter
  if (tibble::is_tibble(x)) {
    # print(sprintf("tibble to %s", out))
    if (out == "matrix") {
      if (id %in% names(x)) {
        x <- column_to_rownames(x, var = id)
        x <- as.matrix(x)
        return(invisible(x))
      }
      if (!id %in% names(x)) {
        stop(sprintf("'id' column %s was not found in your input object.", id))
      }
    }

    if (out == "data.frame") {
      x <- as.data.frame(x)
      return(invisible(x))
    }

    if (out == "tibble") {
      # print("You requested to turn a tibble into a tibble, so the code is doing nothing.")
      return(invisible(x))
    }
  }

  # data frame converter
  if (!tibble::is_tibble(x) & is.data.frame(x)) {
    # print("table in")
    if (out == "data.frame") {
      # print("You requested to turn a data frame into a data frame, so the code is doing nothing.")
      return(invisible(x))
    }

    if (out == "matrix") {
      if (id %in% names(x)) {
        x <- column_to_rownames(x, var = id)
        x <- as.matrix(x)
        return(invisible(x))
      }
      #if (!id %in% names(x) & tibble::has_rownames(x) == TRUE) { #has_rownames failing sometimes
      if (!id %in% names(x) & identical(rownames(x), as.character(1:nrow(x))) == FALSE) {
        #x <- column_to_rownames(x, var = id)
        x <- as.matrix(x)
        return(invisible(x))
      }
      #if (!id %in% names(x) & tibble::has_rownames(x) == FALSE) {
      if (!id %in% names(x) & identical(rownames(x), as.character(1:nrow(x))) == TRUE) {
        stop(sprintf("'id' column '%s' was not found in your input object.", id))
      }
    }

    #if (out == "tibble"  & tibble::has_rownames(x) == TRUE) {
    if (out == "tibble"  & identical(rownames(x), as.character(1:nrow(x))) == FALSE) {
      if(id %in% names(x)){
        #print(x)
        #print(rownames(x))
        #print(has_rownames(x))
        #stop(print(x))
        #stop(sprintf("'id' column %s was already found in your input object, but you have rownames. Your input colnames are %s", id, names(x)))
      }
      x <- rownames_to_column(x, var = id)
      x <- tibble::as_tibble(x)
      return(invisible(x))
    }

    #if (out == "tibble"  & tibble::has_rownames(x) == FALSE) {
    if (out == "tibble"  & identical(rownames(x), as.character(1:nrow(x))) == TRUE) {
      x <- tibble::as_tibble(x)
      return(invisible(x))
    }
  }

  # matrix converter
  if ((!tibble::is_tibble(x) | !is.data.frame(x)) & is.matrix(x)) { # returns true only if matrix
    # print("matrix in")
    if (out == "matrix") {
      # print("You requested to turn a matrix into a matrix, so the code is doing nothing.")
      return(invisible(x))
    }

    if (out == "tibble") {
      if (identical(rownames(x), as.character(1:nrow(x)))) {
        x <- as_tibble(x, .name_repair = "unique")
        return(invisible(x))
      }

      if (!identical(rownames(x), as.character(1:nrow(x)))) {
        x <- as_tibble(x, rownames = id, .name_repair = "unique")
        return(invisible(x))
      }
    }

    if (out == "data.frame") {
      if (identical(rownames(x), as.character(1:nrow(x)))) {
        x <- as_tibble(x, .name_repair = "unique")
        x <- as.data.frame(x)
        return(invisible(x))
      }

      if (!identical(rownames(x), as.character(1:nrow(x)))) {
        x <- as_tibble(x, rownames = id, .name_repair = "unique")
        x <- as.data.frame(x)
        return(invisible(x))
      }
    }
  }
}
#' tibblefy a specific type of data frame. DEPRECATED. use converter() instead
#'
#' @param x data frame you want to turn into a tibble
#' @param type asvtable or taxa
#' @importFrom lifecycle deprecate_warn
#'
#' @returns a tibble
#'
tibblefy <- function(x, type = "asvtable") {
  lifecycle::deprecate_warn("0.0.0.9000", "tibblefy()", "converter()")
  if (type != "asvtable" & type != "taxa") {
    stop("Valid options for type are either 'asvtable' or 'taxa'.")
  }

  if (type == "asvtable") {
    rownames <- "SampleID"
  }

  if (type == "taxa") {
    rownames <- "ASV"
  }

  if (identical(rownames(x), as.character(1:nrow(x)))) {
    x <- as_tibble(x, .name_repair = "unique")
    return(x)
  }

  if (!identical(rownames(x), as.character(1:nrow(x)))) {
    x <- as_tibble(x, rownames = rownames, .name_repair = "unique")
    return(x)
  }
}
#' Load in example metadata file
#'
#' @returns An example metadata file
#' @export
#'
#' @examples
#' metadata <- example_metadata()
example_metadata <- function() {
  filepath <- system.file("extdata/objects", package = "micro4R", "metadata.csv", mustWork = TRUE)
  metadata <- read.csv(file = filepath, header = TRUE)
  metadata <- tibble::as_tibble(metadata)
  return(metadata)
}
#' Load in unsampled example
#'
#' @returns An list with the unsampled example metadata and asvtable files
#' @export
#'
#' @examples
#' unsampled_example()
unsampled_example <- function() {
  filepath <- system.file("extdata/objects", package = "micro4R", "unsampled_metadata.csv", mustWork = TRUE)
  metadata <- read.csv(file = filepath, header = TRUE)
  metadata <- tibble::as_tibble(metadata)

  filepath <- system.file("extdata/objects", package = "micro4R", "unsampled_asvtable.csv", mustWork = TRUE)
  asvtable <- read.csv(file = filepath, header = TRUE)
  asvtable <- tibble::as_tibble(asvtable)

  return(list("asvtable" = asvtable, "metadata" = metadata))
}
#' "Contaminate" the example ASV table so decontam can run in example
#'
#' @returns An artificially "contaminated" ASV table
#' @export
#'
#' @examples
#' contaminated_asvtable <- contaminate()
contaminate <- function() {
  filepath <- system.file("extdata/objects", package = "micro4R", "asvtable.csv", mustWork = TRUE)
  asvtable <- read.csv(file = filepath, header = TRUE)
  asvtable <- tibble::as_tibble(asvtable)
  # SAMPLED_5080-MS-1_307-ATAGTACC-ACGTCTCG_S307_L001 and SAMPLED_5080-MS-1_313-GACATAGT-TCGACGAG_S313_L001 are the negative controls

  asvtable <- dplyr::full_join(example_metadata(), asvtable, by = "SampleID")

  row_to_modify <- asvtable %>%
    dplyr::filter(.data$neg == TRUE) %>%
    dplyr::mutate(TACGTAGGTGGCAAGCGTTATCCGGAATTATTGGGCGTAAAGCGCGCGTAGGCGGTTTTTTAAGTCTGATGTGAAAGCCCACGGCTCAACCGTGGAGGGTCATTGGAAACTGGAAAACTTGAGTGCAGAAGAGGAAAGTGGAATTCCATGTGTAGCGGTGAAATGCGCAGAGATATGGAGGAACACCAGTGGCGAAGGCGACTTTCTGGTCTGTAACTGACGCTGATGTGCGAAAGCGTGGGGATCAAACAGG = 10)

  new_negs <- row_to_modify %>%
    dplyr::slice(rep(1:n(), times = c(3, 5))) %>%
    dplyr::mutate(SampleID = c("FakeNeg1", "FakeNeg2", "FakeNeg3", "FakeNeg4", "FakeNeg5", "FakeNeg6", "FakeNeg7", "FakeNeg8"))

  asvtable <- asvtable %>%
    dplyr::filter(.data$neg != TRUE) %>%
    dplyr::bind_rows(row_to_modify) %>%
    dplyr::bind_rows(new_negs)
  # dplyr::select(-c("LabID", "SampleType", "host_age", "host_sex", "Host_disease", "neg"))

  metadata <- asvtable %>% dplyr::select(c(colnames(example_metadata())))
  asvtable <- asvtable %>% dplyr::select(-c("LabID", "SampleType", "host_age", "host_sex", "Host_disease", "neg"))

  return(list("asvtable" = asvtable, "metadata" = metadata))
}
#' Package up your three objects (metadata, asvtable, taxonomy table) into a single list for less typing
#'
#' @param metadata Metadata object
#' @param asvtable ASV count table object
#' @param taxa Taxonomy table object
#'
#' @returns A list containing the above three objects
#' @export
#'
#' @examples
#' asvtable <- dada2_asvtable(example = TRUE)
#' train <- "inst/extdata/db/EXAMPLE_silva_nr99_v138.2_toGenus_trainset.fa.gz"
#' species <- "inst/extdata/db/EXAMPLE_silva_v138.2_assignSpecies.fa.gz"
#' taxa <- dada2_taxa(asvtable = asvtable, train = train, species = species)
#' metadata <- example_metadata()
#' all <- packItUp(metadata, asvtable, taxa)
packItUp <- function(asvtable = NULL, taxa = NULL, metadata = NULL) {
  return(list("asvtable" = asvtable, "taxa" = taxa, "metadata" = metadata))
}
#' Load test databases into environment without having to type so much.
#' Because I'm lazy and got really tired of finding the exact text to copy paste
#'
#' @returns a list of the example training and species databases
#' @export
#'
#' @examples
#' db <- test_dbs()
#' train <- db$train
#' species <- db$species
test_dbs <- function() {
  train <- system.file("extdata/db", package = "micro4R", "EXAMPLE_silva_nr99_v138.2_toGenus_trainset.fa.gz", mustWork = TRUE)
  species <- system.file("extdata/db", package = "micro4R", "EXAMPLE_silva_v138.2_assignSpecies.fa.gz", mustWork = TRUE)
  return(list("train" = train, "species" = species))
}
#' Simple function to check for a column called SampleID
#'
#' @param df Your ASV table or metadata object
#'
#' @returns Your ASV table or metadata object with your sample IDs column named 'SampleID'
#' @export
#'
#' @examples
#' checkSampleID(example_metadata())
checkSampleID <- function(df) {
  if (!("SampleID" %in% colnames(df))) {
    user_input <- readline(sprintf("A column called 'SampleID' was not detected. What is the column name that you're using as your sample IDs? "))
    if (!(user_input %in% colnames(df))) stop(sprintf("Column '%s' wasn't found in your data. Look for typos.", user_input))
    user_answer <- readline(sprintf("Is it OK to change column name '%s' to 'SampleID'? y/n: ", user_input))
    if (user_answer != "y") print("OK, no change made since you did not press y.")
    if (user_answer == "y") {
      df <- df %>% rename(SampleID = user_input)
      return(df)
    }
  }

  if ("SampleID" %in% colnames(df)) {
    sprintf("Looks good")
  }
}
#' checker utils in this section
#' Check your ASV count and taxonomy tables, and optionall metadata, for potential issues.
#'
#' @param asvtable The ASV table
#' @param taxa Its associated taxonomy table
#' @param metadata The associated metadata table
#' @param ids SampleIDs
#'
#' @returns Notifies user of issues with asvtable, taxonomy table, or metadata that could cause downstream problems.
#' @export
#'
#' @examples
#' out <- dada2_wrapper(example = TRUE)
#' checkAll(asvtable = out$asvtable, taxa = out$taxa, metadata = out$metadata)
#'
checkAll <- function(asvtable = NULL, taxa = NULL, metadata = NULL, ids = "SampleID") {
  asvtable <- converter(asvtable, out = "tibble")
  taxa <- converter(taxa, out = "tibble", id = "ASV")
  if (!is.null(metadata)) {
    metadata <- converter(metadata, out = "tibble")
  }

  if (!ncol(asvtable[-1]) == nrow(taxa)) {
    warning(sprintf("The number of ASVs in your ASV table doesn't match the number of ASVs in your taxonomy table."))
  }
  if (ncol(asvtable[-1]) == nrow(taxa)) {
    if (!all(colnames(asvtable[-1]) == taxa$ASV)) {
      warning(sprintf("The names of your ASVs in your ASV table don't match the names in the taxonomy table."))
    }
  }
  if (all(sapply(asvtable[-1], is.numeric)) == FALSE) {
    warning(sprintf("In your ASV table, not all columns (other than the SampleID) were identified as numeric. Check that you don't have anything that's not a number in your ASV count columns."))
  }

  if (!("SampleID" %in% colnames(asvtable))) {
    warning(sprintf("A column called 'SampleID' wasn't found in your ASV table '%s'. It's recommended to run checkSampleID(%s) first.", deparse(substitute(asvtable)), deparse(substitute(asvtable))))
  }

  if (!is.null(metadata)) {
    if (!("SampleID" %in% colnames(metadata))) {
      warning(sprintf("A column called 'SampleID' was not found in your metadata object '%s'. It's recommended to run checkSampleID(%s) first.", deparse(substitute(metadata)), deparse(substitute(metadata))))
    }

    if ("SampleID" %in% colnames(metadata) & "SampleID" %in% colnames(asvtable)) {
      if (nrow(merge(metadata, asvtable, by = "SampleID")) < 1) {
        warning(sprintf("After merging your metadata and ASV objects, no samples were retained. Check that the SampleIDs match in each object. For example, you may have a non-matching number of padded zeroes."))
      }
    }

    if (ids %in% colnames(metadata)) {
      dups <- unique(metadata[duplicated(metadata[[ids]]), ][ids])
      dups <- paste0(dups[[ids]], collapse = ", ")
      if (length(unique(metadata[[ids]])) != nrow(metadata)) {
        warning(sprintf("You indicated the variable to use for the sample IDs was %s. However, these are not all unique, and they need to be unique. Your duplicated sample ID(s) were: %s.", ids, dups))
      }
    }

    if (sum(!stats::complete.cases(metadata)) > 0) {
      print(sprintf("As least 1 NA or empty cell was detected in %s sample(s) in your metadata object. This is not necessarily bad or wrong, but if you were not expecting this, check your metadata object again. Sample(s) %s were detected to have NAs or empty cells.", sum(!stats::complete.cases(metadata)), paste0(metadata[!stats::complete.cases(metadata), ][[ids]], collapse = ", ")))
    }
  }

  print("No errors or warnings identified.")
}
#' Check metadata file to identify potential downstream issues. DEPRECATED
#'
#' @param df A data frame or tibble containing your sample metadata.
#' @param ids The column name in your data frame that identifies the sample IDs.
#'
#' @returns Returns warnings or errors with your metadata object that may cause downstream problems.
#' @export
#' @import tibble
#'
#' @examples
#' metadata <- data.frame(
#'   SampleIDs = c("Sample1", "Sample2", "Sample3"),
#'   Age       = c(34, 58, 21),
#'   Health    = c("Healthy", "Sick", NA)
#' )
#' checkMeta(metadata, "SampleIDs")
checkMeta <- NULL
checkMeta1 <- function(df, ids = "SampleID") {
  if (!is.data.frame(df) & !tibble::is_tibble(df)) {
    warning("R does not recognize your metadata object as either a data frame or tibble. There may be unexpected downstream issues. It is recommended you convert your metadata object to a data frame or a tibble before proceeding. E.g., try as.data.frame() or tibble::as_tibble() and check if your data still looks as expected.")
  }
}

checkMeta2 <- function(df, ids = "SampleID") {
  if (!ids %in% colnames(df)) {
    warning(sprintf("You indicated the variable to use for the sample IDs was %s. However, this was not found as a column name in your metadata file.", ids))
  }
}

checkMeta3 <- function(df, ids = "SampleID") {
  if (ids %in% colnames(df)) {
    dups <- unique(df[duplicated(df[[ids]]), ][ids])
    dups <- paste0(dups[[ids]], collapse = ", ")
    if (length(unique(df[[ids]])) != nrow(df)) {
      warning(sprintf("You indicated the variable to use for the sample IDs was %s. However, these are not all unique, and they need to be unique. Your duplicated sample ID(s) were: %s.", ids, dups))
    }
  }
}

checkMeta4 <- function(df, ids = "SampleID") {
  if (sum(!stats::complete.cases(df)) > 0) {
    warning(sprintf("As least 1 NA or empty cell was detected in %s sample(s) in your metadata object. This is not necessarily bad or wrong, but if you were not expecting this, check your metadata object again. Sample(s) %s were detected to have NAs or empty cells.", sum(!stats::complete.cases(df)), paste0(df[!stats::complete.cases(df), ][[ids]], collapse = ", ")))
  }
}

checkMeta <- function(df, ids = "SampleID") {
  lifecycle::deprecate_warn("0.0.0.9000", "checkMeta()", "checkAll()")
  out1 <- checkMeta1(df, ids)
  out2 <- checkMeta2(df, ids)
  out3 <- checkMeta3(df, ids)
  out4 <- checkMeta4(df, ids)

  if (is.null(out1) & is.null(out2) & is.null(out3) & is.null(out4)) {
    message("No warnings or errors detected.")
  }
}

#' Filter the ASV table
#'
#' @param asvtable Input ASV table
#' @param minDepth Minimum number of reads a sample must have to be kept
#' @param minASVCount Minimum count an ASV must have to be kept
#'
#' @returns A filtered ASV table
#' @export
#'

filtering <- function(asvtable = NULL, minDepth = 1000, minASVCount = 2) {
  asvtable <- converter(asvtable, out = "tibble", id = "SampleID")

  if (max(rowSums(asvtable[-1])) < minDepth) {
    warning(sprintf("Your filtering may remove all samples. Your minimum requested sequence depth is %s, which may be too aggressive for your data, as the maximum read count in your input data is %s.", minDepth, max(rowSums(asvtable[-1]))))
  }

  if (max(colSums(asvtable[, -1])) < minASVCount) {
    warning(sprintf("Your filtering may remove all ASVs. Your minimum requested ASV count is %s, which may be too aggressive for your data, as the maximum ASV count in your input data is %s.", minASVCount, max(colSums(asvtable[, -1]))))
  }

  seqtabout <- asvtable %>%
    dplyr::rowwise() %>%
    dplyr::mutate("row.sum" = sum(dplyr::c_across(where(is.numeric)))) %>%
    dplyr::filter(.data$row.sum >= minDepth) %>%
    dplyr::select(-c("row.sum")) %>%
    dplyr::select(c("SampleID", where(~ is.numeric(.) && sum(.) >= minASVCount))) %>%
    #dplyr::rename("SampleID" = "X") %>%
    ungroup()

  return(seqtabout)
}
normalize <- function(df) {
 # df <- filtering(asvtable = x, minDepth = 1)
  row_sums <- rowSums(df[,-1])
  normalized_df <- df[,-1] / row_sums

  normalized_df <- dplyr::bind_cols(df[1], normalized_df) %>% mutate(across(everything(), ~replace(.x, is.nan(.x), 0)))
}



