import pandas as pd
from email_cred import send_mail


url = "https://raw.githubusercontent.com/owi2/covid-19-data/master/public/data/owid-covid-data.csv"
columns = ['continent', 'location', 'date', 'total_cases', 'total_cases_per_million', 'new_cases_smoothed', 'total_deaths', 'total_deaths_per_million', 'new_deaths_smoothed']
countries = ["Belgium", "Croatia", "Cyprus", "Czech Republic", "Denmark", "Estonia", "France", "Germany", "Iceland", "Ireland", "Latvia", "Lithuania", "Malta", "Netherlands", "Norway", "Portugal", "Romania", "Slovenia", "Spain", "United Kingdom", "United States"]

try:
    c = pd.read_csv(url, usecols = columns, parse_dates = ['date'])
    df = c[c['location'].isin(countries)]
    # df['year'] = df['date'].dt.year
    # df['week'] = df['date'].dt.week
    df.to_csv('B_covidDaily.csv', index=False)

except Exception as e:
	send_mail('mvtec2020covid@gmail.com','Error', 'Something went wrong: %s' % str(e))
