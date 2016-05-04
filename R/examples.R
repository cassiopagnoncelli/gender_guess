source('R/server_backend.R')

names = c(
  'Cassio Pagnoncelli',
  'Gabriel Francisco',
  'Eduarda Kortmann Duda',
  'Geizebel Santiago Cardoso',
  'Julian Serrano Dal`Asta',
  'Pritham Bora',
  'Naara Katheline Silva',
  'Samanta Fiorentin'
)

gender(names, input_format='raw', output_format='raw')
gender(names, input_format='raw', output_format='json')

# JSON input.
names_json <- '{"names":[
  "Cássius P4GN0NC3LL1 ",
  "gABRIéL    Francysco",
  "EduArda Kart",
  "Geyzebel SanThiago Cardoso",
  "JULIAN CERRANO DaLLAsha",
  "  Pritham-Kumar Bora Bora",
  "NAARA Katheline Cilva",
  "SaMAnTa Fyorrentin"
]}'

gender(names_json, input_format='json', output_format='raw')
gender(names_json, input_format='json', output_format='json')
