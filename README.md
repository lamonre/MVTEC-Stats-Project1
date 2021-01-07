# MVTEC: Group 2
@authors: Ànnia, Rebecca, Rocío, Victor.

###### Update: Thurs, Jan 7, 2020

## Observable notebooks
[Main](https://observablehq.com/@mvtecgroup2module1/mvtec-group-2)

## Two data pipelines

###  Data Pipeline 1: Preprocessing
In order to keep the predictions as clean as possible, we ended up using Python to script out 3 processed data files for each of the 3 previous days, based on UTC time.

We then, pushed these files up to S3 and used them for the second data pipeline.

![Data pipeline 1 Diagram](https://github.com/arixha/MVTEC-Stats-Project1/blob/main/dataPipeline1-preprocessing.jpg?raw=true)

Date Pipeline 1: Please refer to this repository: [https://github.com/arixha/MVTEC-Stats-Project1/tree/main/dataPipeline1-preprocessing](https://github.com/arixha/MVTEC-Stats-Project1/tree/main/dataPipeline1-preprocessing)

###  Data Pipeline 2: Five cluster predictions
The second data pipeline has three Rscripts. Two of them just run predictions on the previous two days and the last one will run the latest prediction and then add in the two previous days predictions to output the "joined" csv files for each cluster. These are then used for the data visualisations.

![Data pipeline 2 Diagram](https://github.com/arixha/MVTEC-Stats-Project1/blob/main/dataPipeline2-clusters.jpg?raw=true)

Date Pipeline 2: Please refer to this repository: [https://github.com/arixha/MVTEC-Stats-Project1/tree/main/dataPipeline2-clusters](https://github.com/arixha/MVTEC-Stats-Project1/tree/main/dataPipeline2-clusters)

## Clusters
During the prediction stage, we were able to use the model to cluster groups together in the following ways:

**Cluster 1** Qatar, Bahrain, Luxembourg, Kuwait, United Arab Emirates, Singapore.

**Cluster 2** San Marino, Andorra, Vatican, Panama, Montenegro, Armenia, Oman, Maldives, Moldova, Costa Rica, Cape Verde, Georgia, Bahamas, Bolivia, Dominican Republic, Ecuador, Belize, Honduras, Morocco, Suriname, Djibouti, Libya, Paraguay, Sao Tome and Principe, Guatemala, Eswatini, Gabon, Namibia, Guyana, Equatorial Guinea, New Zealand, Marshall Islands, Papua New Guinea, Fiji, Solomon Islands, Samoa, Vanuatu.

**Cluster 3** Chile, Israel, Belgium, Czechia, Switzerland, Canada, Australia.

**Cluster 4** Mexico, Spain, Colombia, Peru, South Africa, Argentina.

**Cluster 5** United States, Brazil. *They were too large for the data predictions and needed to be considered separately.*

## Data focus: Which countries we selected and why.
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


