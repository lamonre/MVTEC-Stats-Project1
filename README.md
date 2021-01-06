# MVTEC-Stats-Project1

###### Update: Thurs, Dec 17, 2020

## Task List:
Pre-processing Project Board [here](https://github.com/arixha/MVTEC-Stats-Project1/projects/1)

## Data focus
We have decided to limit our analysis to the top 10 countries for each region which have the highest number of total cases per million.

*Last updated on Thurs Dec 27*

countriesAfrica = c("Cape Verde", "South Africa", "Djibouti", "Sao Tome and Principe", "Libya", "Gabon", "Eswatini", "Equatorial Guinea", "Morocco", "Namibia") 

countriesEurope = c("Andorra", "San Marino", "Vatican", "Luxembourg", "Montenegro", "Belgium", "Spain", "Czechia", "Moldova", "Switzerland")

countriesAsia = c("Qatar", "Bahrain", "Kuwait", "Armenia", "Israel", "Oman", "Maldives", "Singapore", "United Arab Emirates", "Georgia")

countriesNorthAmerica = c("Panama", "United States", "Costa Rica", "Dominican Republic", "Bahamas", "Honduras", "Mexico", "Belize", "Canada", "Guatemala")

countriesSouthAmerica = c("Chile", "Peru", "Brazil", "Argentina", "Colombia", "Bolivia", "Ecuador", "Suriname", "Paraguay", "Guyana")

countriesOceania = c("Australia", "New Zealand", "Marshall Islands", "Papua New Guinea", "Fiji", "Solomon Islands", "Vanuatu", "Samoa")

allCountries = c("Cape Verde", "South Africa", "Djibouti", "Sao Tome and Principe", "Libya", "Gabon", "Eswatini", "Equatorial Guinea", "Morocco", "Namibia", "Qatar", "Bahrain", "Kuwait", "Armenia", "Israel", "Oman", "Maldives", "Singapore", "Georgia", "United Arab Emirates","Andorra", "San Marino", "Vatican", "Luxembourg", "Montenegro", "Belgium", "Spain", "Czechia", "Moldova","Switzerland","Panama", "Costa Rica", "Dominican Republic", "Bahamas", "Honduras", "Mexico", "Belize", "Canada", "Guatemala","Australia", "New Zealand", "Marshall Islands", "Papua New Guinea", "Fiji", "Solomon Islands", "Vanuatu", "Samoa",
"Chile", "Peru", "Argentina", "Colombia", "Bolivia", "Ecuador", "Suriname", "Paraguay", "Guyana","Brazil","United States"))

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
