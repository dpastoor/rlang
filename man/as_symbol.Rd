% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/expr-lang.R, R/expr-sym.R
\name{as_lang}
\alias{as_lang}
\alias{as_symbol}
\alias{as_name}
\title{Coerce an object to a name or call.}
\usage{
as_lang(x)

as_symbol(x)

as_name(x)
}
\arguments{
\item{x}{An object to coerce}
}
\value{
\code{as_symbol()} and \code{as_lang()} return a symbol or a
call. \code{as_name()} returns a string.
}
\description{
These coercing functions can transform names, calls, formulas, and
strings. The distinction between a name and a call is particularly
important when coercing from a string. Coercing to a call will
parse the string, coercing to a name will create a (potentially)
non-syntactic name.
}
\examples{
as_symbol("x + y")
as_lang("x + y")

as_lang(~ f)
as_symbol(~ f())
}
