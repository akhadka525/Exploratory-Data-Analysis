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


## First select the data for Baltimore City fips = 24510

NEI_Baltimore <- NEI %>%
        filter(fips == 24510)


## To get the motor vehicle related emissions in Baltimore city first select coal 
## combustion related fields from SCC Data and subset NEI_Baltimore data based on the selected field in SCC 

vehicle_SCC <- SCC[grep("Vehicles", SCC$Short.Name), ]

Vehicle_NEI_Baltimore <- NEI_Baltimore[NEI_Baltimore$SCC %in% vehicle_SCC$SCC, ]

## Calculate toal Pm2.5 emissions by source type for vehicle emissions each year over Baltimore City
AvgVehicle_NEI_Baltimore <- Vehicle_NEI_Baltimore %>%
        group_by(year, type) %>%
        summarise(totalEmission = sum(Emissions, na.rm = TRUE))

## Now Plot the total Pm2.5 emissions for Baltimore from motor vehicles for type of sources 
## for each year and save to plot5.png

ggplot(data = AvgVehicle_NEI_Baltimore,
       aes(x = factor(year), y = totalEmission, fill = type)) +
        geom_bar(stat = "identity") +
        facet_grid(.~type) +
        theme_bw() +
        guides(fill = FALSE) +
        labs(x = "Year", 
             y = "Total PM"["2.5"]~"Emissions (Tons)",
             title = expression("Total PM"["2.5"]~"Emissions by Motor Vehicles in Baltimore City, Maryland")) +
        theme(plot.title = element_text(hjust = 0.5))

ggsave("Plot5.png", height = 6, width = 8)
dev.off()