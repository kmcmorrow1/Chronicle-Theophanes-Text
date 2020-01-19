# Chronicle-Theophanes-Text

Here is a text mining algorithm that attempts to detect the names and locations present in the "Chronicle of Theophanes" text. The text is incredibly extensive, and feautures many names/locations that are either anachronistic, or no longer exist. As such, it would be near-impossible to read through thousands of lines and perfectly record each occurrence of name and place.  

The algorithm is trained with a set of manually chosen "seeds" (these were picked at random from a list of pre-discovered entities from the text) but could realistically use any combination of names/locations from the corpus. 

My algorithm discovered 4,925 unique names/locations (this is the "locations.csv" file.) The manually coded list of named entities contained only 1,894 unique names/locations. Out of curiosity, I attempted to rerun the process, this time forgoing my algorithm for the "OpenNLP" package in R. OpenNLP is a machine learning based toolkit for natural language processing in R. OpenNLP, while quicker than my algorithm, only disocered 1,572 named entities.   
