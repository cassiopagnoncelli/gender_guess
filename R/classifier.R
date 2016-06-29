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

source('R/base.R')
source('R/load_parameters.R')

assertLoad('randomForest')
assertLoad('rpart')
assertLoad('e1071')
assertLoad('nnet')

#' Gender
#'
#' Guess the gender of a person
#'
#' @param names A vector of names
#' @return A factor indicating whether names are m/f
#' @export
gender_guess <- function(names) {
  # Validate inputs.
  if (!is.vector(names) || !(class(gender_guess_fit) %in% 'gender_ensemble')) {
    cat('Check inputs.
        Names should be a string-vector; model should a gender_ensemble object, trained by gender_guess_train.\n')
    return(F)
  }

  # Data cleansing
  names <- gsub('\t', '', names)

  # Data normalisation.
  padding <- c('Renan', 'Carla', 'Zuleika')
  input_names <- append(names, padding)
  normalised <- normalise_data(input_names)

  # First stage.
  n <- length(input_names)
  votes <- data.frame(
    v1 = prediction_normalisation(predict(gender_guess_fit$first$v1, normalised), n, class(gender_guess_fit$first$v1)),
    v2 = prediction_normalisation(predict(gender_guess_fit$first$v2, normalised), n, class(gender_guess_fit$first$v2)),
    v3 = prediction_normalisation(predict(gender_guess_fit$first$v3, normalised), n, class(gender_guess_fit$first$v3)),
    v4 = prediction_normalisation(predict(gender_guess_fit$first$v4, normalised), n, class(gender_guess_fit$first$v4))
  )

  # Second stage.
  decision <- prediction_normalisation(predict(gender_guess_fit$second, votes), n, class(gender_guess_fit$second))

  # Return.
  decision[-(length(names)+1):-(length(names)+3)]
}
