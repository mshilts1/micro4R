#' Collection of helper/utility functions not intended to be used by end user
#'
#' @returns Path of user's current working directory
#' @export
#'
#' @examples
#' findUserCD()
findUserCD <- function() {
  # cur_dir <- getwd()
  return(getwd())
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
known_dada2_dbs <- function(what = "list"){

  if(what != "keypair" & what != "list" & !is.null(what)){
    stop("You did not provide a valid value. Valid options are 'list' or 'keypair'.")
  }

  if(what == "keypair"){ #i wasn't smart enough to get this to work properly, but saving in case i ever do figure it out
  return_value <- tibble::tribble(
          ~db, ~pattern,
          "silva",   "^silva_.*fa.gz$",
          "rdp",   "^rdp_.*trainset.fa.gz$",
          "greengenes",   "^gg2_trainset.fa.gz$",
          "unite",  "sh_general_release_all_.*tgz")
  }

  if(what == "list"){
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
#'
#' @returns The file path of the database
#' @export
#'
ref_db <- function(db) {
  # Check if the file exists first
  if (!file.exists(db)) {
    stop("Error: The file name your provided does not exist at the provided path.")
  }

  # Check if the file is a file (not a directory)
  if (!file_test("-f", db)) {
    stop("Error: You provided a path to a directory. Provide the file name too. E.g., instead of /path/to/reference, use /path/to/reference/database.gz.")
  }

  filename <- basename(db)

# Check if the file name matches *known* patterns:
  if (grepl("^silva_.*fa.gz$", filename)) {
    print("Your reference taxonomic database is suspected to be one of the SILVA databases. If that does not seem correct to you, please check!")
  }
  if (grepl("^rdp_.*trainset.fa.gz$", filename)) {
    print("Your reference taxonomic database is suspected to be one of the RDP databases. If that does not seem correct to you, please check!")
  }
  if (grepl("^gg2_.*trainset.fa.gz$", filename)) {
    print("Your reference taxonomic database is suspected to be one of the greengenes databases. If that does not seem correct to you, please check!")
  }
  if (grepl("^sh_general_release_all_.*tgz", filename)) {
    print("Your reference taxonomic database is suspected to be one of the UNITE all eukaryotes databases. If that does not seem correct to you, please check!")
  }
  if (!grepl("^silva_.*fa.gz$", filename) & !grepl("^rdp_.*trainset.fa.gz$", filename) & !grepl("^gg2_.*trainset.fa.gz$", filename) & !grepl("^sh_general_release_all_.*tgz", filename)){
    print("The file name of your reference database did not match any of the known maintained dada2-formatted taxonomic databases. This does not mean your database is wrong! Just that it's not on my known list. Check below to see the names of all known databases:")
    print(known_dada2_dbs("list"))
  }

  return(db)
}

