#' @title Check input
#'
#' @description A set of convenience functions for checking
#' objects/arguments to a function passed by a user.
#'
#' @param x object to be checked
#' @param name name of the object that will be print in the error
#' message.
#' @param check_length length of the object to be checked. Defaults to
#' \code{1}. Set to \code{0} in order to not check object length.
#' @param allow_NULL whether the object can be \code{NULL}.
#' If so, no checks are executed.
#' @param allow_values names of values allowed in a character vector.
#' Defaults to \code{NULL} (do not check).
#' @param check_names names of entries allowed in a list. Defaults to
#' \code{NULL} (do not check).
#' @param all_objects whether all entries in \code{check_names} must be
#' present. Defaults to \code{FALSE}.
#' @param allow_other whether additional entries then the specified in
#' \code{check_names} might be present
#' @param lower lower bound of allowed values.
#' Defaults to \code{-Inf} (do not check).
#' @param upper upper bound of allowed values.
#' Defaults to \code{Inf} (do not check).
#' @param allow_bound whether the values at the boundary are allowed.
#' Defaults to \code{TRUE}.
#' @param call string to be placed as a prefix to the error call.
#'
#' @examples
#' # check whether the object is logical
#' check_bool(TRUE, name = "input")
#'
#' # will throw an error on any other type
#' \dontrun{
#'   check_bool("TRUE", name = "input")
#' }
#'
#' @return returns \code{NULL}, called for the input check.
#'
#' @name check_input
#' @export check_bool
#' @export check_char
#' @export check_int
#' @export check_real
#' @export check_list

#' @rdname check_input
check_bool   <- function(x, name, check_length = 1, allow_NULL = FALSE, call = ""){

  if(is.null(x)){
    if(allow_NULL){
      return()
    }else{
      stop(paste0(call, "The '", name, "' argument cannot be NULL."), call. = FALSE)
    }
  }

  if(!is.logical(x) | !is.vector(x))
    stop(paste0(call, "The '", name, "' argument must be a logical vector."), call. = FALSE)

  if(check_length != 0  && length(x) != check_length)
    stop(paste0(call, "The '", name, "' argument must have length '", check_length, "'."), call. = FALSE)

  return()
}

#' @rdname check_input
check_char   <- function(x, name, check_length = 1, allow_values = NULL, allow_NULL = FALSE, call = ""){

  if(is.null(x)){
    if(allow_NULL){
      return()
    }else{
      stop(paste0(call, "The '", name, "' argument cannot be NULL."), call. = FALSE)
    }
  }

  if(!is.character(x) | !is.vector(x))
    stop(paste0(call, "The '", name, "' argument must be a character vector."), call. = FALSE)

  if(check_length != 0 && length(x) != check_length)
    stop(paste0(call, "The '", name, "' argument must have length '", check_length, "'."), call. = FALSE)

  if(!is.null(allow_values) && any(!x %in% allow_values))
    stop(paste0(call, "The '", paste0(x[!x %in% allow_values], collapse = "', '") ,"' values are not recognized by the '", name, "' argument."), call. = FALSE)

  return()
}

#' @rdname check_input
check_real   <- function(x, name, lower = -Inf, upper = Inf, allow_bound = TRUE, check_length = 1, allow_NULL = FALSE, call = ""){

  if(is.null(x)){
    if(allow_NULL){
      return()
    }else{
      stop(paste0(call, "The '", name, "' argument cannot be NULL."), call. = FALSE)
    }
  }

  if(!is.numeric(x) | !is.vector(x))
    stop(paste0(call, "The '", name, "' argument must be a numeric vector."), call. = FALSE)

  if(!is.infinite(lower)){
    if(!allow_bound){
      if(any(x <= lower))
        stop(paste0(call, "The '", name ,"' must be higher than ", lower,"."), call. = FALSE)
    }else{
      if(any(x < lower))
        stop(paste0(call, "The '", name ,"' must be equal or higher than ", lower,"."), call. = FALSE)
    }
  }

  if(!is.infinite(upper)){
    if(!allow_bound){
      if(any(x >= upper))
        stop(paste0(call, "The '", name ,"' must be lower than ", upper,"."), call. = FALSE)
    }else{
      if(any(x > upper))
        stop(paste0(call, "The '", name ,"' must be equal or lower than ", upper,"."), call. = FALSE)
    }
  }

  if(check_length != 0 && length(x) != check_length)
    stop(paste0(call, "The '", name, "' argument must have length '", check_length, "'."), call. = FALSE)

  return()
}

#' @rdname check_input
check_int    <- function(x, name, lower = -Inf, upper = Inf, allow_bound = TRUE, check_length = 1, allow_NULL = FALSE, call = ""){

  if(is.null(x)){
    if(allow_NULL){
      return()
    }else{
      stop(paste0(call, "The '", name, "' argument cannot be NULL."), call. = FALSE)
    }
  }

  check_real(x, name, lower, upper, allow_bound, check_length, allow_NULL)

  if(!all(.is.wholenumber(x)))
    stop(paste0(call, "The '", name ,"' argument must be an integer vector."), call. = FALSE)

  return()
}

#' @rdname check_input
check_list   <- function(x, name, check_length = 0, check_names = NULL, all_objects = FALSE, allow_other = FALSE, allow_NULL = FALSE, call = ""){

  if(is.null(x)){
    if(allow_NULL){
      return()
    }else{
      stop(paste0(call, "The '", name, "' argument cannot be NULL."), call. = FALSE)
    }
  }

  if(!is.list(x))
    stop(paste0(call, "The '", name, "' argument must be a list."), call. = FALSE)

  if(check_length != 0 && length(x) != check_length)
    stop(paste0(call, "The '", name, "' argument must have length '", check_length, "'."), call. = FALSE)

  if(!is.null(check_names)){

    if(all_objects && any(!check_names %in% names(x)))
      stop(paste0(call, "The '", paste0(check_names[!check_names %in% names(x)], collapse = "', '") ,"' objects are missing in the '", name, "' argument."), call. = FALSE)

    if(!allow_other && any(!names(x) %in% check_names))
      stop(paste0(call, "The '", paste0(names(x)[!names(x) %in% check_names], collapse = "', '") ,"' objects are not recognized by the '", name, "' argument."), call. = FALSE)
  }

  return()
}

# helper functions
.is.wholenumber  <- function(x, tol = .Machine$double.eps^0.5){
  abs(x - round(x)) < tol
}
