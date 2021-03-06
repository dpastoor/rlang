% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/formula.R
\name{is_formula}
\alias{is_formula}
\title{Is object a formula?}
\usage{
is_formula(x, scoped = NULL)
}
\arguments{
\item{x}{An object to test.}

\item{scoped}{A boolean indicating whether the quosure or formula
is scoped, that is, has a valid environment attribute. If \code{NULL},
the scope is not inspected.}
}
\description{
Is object a formula?
}
\examples{
x <- disp ~ am
is_formula(x)

is_formula(~ 10)
is_formula(10)
}
\seealso{
\code{\link[=is_quosure]{is_quosure()}}
}
