require(ggplot2)
require(pastecs)
require(lubridate)
require(scales)
require(ggthemes)
require(car)
require(reshape2)
require(caret)
require(pROC)
require(rpart)
require(ROCR)

#import data
incomepredict<-read.table(file="C:/Users/chris/Desktop/exercises/exercise01/flattened.csv", header=TRUE, sep=",")

#review data for completeness
head(incomepredict)
#attach dataset for easy reference
attach (incomepredict)

summary(incomepredict)
#capital gain has a weird cap -- probably not going to be useful/linear
#several with ? as values, going to leave as a separate category as of now to determine if variables even used in models (As opposed to deleting missing cases)




hist(over_50k)
hist(country_id)
hist(marital_status_id)
hist(race_id)
hist(relationship_id)
hist(sex_id)
hist(hours_week)
hist(education_level_id)
g2<-ggplot(incomepredict, aes(y=capital_gain, x=capital_loss))+geom_point(aes(color=over_50k))


Over50 <- factor(over_50k, levels=c(0,1), labels=c("No", "Yes"))
           
#check associations
tbl1<-table(marital, over_50k)
tbl1

chisq.test(tbl1) #very Significant P<.0001

tbl2<-table(education_num, over_50k) 
tbl2

chisq.test(tbl2) #very Significant

tbl3<-table(race, over_50k)
tbl3

chisq.test(tbl3) #very significant

tbl4<-table(hours_week,over_50k)
tbl4

chisq.test(tbl4)#significant

tbl5<-table(sexes,over_50k)
tbl5

chisq.test(tbl5)#significant

tbl6<-table(country,over_50k) #potential quasi-complete separation, some null cells need to be careful, appears significant
tbl6


hist(tbl6)

chisq.test(tbl6) #I looked into changing Holland entry to Germany to see if it helped, but still had quasi complete issues


#look at binning country variables to fix quasi complete and hopefully strengthen association
incomepredict$country2<- ifelse(country%in% c("Canada" , "England" , "France" , "Italy" , "Japan" , "Portugal" , "Scotland" , "South" , "Hong" , "Taiwan", "United-States"), c("Developed"), c("Developing"))


tbl7<-table(incomepredict$country2,over_50k) 
chisq.test(tbl7) #less significant - fixes quasi complete but we are clearly losing some information

#determine if binning other with '?' developed gives us better fit
incomepredict$country3<- ifelse(country%in% c("Canada" , "England" , "France" , "Italy" , "Japan" , "Portugal" , "Scotland" , "South" , "Hong" , "Taiwan", "United-States" ,"?"), c("Developed"), c("Developing"))

tbl8<-table(incomepredict$country3,over_50k)
chisq.test(tbl8)

#missing values appear to bin better with developed- makes sense given overwhelming majority of folks in US

#partition data
library(caret)

#split into 70 training 20 validation 10 test

set.seed(1234)
trainIndex<- createDataPartition(id, p=.7, list=FALSE, times=1)
head(trainIndex)

incometrain <-incomepredict[trainIndex,]
incomevalid <-incomepredict[-trainIndex,]

head(incometrain)
head(incomevalid)

#split validation further -- one third into test while the others remain in validation set
validIndex<-createDataPartition(incomevalid$id, p=.66, list=FALSE, times=1)
incomevalid2<-incomevalid[validIndex,]
incometest<-incomevalid[-validIndex,]
head(incomevalid)
head(incometest)


#begin modeling - kitchen sink model
mylogit1<-glm(over_50k ~ age + occupation + race + relationship + class +sexes+ ed_level+ marital +country3+ capital_gain +capital_loss, data=incometrain, family=binomial("logit"))
summary(mylogit)
roc(mylogit1$y, mylogit1$fitted)
#begin with country
mylogit2<-glm(over_50k ~ country3,data=incometrain, family=binomial("logit"))
summary(mylogit2)
roc(mylogit2$y, mylogit2$fitted)
#continue adding what appeared significant
mylogit3<-glm(over_50k ~ country3 + sexes + ed_level + marital + age, data=incometrain, family=binomial("logit"))
summary(mylogit3)
roc(mylogit3$y, mylogit3$fitted)
#add race
mylogit4<-glm(over_50k ~ country3 + sexes + ed_level + marital + age+race, data=incometrain, family=binomial("logit"))
summary(mylogit4)
roc(mylogit4$y, mylogit4$fitted)
#race not significant, drop and add class
mylogit5<-glm(over_50k ~ country3 + sexes + ed_level + marital + age+class,data=incometrain, family=binomial("logit"))
summary(mylogit5)
roc(mylogit5$y, mylogit5$fitted)
#look at capital gain 

