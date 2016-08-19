#--------
# Part 1
#--------
pollutantmean <- function(directory, pollutant, id = 1:332){
    all_vectors <- list()
    ## Accumulate all vectors and then convert to single vector
    ## (more efficient? :D)
    ## See also: list.files
    for (i in id){
        ## Get the file name
        fname <- file.path(directory, sprintf("%03d.csv",i))
        ## Get the data
        data <- read.csv(fname)
        vector_data <- data[[pollutant]]
        all_vectors[[i]] <- vector_data
    }
    mean( unlist(all_vectors),  na.rm = TRUE)
}

#--------
# Part 2
#--------
## For this one I try a different approach for the loading

## From http://stackoverflow.com/questions/5738831/r-plus-equals-and-plus-plus-equivalent-from-c-c-java-etc
inc <- function(x){
    eval.parent(substitute(x <- x + 1))
}
## Generate a vector with all the files
gen_file_names <- function(directory, id =  1:332){
    fnames <- vector(mode = "character", length = length(id))     
    i <- 1
    for (j in id){
        fnames[i] <-file.path(directory, sprintf("%03d.csv",j))
        inc(i)
    }
    # return
    fnames
}

# The actual function
complete <- function(directory, id = 1:332){
    fnames <- gen_file_names(directory, id)
    all_data <- lapply(fnames, read.csv)
    all_ccases <- lapply(all_data, complete.cases)
    all_sccases <- lapply(all_ccases, sum)
    result_df <- data.frame(id = id, nobs = unlist(all_sccases))
    # ALL complete cases sum(unlist(all_ccases))
    #return
    result_df
}

#--------
# Part 3
#--------
corr <- function(directory, threshold = 0){
    fnames <- gen_file_names(directory)
    all_data <- lapply(fnames, read.csv)
    
    # Complete cases
    all_ccases <- lapply(all_data, complete.cases)
    all_sccases <- lapply(all_ccases, sum)
    casesdf <- data.frame(id = id, nobs = unlist(all_sccases))
    
    # The new code
    thres_casesdf <- subset(casesdf, nobs > threshold)
    if(nrow(cases["id"]) == 0){
        return(vector(mode = "numeric")) 
    }
    else{
        interesting_ids <- thres_casesdf[["id"]]
        x <- vector(mode = "numeric", length = length(interesting_ids)) 
        j<-0
        for (i in interesting_ids){
            x[j]<-cor(all_data[[i]][["sulfate"]],all_data[[i]][["nitrate"]], use = "complete.obs")
            print(x)
            inc(j)
        }
            return(unlist(x))
    }
}

