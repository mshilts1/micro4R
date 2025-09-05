.onAttach <- function(libname, pkgname) {
  packageStartupMessage("This is version ", packageVersion(pkgname),
                        " of ", pkgname, ". CAUTION: This is package is under active development and its functions may change at any time, without warning! Please visit https://github.com/mshilts1/micro4R to see recent changes.")
}
