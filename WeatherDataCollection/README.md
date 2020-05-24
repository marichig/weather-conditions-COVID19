# File Descriptions
## Python Notebooks
- [Weather Data Collection for Upload (Jupyter Notebook)](WeatherDataCollection/UV%20Data%20Collection%20for%20Upload.ipynb): This is the main notebook used for collect all weather variables analyzed except UV data, with data downloaded from [World Weather Online](https://www.worldweatheronline.com/developer/) (WWO).
  - This notebook uses [wwo-hist](https://github.com/ekapope/WorldWeatherOnline) to access the WWO API.
- [UV Data Collection for Upload (Jupyter Notebook)](WeatherDataCollection/UV%20Data%20Collection%20for%20Upload.ipynb): This notebook is used to download UV Data from [OpenWeatherMap](https://openweathermap.org/). We obtain UV data as measured at noon each day. Requests are passed using [epoch timestamps](https://en.wikipedia.org/wiki/Unix_time) to give the start and end date of collection; hence, this notebook also reads in [US_timezones.xlsx](WeatherDataCollection/US_timezones.xlsx) or [global_timezones.xlsx](WeatherDataCollection/global_timezones.xlsx) to calculate the correct timestamp for noon, local time for a given location. Results are then exported to an output spreadsheet using the provided template.
  - This notebook uses [pyowm](https://github.com/csparpa/pyowm) to access the OpenWeatherMap API.
- [AirPollutionDataExtraction (Jupyter Notebook)](WeatherDataCollection/AirPollutionDataExtraction.ipynb) uses the [netCDF4](https://unidata.github.io/netcdf4-python/netCDF4/index.html) library for reading particulate matter, ozone, sulfur dioxide, and nitrogen dioxide data from the [European Centre for Medium-Range Weather Forecasts](https://www.ecmwf.int/) CAMS-Near Real Time dataset.
- [Excel Clean-up (Jupyter Notebook)](WeatherDataCollection/Excel%20Clean-up.ipynb) uses pandas and numpy to preprocess the weather/air pollution data. Such preprocessing includes unit conversions, interpolating over missing values using four-day windows, and performing population-weighted averages of city-level data for a country to give one aggregate vector for that country.

## Template Files
These files are prepared in Excel and have the start-end date range written along the top row of the sheets - if you are to use these to collect weather data for different date ranges, make sure to adjust these on the template files.
- [US_template.xlsx](WeatherDataCollection/templates/US_template.xlsx) provides the template used for the 3149 U.S. locations in the analysis.
- [global_simple_template.xlsx](WeatherDataCollection/templates/global_simple_template.xlsx) provides the template used for the 590 non-U.S. locations in the analysis, with coordinates denoting the centroid of each location.
- [global_weighted_template.xlsx](WeatherDataCollection/templates/global_weighted_template.xlsx) gives coordinates for any large city (pop &gt; 500,000) within our given countries.
- [1072_template.xlsx](WeatherDataCollection/templates/1072_template.xlsx) gives coordinates for the top 1072 urban areas in the world, as determined by Demographia World Urban Areas, 15th edition.

The corresponding pollution files contain the same locations for a slightly larger time range.

Also, the spreadsheets containg timezone-offsets for the [US](WeatherDataCollection/US_timezones.xlsx) and [world](WeatherDataCollection/global_timezones.xlsx) are used for querying UV data for a given location within one hour of noon local time.

## Data Files
The final data files, including case numbers, population density data, and data for all weather variables, are included in the [data](WeatherDataCollection/data) folder. The U.S. file was broken into three spreadsheets due to file size - the "Main Variables" file includes the main variables from the study, with the remaining variables stored in the other two US files.

Pollution data files (needed for [extracting air pollution data](WeatherDataCollection/AirPollutionDataExtraction.ipynb)) can be found in this [DropBox folder](https://www.dropbox.com/sh/lp9fubphu8lua4m/AACJ-m0o4BA0uTWhyvy9yhPxa?dl=0). These files are downloaded from ECMWF, and come in netCDF format.

The Python pickle file canonical_order.p contains a list of all countries in our global data set ordered by our working convention, and the pickle file weighted_countries_list.p contains a list of those countries for which population-weighted weather vectors were calculated.
