###NMC471/2001H1S Winter 2022

#-----------------------------------------------------------------
### Lesson 1, Intro to R, Basics
###Assigning Variables, Opening Data Files, Examining Data Files
#-----------------------------------------------------------------

#Part 1: Basics

#Setting working directory
#Navigate to directory on bottom right, under files tab; 
#then More-->Set as working directory 
#OR type directly into console:
setwd("D:/Teaching/NMC471-2001_DataScience/RCode")

#Create R script: File->New File->R Script OR Ctrl+Shift+N

#Note: to run single line of code, cursor on relevant line then CTRL+Enter
#To run multiple lines of code, select relevant lines, then CTRL+Enter
#To run all code in file, from start to end XXXXX

#Calculator
3+6
5*7
5**2
5^3

#Creating variables using <- or = 
#<- is preferred because = can be used in other contexts, so can be confusing
x<-5
y<-7
z=2

#Use camelCase to name your items
myNumber <- 42
anotherNumber<- 56
someText <- "Here is some text"

# Use snake_case to name your items
#Any text must have quotes
first_number <- 17
second_number <- 72
first_text <- "Some extra text goes here"

#See value in environment tab (top right) OR
show(x)
print(y)
z

#Find data type of variable (important for troubleshooting!)
#Technically, all values are stored as vectors
#Single variables are of length = 1 (shown as [1] when dispaying values)
class(x)
class(someText)

#Forcing specific data types
x<-as.integer(5)
class(x)
x<-5L
class(x)

# Calculations using variables
myNumber+anotherNumber
first_number*second_number

#Different ways to use powers
myNumber^2
first_number**3

#Clearing the Environment
rm(list =ls())

#-----------------
#Part 2: Functions

#Create a list; c = combine
myList<-c(2,5,6,9,6,-9)
myList

#Create a sequence
sequenceList<-5:10
sequenceList

reverseSequenceList<-rev(sequenceList)
reverseSequenceList

decreasingList<-10:5
decreasingList

#Create sequence by increments (from, to, by)
incrementSequenceList<-seq(2,10,2)
incrementSequenceList

#Repeat sequence
repeatSequence<-rep(1:5, times=3)
repeatSequence

#Selecting elements in list
myList[2]
myList[3:5]

# mean from first principles
length(myList)
sum(myList)
sum(myList)/length(myList)

#mean
mean(myList)

#Lists of text values
countries<-c("Turkey", "Syria", "Iraq", "Iran")
countries
length(countries)
nchar(countries)

#Getting help
?mean

#Dealing with missing values
#NA not in quotation marks
mylistNA <- c(3,6,NA,6,10,NA,11)
mean(mylistNA)
?mean #get help with missing values
mean(mylistNA,na.rm=TRUE)

#Note: the character # is ignored by R, so anything on a line following # will be ignored

#-----------------------
#Other Data Types
#Logical values
logic<-TRUE
logic
class(logic)

#Testing logic (test for equality using ==)
first_number == 12

#Factors (nominal values)
countryFactor<-as.factor(countries)
countryFactor

duplicateCountries<-c("Turkey", "Syria", "Iraq", "Turkey", "Iran","Syria")
duplicateCountries
duplicateFactor<-as.factor(duplicateCountries)
duplicateFactor

#Dates
date1<-as.Date("2021-06-27")
date2<-as.Date("2021-12-31")
class(date1)
date2-date1

#Clearing the Environment
rm(list =ls())

#------------------
#Part 3: Importing and Examining Datasets

#Data Frames
#Constructing a data frame manually
ID<-as.integer(1:4)
firstName<-c("George","Paul","John","Ringo")
lastName<-c("Harrison","McCartney","Lennon","Starr")
score<-c(10,20,30,40)
d<-data.frame(ID,firstName,lastName,score)
d
class(d)
colnames(d)

#Importing a dataset
#Remember to check your working directory!
getwd()

#Import dataset
FAOSTAT <- read.csv("FAOSTAT.csv")

#Examining a datset
head(FAOSTAT)
str(FAOSTAT)
summary(FAOSTAT)

#Applying a function
sd(FAOSTAT$Value)

#Selecting individual rows and elements
FAOSTAT[18,]
FAOSTAT[10:15,]
FAOSTAT[42,2]
FAOSTAT[35:37,2:3]

# Finding a maximum 
max(FAOSTAT$Value)
which.max(FAOSTAT$Value)
FAOSTAT[675347,4]
FAOSTAT[675347,8]

FAOSTAT[which.max(FAOSTAT$Value),8]

#Adding a column
FAOSTAT$Yield_Kg <- FAOSTAT$Value/10

#Creating a subset of results
syria <- subset(FAOSTAT, FAOSTAT$Area == "Syrian Arab Republic")
syria_wheat <- subset(syria, syria$Item == "Wheat")
min(syria_wheat$Year)
max(syria_wheat$Year)
mean(syria_wheat$Yield_Kg)
min(syria_wheat$Yield_Kg)
max(syria_wheat$Yield_Kg)


#-----------------------------------------------------------------
###Part 2, Manipulating Data
###Installing Packages, Selecting, Filtering and Ordering Data, 
###Adding Columns, Creating Graphs
#-----------------------------------------------------------------

