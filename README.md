
The **R**-package **`testr`** supplies users with functions for setting up ephemeral RStudio Projects and/or R-packages for use in unit testing, and helps promote test-driven development.

Basically **`testr`** allows you to quickly and easily create example projects or R-packages inside a calling function, and once the function environment is exited, the project/package is deleted and nothing in the calling environment is modified. This package is essentially copied from `usethis`, where it is used to test the functionality of `usethis` functions. But because `usethis` did not export this functionality, this package is needed.

## Installation 
The package can be installed via `remotes::install_github()`
