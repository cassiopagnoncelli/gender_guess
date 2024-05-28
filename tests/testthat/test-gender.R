test_that("gender guess one name", {
  res <- gender(c("Cassio", "Isa"),
                input_format = "raw",
                output_format = "json")
  expect_equal(res, toJSON(c("m", "f")))
})
