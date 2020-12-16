# MVTEC-Stats-Project1

###### Update: Wednesday, Dec 16, 2020

## Task List:
- [ ] Create "A_extraData.csv" (Annia to compile)
    - [ ] Rebecca sends healthSecurity data
    - [ ] Rocio sends mortalityCauses data
    - [ ] Victor sends temperature data
- [ ] Set up logins
    - [ ] AWS
    - [ ] Heroku
    - [ ] Observable?
    - [x] Email errors
- [ ] Figure out how to upload A_extraData.csv
- [ ] Create Python script to read CovidDaily data and output data we need to S3 bucket to create "B_covidDaily.csv"
- [ ] Create scripts to join A & B, output C for next stage

## Questions to Matt:
- Show diagram and make sure we are going in the right direction.
- Should we try read the daily data directly into R, or should we use Python instead? For B_covidDaily.csv.
- Save the CSV directly from R to S3, avoid having to write Python script? Or should we be putting more Python scripts in for error checks?
- Should we grab the data daily(or weekly??), and then only upload weekly, or should we also do this daily?
- Should we use the Heroku scheduler multiple times? Or can we only run it once? Will this start charging us? How can we track?
- Maybe some tips to simplify the workflow.

## Data focus
We have decided to limit our analysis to the countries that have sufficient data for **hospital beds** and **weekly hospital admissions**. This is provided only by the European and US data centres for certain countries therefore our analysis is limited to the following 22 countries:

countries = [
            Belgium, 
            Croatia, 
            Cyprus, 
            Czech Republic, 
            Denmark,
            Estonia,
            France,
            Greece, 
            Germany,
            Iceland,
            Ireland,
            Latvia, 
            Lithuania,
            Malta,
            Netherlands,
            Portugal, 
            Romania,
            Slovenia,
            Spain,
            Sweden,
            United Kingdom,
            United States]

## Pre-processing

In the pre-processing stage, we will be uploading two data files and then later join them into one for the next stage.

One is a static file that will be uploaded one time (A_extraData.csv). The other is a dynamic file that will be pulling in data daily (B_covidDaily.csv).

#### Variables in "A_extraData.csv"
There will be no date field. It is uploaded once.

| Variables     | Type      | Origin    | Description      |
| ------------- |:--------: |:--------: | :-----        |
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
| ----------- | :-------: | :---------:| ---        |
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

**Output will be C_covidOK.csv**