mylogit6<-glm(over_50k ~ country3 + sexes + ed_level + marital + age+class + capital_gain + capital_loss,data=incometrain, family=binomial("logit"))
summary(mylogit6)
roc(mylogit6$y, mylogit6$fitted)

#roc area .8946
# I like Model 6, lets look at some additional variable transformations to improve significance of some classes 

#determine potential splits for cap gains/loss
captree<-rpart(over_50k~capital_gain, data=incomepredict, method="class")
printcp(captree)
plotcp(captree)
summary(captree)

plot(captree,uniform=TRUE, main="Identifying splits for Capital Gains")
#split identified at 5,112, round to 5,000

incomepredict$capgain2 <- ifelse(capital_gain < 5000, "0-4999","5000+")
mylogit6bin<-glm(over_50k ~ country3 + sexes + ed_level + marital + age+class + capgain2 + capital_loss,data=incometrain, family=binomial("logit"))
summary(mylogit6bin)
roc(mylogit6bin$y, mylogit6bin$fitted)


captree2<-rpart(over_50k~capital_loss, data=incomepredict, method="class")
printcp(captree2)
plotcp(captree2)
summary(captree2)

plot(captree2,uniform=TRUE, main="Identifying splits for Capital Loss")
text(captree2, use.n=TRUE, all=TRUE, cex=.8)

#create splits at 2000, 2500
incomepredict$caploss2 <- ifelse((capital_loss < 2000), c("0-1999"), (ifelse(capital_loss<=2500 & capital_loss<2500, c("2000-2499"), c("2500+"))))
#rerun Split
mylogit6bin<-glm(over_50k ~ country3 + sexes + ed_level + marital + age+class + capgain2 + caploss2,data=incometrain, family=binomial("logit"))
summary(mylogit6bin)
roc(mylogit6bin$y, mylogit6bin$fitted)

incomepredict$edbins<- ifelse(ed_level%in% c("Preschool" , "1st-4th" , "5th-6th" , "7th-8th"), c("NoHighSchool"), 
                                (ifelse(ed_level%in%(c("9th","10th","11th","12th")), c("SomeHighSchool"), c(ed_level) )))

mylogit7bin<-glm(over_50k ~ country3 + sexes + edbins + marital + age+class + capgain2 + caploss2, data=incometrain, family=binomial("logit"))
summary(mylogit7bin)
finalroc<-roc(mylogit7bin$y, mylogit7bin$fitted, plot=TRUE)

#would like to spend time binning addt'l variables but getting a bit short on time given remaining objectives
#definitely playing fast and loose with some assumptions, however still have to test and validate some things as well as create a visual

#calculating optimal cutoff for scoring based on Youden's (cost free method)
#note youden is default "best" method used below
coords(finalroc, "b", ret=c("t","sen", "spec"))

#threshold sensitivity specificity 
#0.2406852   0.8492345   0.7707589

#model appears to be fairly accurate - lets see how it performs on the validation set

classify<-data.frame(response=incomevalid$over_50k, predicted=(predict(mylogit7bin, incomevalid, type="response") > .2406852))
summary(classify)
xtabs(~ predicted + response, data= classify)

#seem to be creating a lot of false positives, lets look at test data for fun. Normally would again look at bins, potentially problematic variables in training model etc

classify<-data.frame(response=incometest$over_50k, predicted=(predict(mylogit7bin, incometest, type="response") > .2406852))
summary(classify)
xtabs(~ predicted + response, data= classify)

#again, roughly 78% accuracy with a lot of false positives
#Now lets work on a graphic

age<-ggplot(data=incomepredict)+geom_density(aes(age, color=factor(Over50), fill=Over50))
age
age1<-age+theme_economist()
age1+scale_colour_economist()
age1<-age1+labs(title="Age and Relationship with Making Over 50k", x='Age', y='Probability')
age1

#having trouble with fill color, giving up at this point.
