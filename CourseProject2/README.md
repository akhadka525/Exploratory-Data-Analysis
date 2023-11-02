# Exploratory Data Analysis: Course Project 2
This repository contain a R Script to prepare different types of plot from [Particulate Pollution Data](https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip) 

## Executing Code
The execution of the code requires the `dplyr` and `ggplot2` library installed. If these libraries are not installed then the code will install these libraries and then run. Clone this repository or copy the R codes to R console and run the code.

## Objectives
The R-codes for different plots adresses the following questions:
- Plot1 : Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.
- Plot2: Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.
- Plot3: Of the four types of sources indicated by the type type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.
- Plot4: Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
- Plot5: How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
- Plot6: Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?
