# MVTEC-Stats-Project1
Annia - create A_extraData.csv
Rebecca - set up logins for AWS, Heroku, Observable??
All - figure out how to upload A_extraData.csv
    - Create Python script to read CovidDaily data and output data we need to S3 bucket to create B_covidDaily.csv
    - Join A & B, to make C

Questions to Matt:
- Show diagram and make sure we are going in the right direction.
- Should we try read the daily data directly into R, or should we use Python instead? For B_covidDaily.csv.
- Save the CSV directly from R to S3, avoid having to write Python script? Or should we be putting more Python scripts in for error checks?
- Should we grab the data daily(or weekly??), and then only upload weekly, or should we also do this daily?
- Should we use the Heroku scheduler multiple times? Or can we only run it once? Will this start charging us? How can we track?
- Maybe some tips to simplify the workflow.

## Final variables

A_extraData.csv (No date field)
*Country*, population, popDensity, medianAge, gdp, obesity, **temp**, govt, corruption, healthSecurity, mortalityCauses  

B_covidDaily.csv (Date field)
Year, Week, Region, *Country*, totalCases, totalCasePerMillion, casesSmooth, totalDeaths, totalDeathsPerMillion, deathSmooth

GROUPING
Year | Rscript
Week | Rscript
Region | OWID 
Country | OWID

QUANTITATIVE
totalCases | Descriptive | OWID
totalCasesPerMillion | Analysis | OWID
casesSmooth | Rscript (take average of week) | OWID
totalDeaths | Descriptive| OWID
totalDeathsPerMillion | Analysis | OWID
deathSmooth | Rscript (take average of week) | OWID


population | OWID 
popDensity | OWID 
medianAge | OWID
gdp | OWID
obesity | EXTRA
temperature? | EXTRA

QUALITATIVE
govt | EXTRA
corruption | EXTRA
healthSecurity | EXTRA Rebecca - will pass a dataset just with the 22 countries
mortalityCauses | EXTRA Rocio - need to compress to 22 countries, top 4 causes of death


Data limitation:
We have decided to limit our analysis to the countries that have sufficient data for hospital beds and weekly hospital admissions. This is provided only by the European and US data centres for certain countries therefore our analysis is limited to the following 22 countries:

countries = Belgium, Croatia, Denmark, Germany, Iceland, Portugal, Romania, United Kingdom, Cyprus, Czech Republic, Estonia, France, Greece, Ireland, Latvia, Lithuania, Malta, Netherlands, Slovenia, Spain, Sweden, United States


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


