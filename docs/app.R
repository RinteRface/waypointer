library(shiny)
library(waypointer)
library(fullPage)

options <- list(
  sectionsColor = c('#f2f2f2', '#4BBFC3', '#7BAABE'),
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
  use_waypointer(),
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
    h3("Animate plots"),
    plotOutput("waypoint3")
  ),
  fullSection(
    menu = "section5",
    center = TRUE,
    fullContainer(
      br(),
      br(),
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
  })

}

shinyApp(ui, server)