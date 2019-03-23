# waypointer

Simple waypoints to shiny.

## Installation

``` r
# install.packages("remotes")
remotes::install_github("JohnCoene/waypointer")
```

## Example

Create a waypoint with `waypoint$new()`  passing _at least_ the id of the element to observe as `dom_id` (first argument). 

``` r
library(shiny)
library(waypointer)

ui <- fluidPage(
	use_waypointer(),
	div(
		"Scroll!", 
		style = "min-height:90vh"
	),
	verbatimTextOutput("result"),
	plotOutput("plot"),
	div(style = "min-height:90vh")
)

server <- function(input, output, session) {

	w <- Waypoint$
		new("plot", offset = "20%")$
		start()

	output$result <- renderPrint({
		w$get_direction()
	})

	output$plot <- renderPlot({

		req(w$get_direction())

		# show if scrolling down
		if(w$get_direction() == "down")
			hist(runif(100))
		else
			"" # hide if sccrolling up
	})

}

shinyApp(ui, server)
```

Note that in the above we use the `get_direction` method to get the direction in which the user is scrolling, _relative to_ the given `dom_id`. However if you provide an `id` when initialising the waypoint then you can use the traditional way of accessing callbacks: `input$id_direction`. The example below would then look like:

``` r
library(shiny)
library(waypointer)

ui <- fluidPage(
	use_waypointer(),
	div(
		"Scroll!", 
		style = "min-height:90vh"
	),
	verbatimTextOutput("result"),
	plotOutput("plot"),
	div(style = "min-height:90vh")
)

server <- function(input, output, session) {

	w <- Waypoint$
		new("plot", offset = "20%", id = "myWaypoint")$
		start()

	output$result <- renderPrint({
		w$get_direction()
	})

	output$plot <- renderPlot({

		req(input$myWaypoint_direction)

		# show if scrolling down
		if(input$myWaypoint_direction == "down")
			hist(runif(100))
		else
			"" # hide if sccrolling up
	})

}

shinyApp(ui, server)
```
