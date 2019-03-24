[![Travis build status](https://travis-ci.org/JohnCoene/waypointer.svg?branch=master)](https://travis-ci.org/JohnCoene/waypointer)

# waypointer

Simple animated waypoints for shiny.

- [waypointer](#waypointer)
  - [Installation](#installation)
  - [Guide](#guide)
  - [Methods](#methods)
  - [Arguments](#arguments)
  - [Examples](#examples)

## Installation

``` r
# install.packages("remotes")
remotes::install_github("JohnCoene/waypointer")
```

## Guide

1. Place `use_waypointer()` anywhere in your ui.
2. Create a waypoint with `new` method, giving it _at least_ the id of the element to watch.
3. Start the waypoint with the `start` method.
4. Watch the waypoint with the `get_direction` method.

## Methods

Note that the `get_*` family of methods return character vectors and not the waypoint, unlike others.

1. `new` - create a waypoint.
2. `start` - start watching the waypoint.
3. `enable` - enable the waypoint (enabled by default)
4. `disable` - disable the waypoint.
5. `destroy` - destroy the waypoint.
6. `animate` - animate the waypoint.
7. `get_direction` - returns the direction in which the user scrolls passed the waypoint (`up` or `down`) 
8. `get_triggered` - returns `TRUE` if the waypoint has been triggered previously, and `FALSE` otherwise.

## Arguments

All the arguments are passed to the `new` method, at the expection of `animation` which can _also_ be passed to the `animate` method.

- `dom_id` - Id of element to watch. 
- `animate` - Set to `TRUE` to automatically animate when the waypoint is triggered.
- `animation` - Name of animation, defaults to `shake`.
- `offset` - By default, the handler is triggered when the top of an element hits the top of the viewport. The offset changes the location of that trigger point.
- `horizontal` - When horizontal is set to true, all of this changes to the horizontal axis and the `get_direction` method will return `left` or `right`.
- `id` - Id of waypoint. When used you can replace the `get_*` family of methods to traditional shiny inputs, e.g. if the `id` of the waypoint is set to `myInput` then you can obtain the `direction` in your shiny server with `input$myInput_direction`.

## Examples

Create a waypoint with `waypoint$new()`  passing _at least_ the id of the element to observe as `dom_id` (first argument). Note that technically the `get_*` family of methods are `input`s, you therefore may need to use `shiny::req` where needed (see below).

``` r
library(shiny)
library(waypointer)

ui <- fluidPage(
	use_waypointer(),
	div(
		h1("Scroll down"), 
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
		h1("Scroll down"), 
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

You can also animate the waypoint, setting `animate` to `TRUE` will automatically animate the waypoint when is triggered.

```r
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
		new("plot", offset = "20%", animate = TRUE)$
		start()

	output$result <- renderPrint({
		w$get_direction()
	})

	output$plot <- renderPlot({

		req(w$get_direction())

		if(w$get_direction() == "down")
			hist(runif(100))
    else
			""
	})

}

shinyApp(ui, server)
```

Otherwise you may use the `animate` method to manually trigger the animation.

```r
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

		hist(runif(100))
    w$animate()
	})

}

shinyApp(ui, server)
```