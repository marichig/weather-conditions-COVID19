# Supplementary Code and Data for "Weather Conditions and COVID-19 Transmission: Estimates and Projections," Xu et al.

This repository provides the code and data needed to replicate the results presented in [Xu et al][paper]. The [appendix][appendix] provides detail on the methods used and should be viewed in tandem with the code and data here. Moreover, we provide some direction here for running the analyses.

This paper can be cited as:
>Xu, Ran and Rahmandad, Hazhir and Gupta, Marichi and DiGennaro, Catherine and Ghaffarzadegan, Navid and Jalali, Mohammad, Weather Conditions and COVID-19 Transmission: Estimates and Projections (May 5, 2020). Available at SSRN: https://ssrn.com/abstract=3593879

Correspondance can be directed to:

Mohammad "MJ" Jalali, Ph. D<br/>
Assistant Professor, Harvard Medical School<br/>
Massachusetts General Hospital, Institute for Technology Assessment<br/>
msjalali \[at] mgh \[dot] harvard \[dot] edu


## Links
* The pre-print and supplementary appendix are available [here][paper].
<!--* The supplementary appendix is available [here][appendix].-->
* The project website is available [here][website].

## Sections
The code for this project is broken into four parts:
1. [WeatherDataCollection](WeatherDataCollection) provides code for downloading global weather data from [World Weather Online](https://www.worldweatheronline.com/) (using [wwo-hist](https://github.com/ekapope/WorldWeatherOnline)) and [OpenWeatherMap](https://openweathermap.org/) (using [pyowm](https://github.com/csparpa/pyowm)), and contains the case-weather data files, with data coming from [Johns Hopkins University Center for Systems Science and Engineering](https://github.com/CSSEGISandData/COVID-19).
2. [ABM](ABM) provides code for running the agent-based model used to generate synthetic data for testing.
3. [SyntheticDataExploration](SyntheticDataExploration) provides code for preprocessing the synthetic case data into a metric incorporating detection delay. This preprocessing was also applied to real case data from JHU.
4. [StatisticalAnalyses](StatisticalAnalyses) provides STATA code for performing the regression analyses.


[paper]: https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3593879
[appendix]: https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3593879
[website]: https://projects.iq.harvard.edu/covid19/people
