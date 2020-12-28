# MVTEC-Stats-Project1

###### Update: Thurs, Dec 17, 2020

## Task List:
Pre-processing Project Board [here](https://github.com/arixha/MVTEC-Stats-Project1/projects/1)
- [ ] Create "A_covidDaily.csv" (Annia to compile)
    - [x] Rebecca sends healthSecurity data
    - [x] Rocio sends mortalityCauses data
    - [ ] Victor sends temperature data
- [x] Get AWS credentials from Matt
- [ ] Upload "A_covidDaily.csv" to S3 via Python script
- [ ] Download "A_covidDaily.csv" to R from S3
- [x] Create Python script to read CovidDaily data and output data we need to S3 bucket to create "B_covidDaily.csv"
- [ ] ?? Create scripts to join A & B, output C for next stage
- [ ] Decide how to handle errors for country names. The latest CSV pulled from OWID github had 'Czech Republic' as 'Czechia'. This could cause problems.

## Data focus
We have decided to limit our analysis to the top 10 countries for each region which have the highest number of total cases per million.

*Last updated on Thurs Dec 27*

countriesAfrica = c("Cape Verde", "South Africa", "Djibouti", "Sao Tome and Principe", "Libya", "Gabon", "Swaziland", "Equatorial Guinea", "Morocco", "Namibia") 

countriesEurope = c("Andorra", "San Marino", "Vatican", "Luxembourg", "Montenegro", "Belgium", "Spain", "Czech Republic", "Moldova", "Switzerland")

countriesAsia = c("Qatar", "Bahrain", "Kuwait", "Armenia", "Israel", "Oman", "Maldives", "Singapore", "Saudia Arabia", "United Arab Emirates")

countriesNorthAmerica = c("Panama", "United States", "Costa Rica", "Dominican Republic", "Bahamas", "Honduras", "Mexico", "Belize", "Canada", "Guatemala")

countriesSouthAmerica = c("Chile", "Peru", "Brazil", "Argentina", "Colombia", "Bolivia", "Ecuador", "Suriname", "Paraguay", "Guyana")

countriesOceania = c("Australia", "New Zealand", "Marshall Islands", "Papua New Guinea", "Fiji", "Solomon Islands", "Vanuatu")

allCountries = c("Cape Verde", "South Africa", "Djibouti", "Sao Tome and Principe", "Libya", "Gabon", "Swaziland", "Equatorial Guinea", "Morocco", "Namibia", "Andorra", "San Marino", "Vatican", "Luxembourg", "Montenegro", "Belgium", "Spain", "Czech Republic", "Moldova", "Switzerland", "Qatar", "Bahrain", "Kuwait", "Armenia", "Israel", "Oman", "Maldives", "Singapore", "Saudia Arabia", "United Arab Emirates", "Panama", "United States", "Costa Rica", "Dominican Republic", "Bahamas", "Honduras", "Mexico", "Belize", "Canada", "Guatemala", "Chile", "Peru", "Brazil", "Argentina", "Colombia", "Bolivia", "Ecuador", "Suriname", "Paraguay", "Guyana", "Australia", "New Zealand", "Marshall Islands", "Papua New Guinea", "Fiji", "Solomon Islands", "Vanuatu")

## Pre-processing

In the pre-processing stage, we will be uploading two data files and then later join them into one for the next stage.

One is a static file that will be uploaded one time (A_extraData.csv). The other is a dynamic file that will be pulling in data daily (B_covidDaily.csv).

#### Variables in "A_extraData.csv"
There will be no date field. It is uploaded once.

| Variables     | Type      | Origin    | Description      |
| :------------ |:--------: |:--------: | :----- |
| **country**   | Identifier| OWID      | Joining variable. |
| population    | Numeric   | OWID      | Population of country. |
| popDensity    | Numeric   | OWID      | Population density. |
| medianAge     | Numeric   | OWID      | |
| gdp           | Numeric   | OWID      | |
| govt          | Character | External  | Type of government in the country. |
| corruption    | Character | External  | Highly corrupt or less corrupt. |
| obesity       | Numeric   | Annia     | |
| healthSecurity| Character | Rebecca   | Pandemic preparedness index from 2019. Most prepared, more prepared and least prepared. | 
|  temp         | Numeric?  | Victor    | |
| mortality     | Character | Rocio     | |
 

#### Variables in "B_covidDaily.csv"
This will include a date field. Most likely written in Python script. Updated daily, uploaded weekly (TBC).
| Variables   | Type      | Origin     | Description |
| :---------- | :-------: | :---------:| ---        |
| year        | Date      | Calculated | Extracted from the date field for grouping of weeks across years. |
| week        | Date      | Calculated | Extracted, similar to year field. |
| region      | Character | OWID       | Used for region groupings if needed. |
| **country** | Identifier| OWID       | Joining and grouping variable. |
| totalCases  | Numeric   | OWID       | Cumulative cases for that country on that date. |
| tcpm        | Numeric   | OWID       | Total cases per million, cumulative.
| casesSmooth | Numeric   | OWID       | Daily new cases smoothed. Avg calculated for each week. |
| totalDeaths | Numeric   | OWID       | Cumulative cases for that country on that date. |
| tdpm        | Numeric   | OWID       | Total deaths per million, cumulative. |
| deathSmooth | Numeric   | OWID       | Daily new deaths smoothed. Avg calculated for each week. |

#### Final output for preprocessing will be "C_covidOK.csv". 
*Please change if I got it wrong!*
