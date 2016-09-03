## Source code for the Programming Assignment 2 of 
## Coursera's R programming course (Data Science track)

## Defines a new type of matrix which is able to store
## its inverse.
makeCacheMatrix <- function(x = matrix()) {
    inv <- NULL
    
    set <- function(y) {
        x <<- y
        inv <<- NULL
    }
    
    get <- function() {
        x
    }
    
    setinverse <- function(inverse){ 
        inv <<- inverse
    }
    
    getinverse <- function() {
        inv
    }
    
    list(set = set, 
         get = get,
         setinverse = setinverse,
         getinverse = getinverse)
}


## Returns the inverse of a matrix generated with makeCacheMatrix.
## If the inverse was already performed, it returns the cached
## value.
cacheSolve <- function(x, ...) {
    ## Return a matrix that is the inverse of 'x'
    inverse <- x$getinverse()
    if (is.null(inverse)){
        message("Calculating inverse")
        inverse <- solve(x$get())
        x$setinverse(inverse)
    }
    else{
        message("Using cached inverse")
    }
    
    # return
    inverse
}

# A simple test
x <- matrix(data =runif(9, 0.0, 10), nrow =3, ncol = 3)
cm <- makeCacheMatrix(x)
cacheSolve(cm) # must calculate the inverse
cacheSolve(cm) # already cached inverse
cacheSolve(cm) # already cached inverse
x <- matrix(data =runif(9, 0.0, 10), nrow =3, ncol = 3)
cm$set(x)
cacheSolve(cm) # must calculate the inverse
cacheSolve(cm) # already cached inverse
