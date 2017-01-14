#Methodology and Results
The task at hand was to develop a model which predicted whether individuals make over $50,000 per year based on the census variables provided.
Before construction of a model, it was necessary to manage then extract the data from its original .sqlite form. The open source anlaytic environment
of choice was R, where the RSQLite and sqldf libraries were utilized to work with the .sqlite database. After flattening the database into a single 
table, using SQL join commands, the table was exported to a CSV file, then imported back into R. The conversion to a CSV file was important,
as this file format was far more efficient to manipulate. A simple exploratory analysis was performed to achieve a better understanding of the data.
Visuals such as histograms, boxplots, and density plots were created within the code below. The data was split into training, validation, and test 
data sets, and a logisitc regression model was created for the training data set. Visuals were attempted for this logistic training data, however, 
several commands found through online resources were not accepted by the current version of RStudio. Speaking of online resources, most of the code
was derived from online documents or R specific books. Little to no domain knowledge was present, therefore further analysis of the data was stunted. 
The code allows for the intercept, estimate, and standard error to be accessible for the logistic training data, and a ggplot of age vs. over_50k was
produced. The code parallel to the above methodology is written below. 


#Installed libraries and packages that I thought would be useful
library("RSQLite")
install.packages("sqldf")
install.packages("XLConnect")
library(sqldf)
library(ggplot2)

#Found this function online, I think it allows R to use SQL
runsql <- function(sql, dbname="C:/Users/Pooja Aphale/Desktop/exercises/exercise01/exercise01.sqlite")
  
#Found this function online, it creates temporary in-memory database
ex1 <- dbConnect(SQLite(), dbname = "C:/Users/Pooja Aphale/Desktop/exercises/exercise01/exercise01.sqlite")

#Not sure if this just replicated what I did above
sqldf("attach 'exercise01.sqlite' as new")

#Thought this was summary of information inside, but it is summary of SQLite such as version, etc. 
summary(ex1)

#This option lists the tables in the database, looks like there are the following:
#countries, education_levels, marital_statuses, occupations, races, records, relationships, sexes, and workclasses
dbListTables(ex1)

#Now we will create dataframe for every table we read in, and name the data frame
countries <- dbReadTable(ex1, "countries")
education_levels <- dbReadTable(ex1, "education_levels")
marital_statuses <- dbReadTable(ex1, "marital_statuses")
occupations <- dbReadTable(ex1, "occupations")
races <- dbReadTable(ex1, "races")
records <- dbReadTable(ex1, "records")
relationships <- dbReadTable(ex1, "relationships")
sexes <- dbReadTable(ex1, "sexes")
workclasses <- dbReadTable(ex1, "workclasses")

#Flattened the database to a single table
flat_table <- sqldf("select * from records
    left join countries on records.country_id=countries.id
    left join education_levels on records.education_level_id=education_levels.id 
    left join marital_statuses on records.marital_status_id=marital_statuses.id
    left join occupations on records.occupation_id = occupations.id
    left join races on records.race_id = races.id
    left join relationships on records.relationship_id = relationships.id
    left join sexes on records.sex_id = sexes.id
    left join workclasses on records.workclass_id = workclasses.id")

#Export flat_table to a CSV file, message in R said that it ignored col.names but not sure why
write.csv(flat_table, "C:/Users/Pooja Aphale/Desktop/exercises/exercise01/flat_table.csv", row.names=TRUE,col.names=TRUE)

#Cleaned up column names and deleted repetitive data when CSV was opened in Excel
#Import cleaned CSV into R
data = read.csv("C:/Users/Pooja Aphale/Desktop/exercises/exercise01/flat_table.csv")

#Explore data and generate summary statistics
summary(data)

#Generate statistical graphs based on summary statistics for a few variables
require(ggplot2)
hist(data$age, main = "Age Histogram", xlab = "Age")
hist(data$race_id, main = "Race Histogram", xlab = "Race")
hist(data$gender_id, main = "Gender Histogram", xlab = "Gender")
plot(hours_week ~ age, data = data)
plot(age ~ capital_gain, data = data)
boxplot(data$hours_week)
boxplot(data$race_id)
ggplot(data = data) + geom_density(aes(x=age))
ggplot(data = data) + geom_density(aes(x=capital_gain))

#Splitting data into training, validation, and test 
#We have 48842 rows
nrow(data)
#Based on the default in Matlab, I will split approximately 70:15:15
index <- 1:nrow(data)
trainingindex <- sample(index, 34190)
training <- data[trainingindex,]
validationindex <- sample(index, 7326)
validation <- data[validationindex,]
testindex <- sample(index, 7326)
test <- data[textindex,] 

#Develop a model that predicts whether individuals make over $50k
logistic_training <- glm(training$over_50k ~ training$age + training$education_num + training$capital_gain + 
                           training$capital_loss + training$hours_week + training$country + training$education
                         + training$marital + training$job + training$race + training$relationship + training$gender +
                           training$workclass, data=training, family=binomial(link="logit"))

#Below command stated 2 coefficients not defined because of singularities
#Those 2 were: Some college education & Without pay workclass
#Not sure how to fix this
summary(logistic_training)

#Create coefficient plot, R error stated that there is no package called coefplot...so that's peculiar
require(coefplot)
coefplot(logistic_training)

#Try drawing curve based on predictions, resulted in many errors
curve(predict(logistic_training,data.frame(age=x),type="resp"),add=TRUE)

#Try drawing points, error is that x and y lengths differ
points("age",fitted(logistic_training),pch=20)

#Try a histogram and curve combo, R error said could not find function logi.hist.plot
logi.hist.plot(age,over_50k,boxp=FALSE,type="hist",col="gray")

#Trying simple plots
plot(training$capital_gain,training$over_50k,pch=20)
plot(training$age,training$over_50k,pch=20)

#Trying the ggplot option
ggplot(logistic_training, aes(x=training$age, y=training$over_50k))+geom_line() 




