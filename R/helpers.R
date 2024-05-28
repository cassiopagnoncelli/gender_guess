# All possible letters a classifier can handle.
alphabet <- c(
  ' ', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
  'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
)

# Transliterate names.
transliterate <- function(names) {
  first_names <- stringr::str_replace(names, "[- ][[:print:]]*", '')

  pre_latin <- gsub("[^[:alpha:][:space:]']", "", first_names)
  latinised <- gsub("[[:punct:]]", "", pre_latin)

  lowercased <- tolower(iconv(latinised, to="ASCII//TRANSLIT"))

  stringr::str_pad(lowercased, 5, side='left', pad=' ')
}

# Calculate *normalized*, reversed x.
calcrev <- function(x) {
  # String reverse.
  as.character(
    sapply(transliterate(x), function(string, index = 1:nchar(string)) {
      paste(rev(unlist(strsplit(string, NULL)))[index], collapse = "")
    })
  )
}

#
# Shared functions.
#

# Matricises data by reversing 5-suffix.
normalise_data <- function(x) {
  revsuffix <- calcrev(x)
  data.frame(
    n0 = factor(substr(revsuffix, 1, 1), levels = alphabet),
    n1 = factor(substr(revsuffix, 2, 2), levels = alphabet),
    n2 = factor(substr(revsuffix, 3, 3), levels = alphabet),
    n3 = factor(substr(revsuffix, 4, 4), levels = alphabet),
    n4 = factor(substr(revsuffix, 5, 5), levels = alphabet)
  )
}

# Prediction normalisation.
prediction_normalisation <- function(pred, n, type) {
  if (is.element('nnet', type)) {
    pred_nn <- rep('f', n)
    pred_nn[pred >= 0.5] <- 'm'
    pred_nn <- factor(pred_nn, levels=c('m', 'f'))
    pred <- pred_nn
  } else if (is.element('rpart', type)) {
    pred_tree <- rep('f', n)
    pred_tree[which(pred[,2] > pred[,1])] <- 'm'
    pred_tree <- factor(pred_tree, levels=c('m', 'f'))
    pred <- pred_tree
  }

  return (pred)
}
