# Supplementary Code and Data for "Weather Conditions and COVID-19 Transmission: Estimates and Projections," Xu et al.

This repository provides the code and data needed to replicate the results presented in [Xu et al][paper]. The [appendix][appendix] provides detail on the methods used and should be viewed in tandem with the code and data here. Moreover, we provide some direction here for running the analyses.

This paper can be cited as:
>"Weather Conditions and COVID-19 Transmission: Estimates and Projections,"
> etc etc fill in

Correspondance can be directed to:

Mohammad "MJ" Jalali, Ph. D<br/>
Assistant Professor, Harvard Medical School<br/>
Massachusetts General Hospital, Institute for Technology Assessment<br/>
msjalali \[at] mgh \[dot] harvard \[dot] edu


## MG TODO
- License? [MIT License](https://opensource.org/licenses/MIT) is a common one for open-source projects
- Fill in pre-print/other URL references

## Links
* The pre-print/publication is available [here][paper].
* The supplementary appendix is available [here][appendix].
* The project website is available [here][website].

## Sections
The code for this project is broken into four parts:
1. [WeatherDataCollection](WeatherDataCollection) provides code for downloading global weather data from [World Weather Online](https://www.worldweatheronline.com/) (using [wwo-hist](https://github.com/ekapope/WorldWeatherOnline)) and [OpenWeatherMap](https://openweathermap.org/) (using [pyowm](https://github.com/csparpa/pyowm)), and contains the case-weather data files, with data coming from [Johns Hopkins University Center for Systems Science and Engineering](https://github.com/CSSEGISandData/COVID-19).
2. [ABM](ABM) provides code for running the agent-based model used to generate synthetic data for testing.
3. [SyntheticDataExploration](SyntheticDataExploration) provides code for preprocessing the synthetic case data into a metric incorporating detection delay. This preprocessing was also applied to real case data from JHU.
4. [StatisticalAnalyses](StatisticalAnalyses) provides STATA code for performing the regression analyses.


[paper]: https://projects.iq.harvard.edu/covid19/people
[appendix]: https://projects.iq.harvard.edu/covid19/people
[website]: https://projects.iq.harvard.edu/covid19/people
