.onLoad <- function(libname, pkgname) {
  shiny::addResourcePath(
    "waypointer-assets",
    system.file("waypoint", package = "waypointer")
  )
}