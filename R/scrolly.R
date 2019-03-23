#' Dependencies
#' 
#' Sources waypointer dependencies.
#' 
#' @details Place anywhere in your shiny UI. 
#' 
#' @import shiny
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
#' @export
Waypoint <- R6::R6Class(
	"Waypoint",
	public = list(
		initialize = function(dom_id, offset = NULL, id = NULL){

			.init(self, dom_id, offset, id)

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
		}
	),
	private = list(
		.id = NULL,
		.dom_id = NULL,
		.offset = 0L
	)
)