# MVTEC-Stats-Project1

## Steps for Pre-processing

*Everybody uploads his preprocessing script at the repository by calling it in that way: P1-Name-Stats-Prep.R
*We've decided to add a column with new data to the main database. Each of us has different data to see if some are relevant for the analysis. Each of us will add and combine one column from a different dataset:
    * Annia: Obesity
    * Rebecca: Global Health Security Index
    * Rocío: Causes of death
    * Victor: Temperature

### Countries:
* 10 first countries per continent, with more cases of Covid per million (from the first date register in the DB)

### Our variables:
#### Qualitative:
* Government_Type
* Corruption_preception
* Causes of mortality


#### Quantitative (Granularity 2 weeks)
* total_cases_per_million
* new_cases_smoothed_per_million
* total_deaths_per_million
* new_deaths_smoothed_per_million 
* reproduction_rate
* weekly_icu_admissions_per_million
* weekly_hosp_admissions_per_million
* total_tests_per_thousand
* population_density
* median_age
* gdp_per_capita


### Datasets:
 * Original
    * Our World In Data Covid-19 [data](https://github.com/arixha/MVTEC-Stats-Project1/blob/main/owid-covid-data-131120.xlsx) by country
    * [Country info](country-info.xlsx) supplied by Karina's students.
 * Additonal datasets
    * [Government response index](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
    * [Obesity](https://github.com/arixha/MVTEC-Stats-Project1/tree/main/our%20data/obesity%20adults%20WHO), [Diabetes](https://github.com/arixha/MVTEC-Stats-Project1/tree/main/our%20data/diabetes%20adults%20WDB)
    * [Mortality](https://github.com/arixha/MVTEC-Stats-Project1/tree/main/our%20data/data%20mortality%20causes%20WHO%202016)
    * [Air pollution](https://github.com/arixha/MVTEC-Stats-Project1/tree/main/our%20data/air%20pollution%20WDB)





-----------------


OTHER QUALITATIVE DATA...
* Cities with aeroports

OTHER QUANTITATIVE DATA...
* total_cases
* new_cases_smoothed
* total_deaths 
* new_deaths_smoothed 
* population
* [Pandemic preparedness & health security index](https://www.ghsindex.org/)
* [Government response index](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)


