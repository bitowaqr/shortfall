This repository contains the R source code for the preprint publication:

### **"Quality-adjusted life expectancy norms for the English population"**

Paul Schneider<sup>1</sup>, Simon McNamara<sup>1,2</sup>,James Love-Koh<sup>3,4</sup>, Tim Doran<sup>5</sup>, Nils Gutacker<sup>3</sup>

<sup>1</sup> ScHARR, University of Sheffield, Sheffield, UK; <sup>2</sup> BresMed, Sheffield, UK; <sup>3</sup> CHE, University of York, York, UK; <sup>4</sup> NICE, London, UK; <sup>5</sup> Department of Health Sciences, University of York, York, UK.

**Preprint on medRxiv: [Link](...)**

**Shortfall shiny app: [Link](https://r4scharr.shinyapps.io/shortfall/)**

*****

#### Folder structure:

```
./app/               # source code for the shiny app
./src manuscript/     # analysis for the results reported in the manuscript
```

*****

#### Abstract

##### **Objective**

The National Institute for Health and Care Excellence in England has proposed severity-of-disease modifiers that give greater weight to health benefits accruing to patients who experience a larger shortfall in quality-adjusted life years (QALYs) under current standard of care compared to healthy individuals. This requires an estimate of quality-adjusted life expectancy (QALE) of the general population by age and sex. Previous QALE population norms are based on nearly 30-year old assessments of HRQoL in the general population. This study provides updated QALE estimates for the English population by age and sex.

##### **Methods**
EQ-5D-5L data for 14,412 participants from the Health Survey for England (waves 2017 and 2018) were pooled and HRQoL population norms were calculated. These norms were combined with official life tables from the Office for National Statistics for 2017-2019 using the Sullivan method to derive QALE estimates by age and sex. Values were discounted using 0%, 1.5% and 3.5% discount rates.

##### **Results**
QALE at birth is 68.04 QALYs for men and 68.48 QALYs for women. These values are lower than previously published QALE population norms based on older HRQoL data. 

##### **Conclusions**
This study provides new QALE population norms for England that serve to establish absolute and relative QALY shortfalls for the purpose of health technology assessments.


****

##### **Data availability** 

All the data sets that were used for the analysis are publicly available:

1. Health Survey for England:
  * University College London Department of Epidemiology and Public Health; National Centre for Social Research (NatCen). Health Survey for England, 2017. UK Data Service (2021). [link](http://doi.org/10.5255/UKDA-SN-8488-2)
  * University College London Department of Epidemiology and Public Health; National Centre for Social Research (NatCen). Health Survey for England, 2018. UK Data Service (2021). [link](http://doi.org/10.5255/UKDA-SN-8649-1)

2. Interim Scoring for the EQ-5D-5L:
  * Van Hout B, Janssen MF, Feng YS, Kohlmann T, Busschbach J, Golicki D, Lloyd A, Scalone L, Kind P, Pickard AS. Interim scoring for the EQ-5D-5L: mapping the EQ-5D-5L to EQ-5D-3L value sets. Value in health. 2012 Jul 1;15(5):708-15. [link](https://doi.org/10.1016/j.jval.2012.02.008)
  * Fraser Morton and Jagtar Singh Nijjar (2020). eq5d: Methods for Calculating 'EQ-5D' Utility Index Scores. R package version 0.7.0. [link](https://cran.r-project.org/package=eq5d)

3. National Life Tables:
  * ONS: National Life Tables, England, 1980-1982 to 2017-2019. (2021). [link](https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/lifeexpectancies/datasets/nationallifetablesenglandreferencetables)

****

If you have comments, questions, or concerns, please [contact Us](mailto:p.schneider@sheffield.ac.uk)

