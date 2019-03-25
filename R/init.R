#' Initialise
#' 
#' Initialise a waypoint
#' 
#' @param self A \code{waypoint} object.
#' @param dom_id Id of element to attach waypoint to.
#' @param offset Vertical offset, an integer (pixels) or a percentage passed as a string e.g. \code{"10"}.
#' @param id Id of waypoint, see details.
#' @param horizontal Whether to apply waypoints of horizontal offset.
#' @param animate Whether to animate the anchor when the waypoint is triggered.
#' @param animation Animation to use, note that this can be overriden in the \code{animate} method.
#' 
#' @details If you do not provide an \code{id} then you will have to rely on the \code{get_*} family of
#' of methods to get the callbacks. If you do, you can still rely on the latter but also may access 
#' the callbacks the traditional way with `input$idName_direction`, `input$idName_next`, and 
#' `input$idName_previous`.
#' 
#' @section Animations:
#' \itemize{
#'   \item{\code{bounce}} 
#'   \item{\code{flash}} 
#'   \item{\code{wobble}} 
#'   \item{\code{bounceInLeft}} 
#'   \item{\code{bounceOutDown}} 
#'   \item{\code{fadeIn}} 
#'   \item{\code{fadeInLeftBig}} 
#'   \item{\code{fadeInUpBig}} 
#'   \item{\code{flipOutX}} 
#'   \item{\code{fadeOutLeft}} 
#'   \item{\code{fadeOutUp}} 
#'   \item{\code{rotateIn}} 
#'   \item{\code{rotateInUpRight}} 
#'   \item{\code{rotateOutUpLeft}} 
#'   \item{\code{rollIn}}
#'   \item{\code{zoomInLeft}} 
#'   \item{\code{zoomOutDown}} 
#'   \item{\code{slideInDown}} 
#'   \item{\code{slideOutDown}} 
#'   \item{\code{heartBeat}} 
#'   \item{\code{flash}} 
#'   \item{\code{headShake}} 
#'   \item{\code{jello}} 
#'   \item{\code{bounceInRight}} 
#'   \item{\code{bounceOutLeft}}  
#'   \item{\code{fadeInDown}} 
#'   \item{\code{fadeInRight}} 
#'   \item{\code{fadeOut}} 
#'   \item{\code{fadeOutLeftBig}} 
#'   \item{\code{fadeOutUpBig}} 
#'   \item{\code{flipOutY}} 
#'   \item{\code{rotateInDownLeft}} 
#'   \item{\code{rotateOut}} 
#'   \item{\code{rotateOutUpRight}} 
#'   \item{\code{rollOut}} 
#'   \item{\code{zoomInRight}} 
#'   \item{\code{zoomOutLeft}} 
#'   \item{\code{slideInLeft}}  
#'   \item{\code{slideOutLeft}} 
#'   \item{\code{pulse}} 
#'   \item{\code{swing}} 
#'   \item{\code{bounceIn}} 
#'   \item{\code{bounceInUp}} 
#'   \item{\code{bounceOutRight}} 
#'   \item{\code{fadeInDownBig}} 
#'   \item{\code{fadeInRightBig}} 
#'   \item{\code{fadeOutDown}} 
#'   \item{\code{fadeOutRight}} 
#'   \item{\code{flipInX}} 
#'   \item{\code{lightSpeedIn}} 
#'   \item{\code{rotateInDownRight	}}  
#'   \item{\code{rotateOutDownLeft}} 
#'   \item{\code{hinge}} 
#'   \item{\code{zoomIn}} 
#'   \item{\code{zoomInUp}} 
#'   \item{\code{zoomOutRight}} 
#'   \item{\code{slideInRight	}} 
#'   \item{\code{slideOutRight}} 
#'   \item{\code{rubberBand}} 
#'   \item{\code{tada}} 
#'   \item{\code{bounceInDown}} 
#'   \item{\code{bounceOut}} 
#'   \item{\code{bounceOutUp}}  
#'   \item{\code{fadeInLeft}} 
#'   \item{\code{fadeInUp}} 
#'   \item{\code{fadeOutDownBig}} 
#'   \item{\code{fadeOutRightBig}} 
#'   \item{\code{flipInY}} 
#'   \item{\code{lightSpeedOut}} 
#'   \item{\code{rotateInUpLeft}} 
#'   \item{\code{rotateOutDownRight}} 
#'   \item{\code{jackInTheBox}} 
#'   \item{\code{zoomInDown}} 
#'   \item{\code{zoomOut}} 
#'   \item{\code{zoomOutUp}}  
#'   \item{\code{slideInUp}}  
#'   \item{\code{slideOutUp}}  
#' }
#' 
#' @aliases .init
#' @name init
#' @export
.init <- function(self, dom_id, animate = FALSE, animation = "bounce", offset = NULL, horizontal = FALSE, id = NULL){
	
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
	self$must_animate <- animate
	self$animation <- animation
}