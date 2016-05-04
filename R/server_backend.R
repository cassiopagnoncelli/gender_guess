source('R/classifier.R')

assertLoad('jsonlite')

gender <- function(names, input_format='json', output_format='json') {
  if (input_format == 'raw')
    classes <- gender_guess(names)
  else if (input_format == 'json') {
    classes <- do.call(gender_guess, fromJSON(names))
  }

  if (output_format == 'raw')
    return (classes)
  else
    return(toJSON(classes))
}
