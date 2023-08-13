# Supplementary Code and Data for "Weather, air pollution, and SARS-CoV-2 transmission: a global analysis," Xu et al.

This repository provides the code and data needed to replicate the results presented in [Xu et al.]([https://www.thelancet.com/journals/lanplh/article/PIIS2542-5196(21)00202-3/fulltext#seccestitle10]). The paper and its appendix provide detail on the methods used and should be viewed in tandem with the code and data here. Moreover, we provide some direction here for running the analyses.

Correspondance can be directed to:

Mohammad Jalali ('MJ'), Ph.D.<br/>
Assistant Professor, Harvard Medical School<br/>
Massachusetts General Hospital, Institute for Technology Assessment<br/>
msjalali \[at] mgh \[dot] harvard \[dot] edu

## Links
[Project website, including an interactive simulator](https://projects.iq.harvard.edu/covid19)

## Sections
The code for this project is broken into four parts:
1. [WeatherDataCollection](WeatherDataCollection) provides code for downloading global weather data from [World Weather Online](https://www.worldweatheronline.com/) (using [wwo-hist](https://github.com/ekapope/WorldWeatherOnline)), [OpenWeatherMap](https://openweathermap.org/) (using [pyowm](https://github.com/csparpa/pyowm)), and for extracting air pollution data from files downloaded from the [European Centre for Medium-Range Weather Forecasting](https://www.ecmwf.int/). Furthermore, it contains the case-weather data files, with case data coming from [Johns Hopkins University Center for Systems Science and Engineering](https://github.com/CSSEGISandData/COVID-19).
2. [ABM](ABM) provides code for running the agent-based model used to generate synthetic data for testing.
3. [SyntheticDataExploration](SyntheticDataExploration) provides code for preprocessing the synthetic case data into a metric incorporating detection delay. This preprocessing was also applied to real case data from JHU.
4. [StatisticalAnalyses](StatisticalAnalyses) provides STATA code for performing the regression analyses.