#Part 1: Installing Packages

#Only the first time
install.packages("dplyr")
#Every time
library(dplyr)

#Part 2: Manipulating Data with dplyr

#Re-import data file to reset to original version
FAOSTAT <- read.csv("FAOSTAT.csv")

#Mutate - Adding a column using dplyr
FAOSTAT<-FAOSTAT %>% mutate(Yield_Kg = Value/10)

#Arranging data
FAOSTAT %>% arrange(Yield_Kg)
FAOSTAT %>% arrange(desc(Yield_Kg))
FAOSTAT %>% arrange(Area, Item)
FAOSTAT %>% top_n(10,Yield_Kg)

#Filtering
FAOSTAT %>% filter(Yield_Kg>20000000)

#Select 
FAOSTAT %>% select(Area, Item, Yield_Kg) 

#Select & Filter
FAOSTAT %>% 
  select(Area, Item, Yield_Kg) %>%
  filter(Yield_Kg>20000000)

#Select, Filter, & Arrange
FAOSTAT %>% 
  select(Area, Item, Yield_Kg) %>%
  filter(Yield_Kg>20000000) %>%
  arrange(desc(Yield_Kg))

# Summarising data
FAOSTAT %>% 
  group_by(Area) %>% 
  summarise(Average = mean(Yield_Kg),Standard_Dev = sd(Yield_Kg))

FAOSTAT %>% 
  group_by(Area, Item) %>% 
  summarise(Average = mean(Yield_Kg),Standard_Dev = sd(Yield_Kg), Min = min(Yield_Kg), Max = max(Yield_Kg))

FAOSTAT %>% 
  filter(Area=="Syrian Arab Republic"& Item=="Wheat")%>%
  group_by(Area) %>% 
  summarise(Average = mean(Yield_Kg),Standard_Dev = sd(Yield_Kg), Min = min(Yield_Kg), Max = max(Yield_Kg)) 

#--------------------------------------
#Part 3: Creating Graphs

# Installing packages
install.packages("datasets")
install.packages("ggplot2")
install.packages("archdata")

#Setup packages
library(datasets)
library(archdata)
?datasets
?archdata
library(help = "datasets")
library(ggplot2)

#Layer 1 - Data and aesthetics
#scatter <- ggplot(faithful,aes(eruptions,waiting))
#syria<-FAOSTAT%>%filter(Area=="Syrian Arab Republic")
wheat<-FAOSTAT%>%filter(Item=="Wheat")
ME_wheat<-wheat%>%filter(Area=="Syrian Arab Republic" | Area=="Iraq" | Area=="Jordan" | Area=="Lebanon" | Area=="Turkey")
syria_wheat<-FAOSTAT%>%filter(Area == "Syrian Arab Republic" & Item=="Wheat")
syria_scatter<-ggplot(syria_wheat, aes(Year,Yield_Kg))
ME_scatter<-ggplot(ME_wheat, aes(Year, Yield_Kg, colour=Area))

#Layer 2 - The Geometry
syria_scatter + geom_point()
syria_scatter + geom_point(shape = 1, colour ="red", size  = 2)
syria_scatter + geom_point(shape = 1, colour ="red", size  = 2) +
  labs(x = "Year", y = "Kg/Ha", title = "Wheat Yields, Syrian Arab Republic")
syria_plot<-ggplot(syria_wheat, aes(Year,Yield_Kg)) + geom_point(shape = 1, colour ="red", size  = 2) +
  labs(x = "Year", y = "Kg/Ha", title = "Wheat Yields, Syrian Arab Republic")

ME_scatter + geom_point()
ME_scatter + geom_point(size = 2) + labs("Year", y="Kg/Ha", title="Middle Eastern Wheat Yields")
ME_plot<-ggplot(ME_wheat, aes(Year, Yield_Kg, colour=Area)) + geom_point(size = 2) + labs("Year", y="Kg/Ha", title="Middle Eastern Wheat Yields")

#Boxplots
#head(iris)
#boxdata <- ggplot(iris, aes(Species, Sepal.Length))
#boxdata + geom_boxplot() + labs(x = "Species", y = "Sepal Length")
ME_wheat<-wheat%>%filter(Area=="Syrian Arab Republic" | Area=="Iraq" | Area=="Jordan" | Area=="Lebanon" | Area=="Turkey")
boxdata <-ggplot(ME_wheat, aes(Area,Yield_Kg))
boxdata + geom_boxplot() + labs(x="Area", y="Yield (kg/ha)")
boxplot<-ggplot(ME_wheat, aes(Area,Yield_Kg))+geom_boxplot() + labs(x="Area", y="Yield (kg/ha)", title="Middle Eastern Wheat Yields, by country")

#Saving your plots
ggsave("FAOSTAT_SyriaScatter.jpg",plot=syria_plot,units="in", width=12, height=8, dpi=600, limitsize=FALSE)
ggsave("FAOSTAT_MEScatter.jpg",plot=ME_plot,units="in", width=12, height=8, dpi=600, limitsize=FALSE)
ggsave("FAOSTAT_MEBoxplot.jpg",plot=boxplot,units="in", width=12, height=8, dpi=600, limitsize=FALSE)
