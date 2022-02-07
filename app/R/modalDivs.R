
modalDivs = function(){
  
  
 list( 
# MODALS ----------
# data modal
div(
  class="modal fade", id="sourcesModal", tabindex="-1", "aria-labelledby"="sourcesModalLabel",  "aria-hidden"="true",
  div(
    class="modal-dialog modal-dialog-scrollable modal-lg",
    div(
      class = "modal-content",
      div(
        class="modal-header",
        div(
          class="modal-title text-center h5", 
          id="sourcesModalLabel",
          "Sources"
        )
      ),
      div(
        class = "py-3 px-5",
        style = "overflow-y:scroll;",
        HTML("
        <b>QALE estimates are based on data from three sources:</b>
        <ol>
            <li> EQ-5D-5L health state profiles, retrieved from the Health Survey for England (waves 2017 and 2018)</li>
            <li> The crosswalk scoring algorithm, developed by van Hout et al. (2012), which maps EQ-5D-5L health states to the UK EQ-5D-3L social value set</li> 
            <li> National Life Tables for England 2017-2019, provided by the Office of National Statistics</li>
        </ol>"
             ),
        div(style = "font-size: 90%",
            br(),
        div(
          tags$b("1. Health Survey for England:"),
          tags$li(
            class ="px-5",
            "University College London Department of Epidemiology and Public Health; National Centre for Social Research (NatCen). Health Survey for England, 2017. UK Data Service (2021).",
            a(href = "http://doi.org/10.5255/UKDA-SN-8488-2", "link", "target" = "_blank")
          ),
          tags$li(
            class ="px-5","University College London Department of Epidemiology and Public Health; National Centre for Social Research (NatCen). Health Survey for England, 2018. UK Data Service (2021).",
            a(href = "http://doi.org/10.5255/UKDA-SN-8649-1", "link", "target" = "_blank")
          )
        ),
        br(),
      div(
        tags$b("2. Interim Scoring for the EQ-5D-5L:"),
        tags$li(
          class ="px-5",
          "Van Hout B, Janssen MF, Feng YS, Kohlmann T, Busschbach J, Golicki D, Lloyd A, Scalone L, Kind P, Pickard AS. Interim scoring for the EQ-5D-5L: mapping the EQ-5D-5L to EQ-5D-3L value sets. Value in health. 2012 Jul 1;15(5):708-15.", 
          a(href = "https://doi.org/10.1016/j.jval.2012.02.008", "link", "target" = "_blank")
        ),
        tags$li(
          class ="px-5",
          "Hernandez Alava, M., Pudney, S., and Wailoo, A. (2020) Estimating the relationship between EQ-5D-5L and EQ-5D-3L: results from an English Population Study. Policy Research Unit in Economic Evaluation of Health and Care Interventions. Universities of Sheffield and York. Report 063", 
          a(href = "http://nicedsu.org.uk/mapping-eq-5d-5l-to-3l/", "link", "target" = "_blank")
        ),
        tags$li(
          class ="px-5",
          "Fraser Morton and Jagtar Singh Nijjar (2020). eq5d: Methods for Calculating 'EQ-5D'
        Utility Index Scores. R package version 0.7.0.", 
          a(href = "https://CRAN.R-project.org/package=eq5d", "link", "target" = "_blank")
        )
      ),
        br(),
        div(
          style = "margin-bottom: 20px;",
          tags$b("3. National Life Tables:"),
        tags$li(
          class ="px-5",
          "ONS: National Life Tables, England, 1980-1982 to 2017-2019. (2021).", 
          a(href = "https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/lifeexpectancies/datasets/nationallifetablesenglandreferencetables", "link", "target" = "_blank")
        ))
      ),
      
      
      # tableOutput("raw_data"),
      br(),
      HTML('
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
      </div>')
    )
  ))
),

# info model
div(
  class="modal fade", id="infoModal", tabindex="-1", "aria-labelledby"="infoModalLabel",  "aria-hidden"="true",
  div(
    class="modal-dialog modal-dialog-scrollable modal-lg",
    div(
      class = "modal-content px-5",
      div(
        class = "p-3 mt-3",
        id = "info-modal",
        style = "overflow-y:auto;",
        
        
        h3("QALY Shortfall Calculator info"),
        
        HTML("
        <p>
        <p>This app provides QALY reference values for the English general population and
        helps the user to compute the absolute and relative QALY shortfalls.
        </p>
        
        <ul>
        <li>NICE is considering introducing severity weights for QALYs</li>
        
        <li>Their proposed approach is based on proportional and absolute QALY shortfall</li>
        
        <li>NICE propose shortfall be calculated based on the difference in the quality-adjusted life expectancy (QALE) of a person with and a person without a particular disease (at a given age)</li>
        <ul>
        <li>Absolute shortfall = expected total QALY loss </li>
        
        <li>Proportional shortfall = percentage of the QALYs that are lost</li>
        </ul>
        </ul>
        
        <br>
        
        <p><b>To calculate the QALY shortfall, the following information are required:</b></p> 
        <ol>
        <li><b>Age</b>: at what age are patients diagnoses and/or treated?</li>
        <li><b>Sex</b>: What is the proportion of women in the patient patient population?</li>
        <li><b>Remaining QALYs (discounted)</b>: How many QALYs does a patient with current standard of care incur? </li>
        <li><b>Discount rate</b>: At what rate should future QALYs be discounted?</li>
        <div style = 'width: 80%; background-color: ##ffffd8; padding: 5px;'>
          <mark><b>NOTE:</b>The discount rate is only used to derive age- and sex-specific QALY norm values.
          The remaining QALYs of the untreated patient population is not being discounted.
          </mark>
        </div>
        </ol>
        <p><b>Contact:</b> <br>
        Paul Schneider<br> 
        University of Sheffield<br>
        <a href='mailto:p.schneider@sheffield.ac.uk'>p.schneider@sheffield.ac.uk</a>
        </p>
        ")
      ),
      
      
      HTML('
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
      </div>')
    )
    
  )
)
 )
  
  }


