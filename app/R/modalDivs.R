
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
        <b>Estimating QALEs requires three inputs:</b>
        <ol>
            <li> EQ-5D health state profiles</li>
            <li> A scoring algorithm to value health states in terms of health-realted quality of life </li> 
            <li> A national life table to derive age and sex-specific survial times</li>
        </ol>"
             ),
        tags$p(
               span(class = "fw-bold", "The following combination of data sources are taken to be the reference case:"),
               tags$li(tags$b("Health state profiles:"), "Health Survey for England 2017 and 2018 (pooled)"),
               tags$li(tags$b("Scoring algorithm:"), "Hernandez Alava, et al.'s EQ-5D-5L to 3L mapping algorithm"),
               tags$li(tags$b("Life tables:"), "England, 2017-2019 (pooled)")
               ),
        tags$p(
          tags$b("In addition, we provide estimates for two alternative specifications:"),
          tags$li("A. Using the  van Hout et al. EQ-5D-5L to 3L mapping algorithm"),
          tags$li("B. Using the EQ-5D-3L health state profiles and value set from the 1993 MVH study")
          ),
        h4("Sources:"),
        div(
          tags$li(
            class ="px-5 my-1",
            "University College London Department of Epidemiology and Public Health; National Centre for Social Research (NatCen). Health Survey for England, 2017. UK Data Service (2021).",
            a(href = "http://doi.org/10.5255/UKDA-SN-8488-2", "link", "target" = "_blank")
          ),
          tags$li(
            class ="px-5 my-1","University College London Department of Epidemiology and Public Health; National Centre for Social Research (NatCen). Health Survey for England, 2018. UK Data Service (2021).",
            a(href = "http://doi.org/10.5255/UKDA-SN-8649-1", "link", "target" = "_blank")
          ),
        tags$li(
          class ="px-5 my-1",
          "Hernandez Alava, M., Pudney, S., and Wailoo, A. (2020) Estimating the relationship between EQ-5D-5L and EQ-5D-3L: results from an English Population Study. Policy Research Unit in Economic Evaluation of Health and Care Interventions. Universities of Sheffield and York. Report 063", 
          a(href = "http://nicedsu.org.uk/mapping-eq-5d-5l-to-3l/", "link", "target" = "_blank")
        ),
        tags$li(
          class ="px-5 my-1",
          "Van Hout B, Janssen MF, Feng YS, Kohlmann T, Busschbach J, Golicki D, Lloyd A, Scalone L, Kind P, Pickard AS. Interim scoring for the EQ-5D-5L: mapping the EQ-5D-5L to EQ-5D-3L value sets. Value in health. 2012 Jul 1;15(5):708-15.", 
          a(href = "https://doi.org/10.1016/j.jval.2012.02.008", "link", "target" = "_blank")
        ),
        tags$li(
          class ="px-5 my-1",
          "Fraser Morton and Jagtar Singh Nijjar (2020). eq5d: Methods for Calculating 'EQ-5D'
        Utility Index Scores. R package version 0.7.0.", 
          a(href = "https://CRAN.R-project.org/package=eq5d", "link", "target" = "_blank")
        ),
        tags$li(
          class ="px-5 my-1",
        "MVH Group (1995). The measurement and valuation of health: Final report on the modelling of valuation tariffs. Centre for Health Economics, University of York." ,
        a(href = "https://www.york.ac.uk/media/che/ documents/reports/MVHFinalReport.pdf", "link", "target" = "_blank"
          )
        ),
        tags$li(
          class ="px-5 my-1",
          "ONS: National Life Tables, England, 1980-1982 to 2017-2019. (2021).", 
          a(href = "https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/lifeexpectancies/datasets/nationallifetablesenglandreferencetables", "link", "target" = "_blank")
        )
        
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


