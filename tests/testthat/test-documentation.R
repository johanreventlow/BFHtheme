# Tests for documentation sync — ensures inst/examples/*.R files parse cleanly

test_that("all inst/examples .R files parse without syntax errors", {
  examples_dir <- system.file("examples", package = "BFHtheme")
  skip_if(examples_dir == "", "inst/examples not found (package not installed)")

  r_files <- list.files(examples_dir, pattern = "\\.R$", full.names = TRUE)
  skip_if(length(r_files) == 0, "No .R files in inst/examples")

  for (f in r_files) {
    result <- tryCatch(
      parse(f),
      error = function(e) e
    )
    expect_false(
      inherits(result, "error"),
      info = paste("Syntax error in", basename(f), ":", conditionMessage(result))
    )
  }
})
