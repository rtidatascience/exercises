## RTI CDS Analytics Exercise 01

Welcome to Exercise 01. This exercise provides a small SQLite database with some data derived from the 1996 US Census and a few analytic questions related to working with SQL and open source analysis packages.

----

### Some guidance

1. Use open source tools, such as Python, R, or Java. Do not use proprietary tools, such as SAS, SPSS, JMP, Tableau, or Stata. 
2. Fork this repository to your personal GitHub account and clone the fork to your computer.
3. Save and commit your answers to your fork of the repository, and push them back to your personal GitHub account. You can then provide a link to that fork of the repository if you need to show a code example.
4. Use the Internet as a resource to help you complete your work. We do it all the time.
5. Comment your code so that when you look back at it in a year, you'll remember what you were doing.
6. There are many ways to approach and solve the problems presented in this exercise.
7. Have fun!

[SQLite Manager](https://addons.mozilla.org/en-US/firefox/addon/sqlite-manager/) is a fantastic free extension to Firefox that enables you to open and explore SQLite databases. We use it often.

Google will point you to popular libraries for connecting to SQLite databases from Python, R, etc.

----

### The Task

There are many things you can do with this dataset. Here are a few structured tasks to attempt:

0. Read the section below about **The Data**.
1. Write a SQL query that creates a consolidated dataset from the normalized tables in the database. In other words, write a SQL query that "flattens" the database to a single table.
2. Export the "flattened" table to a CSV file.
3. Import the "flattened" table (or CSV file) into your open source analytic environment of choice (R, Python, Java, etc.) and stage it for analysis.
4. Perform some simple exploratory analysis and generate summary statistics to get a sense of what is in the data.
5. Split the data into training, validation, and test data sets. 
6. Develop a model that predicts whether individuals, based on the census variables provided, make over $50,000/year. Use `over_50k` as the target variable. 
7. Generate a chart that you feel conveys 1 or more important relationships in the data.
8. Describe your methodology and results in 1/2 page of writing.

Voila!

----

### The Data

This repository contains a file called `exercise01.sqlite`. It is a normalized relational [SQLite database](http://www.sqlite.org). 

It contains a table, named `records`, that has 48842 US Census records with the following fields:

- `id`: a unique id number for each record
- `age`: a continuous variable representing an individual's age
- `workclass_id`: foreign key to the `workclasses` table, representing the broad class of occupation of an individual
- `education_level_id`: foreign key to the `education_levels` table, representing the highest level of education an individual received
- `education_num`: a continuous variable representing an individual's current education level
- `marital_status_id`: foreign key to the `marital_statuses` table, representing an individual's marital status
- `occupation_id`: foreign key to the `occupations` table, representing an individual's occupation
- `race_id`: foreign key to the `races` table, representing an individual's race
- `sex_id`: foreign key to the `sexes` table, representing an individual's sex
- `capital_gain`: a continuous variable representing post-social insurance income, in the form of capital gains.
- `capital_loss`: a continuous variable representing post-social insurance losses, in the form of capital losses.
- `hours_week`: a continuous variable representing the number of hours per week an individual worked.
- `country_id`: foreign key to the `countries` table, representing an individual's native country
- `over_50k`: a boolean variable and **the target variable**, representing whether the individual makes over $50,000/year. A value of 1 means that the person makes greater than $50,000/year and a value of 0 means that the person makes less than or equal to $50,000/year.

Inspection of the database will reveal the reference tables and the values that they contain, referenced by the foreign keys in the categorical fields of the `records` table. Basically, anywhere you see a field name above that ends with `_id`, there is a corresponding table in the database that contains the values associated with that categorical variable. Fields that contain continuous values, such as `age`, do not join to other tables.

Some of the reference tables have an entry for a question mark `?` that represents missing data in `records`.

#### The Target Variable

The target variable is `over_50k` in the `records` table in the database.



