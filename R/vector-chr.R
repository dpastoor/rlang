#' Construct a character vector or a string.
#'
#' These base-type constructors allow more control over the creation
#' of strings in R. They take character vectors or string-like objects
#' (integerish or raw vectors), and optionally set the encoding. The
#' string version checks that the input contains a scalar string.
#'
#' @param x A character vector or a vector or list of string-like
#'   objects.
#' @param encoding If non-null, passed to [chr_set_encoding()] to add
#'   an encoding mark. This is only declarative, no encoding
#'   conversion is performed.
#' @seealso `chr_set_encoding()` for more information
#'   about encodings in R.
#' @export
#' @examples
#' # As everywhere in R, you can specify a string with Unicode
#' # escapes. The characters corresponding to Unicode codepoints will
#' # be encoded in UTF-8, and the string will be marked as UTF-8
#' # automatically:
#' cafe <- string("caf\uE9")
#' str_encoding(cafe)
#' as_bytes(cafe)
#'
#' # In addition, string() provides useful conversions to let
#' # programmers control how the string is represented in memory. For
#' # encodings other than UTF-8, you'll need to supply the bytes in
#' # hexadecimal form. If it is a latin1 encoding, you can mark the
#' # string explicitly:
#' cafe_latin1 <- string(c(0x63, 0x61, 0x66, 0xE9), "latin1")
#' str_encoding(cafe_latin1)
#' as_bytes(cafe_latin1)
string <- function(x, encoding = NULL) {
  if (is_integerish(x)) {
    x <- rawToChar(as.raw(x))
  } else if (is_raw(x)) {
    x <- rawToChar(x)
  } else if (!is_string(x)) {
    abort("`x` must be a string or raw vector")
  }

  chr_set_encoding(x, encoding)
}

#' Coerce to a character vector and attempt encoding conversion.
#'
#' @description
#'
#' Unlike specifying the `encoding` argument in `as_string()` and
#' `as_character()`, which is only declarative, these functions
#' actually attempt to convert the encoding of their input. There are
#' two possible cases:
#'
#' * The string is tagged as UTF-8 or latin1, the only two encodings
#'   for which R has specific support. In this case, converting to the
#'   same encoding is a no-op, and converting to native always works
#'   as expected, as long as the native encoding, the one specified by
#'   the `LC_CTYPE` locale (see [set_utf8_locale()]) has support for
#'   all characters occurring in the strings. Unrepresentable
#'   characters are serialised as unicode points: "<U+xxxx>".
#'
#' * The string is not tagged. R assumes that it is encoded in the
#'   native encoding. Conversion to native is a no-op, and conversion
#'   to UTF-8 should work as long as the string is actually encoded in
#'   the locale codeset.
#'
#' @param x An object to coerce.
#' @export
#' @examples
#' # Let's create a string marked as UTF-8 (which is guaranteed by the
#' # Unicode escaping in the string):
#' utf8 <- "caf\uE9"
#' str_encoding(utf8)
#' as_bytes(utf8)
#'
#' # It can then be converted to a native encoding, that is, the
#' # encoding specified in the current locale:
#' \dontrun{
#' set_latin1_locale()
#' latin1 <- as_native_string(utf8)
#' str_encoding(latin1)
#' as_bytes(latin1)
#' }
as_utf8_character <- function(x) {
  enc2utf8(as_character(x))
}
#' @rdname as_utf8_character
#' @export
as_native_character <- function(x) {
  enc2native(as_character(x))
}
#' @rdname as_utf8_character
#' @export
as_utf8_string <- function(x) {
  coerce_type(x, "string",
    symbol = ,
    string = enc2utf8(as_string(x))
  )
}
#' @rdname as_utf8_character
#' @export
as_native_string <- function(x) {
  coerce_type(x, "string",
    symbol = ,
    string = enc2native(as_string(x))
  )
}

