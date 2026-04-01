library(shiny)

ui <- tags$html(
  tags$head(
    tags$title("QALY Shortfall Calculator"),
    tags$style("
      html, body { margin: 0; padding: 0; height: 100%; overflow: hidden; }
      iframe { width: 100%; height: 100%; border: none; }
    ")
  ),
  tags$body(
    tags$iframe(src = "https://shortfallv2.vercel.app/")
  )
)

server <- function(input, output, session) {}

shinyApp(ui, server)
