## Load the necessary libraries. 
## If not installed, install and load the required libraries

packages <- c("dplyr", "ggplot2")
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

## First select the data for Baltimore City fips = 24510 and Los Angeles COunty
 ## fips = 06037

NEI_BaLos <- NEI %>%
        filter(fips == "24510"| fips == "06037")


## To get the motor vehicle related emissions in Baltimore city and Los Angeles first select 
## vehicle related fields from SCC Data and subset NEI_BaLos data based on the selected field in SCC 

vehicle_SCC <- SCC[grep("Vehicles", SCC$Short.Name), ]

Vehicle_NEI_BaLos <- NEI_BaLos[NEI_BaLos$SCC %in% vehicle_SCC$SCC, ]

## Calculate toal Pm2.5 emissions by source type for vehicle emissions each year over Baltimore City
AvgVehicle_NEI_BaLos <- Vehicle_NEI_BaLos %>%
        group_by(year, fips) %>%
        summarise(totalEmission = sum(Emissions, na.rm = TRUE))

## Now Plot the total Pm2.5 emissions for Baltimore from motor vehicles for type of sources 
## for each year and save to plot5.png

ggplot(data = AvgVehicle_NEI_BaLos, aes(x = year, y = totalEmission, group = fips, color = fips)) +
        geom_line() +
        geom_point() +
        theme_bw() +
        labs(x = "Year", 
             y = "Total PM"["2.5"]~"Emissions (Tons)",
             title = expression("Total PM"["2.5"]~"Emissions by Motor Vehicles")) +
        scale_color_manual(values = c("24510" = "red", "06037" = "blue"),
                           breaks = c("24510", "06037"),
                           labels = c("Baltimore City", "Los Angeles")) +
        theme(plot.title = element_text(hjust = 0.5),
              legend.title = element_blank(),
              legend.position = c(.8,.9))

ggsave("Plot6.png", height = 5, width = 4)
dev.off()