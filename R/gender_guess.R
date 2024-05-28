# Gender classification model.
#
# This model guesses the gender of a person given their name. Architecture is as follows.
#
# 1) Look up in the names database (names.db); if it is there, then just
# return gender.
#
# 2) Otherwise, use a two-layer ensemble machine learning model,
#
#    1st phase: svm, decision tree, random forest, neural net, and ada boost
#               are used to generate independent votes.
#
#    2nd phase: an SVM takes a decision based on previous stage votes.model$second
#

#' @description Guess the gender of a person
#' @param names A vector of names
#' @return A factor indicating whether names are m/f
#' @export
gender_guess <- function(names) {
  # Validate inputs.
  if (!is.vector(names) || !(class(gender_guess_fit) %in% 'gender_ensemble')) {
    cat(c(
      "`names` must be an array of strings",
      "`gender_guess_fit`, loaded in env, must be a gender_ensemble object",
      "trained by gender_guess_train."
      ), sep = "\n")
    return(F)
  }

  # Data cleaning
  names <- gsub('\t', '', names)

  # Data normalization.
  padding <- c('Renan', 'Carla', 'Zuleika')
  input_names <- append(names, padding)
  normalised <- normalise_data(input_names)

  # First stage.
  n <- length(input_names)
  votes <- data.frame(
    v1 = prediction_normalisation(
      predict(gender_guess_fit$first$v1, normalised),
      n,
      class(gender_guess_fit$first$v1)
    ),
    v2 = prediction_normalisation(
      predict(gender_guess_fit$first$v2, normalised),
      n,
      class(gender_guess_fit$first$v2)
    ),
    v3 = prediction_normalisation(
      predict(gender_guess_fit$first$v3, normalised),
      n,
      class(gender_guess_fit$first$v3)
    ),
    v4 = prediction_normalisation(
      predict(gender_guess_fit$first$v4, normalised),
      n,
      class(gender_guess_fit$first$v4)
    )
  )

  # Second stage.
  decision <- prediction_normalisation(
    predict(gender_guess_fit$second, votes),
    n,
    class(gender_guess_fit$second)
  )

  # Return.
  range_start <- -(length(names)+1)
  range_end <- -(length(names)+3)
  decision[range_start:range_end]
}

#' @description Alias for gender_guess.
genderguess <- gender_guess
