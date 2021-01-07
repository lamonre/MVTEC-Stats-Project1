# MVTEC-Stats-Project1
---
*Thurs Dec 17*
## Task List:
Pre-processing Project Board [here](https://github.com/arixha/MVTEC-Stats-Project1/projects/1)

## Pre-processing

In the pre-processing stage, we will be uploading two data files and then later join them into one for the next stage.

One is a dinamic file that will be uploaded in all data daily from OWID (A_extraData.csv). The other is a dynamic file that will be pulling in data daily with the Top 10 data preprocessing (B_covidDaily.csv).

#### Variables in "A_extraData.csv"

| Variables     | Type      | Origin    | Description      |
| :------------ |:--------: |:--------: | :----- |
| **country**   | Identifier| OWID      | Joining variable. |
| **code**      | Identifier| OWID      | Joining variable. |
| date          | Date      | OWID
| continent     | Character | OWID 
| location     | Character | OWID 
| population    | Numeric   | OWID      | Population of country. |
| population_density   | Numeric   | OWID      
| total_cases   | Numeric   | OWID      | Total Cases Covid. |
| total_cases_per_million   | Numeric   | OWID      | Total Cases Covid per million population. |
| new_cases     | Numeric   | OWID      | Daily Cases Covid. |
| total_cases   | Numeric   | OWID      | Total Cases Covid. |
| reproduction_rate | Numeric   | OWID      | |  
| total_deaths  | Numeric   | OWID      | Total Deaths Covid. |
| total_deaths per million  | Numeric   | OWID      | Total Deaths Covid per million population. |
| new_deaths    | Numeric   | OWID      | Daily Deaths Covid. |
| hospital_beds_per_thousand  | Numeric   | OWID      | Hospital disponible beds. |
| total_tests   | Numeric   | OWID      | Total tests Covid. |
| total_tests_per_thousand   | Numeric   | OWID      | Total tests Covid per thousand population. |
| median_age    | Numeric   | OWID      | Population median age. |
| gdp_per_capita| Numeric   | OWID      | |
| gov           | Character | External  | Type of government in the country. |
| corruption    | Character | External  | Highly corrupt or less corrupt. |
| obesity       | Numeric   | Annia     | |
| healthSecurity| Character | Rebecca   | Pandemic preparedness index from 2019. Most prepared, more prepared and least prepared. | 
| temp          | Numeric  | Victor    | |
| pulmonary_deaths| Character | Rocio     | | 2016 data from WHO by country
| diabetes_deaths | Character | Rocio     | | 2016 data from WHO by country
| cardiovascular_deaths| Character | Rocio     | | 2016 data from WHO by country
| cancer_deaths| Character | Rocio     | | 2016 data from WHO by country
 

#### Variables in "B_covidDaily.csv"
Updated daily.
| Variables     | Type      | Origin    | Description      |
| :------------ |:--------: |:--------: | :----- |
| **country**   | Identifier| OWID      | Joining variable. |
| **code**      | Identifier| OWID      | Joining variable. |
| date          | Date      | OWID
| continent     | Character | OWID 
| location     | Character | OWID 
| population    | Numeric   | OWID      | Population of country. |
| population_density   | Numeric   | OWID      
| total_cases   | Numeric   | OWID      | Total Cases Covid. |
| new_cases     | Numeric   | OWID      | Daily Cases Covid. |
| reproduction_rate | Numeric   | OWID      | |  
| total_deaths  | Numeric   | OWID      | Total Deaths Covid. |
| total_deaths per million  | Numeric   | OWID      | Total Deaths Covid per million population. |
| new_deaths    | Numeric   | OWID      | Daily Deaths Covid. |
| hospital_beds_per_thousand  | Numeric   | OWID      | Hospital disponible beds. |
| total_tests   | Numeric   | OWID      | Total tests Covid. |
| total_tests_per_thousand   | Numeric   | OWID      | Total tests Covid per thousand population. |
| median_age    | Numeric   | OWID      | Population median age. |
| gdp_per_capita| Numeric   | OWID      | |
| gov           | Character | External  | Type of government in the country. |
| corruption    | Character | External  | Highly corrupt or less corrupt. |
| obesity       | Numeric   | Annia     | |
| healthSecurity| Character | Rebecca   | Pandemic preparedness index from 2019. Most prepared, more prepared and least prepared. | 
| temp          | Numeric  | Victor    | |
| pulmonary_deaths| Character | Rocio     | | 2016 data from WHO by country
| diabetes_deaths | Character | Rocio     | | 2016 data from WHO by country
| cardiovascular_deaths| Character | Rocio     | | 2016 data from WHO by country
| cancer_deaths| Character | Rocio     | | 2016 data from WHO by country

#### Final output for preprocessing will be .... 
*Please change if I got it wrong!*

*Wed Dec 16*
## Questions to Matt:
- Show diagram and make sure we are going in the right direction. Maybe some tips to simplify the workflow.
- Should we try read the daily data directly into R, or should we use Python instead? For B_covidDaily.csv.
*It's better to use Python (like we have at the diagram it's OK)*
- Save the CSV directly from R to S3, avoid having to write Python script? Or should we be putting more Python scripts in for error checks?
*Yes we can -> https://www.rdocumentation.org/packages/AnnotationHub/versions/2.4.2/topics/upload_to_S3*
- Should we grab the data daily(or weekly??), and then only upload weekly, or should we also do this daily?
*Daily*
- Should we use the Heroku scheduler multiple times? Or can we only run it once? Will this start charging us? How can we track?

