context("vector")

test_that("vector is modified", {
  x <- c(1, b = 2, c = 3, 4)
  out <- modify(x, 5, b = 20, .elts = list(6, c = "30"))
  expect_equal(out, list(1, b = 20, c = "30", 4, 5, 6))
})

test_that("are_na() requires vector input but not is_na()", {
  expect_error(are_na(base::eval), "must be a vector")
  expect_false(is_na(base::eval))
})

test_that("atomic vectors are spliced", {
  lgl <- lgl(TRUE, c(TRUE, FALSE), list(FALSE, FALSE))
  expect_identical(lgl, c(TRUE, TRUE, FALSE, FALSE, FALSE))

  int <- int(1L, c(2L, 3L), list(4L, 5L))
  expect_identical(int, 1:5)

  dbl <- dbl(1, c(2, 3), list(4, 5))
  expect_identical(dbl, as_double(1:5))

  cpl <- cpl(1i, c(2i, 3i), list(4i, 5i))
  expect_identical(cpl, c(1i, 2i, 3i, 4i, 5i))

  chr <- chr("foo", c("foo", "bar"), list("buz", "baz"))
  expect_identical(chr, c("foo", "foo", "bar", "buz", "baz"))

  raw <- bytes(1, c(2, 3), list(4, 5))
  expect_identical(raw, bytes(1:5))
})

test_that("can create empty vectors", {
  expect_identical(lgl(), logical(0))
  expect_identical(int(), integer(0))
  expect_identical(dbl(), double(0))
  expect_identical(cpl(), complex(0))
  expect_identical(chr(), character(0))
  expect_identical(bytes(), raw(0))
  expect_identical(splice(), list())
})

test_that("objects are not spliced", {
  expect_error(lgl(structure(list(TRUE, TRUE), class = "bam")), "Objects cannot be spliced")
})

test_that("explicitly spliced lists are spliced", {
  expect_identical(lgl(FALSE, structure(list(TRUE, TRUE), class = "spliced")), c(FALSE, TRUE, TRUE))
})

test_that("splicing uses inner names", {
  expect_identical(lgl(c(a = TRUE, b = FALSE)), c(a = TRUE, b = FALSE))
  expect_identical(lgl(list(c(a = TRUE, b = FALSE))), c(a = TRUE, b = FALSE))
})

test_that("splicing uses outer names when scalar", {
  expect_identical(lgl(a = TRUE, b = FALSE), c(a = TRUE, b = FALSE))
  expect_identical(lgl(list(a = TRUE, b = FALSE)), c(a = TRUE, b = FALSE))
})

test_that("warn when outer names unless input is unnamed scalar atomic", {
  expect_warning(expect_identical(dbl(a = c(1, 2)), c(1, 2)), "Outer names")
  expect_warning(expect_identical(dbl(list(a = c(1, 2))), c(1, 2)), "Outer names")
  expect_warning(expect_identical(dbl(a = c(A = 1)), c(A = 1)), "Outer names")
  expect_warning(expect_identical(dbl(list(a = c(A = 1))), c(A = 1)), "Outer names")
})

test_that("warn when spliced lists have outer name", {
  expect_warning(lgl(C = list(c = FALSE)), "Outer names")
  expect_warning(lgl(C = list(FALSE)), "Outer names")
})

test_that("splice() splices names", {
  expect_identical(splice(a = TRUE, b = FALSE), list(a = TRUE, b = FALSE))
  expect_identical(splice(c(A = TRUE), c(B = FALSE)), list(c(A = TRUE), c(B = FALSE)))
  expect_identical(splice(a = c(A = TRUE), b = c(B = FALSE)), list(a = c(A = TRUE), b = c(B = FALSE)))
  expect_warning(regexp = "Outer names",
    expect_identical(
      splice(a = list(A = TRUE), b = list(B = FALSE)) ,
      list(A = TRUE, B = FALSE)
    )
  )
  expect_warning(regexp = "Outer names",
    expect_identical(
      splice(a = list(TRUE), b = list(FALSE)) ,
      list(TRUE, FALSE)
    )
  )
})

test_that("splice() with `.bare = FALSE` doesn't splice bare lists", {
  expect_identical(splice(list(1, 2), .bare = FALSE), list(list(1, 2)))
  expect_identical(splice(spliced(list(1, 2)), .bare = FALSE), list(1, 2))
})

test_that("atomic inputs are implicitly coerced", {
  expect_identical(lgl(10L, FALSE, list(TRUE, 0L, 0)), c(TRUE, FALSE, TRUE, FALSE, FALSE))
  expect_identical(dbl(10L, 10, TRUE, list(10L, 0, TRUE)), c(10, 10, 1, 10, 0, 1))

  expect_error(lgl("foo"), "Cannot convert objects of type")
  expect_error(chr(10), "Cannot convert objects of type")
})

test_that("type errors are handled", {
  expect_error(lgl(chr()), "Cannot convert objects of type `character`")
  expect_error(lgl(list(chr())), "Cannot convert objects of type `character`")

  expect_error(lgl(env()), "Cannot splice objects of type `environment`")
  expect_error(lgl(list(env())), "Cannot splice objects of type `environment`")
})

test_that("empty inputs are spliced", {
  expect_identical(lgl(NULL, lgl(), list(NULL, lgl())), lgl())
  expect_warning(regexp = NA, expect_identical(lgl(a = NULL, a = lgl(), list(a = NULL, a = lgl())), lgl()))
})
