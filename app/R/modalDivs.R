



modalDivs = function(){

  lifetableItem = function(){
    tags$li(class ="ms-3", "Life tables:", 
            a(
              href = "https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/lifeexpectancies/datasets/nationallifetablesenglandreferencetables", 
              "England, 2017-2019 ", 
              "target" = "_blank"
            ), 
            "(pooled)"
    )
  }
    
  
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
        <b>Quality-adjusted life expectancy (QALE) is the basis for computing the QALY shortfall. Estimating QALE requires four components:</b>
        <ol>
            <li> A national life table to derive age and sex-specific survial times</li>
            <li> A scoring algorithm to value health states in terms of health-realted quality of life </li> 
            <li> EQ-5D health state profiles</li>
            <li> A model to estimate HRQoL norms by age and sex </li>
        </ol>
             <hr>"
             ),
        
          h4("Scenarios:"),
        tags$p(
                tags$ul(
                  tags$b(tags$u("Reference case:")),
                   lifetableItem(),
                  tags$li(
                    class ="ms-3", 
                    "Scoring algorithm: EQ-5D-3L value set from the",
                    a(href = "https://www.york.ac.uk/media/che/documents/reports/MVH%20Final%20Report.pdf", "1993 MVH study", "target" = "_blank")
                    ),
                  tags$li(class ="ms-3", "Health state profiles: EQ-5D-3L from the",
                          a(href = "http://doi.org/10.5255/UKDA-SN-7919-3", "Health Survey for England 2014", "target" = "_blank")
                  ),
                  tags$li(
                    class ="ms-3", "Model: ALDVMM",
                    a(href = "https://www.sheffield.ac.uk/sites/default/files/2022-02/DSU%20Age%20based%20utility%20-%20Final%20for%20website.pdf", "by Hernandez Alava, et al. 2022", "target" = "_blank")
                    ),
                  
               )
               ),
        
        
        tags$p(
          tags$ul(
          tags$b(tags$u("Alternative A:")),
          lifetableItem(),
          tags$li(class ="ms-3", "Scoring algorithm: EQ-5D-5L to 3L mapping by",
                  a(href = "https://www.nice.org.uk/Media/Default/About/what-we-do/NICE-guidance/estimating-the-relationship-betweenE-Q-5D-5L-and-EQ-5D-3L.pdf", "by Hernandez Alava, et al. 2020", "target" = "_blank")
          ),
          tags$li(class ="ms-3", "Health state profiles: Health Survey for England", 
                  a(href = "http://doi.org/10.5255/UKDA-SN-8488-2", "2017", "target" = "_blank"),
                  "and",
                  a(href = "http://doi.org/10.5255/UKDA-SN-8649-1","2018" , "target" = "_blank"),
                  "(pooled)"
                  ),
          tags$li(class ="ms-3", "Model: emprical means/no interpolation"),
          )
        ),
        
        
        tags$p(
          tags$ul(
          tags$b(tags$u("Alternative B:")),
          lifetableItem(),
          tags$li(class ="ms-3", "Scoring algorithm: EQ-5D-5L to 3L mapping by", 
                  a(href = "https://doi.org/10.1016/j.jval.2012.02.008", "van Hout et al. 2012", "target" = "_blank"),
                  ),
          tags$li(class ="ms-3", "Health state profiles: Health Survey for England", 
                  a(href = "http://doi.org/10.5255/UKDA-SN-8488-2", "2017", "target" = "_blank"),
                  "and",
                  a(href = "http://doi.org/10.5255/UKDA-SN-8649-1","2018" , "target" = "_blank"),
                  "(pooled)"
          ),
          tags$li(class ="ms-3", "Model: emprical means/no interpolation"),
          )
        ),
        
        
        tags$p(
          tags$ul(
          tags$b(tags$u("Alternative C:")),
          lifetableItem(),
          tags$li(
            class ="ms-3", 
            "Scoring algorithm: EQ-5D-3L value set from the",
            a(href = "https://www.york.ac.uk/media/che/documents/reports/MVH%20Final%20Report.pdf", "1993 MVH study", "target" = "_blank")
          ),
          tags$li(
            class ="ms-3", 
            "Health state profiles: EQ-5D-3L from the 1993 MVH study by", 
            a(href = "https://www.york.ac.uk/che/pdf/DP172.pdf", "Kind et al., 1999", "target" = "_blank")
            ),
          tags$li(class ="ms-3", "Model: emprical means/no interpolation"),
          )
        ),
        
        
        tags$p(
          tags$ul(
          tags$b(tags$u("Alternative D:")),
          lifetableItem(),
          tags$li(
            class ="ms-3", 
            "Scoring algorithm: EQ-5D-3L value set from the",
            a(href = "https://www.york.ac.uk/media/che/documents/reports/MVH%20Final%20Report.pdf", "1993 MVH study", "target" = "_blank")
          ),
          tags$li(class ="ms-3", "Health state profiles: Health Survey for England", 
                  a(href = "http://doi.org/10.5255/UKDA-SN-7480-1", "2012", "target" = "_blank"),
                  "+",
                  a(href = "http://doi.org/10.5255/UKDA-SN-7919-3","2014" , "target" = "_blank"),
                  "(pooled)"
          ),
          tags$li(class ="ms-3", "Model: emprical means/no interpolation"),
          )
        ),
        
        tags$hr(),
        
        div(
          h4("Sources:"),
          class="hanging-indent mt-5",
          
          
          div(
            class ="px-5 my-1",
            "Fraser Morton and Jagtar Singh Nijjar (2020). eq5d: Methods for Calculating 'EQ-5D'
        Utility Index Scores. R package version 0.7.0.", 
            a(href = "https://CRAN.R-project.org/package=eq5d", "link", "target" = "_blank")
          ),
          
          div(
            class ="px-5 my-1",
            "Hernandez Alava, M., Pudney, S., and Wailoo, A. (2020) Estimating the relationship between EQ-5D-5L and EQ-5D-3L: results from an English Population Study. Policy Research Unit in Economic Evaluation of Health and Care Interventions. Universities of Sheffield and York. Report 063", 
            a(href = "http://nicedsu.org.uk/mapping-eq-5d-5l-to-3l/", "link", "target" = "_blank")
          ),
          
          
          div(
            class ="px-5 my-1",
            "Hernandez Alava, M., Pudney, S., and Wailoo, A. (2022) Estimating EQ-5D by age and sex for the UK. NICE DSU Report. 2022.", 
            a(href = "https://www.sheffield.ac.uk/sites/default/files/2022-02/DSU%20Age%20based%20utility%20-%20Final%20for%20website.pdf", "link", "target" = "_blank")
          ),
          
          div(
            class ="px-5 my-1",
            "Kind P, Hardman G, Macran S (1999). UK population norms for EQ-5D.." ,
            a(href = "https://www.york.ac.uk/che/pdf/DP172.pdf", "link", "target" = "_blank"
            )
          ),
          
          
          div(
            class ="px-5 my-1",
            "MVH Group (1995). The measurement and valuation of health: Final report on the modelling of valuation tariffs. Centre for Health Economics, University of York." ,
            a(href = "https://www.york.ac.uk/media/che/documents/reports/MVH%20Final%20Report.pdf", "link", "target" = "_blank"
            )
          ),
          
          
          div(
            class ="px-5 my-1",
            "ONS (2021). National Life Tables, England, 1980-1982 to 2017-2019.", 
            a(href = "https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/lifeexpectancies/datasets/nationallifetablesenglandreferencetables", "link", "target" = "_blank")
          ),
          
          
          
        div(
            class ="px-5 my-1",
            "University College London Department of Epidemiology and Public Health; National Centre for Social Research (NatCen) (2021).  Health Survey for England, 2018. UK Data Service.",
            a(href = "http://doi.org/10.5255/UKDA-SN-8649-1", "link", "target" = "_blank")
        ),
        div(
            class ="px-5 my-1",
            "University College London Department of Epidemiology and Public Health; National Centre for Social Research (NatCen) (2021). Health Survey for England, 2017. UK Data Service.",
            a(href = "http://doi.org/10.5255/UKDA-SN-8488-2", "link", "target" = "_blank")
          ),
        div(
            class ="px-5 my-1","University College London Department of Epidemiology and Public Health; National Centre for Social Research (NatCen) (2018). Health Survey for England, 2014. UK Data Service.",
            a(href = "http://doi.org/10.5255/UKDA-SN-7919-3", "link", "target" = "_blank")
          ),
        div(
            class ="px-5 my-1","University College London Department of Epidemiology and Public Health; National Centre for Social Research (NatCen) (2014). Health Survey for England, 2012. UK Data Service.",
            a(href = "http://doi.org/10.5255/UKDA-SN-7480-1", "link", "target" = "_blank")
          ),
        
        div(
          class ="px-5 my-1",
          "Van Hout B, Janssen MF, Feng YS, Kohlmann T, Busschbach J, Golicki D, Lloyd A, Scalone L, Kind P, Pickard AS (2012). Interim scoring for the EQ-5D-5L: mapping the EQ-5D-5L to EQ-5D-3L value sets. Value in health. Jul 1;15(5):708-15.", 
          a(href = "https://doi.org/10.1016/j.jval.2012.02.008", "link", "target" = "_blank")
        ),
        
      ),
      
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
        <li><b>QALE / Remaining QALYs (discounted)</b>: How many QALYs does a patient with current standard of care incur? </li>
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