---
## Our first thoughts

### Granularity:
 * Monthly | :+1: :+1: votes
 * Weekly | :+1: :+1: votes
 * Fortnightly | :+1: :+1: votes

### Datasets:
 * Original
    * Our World In Data Covid-19 [data](https://github.com/arixha/MVTEC-Stats-Project1/blob/main/owid-covid-data-131120.xlsx) by country
    * [Country info](country-info.xlsx) supplied by Karina's students.
 * Additonal datasets
    * [Government response index](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)
    * [Obesity](https://github.com/arixha/MVTEC-Stats-Project1/tree/main/our%20data/obesity%20adults%20WHO), [Diabetes](https://github.com/arixha/MVTEC-Stats-Project1/tree/main/our%20data/diabetes%20adults%20WDB)
    * [Mortality](https://github.com/arixha/MVTEC-Stats-Project1/tree/main/our%20data/data%20mortality%20causes%20WHO%202016)
    * [Air pollution](https://github.com/arixha/MVTEC-Stats-Project1/tree/main/our%20data/air%20pollution%20WDB)

### Variables:
#### Qualitative:
* Government_Type
* Corruption_preception
* Causes of mortality ¿¿ I don't find Monthly/weekly/fortnightly by countries ??
* Unnecessary deaths ¿¿ I don't find Monthly/weekly/fortnightly by countries ??

OTHER...
* Cities with more Density Population
* Cities with aeroports

#### Quantitative:
* GDP_per_capita
* Density Population
* Obesity index
* Overweight 
* Acumulative Cases Covid
* Ages Covid
* Monthly or Weekly or Fortnightly Cases Covid ??
* Monthly or Weekly or Fortnightly Tests Covid ??
* Monthly or Weekly or Fortnightly Diabetes Prevalence Covid ??
* Monthly or Weekly or Fortnightly cardiovasc_death_rate Covid vs total deaths Covid ??
* Weekly_icu_admissions vs hospital_beds_per_thousand Covid ??
* [Pandemic preparedness & health security index](https://www.ghsindex.org/)
* [Government response index](https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker)


## Possible hypotheses

* Spread is more related to **everyday lifestyle** than rates of wealth, or socioeconomic status. *(Number of aeroports, public transport...?)*
* How the **weather** of each country *(cold or hot)* affected the spread of the virus. At the beginning of the pandemic some scientists said that the virus was somehow deactivated or supressed by cold weather. *(Also Pollution...?)*
* **Obesity** and its impact on severity of virus symptoms, including chance of death.
* **Ethnicity** and its impact on spread of virus. Black people in USA have more risk of being contagious.
* Contract tracing and widespread **testing** are key factors in controlling the outbreak.
* **Age** is just a number and doesn't determine how severe you will experience the virus symptoms. Need to show something that indicates the wide variety of ages is contrary to popular opinion that younger people don't suffer from it as much or as long.
* **Overloaded hospital** systems was the biggest cause of unnecessary death. Types of medication used by different countries - does it have an impact on death rate?

