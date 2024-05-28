test_that("gender guess one name", {
  expect_equal(as.vector(gender_guess("Cassio")), "m")
})

test_that("gender guess multiple names", {
  expect_equal(as.vector(gender_guess(c("Isabela", "Maiara", "John"))),
               c("f", "f", "m"))
})
