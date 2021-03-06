% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tidy-quote.R
\name{exprs_auto_name}
\alias{exprs_auto_name}
\title{Ensure that list of expressions are all named.}
\usage{
exprs_auto_name(exprs, width = 60L)
}
\arguments{
\item{exprs}{A list of expressions or expression wrappers,
e.g. tidy quotes.}

\item{width}{Maximum width of names.}
}
\description{
This gives default names to unnamed elements of a list of
expressions (or expression wrappers such as formulas or tidy
quotes). The expressions are deparsed with \code{\link[=expr_text]{expr_text()}}.
}
