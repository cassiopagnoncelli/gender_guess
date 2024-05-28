test_that("gender_guess one name", {
  expect_equal(as.vector(gender_guess("Cassio")), "m")
})

test_that("gender_guess multiple names", {
  expect_equal(as.vector(gender_guess(c("Isabela", "Maiara", "John"))),
               c("f", "f", "m"))
})

test_that("genderguess alias", {
  expect_equal(as.vector(genderguess("Cassio")), "m")
})
