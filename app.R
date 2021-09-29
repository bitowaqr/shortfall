# shortfall app


library(shiny)
library(shinyjs)
library(shinyWidgets)
library(highcharter)
library(dplyr)

ref_df = read.csv("./ref_df.csv")

compQale = function(df, prop_female = 0.5, start_age = 50, disc_rate = 0.035){
  df = df[df$age >= start_age,]
  df = df[order(df$age),]
  df_female = df[df$sex == "female",c("age","cw","lx","dx","mx")]
  df_male = df[df$sex == "male",c("age","cw","lx","dx","mx")]
  
  df_comp = data.frame(
    age = df_female$age,
    cw = (1-prop_female) * df_male$cw  + prop_female * df_female$cw,
    lx = (1-prop_female) * df_male$lx  + prop_female * df_female$lx,
    dx = (1-prop_female) * df_male$dx  + prop_female * df_female$dx,
    mx = (1-prop_female) * df_male$mx  + prop_female * df_female$mx
  )
  
  # person years in year i
  df_comp$Lx = NA
  for(i in 2:nrow(df_comp)){
    df_comp$Lx[i-1] = df_comp$lx[i] + (0.5 * df_comp$dx[i-1])
  }
  df_comp$Lx[nrow(df_comp)] = (df_comp$lx[nrow(df_comp)]-df_comp$dx[nrow(df_comp)]) + (0.5 * df_comp$dx[nrow(df_comp)])
  
  # person QALYs in year i
  df_comp$Yx = df_comp$cw * df_comp$Lx
  
  # apply discounting
  v_disc <- 1/(1+disc_rate)^(0:(length(df_comp$Yx)-1))
  df_comp$Yx = df_comp$Yx * v_disc
  
  # remaining person QALYs?
  df_comp$Nx = NA
  df_comp$Nx[nrow(df_comp)] = df_comp$Yx[nrow(df_comp)]
  for(i in nrow(df_comp):2){
    df_comp$Nx[i-1] = df_comp$Yx[i-1] + df_comp$Nx[i]
  }
  
  # Quality adjusted life expectancy 
  df_comp$Qx = df_comp$Nx / df_comp$lx
  
  q_factor = sum(df_comp$Yx) / df_comp$Qx[1]
  
  cw_by_year = df_comp$cw
  df_comp$qalys_by_year = df_comp$Yx/q_factor 
  df_comp$cumulative_qalys = cumsum(df_comp$qalys_by_year)
  
  # cumulative survival function
  df_comp$S = 1-df_comp$mx
  df_comp$S_cumulativ =  cumprod(df_comp$S)
  
  return(df_comp)
  
}

# intensity_cols = colorRampPalette(c("black","orange","red"))

# div(
#   class="spinner-border", role="status",
#   span(class="visually-hidden", "Loading...")
# )


