.onLoad <- function(libname, pkgname) {
  shiny::addResourcePath(
    "waypointer-assets",
    system.file("waypoint", package = "waypointer")
  )
  shiny::addResourcePath(
    "animate-assets",
    system.file("animate", package = "waypointer")
  )
}