#' Set encoding of a string or character vector.
#'
#' R has specific support for UTF-8 and latin1 encoded strings. This
#' mostly matters for internal conversions. Thanks to this support,
#' you can reencode strings to UTF-8 or latin1 for internal
#' processing, and return these strings without having to convert them
#' back to the native encoding. However, it is important to make sure
#' the encoding mark has not been lost in the process, otherwise the
#' output will be treated as if encoded according to the current
#' locale (see [set_utf8_locale()] for documentation about locale
#' codesets), which is not appropriate if it does not coincide with
#' the actual encoding. In those situations, you can use these
#' functions to ensure an encoding mark in your strings.
#'
#' @param x A string or character vector.
#' @param encoding Either an encoding specially handled by R
#'   (`"UTF-8"` or `"latin1"`), `"bytes"` to inhibit all encoding
#'   conversions, or `"unknown"` if the string should be treated as
#'   encoded in the current locale codeset.
#' @seealso [set_utf8_locale()] about the effects of the locale, and
#'   [as_utf8_string()] about encoding conversion.
#' @export
#' @examples
#' # Encoding marks are always ignored on ASCII strings:
#' str_encoding(str_set_encoding("cafe", "UTF-8"))
#'
#' # You can specify the encoding of strings containing non-ASCII
#' # characters:
#' cafe <- string(c(0x63, 0x61, 0x66, 0xC3, 0xE9))
#' str_encoding(cafe)
#' str_encoding(str_set_encoding(cafe, "UTF-8"))
#'
#'
#' # It is important to consistently mark the encoding of strings
#' # because R and other packages perform internal string conversions
#' # all the time. Here is an example with the names attribute:
#' latin1 <- string(c(0x63, 0x61, 0x66, 0xE9), "latin1")
#' latin1 <- set_names(latin1)
#'
#' # The names attribute is encoded in latin1 as we would expect:
#' str_encoding(names(latin1))
#'
#' # However the names are converted to UTF-8 by the c() function:
#' str_encoding(names(c(latin1)))
#' as_bytes(names(c(latin1)))
#'
#' # Bad things happen when the encoding marker is lost and R performs
#' # a conversion. R will assume that the string is encoded according
#' # to the current locale:
#' \dontrun{
#' bad <- set_names(str_set_encoding(latin1, "unknown"))
#' set_utf8_locale()
#'
#' str_encoding(names(c(bad)))
#' as_bytes(names(c(bad)))
#' }
chr_set_encoding <- function(x, encoding = c("unknown", "UTF-8", "latin1", "bytes")) {
  if (!is_null(encoding)) {
    Encoding(x) <- match.arg(encoding)
  }
  x
}
#' @rdname chr_set_encoding
#' @export
chr_encoding <- function(x) {
  Encoding(x)
}
#' @rdname chr_set_encoding
#' @export
str_set_encoding <- function(x, encoding = c("unknown", "UTF-8", "latin1", "bytes")) {
  stopifnot(is_string(x))
  chr_set_encoding(x, encoding)
}
#' @rdname chr_set_encoding
#' @export
str_encoding <- function(x) {
  stopifnot(is_string(x))
  Encoding(x)
}

#' Set the locale's codeset for testing.
#'
#' Setting a locale's codeset (specifically, the `LC_CTYPE` category)
#' produces side effects in R's handling of strings. The most
#' important of these affects how the R parser marks strings. R has
#' specific internal support for latin1 (single-byte encoding) and
#' UTF-8 (multi-bytes variable-width encoding) strings. If the locale
#' codeset is latin1 or UTF-8, the parser will mark all strings with
#' the corresponding encoding. It is important for strings to have
#' consistent encoding markers, as they determine a number of internal
#' encoding conversions when R or packages handle strings (see
#' [str_set_encoding()] for some examples).
#'
#' If you are changing the locale encoding for testing purposes, you
#' need to be aware that R caches strings and symbols to save
#' memory. If you change the locale during an R session, it can lead
#' to surprising and difficult to reproduce results. In doubt, restart
#' your R session.
#'
#' Note that these helpers are only provided for testing interactively
#' the effects of changing locale codeset. They let you quickly change
#' the default text encoding to latin1, UTF-8, or non-UTF-8 MBCS. They
#' are not widely tested and do not provide a way of setting the
#' language and region of the locale. They have permanent side effects
#' and should probably not be used in package examples, unit tests, or
#' in the course of a data analysis. Note finally that
#' `set_utf8_locale()` will not work on Windows as only latin1 and
#' MBCS locales are supported on this OS.
#'
#' @return The previous locale (invisibly).
#' @export
set_utf8_locale <- function() {
  if (.Platform$OS.type == "windows") {
    warn("UTF-8 is not supported on Windows")
  } else {
    inform("Locale codeset is now UTF-8")
    set_ctype("en_US.UTF-8")
  }
}
#' @rdname set_utf8_locale
#' @export
set_latin1_locale <- function() {
  if (.Platform$OS.type == "windows") {
    locale <- "English_United States.1252"
  } else {
    locale <- "en_US.ISO8859-1"
  }
  inform("Locale codeset is now latin1")
  set_ctype(locale)
}
#' @rdname set_utf8_locale
#' @export
set_mbcs_locale <- function() {
  if (.Platform$OS.type == "windows") {
    locale <- "English_United States.932"
  } else {
    locale <- "ja_JP.SJIS"
  }
  inform("Locale codeset is now of non-UTF-8 MBCS type")
  set_ctype(locale)
}
set_ctype <- function(x) {
  # Workaround bug in Sys.setlocale()
  old <- Sys.getlocale("LC_CTYPE")
  Sys.setlocale("LC_CTYPE", locale = x)
  invisible(old)
}
