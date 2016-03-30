## RTI CDS Analytics Exercise 02

Welcome to Exercise 02. This exercise provides data from the [National Transportation Safety Board](http://www.ntsb.gov/Pages/default.aspx)'s [database of aviation accidents](http://www.ntsb.gov/_layouts/ntsb.aviation/index.aspx). We'll ask you to perform some routine high-level analytic tasks with the data. 

----

### Some guidance

1. Use open source tools, such as Python, R, or Java. Do not use proprietary tools, such as SAS, SPSS, JMP, Tableau, or Stata. 
2. Fork this repository to your personal GitHub account and clone the fork to your computer.
3. Save and commit your answers to your fork of the repository, and push them back to your personal GitHub account. You can then provide a link to that fork of the repository if you need to show a code example.
4. Use the Internet as a resource to help you complete your work. We do it all the time.
5. Comment your code so that when you look back at it in a year, you'll remember what you were doing.
6. There are many ways to approach and solve the problems presented in this exercise.
7. Have fun!

----

### The Data

There are 145 files in this repository:

- `AviationData.xml`: This is a straight export of the database provided by the NTSB. The data has not been altered. It was retrieved by clicking "Download All (XML)" from [this page on the NTSB site.](http://www.ntsb.gov/_layouts/ntsb.aviation/index.aspx)

There are 144 files in the following format:

- `NarrativeData_xxx.json`: These files were created by taking the `EventId`s from `AviationData.xml` and collecting two additional pieces of data for each event: 
  - `narrative`: This is the written narrative of an incident.
  - `probable_cause`: If the full narrative includes a "probable cause" statement, it is in this field. 

----

### The Task

**Explore the data and prepare a 1/2 to 1 page written overview of your findings.**

_Additional Context:_

* Assume the audience for your write-up is a non-technical stakeholder. 
* Assume the audience for your code is a colleague who may need to read or modify it in the future. 

#### Possible approaches

This data is ripe for exploration. Working with the files provided, here are a few structured tasks that you can attempt. Note: these are suggested data exploration tasks. Feel free to complete none, some, or all of these steps as you explore the data.

1. Determine what fields you have available for each incident record.
2. Prepare descriptive statistics that convey an overview of the data.
3. If/Where you feel it is appropriate, visualize the data to help build a narrative around the descriptive statistics.
4. Perform initial exploratory analysis of the narrative text. What, if anything, can you learn from analyzing the text that you cannot learn from the structured data fields?
5. After removing common stopwords, what are the most frequent terms in the narrative text? Do the word frequencies change over time?
6. Use topic modeling to cluster the incidents based on the narrative text and/or probable cause descriptions. How do the clusters differ from those created with the structured data fields?
7. Imagine you have a client with a fear of flying. That client wants to know what types of flights present the most risk of an incident. Use your findings from the earlier tasks to answer the client's question in a report no longer than 1 page.
