#' Waypoints dependencies
#' 
#' Sources waypointer dependencies.
#' 
#' @details Place anywhere in your shiny UI. 
#' 
#' @import shiny
#' 
#' @seealso \code{\link{waypoints}}
#' 
#' @export
use_waypointer <- function() {
	singleton(
		tags$head(
			tags$script("window.wps = [];"),
      tags$script("window.trg = [];"),
      tags$link(href = "animate-assets/animate.min.css", rel = "stylesheet", type = "text/css"),
			tags$script(src = "waypointer-assets/scrolly.min.js"),
			tags$script(src = "waypointer-assets/custom.js")
		)
	)
}

#' Waypoint
#' 
#' A waypoint object to track.
#' 
#' @examples
#' library(shiny)
#' 
#' 
#' ui <- fluidPage(
#' 	use_waypointer(),
#' 	div(
#' 		h1("Scroll down"), 
#' 		style = "min-height:90vh"
#' 	),
#' 	verbatimTextOutput("result"),
#' 	plotOutput("plot"),
#' 	div(style = "min-height:90vh")
#' )
#' 
#' server <- function(input, output, session) {
#' 
#' 	w <- Waypoint$
#' 		new("plot", offset = "20%")$
#' 		start()
#' 
#' 	output$result <- renderPrint({
#' 		w$get_direction()
#' 	})
#' 
#' 	output$plot <- renderPlot({
#' 
#' 		req(w$get_direction())
#' 
#' 		if(w$get_direction() == "down")
#' 			hist(runif(100))
#' 		else
#' 			""
#' 	})
#' 
#' }
#' 
#' if(interactive()) shinyApp(ui, server)
#' @aliases waypointer Waypointer Waypoint
#' @name waypoints
#' @export
Waypoint <- R6::R6Class(
	"Waypoint",
#' @details Initialise
#' 
#' @param id Id of element to use as waypoint.
#' @param animate Whether to animate element when the waypoint is triggered.
#' @param animation Animation to use if \code{animate} is set.
#' @param offset Offset relative to viewport to trigger the waypoint.
#' @param horizontal Set to \code{TRUE} if using horizontally.
#' @param waypoint_id Id of waypoint, useful to get the input value.
#' @param start Whether to automatically start watching the waypoint.
	public = list(
		initialize = function(id, animate = FALSE, animation = "shake", offset = NULL, horizontal = FALSE, waypoint_id = NULL, start = TRUE){

			.init(self, id, animate, animation, offset, horizontal, waypoint_id)

      if(start)
        self$start()

      invisible(self)

		},
#' @details Start watching the waypoint.
		start = function(){
			
			session <- .get_session()

			opts <- list(
				id = private$.id,
				dom_id = private$.dom_id,
				offset = private$.offset,
        animate = private$.must_animate,
        animation = private$.animation
			)
			session$sendCustomMessage("waypoint-start", opts)
			invisible(self)
		},
#' @details Destroy the waypoint.
		destroy = function(){
			session <- .get_session()
			session$sendCustomMessage("waypoint-destroy", list(id = private$.id))
			invisible(self)
		},
#' @details Enable the waypoint.
		enable = function(){
			session <- .get_session()
			session$sendCustomMessage("waypoint-enable", list(id = private$.id))
			invisible(self)
		},
#' @details Disable the waypoint.
		disable = function(){
			session <- .get_session()
			session$sendCustomMessage("waypoint-disable", list(id = private$.id))
			invisible(self)
		},
#' @details Animate the waypoint.
		animate = function(animation = NULL){

      opts <- list(dom_id = private$.dom_id, animation = private$.animation)

      if(!is.null(animation))
        opts$animation <- animation

			session <- .get_session()
			session$sendCustomMessage("waypoint-animate", opts)
			invisible(self)
		},
#' @details Get direction in which user is scrolling past the waypoint
		get_direction = function(){
			.get_callback(private$.id, "direction")
		},
#' @details Whether user is scrolling up past the waypoint.
		going_up = function(){
			direction <- .get_callback(private$.id, "direction")

      if(is.null(direction))
        return(FALSE)
      
      direction == "up"
		},
#' @details Whether user is scrolling down past the waypoint.
		going_down = function(){
			direction <- .get_callback(private$.id, "direction")

      if(is.null(direction))
        return(FALSE)
      
      direction == "down"
		},
#' @details Whether waypoint has been triggered.
		get_triggered = function(){
      .get_callback(private$.id, "triggered")
		}
	),
	private = list(
		.id = NULL,
		.dom_id = NULL,
		.offset = 0L,
		.horizontal = FALSE,
    .must_animate = FALSE,
    .animation = "shake"
	)
)
