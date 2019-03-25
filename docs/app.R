library(shiny)
library(waypointer)

section <- function(..., style = "text-align:center;"){
  stl <- paste("min-height:50vh;", style)
  div(
    style = stl,
    ...
  )
}

ui <- fluidPage(
  use_waypointer(),
  section(
    br(),
    br(),
    h1(
      code("waypointer")
    )
  ),
  section(
    uiOutput("waypoint1")
  ),
  section(
    uiOutput("waypoint2")
  ),
  section(
    h3("Animate plots"),
    plotOutput("waypoint3")
  ),
  section()
)

server <- function(input, output, session) {

  w1 <- Waypoint$new(
    "waypoint1",
    offset = "50%"
  )$
    start()

  w2 <- Waypoint$new(
    "waypoint2",
    offset = "50%"
  )$
    start()

  w3 <- Waypoint$new(
    "waypoint3",
    offset = "50%"
  )$
    start()

  output$waypoint1 <- renderUI({
    req(w1$get_triggered())
    
    if(w1$get_triggered())
      h3("Programatically trigger waypoints")
  })

  output$waypoint2 <- renderUI({
    req(w2$get_triggered())
    
    if(w2$get_triggered()){
      w2$animate()
      h3("Animate when triggered!")
    }
  })  

  output$waypoint3 <- renderPlot({
    req(w3$get_triggered())
    
    if(w3$get_triggered()){
      w3$animate()
      hist(runif(100))
    }
  })  

}

shinyApp(ui, server)