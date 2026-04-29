# QALY Shortfall Calculator (v1 — Legacy)

> **This version is no longer actively maintained.** The Shiny app now redirects to the [QALY Shortfall Calculator v2](https://shortfallv2.vercel.app/), built in JavaScript/Nuxt. Source code for v2: [github.com/bitowaqr/shortfall_v2](https://github.com/bitowaqr/shortfall_v2)

---

This repository contains the original R/Shiny source code and manuscript analysis for:

> McNamara S, Schneider PP, Love-Koh J, Doran T, Gutacker N. **Quality-Adjusted Life Expectancy Norms for the English Population**. Value in Health. 2022 Aug 12. [https://doi.org/10.1016/j.jval.2022.07.005](https://doi.org/10.1016/j.jval.2022.07.005)

### Repository structure

```
./app/               # Shiny app (now serves an iframe redirect to v2)
./src manuscript/    # Analysis for the results reported in the manuscript
```

### Data availability

All data sets used in the analysis are publicly available:

- **Health Survey for England, 2017.** [link](http://doi.org/10.5255/UKDA-SN-8488-2)
- **Health Survey for England, 2018.** [link](http://doi.org/10.5255/UKDA-SN-8649-1)
- **EQ-5D-5L Interim Scoring.** Van Hout et al. (2012). [link](https://doi.org/10.1016/j.jval.2012.02.008)
- **EQ-5D-5L to 3L Mapping.** Hernandez Alava et al. (2020). [link](http://nicedsu.org.uk/mapping-eq-5d-5l-to-3l/)
- **National Life Tables, England.** ONS (2021). [link](https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/lifeexpectancies/datasets/nationallifetablesenglandreferencetables)

### Contact

If you have comments, questions, or concerns, please [contact us](mailto:bitowaqr@gmail.com).
