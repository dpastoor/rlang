% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/expr-lang.R
\name{is_lang}
\alias{is_lang}
\alias{is_unary_lang}
\alias{is_binary_lang}
\title{Is object a call (language type)?}
\usage{
is_lang(x, name = NULL, n = NULL)

is_unary_lang(x, name = NULL)

is_binary_lang(x, name = NULL)
}
\arguments{
\item{x}{An object to test. If a formula, the right-hand side is
extracted.}

\item{name}{An optional name that the call should match. It is
passed to \code{\link[=as_symbol]{as_symbol()}} before matching. This argument is
vectorised and you can supply a vector of names to match. In this
case, \code{is_lang()} returns \code{TRUE} if at least one name matches.}

\item{n}{An optional number of arguments that the call should
match.}
}
\description{
This function tests if \code{x} is a call. This is a pattern-matching
predicate that will return \code{FALSE} if \code{name} and \code{n} are supplied
and the call does not match these properties. \code{is_unary_lang()} and
\code{is_binary_lang()} hardcode \code{n} to 1 and 2.
}
\details{
Note that the base type of calls is \code{language}, while \code{call} is the
old S mode. While it is usually better to avoid using S
terminology, it would probably be even more confusing to refer to
"calls" as "language". We still use \code{lang} as prefix or suffix for
consistency.
}
\examples{
is_lang(quote(foo(bar)))

# Right-hand sides are extracted from formulas:
is_lang(~foo(bar))

# You can pattern-match the call with additional arguments:
is_lang(~foo(bar), "foo")
is_lang(~foo(bar), "bar")
is_lang(~foo(bar), quote(foo))

# Match the number of arguments with is_lang():
is_lang(~foo(bar), "foo", 1)
is_lang(~foo(bar), "foo", 2)

# Or more specifically:
is_unary_lang(~foo(bar))
is_unary_lang(~ +3)
is_unary_lang(~ 1 + 3)
is_binary_lang(~ 1 + 3)

# Namespaced calls are a bit tricky. Strings won't work because
# as_symbol("base::list") returns a symbol rather than a namespace
# call:
is_lang(~base::list(baz), "base::list")

# However you can use the fact that as_symbol(quote(base::list()))
# extracts the function identifier as is, and thus returns the call
# base::list:
is_lang(~base::list(baz), ~base::list(), 1)


# The name argument is vectorised so you can supply a list of names
# to match with:
is_lang(~foo(bar), c("bar", "baz"))
is_lang(~foo(bar), c("bar", "foo"))
is_lang(~base::list, c("::", ":::", "$", "@"))
}
\seealso{
\code{\link[=is_expr]{is_expr()}}
}
