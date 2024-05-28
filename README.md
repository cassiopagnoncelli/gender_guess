## Synopsis

__gender_guess__ is an R library to guess gender given a name and is part of a data enrichment suite.

## Installation

```python
library('devtools')
install_github('cassiopagnoncelli/gender_guess')
```

## Usage

`gender_guess` offers a way to infer genders based on names suffixes.
`gender` is a wrapper to produce responses from/to JSON.

```r
> gender_guess("Cassio")
1 
m 
Levels: f m
> gender('{"names":[
  "Cássius",
  "g4BRIéL",
  "EduArda",
  "Geyzebel Cardoso",
  "JULIAN",
  "  Pritham-Kumar Bora Bora",
  "NAARA Katheline Cilva",
  "SaMAnTa Fyorrentin"
]}')
["m","m","f","f","m","m","f","f"] 
```

## Description

__gender__ is a machine learning model for classifying names as either _male_ or _female_. It works fine for Brazilian names and comes along with a names database, albeit it is more general and could be deployed for purposes other than national names.

This model is a two-tier layer casting a voters-judge architecture. 

1. **ETL** phase: Responsible for converting input name, whichever the format it is given, into its first name suffix and transliterating it to Latin alphabet.
2. **First layer** phase: Suffix is given as input to four different, trained classifiers, hereby called voters, such that each one output one different vote whether the name should be **m** or **f**. Classifiers used here are 
[SVM](https://en.wikipedia.org/wiki/Support_vector_machine),
[Random Forest](https://en.wikipedia.org/wiki/Random_forest),
[Decision Tree](https://en.wikipedia.org/wiki/Decision_tree), and
[Neural Networks](https://en.wikipedia.org/wiki/Artificial_neural_network).
(Individual voters average a hit rate of 80-85%.)
3. **Second layer** phase: Given individual votes for each classifier, an aggregator classifier, hereby called judge, decides, based on votes, which should be the gender for the given name. (Classication hit rate soars to over 97% out of individual classifiers.)

![Diagram](./assets/gender.png)

## Caveats

Depending on machine conditions performance accrued from bulk calls can be over a few thousands classified instances.

As per independent calls classifier shows its overhead, hence it is recommended to prepare calls for bulk classification.

## Deployment

Package can be deployed as 

* a JSON webservice,
* an R script running in a cron.


