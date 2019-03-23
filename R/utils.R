# generate a random id
.random_id <- function() {
	letters <- LETTERS %>% 
		tolower() %>% 
		sample()

	numbers <- 1:20 %>% 
		sample() 

	paste0(letters, numbers, collapse = "")
}

# check if sessions is valid
.check_session <- function(x){
  if(is.null(x))
    stop("invalid session, run this function inside your Shiny server.", call. = FALSE)
}

# get shiny session
.get_session = function(){
  session <- shiny::getDefaultReactiveDomain()
  .check_session(session)
  return(session)
}

# get the input object
.get_input = function(){
  session <- .get_session()
  return(session$input)
}

# buiuld shiny input
.build_input <- function(...){
  v <- c(...)
  paste0(v, collapse = "_")
}

# get output
.get_callback <- function(...){
  input <- .get_input()
  get <- .build_input(...)
  input[[get]]
}