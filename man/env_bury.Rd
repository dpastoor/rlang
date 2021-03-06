% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/env.R
\name{env_bury}
\alias{env_bury}
\title{Bury bindings and define objects in new scope.}
\usage{
env_bury(env = caller_env(), data = list())
}
\arguments{
\item{env}{An environment or an object with a S3 method for
\code{env()}. If missing, the environment of the current evaluation
frame is returned.}

\item{data}{A vector with unique names which defines bindings
(pairs of name and value). See \code{\link[=is_dictionary]{is_dictionary()}}.}
}
\value{
An object associated with the new environment.
}
\description{
\code{env_bury()} is like \code{env_bind()} but it creates the bindings in a
new child environment. Note that this function does not modify its
inputs.
}
\examples{
scope <- child_env(base_env(), list(a = 10))
fn <- function() a
env(fn) <- scope

# fn() sees a = 10:
fn()

# env_bury() will bury the current scope of fn() behind a new
# environment:
fn <- env_bury(fn, list(a = 1000))
fn()
}
