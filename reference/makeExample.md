# Create example data for testing and teaching purposes specifically for this package.

Create example data for testing and teaching purposes specifically for
this package.

## Usage

``` r
makeExample(what = NULL)
```

## Arguments

- what:

  What do you want to create? Valid options are 'meta' (for a metadata
  table), 'asv' (for an ASV table), 'taxa' (for a taxonomy table) or
  'all' or left blank to create a list of all three.

## Value

A metadata, ASV, or taxonomy table, or a list of all three.

## Examples

``` r
metadata <- makeExample("meta")
asvtable <- makeExample("asv")
taxa <- makeExample("taxa")
all <- makeExample() # OR:
all <- makeExample("all")
```
