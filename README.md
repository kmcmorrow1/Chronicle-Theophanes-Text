# Chronicle-Theophanes-Text

A language processing algorithm that attempts to detect occurrences of proper names and locations in the ancient text, *The Chronicle of Theophanes*. Other language processing methods proves unsuccessful, in part, due to the obsolescence of many of the names and locations mentioned in the Byzantine text.

The function takes as its input a dictionary of *seeds*. These are a selection of ten known locations from the text, but it can also be trained with proper names, as seen in the *person_seeds* dictionary. 

While less efficient, the above algorithm outperforms the *OpenNLP* package by 213% (4,925 unique names/locations compared to *OpenNLP*'s 1,572)
