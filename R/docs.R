#' Initialise
#' 
#' Initialise a waypoint
#' 
#' @param self A \code{waypoint} object.
#' @param dom_id Id of element to attach waypoint to.
#' @param offset Vertical offset, an integer (pixels) or a percentage passed as a string e.g. \code{"10"}.
#' @param id Id of waypoint, see details.
#' @param horizontal Whether to apply waypoints of horizontal offset.
#' 
#' @details If you do not provide an \code{id} then you will have to rely on the \code{get_*} family of
#' of methods to get the callbacks. If you do, you can still rely on the latter but also may access 
#' the callbacks the traditional way with `input$idName_direction`, `input$idName_next`, and 
#' `input$idName_previous`.
#' 
#' @export
.init <- function(self, dom_id, offset = NULL, horizontal = FALSE, id = NULL){
	
	if(missing(dom_id))
		stop("missing dom_id", call. = FALSE)

	if(!is.null(offset))
		self$offset <- offset

	if(!is.null(id))
		self$id <- id
	else
		self$id <- .random_id()

	self$dom_id <- dom_id
	self$horizontal <- horizontal
}