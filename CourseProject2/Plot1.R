## Load the necessary libraries. 
## If not installed, install and load the required libraries

packages <- c("dplyr")
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
        install.packages(packages[!installed_packages])
}
invisible(lapply(packages, library, character.only = TRUE))

## Get the path of current working directory
dir_path <- getwd() 

## Download the data if not downlaoded and load it in memory
## Create data url and path to unzip data and download the data
data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
zip_data_file <- "NEI_data.zip"
unzip_dir <- "data"


# Check if the file already exists in the current directory then download data
if (!file.exists(zip_data_file)) {
        download.file(data_url, zip_data_file) # If the file does not exist, download it
        print("File downloaded successfully.")
} else {
        print("File already exists.")
}

# Check if the unzipped data folder already exists

if (!dir.exists(unzip_dir)){
        unzip(zip_data_file, exdir = unzip_dir) # If the folder does not exist, unzip the file
        print("Data unzipped successfully.")
} else {
        print("Data folder already exists.")
}


NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

## Group the Pm2.5 emissions by Year and calculate the total pm2.5 emission from all sources

total_emission <- NEI %>%
        group_by(year) %>%
        summarise(totalEmission = sum(Emissions, na.rm = TRUE))

## Now Plot the total Pm2.5 emissions from all sources for each year and save to plot1.png

{
        png("Plot1.png", width=720, height=720)
        
        par(mgp = c(2.2, 1, 0))
        barplot(total_emission$totalEmission/10^6, names.arg = total_emission$year,
                ## emission value is large so expressed in scale of 10^6 
                col = "Red",
                xlab = "Year",
                ylab = expression(Total ~ PM[2.5] ~ Emissions ~ (10^6 ~ Tons), line = 0),
                main = expression(Total ~ PM[2.5] ~ Emissions ~ From ~ All ~ Sources),
                ylim = c(0, max(total_emission$totalEmission/10^6+1))) ## setting Y-axis limit
        
        dev.off()
        }
