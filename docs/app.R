library(shiny)
library(waypointer)
library(fullPage)

options <- list(
  sectionsColor = c('#FFF07C', '#E2FCEF', '#FFE2D1', '#ECEBE4', '#C4E7D4'),
  parallax = TRUE,
  autoScrolling = FALSE
)

ui <- fullPage(
  menu = c("waypointer" = "link1",
           "Trigger" = "link2",
           "Animations" = "section3",
           "Plots" = "section4",
           "Install" = "section5"),
  opts = options,
  tags$head(
    tags$link(
      href = "https://fonts.googleapis.com/css?family=Montserrat",
      rel = "stylesheet"
    )
  ),
  use_waypointer(),
  tags$style("*{font-family: 'Montserrat', sans-serif;}"),
  fullSection(
    center = TRUE,
    menu = "link1",
    fullContainer(
      center = TRUE,
      h1("waypointer"),
      br(),
      br(),
      p("Simple animated waypoints for Shiny")
    )
  ),
  fullSection(
    menu = "link2",
    fullContainer(
      uiOutput("waypoint1")
    )
  ),
  fullSection(
    menu = "section3",
    center = TRUE,
    fullContainer(
      fullRow(
        fullColumn(
          uiOutput("waypoint2")
        ),
        fullColumn(
          verbatimTextOutput("direct")
        )
      )
    )
  ),
  fullSection(
    menu = "section4",
    center = TRUE,
    h2("Animate plots"),
    br(),
    plotOutput("waypoint3")
  ),
  fullSection(
    menu = "section5",
    center = TRUE,
    fullContainer(
      br(),
      h2("Install"),
      br(),
      code("remotes::install_github('RinteRface/waypointer')"),
      br(),
      br(),
      br(),
      tags$a(
        id = "code",
        icon("code"),
        href = "https://github.com/RinteRface/waypointer",
        class = "fa-7x"
      )
    )
  )
)

server <- function(input, output, session) {

  w1 <- Waypoint$new(
    "waypoint1",
    offset = "50%"
  )$
    start()

  w2 <- Waypoint$new(
    "waypoint2",
    offset = "50%",
    animation = "fadeInLeft"
  )$
    start()

  w3 <- Waypoint$new(
    "waypoint3",
    offset = "50%",
    animation = "fadeInUp"
  )$
    start()

  output$waypoint1 <- renderUI({
    req(w1$get_triggered())
    
    if(w1$get_triggered())
      h2("Programatically trigger waypoints")
  })

  output$waypoint2 <- renderUI({
    req(w2$get_triggered())
    
    if(w2$get_triggered()){
      w2$animate()
      h3("Animate when triggered!")
    }
  })

  output$direct <- renderPrint({
    w2$get_direction()
  })

  output$waypoint3 <- renderPlot({
    req(w3$get_triggered())
    
    if(w3$get_triggered()){
      w3$animate()
      hist(runif(100))
    }
  }, bg = "transparent")

}

shinyApp(ui, server)