if (!exists("Data")) {
  dir.create("Data")
}
if (!file.exists("./Data/NEI_data.zip")){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "./Data/NEI_data.zip")
  unzip("./Data/NEI_data.zip")
}
if (!exists("NEI"))  NEI <- readRDS("summarySCC_PM25.rds")
if (!exists("SCC"))  SCC <- readRDS("Source_Classification_Code.rds")


#Plot5
extractFunc <- function(x) {
  if (sum((grep("Vehicles", x)))>0) {
    x <- 1
  } else {
    x <- 0
  }
  x  
}
subset_vehicle <- SCC
subset_vehicle$isVehicle <- sapply(subset_vehicle$EI.Sector, function(x) extractFunc(x))
subset_vehicle <- subset_vehicle[subset_vehicle$isVehicle>0,]
data_vehicle <- merge(subset(NEI, fips=="24510"), subset_vehicle, by="SCC")
total_emission_vehicle_balt <- aggregate(Emissions ~ year, data=data_vehicle, sum)
plot5 <-ggplot(data = total_emission_vehicle_balt, aes(x = year, y = Emissions)) +
  geom_line()+ scale_x_continuous(breaks=c(1999, 2002, 2005, 2008))
plot5 + ylab("Vehicle Emmisions in tons in Baltimore")
dev.copy(png, file="plot5.png")#
dev.off()