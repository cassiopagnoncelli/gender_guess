source('R/load_parameters.R')
source('R/classifier.R')

# Unit testing.
gender_guess(NULL) # null
gender_guess('')  # blank
gender_guess('ada')  # short
gender_guess('Underson')  # standard
gender_guess('Aramildíssima') # long, strees
gender_guess('Cássio Jandir') # stress, multi-valued
gender_guess('çÂÛ!15"!@#$%*()_')  # invalid
gender_guess(c('Freddie', 'Farrokh', 'Bulsara', 'Mercury')) # length-4
gender_guess(c('Madre Teresa de Calcutá')) # length-4
sink('/dev/null')
gender_guess(rep(c('Freddy', 'Bulsara'), 50000)) # length-100k (2x50k) names
sink()

# Testing.
assertLoad('RMySQL')

conn <- dbConnect(MySQL(), dbname='pay')
fnames_sql <- dbSendQuery(conn, 'SELECT fname, fname_count FROM pay.names_count ORDER BY fname_count DESC')
fnames <- dbFetch(fnames_sql, n=-1)
dbClearResult(fnames_sql)
dbDisconnect(conn)
tnames <- data.frame(name = fnames$fname, count = fnames$fname_count)

testing_x <- fnames$fname[sample(1:length(fnames$fname), 100)]
genders <- gender_guess(testing_x)

head(data.frame(name=testing_x, gender=genders), 30)
