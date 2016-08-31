outcome <- read.csv("data/outcome-of-care-measures.csv", colClasses = "character")
head(outcome)
outcome[, 11] <- as.numeric(outcome[, 11])
hist(outcome[, 11])

best <- function(state, outcome, 
                 reverse = FALSE, 
                 range = 1:1, 
                 data_source = "data/outcome-of-care-measures.csv") {
    
    if (class(data_source) == "character"){
        ## Read outcome data
        outcome_data <- read.csv(data_source, colClasses = "character")
    }
    else{
        outcome_data <- data_source
    }
    # To easily index the dataframe
    indexes_dict = list("heart attack" = 11, 
                        "heart failure" = 17, 
                        "pneumonia" = 23)
    
    ## Check that state and outcome are valid
    if (!outcome %in% c("heart attack", "heart failure", "pneumonia")){
        stop("invalid outcome")
    }
    if (!state %in% unique(outcome_data[["State"]])){
        stop("invalid state") 
    }
    
    ## Return hospital name in that state with lowest 30-day death
    ## rate
    state_selector <- (outcome_data["State"] == state)

    outcome_values <- as.numeric(outcome_data[ ,indexes_dict[[outcome]]])
    selected_values <- complete.cases(outcome_values) & state_selector
    
    hospital_names <- outcome_data[["Hospital.Name"]][selected_values]
    hospital_values <- outcome_values[selected_values]
    
    ordered_indices <- order(hospital_values, hospital_names)
    
    if(reverse){
        return(hospital_names[ordered_indices[length(ordered_indices)]])
    }
    else{
        return(hospital_names[ordered_indices[range]])
    }
}

rankhospital <- function(state, 
                         outcome, 
                         num = "best", 
                         data_source = "data/outcome-of-care-measures.csv") {
    if(class(num) == "numeric" | class(num) == "integer"){
        # then return the n best hospitals
        return(best(state,outcome, range=as.integer(num):as.integer(num), 
                    data_source = data_source))
        
    }
    else{
        if(class(num) == "character"){
            # Check that the parameter is correct
            if (!num %in% c("best","worst")){
                stop("Unexpected value for num parameter")
            }
            else{
                if(num == "best"){
                    return(best(state,outcome,
                                data_source = data_source))
                }
                else{
                    return(best(state,outcome,TRUE,
                                data_source = data_source))
                }
            }
        }
        else{
            stop("Unexpected type for num parameter")
        }
    }
    #TODO : function should return NA if num > length
    #TODO : function must return a data frame 
}

rankall <- function(outcome, num = "best") {
    outcome_data <- read.csv("data/outcome-of-care-measures.csv", colClasses = "character")
    all_states <- unique(outcome_data[["State"]])
    results = vector(length = length(all_states))
    i <- 1
    for (state in all_states){
        results[i] <- rankhospital(state = state, 
                           outcome = outcome,
                           num = num,
                           data_source = outcome_data)
        i <- i+1
    }
    results
    data.frame("hospital"=results, "state"=all_states)
    # TODO : return results ordered by state?
}
