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
			tags$script(src = "waypointer-assets/scrolly.min.js"),
			tags$script(src = "waypointer-assets/custom.js")
		)
	)
}

#' Waypoint
#' 
#' A waypoint object to track.
#' 
#' @section Methods:
#' \itemize{
#'   \item{\code{new}: Instantiates a new waypoint, arguements can be found at \code{\link{.init}}}	
#'   \item{\code{start}: Starts monitoring a waypoint.}	
#'   \item{\code{destroy}: Destroy a waypoint.}	
#'   \item{\code{enable}: Enable a waypoint.}	
#'   \item{\code{disable}: Disable awaypoint.}	
#'   \item{\code{get_direction}: Get the direction of the scroll.}	
#'   \item{\code{get_next}: Get the next waypoint.}	
#'   \item{\code{get_previous}: Get the previous waypoint.}	
#' }
#' 
#' @examples
#' library(shiny)
#' 
#' 
#' ui <- fluidPage(
#' 	use_waypointer(),
#' 	div(
#' 		"Scroll!", 
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
#' 
#' @name waypoints
#' @export
Waypoint <- R6::R6Class(
	"Waypoint",
	public = list(
		initialize = function(dom_id, offset = NULL, horizontal = FALSE, id = NULL){

			.init(self, dom_id, offset, horizontal, id)

		},
		start = function(){
			
			session <- .get_session()

			opts <- list(
				id = private$.id,
				dom_id = private$.dom_id,
				offset = private$.offset
			)
			session$sendCustomMessage("waypoint-start", opts)
			invisible(self)
		},
		destroy = function(){
			session <- .get_session()
			session$sendCustomMessage("waypoint-destroy", list(id = private$.id))
			invisible(self)
		},
		enable = function(){
			session <- .get_session()
			session$sendCustomMessage("waypoint-enable", list(id = private$.id))
			invisible(self)
		},
		disable = function(){
			session <- .get_session()
			session$sendCustomMessage("waypoint-disable", list(id = private$.id))
			invisible(self)
		},
		get_direction = function(){
			.get_callback(private$.id, "direction")
		},
		get_previous = function(){
			.get_callback(private$.id, "previous")
		},
		get_next = function(){
			.get_callback(private$.id, "next")
		}
	),
	active = list(
		id = function(id){
			if(missing(id))
				missing(id)
			else
				private$.id <- id
		},
		dom_id = function(dom_id){
			if(missing(dom_id))
				missing("missing dom_id")
			else
				private$.dom_id <- dom_id
		},
		offset = function(offset){
			if(missing(offset))
				missing("missing offset")
			else
				private$.offset <- offset
		},
		horizontal = function(horizontal){
			if(missing(horizontal))
				missing("missing horizontal")
			else
				private$.horizontal <- horizontal
		}
	),
	private = list(
		.id = NULL,
		.dom_id = NULL,
		.offset = 0L,
		.horizontal = FALSE
	)
)
