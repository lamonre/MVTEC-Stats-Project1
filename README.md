# MVTEC-Stats-Project1

###### Update: Thurs, Dec 17, 2020

## Task List:
- [ ] Create "A_extraData.csv" (Annia to compile)
    - [x] Rebecca sends healthSecurity data
    - [ ] Rocio sends mortalityCauses data
    - [ ] Victor sends temperature data
- [ ] Get AWS credentials from Matt
- [ ] Upload "A_extraData.csv" to S3 via Python script
- [ ] Create Python script to read CovidDaily data and output data we need to S3 bucket to create "B_covidDaily.csv"
- [ ] Create scripts to join A & B, output C for next stage
- [ ] Decide how to handle errors for country names. The latest CSV pulled from OWID github had 'Czech Republic' as 'Czechia'. This could cause problems.

## Data focus
We have decided to limit our analysis to the countries that have sufficient data for **hospital beds** and **weekly hospital admissions**. This is provided only by the European and US data centres for certain countries therefore our analysis is limited to the following 22 countries:

countries = c("Belgium", "Croatia", "Cyprus", "Czech Republic", "Denmark", "Estonia", "France", "Germany", "Iceland", "Ireland", "Latvia", "Lithuania", "Malta", "Netherlands", "Norway", "Portugal", "Romania", "Slovenia", "Spain", "United Kingdom", "United States") *Last updated on Thurs Dec 17*

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
