library(XML)
library(httr)
library(tau)
library(tm)
library(stringr)

seeds = c("Tyre", "Mecca", "Saracens", "Palestine", "Jordan", 
          "House of Darkness", "Lebanon", "The River Next To Nisibis", "Greece", "Castle of the Theodosiani")

person_seeds = c("Theodosios, 20th year Vararanes", "Theophano, the Athenian", "Solomon, general of Libya",
                 "Romulus, founder of Rome", "Porphyrios, a Tyrian", "Rufus, protostrator of Opsikon", 
                 "Phoenicians", "Moors", "Michael, presbyter of the Apostolic See", "Mesopotamians")



a = readLines("./Chronicle_text.txt")
a = iconv(enc2utf8(a), sub="byte")
t = paste(a, collapse = " ")
t = gsub("[^-A-Za-z .,;?!()]", " ", t)
t = gsub("[ ]{2,}", " ", t)

dict = character(0)
## Define a function that will return the unique set of words preceeding the seeds
get_patterns = function(seeds){
  for (x in 1:length(seeds)){
    print(paste(x, " pattern loop"))
    m = gregexpr(paste(" ([a-z]+ )+(?=",seeds[x],"[^a-z])", sep=""), t, perl = T)
    dict = c(dict, regmatches(t, m)[[1]])
  }
  return(unique(dict))
}
dict = get_patterns(seeds)
dict

## test = trimws(dict, which = "both")  %in% stopwords(kind = "en")
## can now do dict = dict[!test] -- which removes all stopwords, should this be fed into get_occurrences??
## dict = dict[!test]

new_subs = character(0)
get_occurrences = function(dict){
  for (x in 1:length(dict)){
    print(paste(x, " occurrence loop"))
    m = gregexpr(paste("(?<=", dict[x], ")([A-Z][a-z]+[ ]*)+", sep = ""), t, perl = T)
    new_subs = c(new_subs, regmatches(t, m)[[1]])
  }
  return(unique(new_subs))
}

new_subs = get_occurrences(dict)
new_subs



## Master function code below
master_dictionary = character(0)
dict = character(0)

master_function = function(seeds, n){
  i = 0
  while (i < n){
    dict = get_patterns(seeds)
    new = get_occurrences(dict)
    seeds = trimws(new, which = "right")
    master_dictionary = c(master_dictionary, trimws(new, which = "right"))
    i = length(master_dictionary)
  }
return(master_dictionary)
}

master_dictionary = master_function(seeds = seeds, n = 3000)
master_dictionary
## two iterations == 4925 UNIQUE locations




base_url = "http://vocabsservices.getty.edu/TGNService.asmx/TGNGetTermMatch?placetypeid=&nationid=Asia&name="

## make data frame containing unique names of master_dictionary
## run below for-loop 3 times: nationid = Africa, Asia, Europe
## add subjectID to dataframe, by the end, most entries should have a subject ID. If they dont -- not a place

place_subject_id1 = character(length(master_dictionary))
place_subject_id2 = character(length(master_dictionary))
place_subject_id3 = character(length(master_dictionary))

## this returns the subject_id of each place in master_dictionary, provided it's in the getty database
for (j in 1:length(master_dictionary)) {
  url = URLencode(paste(base_url, master_dictionary[j], sep=""))
  print(j)
  
  try({
    d = read_xml(url)
    ns = xml_find_all(x=d, xpath="//Subject_ID")
    if (length(ns) > 0) {
      place_subject_id2[j] = paste(sapply(ns, FUN=xml_text), collapse = "; ")
    }
  }, silent=T)
}


sum(place_subject_id1 != "")
sum(place_subject_id2 !="")
sum(place_subject_id3 != "")


id_df = data.frame(place = master_dictionary, africa_id = place_subject_id1, asia_id = place_subject_id2, europe_id = place_subject_id3, stringsAsFactors = F)

## find which places actually exist. If there are no getty entries in africa, asia, or europe -- we denote this
## with a 0 -- else 1

for (z in 1:nrow(id_df)){
  if (id_df$africa_id[z] == "" & id_df$asia_id[z] == "" & id_df$europe_id[z] == ""){
    id_df$is_place[z] = 0
  } else {id_df$is_place[z] = 1} 
}

write.csv(x = id_df, file = "locations.csv")

