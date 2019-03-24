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
#' @section Methods:
#' \itemize{
#'   \item{\code{new}: Instantiates a new waypoint, arguements can be found at \code{\link{.init}}}	
#'   \item{\code{start}: Starts monitoring a waypoint.}	
#'   \item{\code{destroy}: Destroy a waypoint.}	
#'   \item{\code{enable}: Enable a waypoint (enabled by default).}	
#'   \item{\code{disable}: Disable a waypoint.}	
#'   \item{\code{animate}: Animate a waypoint, accepts, optionally, an animation.}	
#'   \item{\code{get_direction}: Returns the direction in which the user scrolls passed the waypoint.}	
#'   \item{\code{get_previous}: eturns `TRUE` if the waypoint has been triggered previously, and `FALSE` otherwise.}	
#' }
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
	public = list(
		initialize = function(dom_id, animate = FALSE, animation = "shake", offset = NULL, horizontal = FALSE, id = NULL){

			.init(self, dom_id, animate, animation, offset, horizontal, id)

		},
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
		animate = function(animation = NULL){

      opts <- list(dom_id = private$.dom_id, animation = private$.animation)

      if(!is.null(animation))
        opts$animation <- animation

			session <- .get_session()
			session$sendCustomMessage("waypoint-animate", opts)
			invisible(self)
		},
		get_direction = function(){
			.get_callback(private$.id, "direction")
		},
		get_triggered = function(){
      .get_callback(private$.id, "triggered")
		}
	),
	active = list(
		id = function(id){
			if(missing(id))
				stop("missing id")
			else
				private$.id <- id
		},
		dom_id = function(dom_id){
			if(missing(dom_id))
				stop("missing dom_id")
			else
				private$.dom_id <- dom_id
		},
		offset = function(offset){
			if(missing(offset))
				stop("missing offset")
			else
				private$.offset <- offset
		},
		horizontal = function(horizontal){
			if(missing(horizontal))
				stop("missing horizontal")
			else
				private$.horizontal <- horizontal
		},
		must_animate = function(must_animate = FALSE){
			if(!is.logical(must_animate))
				stop("must_animate is not logical")
			else
				private$.must_animate <- must_animate
		},
		animation = function(animation){
			if(missing(animation))
				stop("missing animation")
			else
				private$.animation <- animation
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
