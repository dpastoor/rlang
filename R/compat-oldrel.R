# nocov - compat-oldrel (rlang 0.0.0.9000)

# This file serves as a reference for compatibility functions for old
# versions of R.


# Compat function for capture functions (that will hopefully make
# their way to the next R version) -----------------------------------

#' @useDynLib rlang rlang_capturearg rlang_capturedots
if (TRUE || utils::packageVersion("base") < "3.4.0") {

  captureArg <- function(x) {
    caller_env <- parent.frame()

    if (identical(caller_env, globalenv())) {
      stop("must be called in a function")
    }
    if (missing(x)) {
      stop("argument \"x\" is missing")
    }

    .Call(rlang_capturearg, NULL, NULL, pairlist(caller_env), env())
  }

  captureDots <- function() {
    caller_env <- parent.frame()

    if (!exists("...", caller_env)) {
      stop("must be called in a function where dots exist")
    }

    .Call(rlang_capturedots, NULL, NULL, pairlist(caller_env), env())
  }

}


# R 3.2.0 ------------------------------------------------------------

if (utils::packageVersion("base") < "3.2.0") {

  dir_exists <- function(path) {
    !identical(path, "") && file.exists(paste0(path, .Platform$file.sep))
  }
  dir.exists <- function(paths) {
    map_lgl(paths, dir_exists)
  }

  names <- function(x) {
    if (is.environment(x)) {
      ls(x, all.names = TRUE)
    } else {
      base::names(x)
    }
  }

}

# nocov end
