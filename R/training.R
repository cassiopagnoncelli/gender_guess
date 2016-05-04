source('R/base.R')
source('R/classifier.R')

# Models.
assertLoad('randomForest')
assertLoad('rpart')
assertLoad('e1071')
assertLoad('nnet')

gender_guess_train <- function(names, y, include.results = F) {
  # Dataset.
  x <- normalise_data(names)
  xy <- data.frame(x, y)
  n <- NROW(xy)

  # First stage.
  sink('/dev/null')    # Suppresses messages.
  fit_svm <- svm(y ~ ., xy)
  fit_rf <- randomForest(y ~ ., xy)
  fit_rt <- rpart(y ~ ., xy, control = rpart.control(maxdepth=6))
  fit_nnet <- nnet(y ~ ., xy, size=5)
  sink()

  pred_svm <- prediction_normalisation(predict(fit_svm, x), n, class(fit_svm))
  pred_rf <- prediction_normalisation(predict(fit_rf, x), n, class(fit_rf))
  pred_rt <- prediction_normalisation(predict(fit_rt, x), n, class(fit_rt))
  pred_nnet <- prediction_normalisation(predict(fit_nnet, x), n, class(fit_nnet))

  votes <- data.frame(
    v1 = pred_svm,
    v2 = pred_rf,
    v3 = pred_rt,
    v4 = pred_nnet
  )

  # Second stage.
  fit_votes <- svm(y ~ ., data.frame(votes, y))

  # Return.
  gfit <- list(
    first  = list(
      v1 = fit_svm,
      v2 = fit_rf,
      v3 = fit_rt,
      v4 = fit_nnet),
    second = fit_votes,
    result = predict(fit_votes)
  )
  class(gfit) <- 'gender_ensemble'

  return (gfit)
}