ui <- fillPage(
  suppressDependencies("bootstrap"),
  tags$head(HTML('
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <script src="www/utils.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    <title>QALY Shortfall Calculator</title>
                 ')),
  
  useShinyjs(),
  includeCSS("style.css"),
  includeScript("./www/utils.js"),
  
  # INTRO --------
  HTML('
<div id = "intro_page">
        <div class="split left-intro border-end border-dark">
            <div class="pos-low px-xl-5 px-lg-3 px-md-2 px-sm-0">
                <div class="intro-title text-start">UK QALY SHORTFALL CALCULATOR</div>
                <div class="intro-subtitle  text-start mt-3">Subtitle</div>
                <div class = "row">
                    <img src="sheffield_logo.png" width="49%" alt="" class="flex-fill  col-6 col-xl-6 col-lg-6 col-md-6 col-sm-12 m-auto my-3">
                    <img src="york_logo.png" width="49%" alt="" class=" flex-fill  col-6 col-xl-6 col-lg-6 col-md-6 col-sm-12 m-auto my-3">
                    <img src="bresmed_logo_copy.png" width="65%" alt="" class=" col-8 col-xl-8 col-lg-8 col-md-8 col-sm-12 m-auto my-3">
                    
                </div>
            </div>
        </div>

        <div class="split right-intro">
            <div class="centered px-xl-5 px-lg-3 px-md-2 px-sm-0">
               <div class="display-5">Some text here</div>
                <p>
                    Lorem ipsum dolor sit amet consectetur adipisicing elit. Beatae natus repudiandae voluptatum excepturi eos voluptates sunt, architecto officia maiores mollitia nobis. Dolor praesentium vel tenetur voluptatum, et unde reprehenderit quae!
                </p>
                <div class="display-5 mb-3">Some text here</div> 
                <ul>
                    <li>This is an important point</li>
                    <li>This is an important point</li>
                    <li>This is an important point</li>
                </ul>
                <div id = "close_intro" class="btn btn-start py-2 px-3 mt-3 shadow">Start <img src="arrow-right-solid.svg" width="15px"/></div>
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
        "UK QALY SHORTFALL CALCULATOR"
        ),
      # inputs
      div(
        class = "d-flex flex-column justify-content-center input-bar",
        
        # pat cohort age
        div(
          class = "control-label text-center mb-2  ",
          "Age of the patient population"
        ),
        sliderInput("start_age", NULL, min = 0, max = 99, value = 75, width = "100%"),
        
        div(
          class = "control-label text-center mb-2  mt-4",
          "% Women in the patient population"
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
            value = 5, 
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
        class = "credits",
        HTML("&copy; credits 2021")
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
                downloadButton("download", "download", icon = icon("download"),class = "btn-info-2 my-2"),
                actionButton("info", "info",icon = icon("info-circle"), class = "btn-info-2 my-2", "data-bs-toggle"="modal", "data-bs-target"="#infoModal"),
                actionButton("sources", "sources", icon = icon("book"), class = "btn-info-2 my-2", "data-bs-toggle"="modal", "data-bs-target"="#sourcesModal"),
                actionButton("code", "code", icon = icon("code"), class = "btn-info-2 my-2"),
                actionButton("contact", "contact", icon = icon("envelope"),class = "btn-info-2 my-2"),
                
                
              ),
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
                  "HRQoL by year" = "cw",
                  "Cumulative survival" = "S_cumulativ"
                )))
              ),
              highchartOutput("high_chart",  height = "400px")
            )
            )
      
    )
)
  
  
  
),


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
          tags$li(class ="px-5","University College London Department of Epidemiology and Public Health; National Centre for Social Research (NatCen). Health Survey for England, 2017. UK Data Service (2021)"),
          tags$li(class ="px-5","University College London Department of Epidemiology and Public Health; National Centre for Social Research (NatCen). Health Survey for England, 2018. UK Data Service (2021)")
          ),
        div(
          class = "accent p",
          "Lifetables were taken from:"
        ),
        tags$li(class ="px-5","ONS: National Life Tables, United Kingdom, 1980-1982 to 2017-2019. 2020.", a(href = "https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/lifeexpectancies/datasets/nationallifetablesunitedkingdomreferencetables", "link")),
        
        
        # tableOutput("raw_data"),
      ),
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
    class="modal-dialog modal-dialog-scrollable",
    div(
      class = "modal-content",
      div(
        class="modal-header",
        div(
          class="modal-title text-center h5", 
          id="infoModalLabel",
          "very important information"
        )
      ),
      div(
        class = "p-3 m-auto",
        style = "overflow-y:scroll;",
        "Text"
      ),
      HTML('
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
      </div>')
    )
    
  )
)







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
      df = ref_df, 
      prop_female = input$sex_mix/100, 
      start_age = input$start_age, 
      disc_rate = input$disc_rate/100  
      )
    
    
    # # discount rate
    # disc_rate = input$disc_rate/100
    # v_disc <- 1/(1+disc_rate)^(0:100)
    # 
    # rf1_m = ref_df %>%
    #   filter(sex == "male") %>%
    #   filter(age >= input$start_age) 
    # 
    # 
    # discounted_qale_m = rf1_m$QALE * v_disc[1:nrow(rf1_m)]
    # rf1_m$QALE_cum = c(0, cumsum(discounted_qale_m[-length(discounted_qale_m)]))
    # 
    # rf1_f = ref_df %>%
    #   filter(sex == "female") %>%
    #   filter(age >= input$start_age) 
    # 
    # discounted_qale_f = rf1_f$QALE * v_disc[1:nrow(rf1_f)]
    # 
    # rf1_f$QALE_cum = c(0, cumsum(discounted_qale_f[-length(discounted_qale_f)]))
    # 
    # dat$rf1 = data.frame(
    #   age = rf1_m$age,
    #   QALE_cum = (rf1_f$QALE_cum * (input$sex_mix/100)  + rf1_m$QALE_cum * (1- (input$sex_mix/100)))
    # )
    
    # if(input$auto_survival){
    #   nearest_approx =  dat$rf1$age[which.min(abs(input$remaining_qalys - dat$rf1$QALE_cum))]
    #   nearest_approx = nearest_approx  - input$start_age
    #   updateAutonumericInput(session, "remaining_survival", value = nearest_approx)  
    # }
    
    
    # dat$rf2 = data.frame(
    #   age = c(input$start_age, input$start_age+input$remaining_survival),
    #   QALE_cum = c(0, input$remaining_qalys)
    # )
    
    dat$shortfall_abs = dat$res$Qx[1] - input$remaining_qalys
    
    dat$shortfall_prop = dat$shortfall_abs / dat$res$Qx[1]
    
  })
  
  
  
  # TEXT OUTPUTS ---------
  output$qales_healthy_txt = renderText({round(dat$res$Qx[1],2)})
  output$qales_ill_txt = renderText({input$remaining_qalys})
  output$abs_short_txt = renderText({round(dat$shortfall_abs,2)})
  output$prop_short_txt = renderText({paste0(round(dat$shortfall_prop*100,1),"%")})
  
  
  
  # LINE chart ---------
  output$high_chart = renderHighchart({
    
    
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
    if(input$chart_type == "cw"){
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