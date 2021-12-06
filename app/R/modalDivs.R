# modalDivs


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
        class = "py-3 px-4",
        style = "overflow-y:scroll;",
        div(
          class = "accent p",
          "EQ-5D-5L scores by age and sex were pooled from:"
        ),
        p(
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
        div(
          class = "accent p",
          "Lifetables were taken from:"
        ),
        tags$li(
          class ="px-5",
          "ONS: National Life Tables, England, 1980-1982 to 2017-2019. (2021).", 
          a(href = "https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/lifeexpectancies/datasets/nationallifetablesenglandreferencetables", "link", "target" = "_blank")
        )
      ),
      
      
      # tableOutput("raw_data"),
      
      HTML('
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
      </div>')
    )
  )
),

# info model
div(
  class="modal fade", id="infoModal", tabindex="-1", "aria-labelledby"="infoModalLabel",  "aria-hidden"="true",
  div(
    class="modal-dialog modal-dialog-scrollable modal-lg",
    div(
      class = "modal-content",
      div(
        class="modal-header",
        div(
          class="modal-title text-center h5", 
          id="infoModalLabel",
          "QALY Shortfall Calculator info"
        )
      ),
      div(
        class = "p-3 ",
        style = "overflow-y:scroll;",
        
        
        h3("Info"),
        p("QALY shortfall refers to the reduction in the quality-adjusted life expectancy (QALE), that is the difference in the average number of QALYs a person with and a person without a particular disease can expect to incur over their remaining lifetime (at a given age)."), 
          tags$li("The absolute shortfall is defined as the expected loss in the total number of QALYs."),
          tags$li("The proportional shortfall is defined as the percentage of the QALYs that are lost."),
        br(),
        p("QALE estimates are based on age- and sex-specific EQ-5D-5L utility scores (van Hout et al, 2012) retrieved from the Health Surves from England 2017 and 2018, 
        and national life tables 2017-2019, from the Office of National Statistics"),
        
        
        h3("Instructions"),
        p("To use the calculator...."),
        
        
        h3("Further information"),
        p("link to paper")
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


