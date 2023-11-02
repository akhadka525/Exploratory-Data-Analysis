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

## To get the Coal Combustion related emissions first select coal combustion related 
## fields from SCC Data and subset NEI data based on the selected field in SCC 

coalCombustion_SCC <- SCC[grep("Coal", SCC$Short.Name), ]

coalCombustion_NEI <- NEI[NEI$SCC %in% coalCombustion_SCC$SCC, ]

## Calculate toal emissions by source type for coal combustion emissions over United States
AvgCoalCombustion_NEI <- coalCombustion_NEI %>%
        group_by(year, type) %>%
        summarise(totalEmission = sum(Emissions, na.rm = TRUE))

## Now Plot the total Pm2.5 emissions from coal combustion for United States from 
## each type of sources for each year and save to plot4.png

ggplot(data = AvgCoalCombustion_NEI,
       aes(x = factor(year), y = totalEmission/10^3, fill = type)) +
        geom_bar(stat = "identity") +
        facet_grid(.~type) +
        theme_bw() +
        guides(fill = FALSE) +
        labs(x = "Year", 
             y = expression("Total PM"["2.5"]~"Emissions ("~10^3~"Tons)"),
             title = expression("Total PM"["2.5"]~
                                        "Emissions From Coal Combustion by Source Type in Unites States")) +
        theme(plot.title = element_text(hjust = 0.5))

ggsave("Plot4.png", height = 6, width = 8)
dev.off()