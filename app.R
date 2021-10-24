# shortfall app


library(shiny)
library(shinyjs)
library(shinyWidgets)
library(highcharter)
library(dplyr)

# load ref df with life table (ONS) and HRQoL estimates (HSE) by age and sex 
ref_df = read.csv("./data/ref_df.csv")

# load function to compute life and quality-adjusted life expectancies
source("./compQale.R")
# compQale(ref_df)


# load modal div content
source("./modalDivs.R")

# intensity_cols = colorRampPalette(c("black","orange","red"))

# rename highchart donwload btn
lang <- getOption("highcharter.lang")
lang$contextButtonTitle <- "Download"
options(highcharter.lang = lang)

ui <- fillPage(
  
  # use bootstrap 5
  suppressDependencies("bootstrap"),
  tags$head(HTML('
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <script src="www/utils.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    <title>QALY Shortfall Calculator</title>
                 ')),
  # enable shinyjs
  useShinyjs(),
  # load js scripts
  includeScript("./www/utils.js"),
  # load custom css
  includeCSS("style.css"),
  
  
  # LANDING PAGE --------
  HTML('
      <div id = "intro_page">
        <div class="split left-intro border-end border-dark">
            <div class="pos-low px-xl-5 px-lg-3 px-md-2 px-sm-0">
                <div class="intro-title text-start">
                  QALY SHORTFALL CALCULATOR
                </div>
                <div class="intro-subtitle  text-start my-3 lh-1">
                  
                </div>
                <div class = "row">
                    <img src="sheffield_logo.png" width="49%" alt="" class="flex-fill  col-6 col-xl-6 col-lg-6 col-md-6 col-sm-12 m-auto my-3">
                    <img src="york_logo.png" width="49%" alt="" class=" flex-fill  col-6 col-xl-6 col-lg-6 col-md-6 col-sm-12 m-auto my-3">
                    <img src="bresmed_logo_copy.png" width="65%" alt="" class=" col-8 col-xl-8 col-lg-8 col-md-8 col-sm-12 m-auto my-3">
                    
                </div>
            </div>
        </div>

        <div class="split right-intro">
            <div class="centered px-xl-5 px-lg-3 px-md-2 px-sm-0">
               
              <div class="display-5 mb-3">
                QALE reference values for England
              </div> 
              <ul id = "intro-list" class ="fs-4 lh-2 ">
                <li>NICE is considering to introduce severity weights for QALYs. </li>
                <li>The aim is to prioritise treatments for severe diseases.</li>
                <li>The approach is based on the proportional and absolute QALY shortfall. </li>
                <li>The shortfall refers to the difference in the quality-adjusted life expectancy (QALE) of a person with and a person without a particular disease.</li>
                <li>This app provides QALE reference values for the English general population. </li>
              </ul>
            <div id = "close_intro" class="btn btn-start fs-3  px-3 mt-1 shadow">Start <img src="arrow-right-solid.svg" width="15px"/></div>
            </div>
        </div>
    </div>
  '),
  
  
  div(
    class="main container-fluid",
      
    div(class = "row w-100 flex-nowrap ms-0",
    
    
    # INPUT PANEL ------------
    div(
      class = "left-main px-xl-5 px-lg-3 px-md-2 px-sm-1 pt-3 shadow border rounded-3  col-4 bg-white me-3",
      div(
        class = "h3 mb-5 mt-3 text-center fw-light",
        "QALY SHORTFALL CALCULATOR"
        ),
      # inputs
      div(
        class = "d-flex flex-column justify-content-center input-bar",
        
        # pat cohort age
        div(
          class = "control-label text-center mb-2  ",
          "Age of the patient population"
        ),
        sliderInput("start_age", NULL, min = 0, max = 99, value = 0, width = "100%"),
        
        div(
          class = "control-label text-center mb-2  mt-4",
          "% women in the patient population"
        ),
        sliderInput("sex_mix", NULL, min = 0, max = 100, value = 50, width = "100%"),
        
        # Remaining QALYs
        div(
          class = "control-label text-center mb-2  mt-4",
          HTML("Remaining (discounted)<br> QALYs of untreated"), 
          ),
        
      div(
        class = "d-flex flex-row align-items-center justify-content-center",
        # style = "white-space: nowrap !important;",
        actionButton("take_1","-", class = "btn-adj mx-3"), 
          autonumericInput(
            inputId = "remaining_qalys", 
            label = NULL, 
            minimumValue = 0, maximumValue = 49,decimalPlaces = 0,
            value = 30, 
            width = "40%"
            ),
        actionButton("add_1","+", class = "btn-adj mx-3"), 
      ),
      
      # discount rate
      div(
        class = "control-label text-center mb-2 mt-4",
        "Discount rate"
      ),
      div(
        class = "d-flex flex-row align-items-center justify-content-center",
        # style = "white-space: nowrap !important;",
        actionButton("take_1_disc","-", class = "btn-adj mx-3"), 
        autonumericInput(
          inputId = "disc_rate", 
          label = NULL, 
          minimumValue = 0, maximumValue = 10,
          decimalPlaces = 1,
          value = 1.5, currencySymbol = "%",
          width = "40%"
        ),
        actionButton("add_1_disc","+", class = "btn-adj mx-3"), 
      ),
      div(
        class = "mt-2 ms-5",
        checkboxInput("no_discount", "no discounting", value = F)
      )
      
      
      
      ),
      div(
        class = "credits small a",
        style = "cursor: pointer;",
        id = "credits",
        HTML("&copy; Schneider et al. 2021"),
          span(class="tooltiptext", id="credits_copied",
          "Paul Schneider, James Love-Koh, Simon McNamara, Tim Doran, Nils Gutacker. QALY Shortfall Calculator. 2021. https://r4scharr.shinyapps.io/shortfall/"
          )
      )
    
      
    ),
      
    
    # div(class="w-100 d-lg-none d-md-none d-none d-sm-block"),
      
    
  # RIGHT MAIN PANEL ----------  
      div(
        class = "col-8 flex-fill row justify-content-center justify-content-start main-right mt-5",
        
        
        
        # RESULTS CARD -----
            div(
              class = "col-6  res-card  flex-fill",
              #style = "height: 10%;",
              
              div(
                class = "shadow border rounded-3 bg-white px-xl-4 px-lg-4 px-md-2 px-sm-1 py-4 mb-3 fs-4",
              
              # card header
              div(
                class = "fs-4 mb-3 d-flex flex-wrap",
                "Remaining QALYS"
              ),
              
              # row 1
              div(
                class = "res row my-3 align-items-center justify-content-start ms-1",
                div(
                  class = "col-lg-9 col-md-8 col-sm-7",
                  "without the disease: "
                ),
                div(
                  class = "col-lg-3 col-md-4 col-sm-5",
                  div(
                    class = "badge bg-primary_col",
                    textOutput("qales_healthy_txt", inline = T) 
                  )
                ),
              ),
              
              # row 2
              div(
                class = "res row my-3 align-items-center justify-content-start ms-1",
                div(
                  class = "col-lg-9 col-md-8 col-sm-7",
                  "with the disease: "
                ),
                div(
                  class = "col-lg-3 col-md-4 col-sm-5",
                  div(
                    class = "badge bg-primary_col",
                    textOutput("qales_ill_txt", inline = T) 
                  )
                )
              ),
              
              # row 3
              div(
                class = "res row my-3 align-items-center justify-content-start ms-1",
                div(
                  class = "col-lg-9 col-md-8 col-sm-7",
                  "absolute shortfall: "
                  ),
                div(
                  class = "col-lg-3 col-md-4 col-sm-5",
                  div(
                    class = "badge bg-primary_col",
                    textOutput("abs_short_txt", inline = T) 
                  )
                ),
              ),
              
              # row 4
              div(
                class = "res row my-3 align-items-center justify-content-start ms-1",
                div(
                  class = "col-lg-9 col-md-8 col-sm-7",
                  "proportional shortfall: "
                ),
                div(
                  class = "col-lg-3 col-md-4 col-sm-5",
                  div(
                    class = "badge bg-primary_col",
                    textOutput("prop_short_txt", inline = T) 
                  )
                ),
              )
              
              ),
              
              # ACTIONS ---------
              div(
                class = "shadow border rounded-3  py-3 bg-white res-card flex-fill me-1 mb-3 px-3 py-4 d-flex justify-content-center flex-wrap",
                actionButton("info", "info",icon = icon("info-circle"), class = "btn-info-2 my-2", "data-bs-toggle"="modal", "data-bs-target"="#infoModal"),
                downloadButton("download", "download", icon = icon("download"),class = "btn-info-2 my-2"),
                actionButton("sources", "sources", icon = icon("book"), class = "btn-info-2 my-2", "data-bs-toggle"="modal", "data-bs-target"="#sourcesModal"),
                actionButton("code", "code", icon = icon("code"), class = "btn-info-2 my-2"),
                actionButton("contact", "contact", icon = icon("envelope"),class = "btn-info-2 my-2"),
                
                
              )
            ),
          
          
        
        # FIGURE BOXES -----
          div(
            class = "col-6 flex-fill",
            div(
              class = "shadow border rounded-3 p-3 bg-white res-card flex-fill me-1 mb-3 d-flex flex-column justify-content-center",
              div(
                class = "d-flex justify-content-center w-100 mt-2",
                div(
                  class = "me-2 mt-1  fs-5",
                  div(
                    style = "border-bottom: solid 2px #7cb5ec;",
                    "Select chart type:"
                  )
                  ),
                div(
                  class = "pt-1 flex-fill",
                  style = "width: 50%; max-width:300px;",
              selectizeInput(
                inputId = "chart_type", 
                label = NULL, width = "100%",
                selected = "bar",
                choices = list(
                  "Absolute shortfall" = "bar",
                  "Proportional shortfall" = "pie",
                  "Cumulative QALYs" = "cumulative_qalys",
                  "HRQoL by year" = "hrqol",
                  "Cumulative survival" = "S_cumulativ"
                )))
              ),
              highchartOutput("high_chart",  height = "400px")
            )
        )
         
    )
)
  
  
  
),


modalDivs()





)




server <- function(input, output, session){
 
  
  # add_1 and take_1 buttton logics -----
  observeEvent(input$add_1,{
    updateAutonumericInput(session, "remaining_qalys", value = input$remaining_qalys+1)
  })
  observeEvent(input$take_1,{
    updateAutonumericInput(session, "remaining_qalys", value = input$remaining_qalys-1)
  })
  
  
  # discount logic ---------
  # add_1 disc
  observeEvent(input$add_1_disc,{
    updateAutonumericInput(session, "disc_rate", value = input$disc_rate+0.1)
  })
  observeEvent(input$take_1_disc,{
    updateAutonumericInput(session, "disc_rate", value = input$disc_rate-0.1)
  })
  
  # no discount checkbox
  observeEvent(input$no_discount,{
    if(input$no_discount){
      disable("disc_rate")
      disable("add_1_disc")
      disable("take_1_disc")
      updateAutonumericInput(session, "disc_rate", value = 0)
    } else {
      enable("disc_rate")
      enable("add_1_disc")
      enable("take_1_disc")
      updateAutonumericInput(session, "disc_rate", value = 1.5)
    }
  })
  
  
  
  # reset remaining LE based on start age -----
  observeEvent(input$start_age,{
    
    max_le = 100-(input$start_age)
    
    if(input$remaining_qalys > max_le){
      updateAutonumericInput(session, "remaining_qalys", value = max_le, options = list(maximumValue = max_le))
    } else {
      updateAutonumericInput(session, "remaining_qalys", options = list(maximumValue = max_le-1))
    }
    
  })
  
  
  
  
  
  
  # REACTIVE DATA -----------
  dat = reactiveValues()
  
  observe({
    
    dat$res = compQale(
      ons_df = ref_df, 
      prop_female = input$sex_mix/100, 
      start_age = input$start_age, 
      disc_rate = input$disc_rate/100  
      )
    
    dat$shortfall_abs = dat$res$Qx[1] - input$remaining_qalys
    
    dat$shortfall_prop = dat$shortfall_abs / dat$res$Qx[1]
    
  })
  
  
  
  # TEXT OUTPUTS ---------
  output$qales_healthy_txt = renderText({round(dat$res$Qx[1],2)})
  output$qales_ill_txt = renderText({input$remaining_qalys})
  output$abs_short_txt = renderText({round(dat$shortfall_abs,2)})
  output$prop_short_txt = renderText({paste0(round(dat$shortfall_prop*100,1),"%")})
  
  
  
  # HIGH CHARTS ---------
  output$high_chart = renderHighchart({
    highchart_out() %>%
    hc_exporting(
      enabled = TRUE,
      chartOptions = list(
        chart = list(
          backgroundColor = "white"
          )
      ),
      buttons = list(
        contextButton = list(
          symbol = "download",
          verticalAlign = "bottom",
          horizontalAlign = "left",
          #titleKey = "oinf",
#          menuItems = NULL,
          onclick = JS("function () {
                    this.exportChart();
                }")
        )
      )
    )
  })
  
  highchart_out = reactive({
    
    
    if(dat$shortfall_abs < 0){
      p_error = highchart() %>% 
        hc_title(
          text = "Error: QALYs must be lower with the disease.", 
          align = "center",
          x=-10, 
          verticalAlign = 'middle', 
          floating = "true", 
          style = list(
            fontSize = "16px",
            color = "#7cb5ec"
            )
          ) 
      return(p_error)
    }
    
    if(input$chart_type == "pie"){
      short_fall = data.frame(
        type = c("QALYs with disease", "% Shortfall"),
        percent = c(100 - dat$shortfall_prop*100, dat$shortfall_prop*100),
        col = c("green","gray")
      )
      
      shortfall_str = paste0(round(dat$shortfall_prop*100,1))
      shortfall_str = paste0("Proportional<br>QALY<br>shortfall:<br><b>",shortfall_str,"%</b>")
      
      p1 = highchart() %>% 
        hc_add_series(short_fall, "pie", hcaes(name = type, y = percent), name = "QALE", innerSize="80%") %>%
        hc_title(text = shortfall_str, align = "center",x=-10, verticalAlign = 'middle', floating = "true", style = list(fontSize = "16px")) %>%
        hc_chart(
          style = list(
            fontFamily = "Inter"
          )
        ) %>%
        hc_tooltip(
          valueDecimals = 1,
          valueSuffix = '%'
        ) %>%
        hc_colors(c("#7cb5ec","gray")) 
      
      
      return(p1)
    } 
    
    
    
    if(input$chart_type == "bar"){
      
      short_fall = data.frame(
        name = c("QALYs with disease","Absolute shortfall","QALYs without disease"),
        value = c(input$remaining_qalys,dat$shortfall_abs, max(dat$res$Qx[1])),
        color = c("#7cb5ec","#6d757d","#3e6386"),
        a = c(F,F,T)
      )
      
      shortfall_str = paste0(round(dat$shortfall_abs,2))
      shortfall_str = paste0("Absolute QALY shortfall:<b>",shortfall_str,"</b>")
      
      p1 = highchart() %>% 
        hc_add_series(
          data = short_fall, "waterfall", 
          pointPadding = "0",
          hcaes(
            name = name, 
            y = value, isSum=a,
            color = color
            ), 
          name = "QALYs"
          ) %>%
        hc_title(text = shortfall_str, align = "left",x=40,y=20,  verticalAlign = 'top', floating = "true", style = list(fontSize = "16px")) %>%
        hc_chart(
          style = list(
            fontFamily = "Inter"
          )
        ) %>%
        hc_tooltip(
          valueDecimals = 2
        ) %>%
        hc_xAxis(
          categories = short_fall$name
          
                 )%>%
        hc_boost(enabled = FALSE)#%>%
         #hc_colors(c("red","#7cb5ec","red"))
      
      return(p1)
    } 
    
    
    disc_str = input$disc_rate > 0
    
    
    if(input$chart_type == "cumulative_qalys"){
      title = round(max(dat$res$Qx[1]),2)
      title = paste0("QALYs without the disease: <b>",title,"</b>",ifelse(disc_str,"(discounted)",""))  
      ytitle = "Cumulative QALYs"
    }
    if(input$chart_type == "hrqol"){
      title = paste0("HRQoL over the lifecourse", ifelse(disc_str,"(undiscounted)",""))
      ytitle = "EQ-5D score"
    }
    if(input$chart_type == "S_cumulativ"){
      title = paste0("Cumulative survival")
      ytitle = "S(t)"
    }
    
    
    
    
    y_max = max(dat$res$Qx[1])
    y_max = ifelse(y_max>50, 80, ifelse(y_max > 30, 50, 30))
    
    plot_df = data.frame(
      age = dat$res$age,
      var = dat$res[,input$chart_type]
    )
    
    
    highchart(
      hc_opts = list(),
      theme = getOption("highcharter.theme"),
      type = "chart",
      width = NULL,
      height = NULL,
      elementId = NULL,
      google_fonts = getOption("highcharter.google_fonts")
    ) %>%
      hc_add_series(
        plot_df, type = "area", 
        name = "Shortfall", color = "#7cb5ec", 
        hcaes(x = "age", y= "var"),
        tooltip = list(enabled = FALSE),
        fast = T) %>%
      
      hc_title(
        text = title,
        y = 60, x=-50,
        
        style = list(
          fontSize = "16px"
            )
        ) %>%
      
      
      hc_plotOptions(
        line = list(
          marker = list(
            enabled = "false",
            fillColor = "transparent",
            width = 0,
            height = 0,
            enabledThreshold = 99,
            radius = 1
          )
        ),
        series = list(
          tooltip = list(
            enabled = TRUE,
            followPointer = "true",
            fillColor = "transparent"
          )
        ),
        area = list(
          states = list(
            hover = list(
              enabled = TRUE
            )
          ),
          marker = list(
            enabled = FALSE,
            fillColor = "blue",
            width = 1,
            height = 1,
            enabledThreshold = 10,
            radius = 1
          )
        )
      ) %>%
      hc_xAxis(
        title = list(text = "Age"),
        gridLineColor= 'lightgray',
        gridLineWidth= 1,
        gridLineDashStyle = "Dot",
        tickLength= 10,
        tickWidth= 2,
        tickmarkPlacement= 'between'
        ) %>% 
      hc_yAxis(
        title = list(text = ytitle)
        #, max = y_max
      ) %>% 
      hc_tooltip(
        enabled = TRUE, 
        valueDecimals = 2,
        pointFormat = '{point.y} ',
        valueSuffix = ' '
      ) %>%
      hc_chart(
        style = list(
          fontFamily = "Inter"
        )
      ) %>%
      hc_legend(
        enabled = F
        )

      
      
  })
 
  

  # download handler ------
  output$download <- downloadHandler(
    filename = function() {
      paste("shortfall-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      
      download_data = data.frame(
        parameter = c(
          "patient age",
          "% female",
          "discount rate",
          "QALYs without disease",
          "QALYs with disease",
          "absolute shortfall",
          "proportional shortfall"
          ),
        value = round(c(
          input$start_age,
          input$sex_mix,
          input$disc_rate,
          dat$res$Qx[1],
          input$remaining_qalys,
          dat$shortfall_abs,
          dat$shortfall_prop
        ),2)
      )
      
      write.csv(download_data, file, row.names = F)
      
    }
  )
  

}


shinyApp(ui, server)