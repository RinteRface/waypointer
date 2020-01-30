.onLoad <- function(libname, pkgname) {
  shiny::addResourcePath(
    "waypointer-assets",
    system.file("waypoint", package = "waypointer")
  )
  shiny::addResourcePath(
    "animate-assets",
    system.file("animate", package = "waypointer")
  )

  shiny::registerInputHandler("waypointer", function(data, ...) {
    jsonlite::fromJSON(jsonlite::toJSON(data, auto_unbox = TRUE))
  }, force = TRUE)
}