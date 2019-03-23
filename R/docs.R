#' Initialise
#' 
#' Initialise a waypoint
#' 
#' @param self A \code{waypoint} object.
#' @param dom_id Id of element to attach waypoint to.
#' @param offset Vertical offset, an integer (pixels) or a percentage passed as a string e.g. \code{"10"}.
#' @param id Id of waypoint.
#' @param horizontal Whether to apply waypoints of horizontal offset.
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