if (!exists("Data")) {
  dir.create("Data")
}
if (!file.exists("./Data/NEI_data.zip")){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "./Data/NEI_data.zip")
  unzip("./Data/NEI_data.zip")
}
if (!exists("NEI"))  NEI <- readRDS("summarySCC_PM25.rds")
if (!exists("SCC"))  SCC <- readRDS("Source_Classification_Code.rds")



#Plot6
data_vehicle_comp <- merge(subset(NEI, fips=="24510" | fips=="06037" ), subset_vehicle, by="SCC")
data_vehicle_comp$fips <- factor(data_vehicle_comp$fips, levels=c("24510","06037"), labels=c("Baltimore","LA"))
total_emission_vehicle_comp <- aggregate(Emissions ~ year + fips, data=data_vehicle_comp, sum)
  
plot6 <-ggplot(data = total_emission_vehicle_comp, aes(x = year, y = Emissions, col=fips)) +
  geom_line() + geom_point(aes(shape=fips), size=4)+ scale_x_continuous(breaks=c(1999, 2002, 2005, 2008))
plot6 + ylab("Vehicle Emmisions in tons ")
dev.copy(png, file="plot6.png")#
dev.off()

