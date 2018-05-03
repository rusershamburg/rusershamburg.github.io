#!/usr/bin/Rscript

# !!! Note: this file is thought to be run by a remote worker 
# !!!       this will cause git pull and git push



#### options ###################################################################

# remote error handling

if ( !interactive() ){
  
  
  
  options(
    error = 
      function(){
        # get error message and traceback
        dump.frames()
        error_message   <- attr(last.dump, "error.message")
        error_file_name <- paste0("stats/error_", format(Sys.time(), "%Y-%m-%d__%H_%M_%S"), ".log")
        sink(error_file_name)
        traceback(3)
        sink()
        
        
        # send mail
        system(
          paste0(
            'cat "', error_file_name, '"', 
            ' | mail -s ',
            '"[ruh-script] Error: ', 
            gsub(pattern = '"', "'", error_message), ' -- ',  
            as.character(Sys.time()), '"',
            ' retep.meissner@gmail.com'
          )
        )
        
        q(save = "no")
      }
  )
  
  git_update = TRUE
  
}else{
  
  git_update = FALSE
  
}



#### packages ##################################################################

library(jsonlite)




#### functions #################################################################

sys_execute <- 
  function(cmd, arg){
    
    # execute command
    sys_out <- capture.output({
      sys2_res <- system2(command = cmd, args = arg)
    })
    
    # check for error and make function fail
    if ( sys2_res != 0 ){
      stop(sys_out)
    }
    
    # return
    invisible(
      list(
        res = sys2_res, out = sys_out)
      )
  }

add_to_repo_commit <- 
  function(x, append = FALSE, git_update = FALSE){
    
    # get name of object to save
    x_name  <- deparse(substitute(x))
    
    # get file name to store data in
    x_fname <- paste0("stats/", x_name, ".json")
    
    # write out data 
    if( append == TRUE ){
      write(x = x, file = x_fname, append = TRUE) 
    }else{
      writeLines(text = x, con = x_fname)
    }
    
    # stage for next commit
    if ( git_update ){
      res <- sys_execute("git", paste0("add ", x_fname))
    }else{
      res <- 0
    }
    
    # return
    invisible(res)
  }


# update git project
if(git_update){ 
  sys_execute("git", "pull") 
  sys_execute("git", "checkout master")
}






#### doing-duty-to-do ##########################################################


# data urls
meetup_group_data_url <- 
  paste(
    "https://api.meetup.com/2/groups?offset=0",
    "format=json",
    "group_id=17102372",
    "photo-host=public",
    "page=20",
    "radius=25.0",
    "fields=",
    "order=id",
    "desc=false",
    "sig_id=202955781",
    "sig=53f7a9722fc3e3d366b4bb656703c2abd229bb35",
    collapse = "&",
    sep = "&"
  )

meetup_event_data_url <- 
  paste(
    "https://api.meetup.com/Hamburg-R-User-Group/events?photo-host=public",
    "page=200",
    "sig_id=202955781",
    "status=past%2Cupcoming",
    "sig=fd0581fca87e3ecd47550a1c28cddfedddf6c1ac",
    collapse = "&",
    sep = "&"
  )

# parse data 
group_json <- 
  stream_in(
    con               = file(meetup_group_data_url), 
    simplifyDataFrame = TRUE
  )

event_json <- 
  stream_in(
    con               = file(meetup_event_data_url), 
    simplifyDataFrame = TRUE
  )

# extract data 
group_meta <- as.list(group_json$meta)
group_data <- as.list(group_json$results[[1]])


# - topics
topics <- group_data$topics[[1]]$name
topics <- toJSON( list( topics = topics ),pretty = TRUE)


# - description
description <- group_data$description
description <- toJSON( list( description = description ), pretty = TRUE)


# - rating
rating <- toJSON(list(rating = list(date = Sys.Date(), rating = group_data$rating) ))

# - memebers
members <- toJSON(list(members = list(date = Sys.Date(), count = group_data$members) ))


# - events
events       <- toJSON(event_json)

events_short <- event_json
  events_short$description   <- NULL
  events_short$visibility    <- NULL
  events_short$group         <- NULL
  events_short$link          <- NULL
  events_short$venue_name    <- events_short$venue$name
  events_short$venue_address <- events_short$venue$address_1
  events_short$venue_lat     <- events_short$venue$lat
  events_short$venue_lon     <- events_short$venue$lon
  events_short$venue         <- NULL
  events_short$duration_h    <- paste0(round(events_short$duration/1000/60/60), "h ", round(((events_short$duration/1000/60/60)%%1)*60), "min" )
events_short <- toJSON(events_short)


# write content to file
add_to_repo_commit(topics,                 git_update = git_update)
add_to_repo_commit(description,            git_update = git_update)
add_to_repo_commit(rating,  append = TRUE, git_update = git_update)
add_to_repo_commit(members, append = TRUE, git_update = git_update)
add_to_repo_commit(events,                 git_update = git_update)
add_to_repo_commit(events_short,           git_update = git_update)




# commit and push
if(git_update){ 
  sys_execute(
    "git", 
    paste0(
      'commit -m ', 
      '"data_update: ', as.character(Sys.time()),'"' 
    )
  ) 
  sys_execute("git", "push")
}


















