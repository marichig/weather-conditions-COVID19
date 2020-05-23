# File Descriptions
## Python Notebooks
- [Weather Data Collection for Upload (Jupyter Notebook)](WeatherDataCollection/UV%20Data%20Collection%20for%20Upload.ipynb): This is the main notebook used for collect all weather variables analyzed except UV data, with data downloaded from [World Weather Online](https://www.worldweatheronline.com/developer/) (WWO).
  - This notebook uses [wwo-hist](https://github.com/ekapope/WorldWeatherOnline) to access the WWO API.
- [UV Data Collection for Upload (Jupyter Notebook)](WeatherDataCollection/UV%20Data%20Collection%20for%20Upload.ipynb): This notebook is used to download UV Data from [OpenWeatherMap](https://openweathermap.org/). We obtain UV data as measured at noon each day. Requests are passed using [epoch timestamps](https://en.wikipedia.org/wiki/Unix_time) to give the start and end date of collection; hence, this notebook also reads in [US_timezones.xlsx](WeatherDataCollection/US_timezones.xlsx) or [global_timezones.xlsx](WeatherDataCollection/global_timezones.xlsx) to calculate the correct timestamp for noon, local time for a given location. Results are then exported to an output spreadsheet using the provided template.
  - This notebook uses [pyowm](https://github.com/csparpa/pyowm) to access the OpenWeatherMap API.

## Template Files
These files are prepared in Excel and have the start-end date range written along the top row of the sheets - if you are to use these to collect weather data for different date ranges, make sure to adjust these on the template files.
- [US_template.xlsx](WeatherDataCollection/US_template.xlsx) provides the template used for the 3149 U.S. locations in the analysis.
- [global_template.xlsx](WeatherDataCollection/global_template.xlsx) provides the template used for the 590 non-U.S. locations in the analysis.

## Data Files
The final data files, including case numbers, population density data, and data for all weather variables, are included in the [data](WeatherDataCollection/data) folder. The U.S. file was broken into two spreadsheets due to file size - the "Main Features" version includes the 9 variables included in the main article, with the remaining features in "Remaining Features."