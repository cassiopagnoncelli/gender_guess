# Load (if needed) fitting parameters eventually training a new model.
if (!exists('gender_guess_fit')) {
  if (!file.exists('data/fit.RData'))
    source('R/training.R')

  load('data/fit.RData')
}
