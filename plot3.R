if (!exists("Data")) {
  dir.create("Data")
}
if (!file.exists("./Data/NEI_data.zip")){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "./Data/NEI_data.zip")
  unzip("./Data/NEI_data.zip")
}
if (!exists("NEI"))  NEI <- readRDS("summarySCC_PM25.rds")
if (!exists("SCC"))  SCC <- readRDS("Source_Classification_Code.rds")


#Plot3
library(ggplot2)
#Total Emissions over year for Baltimore with type
total_emission_Balt_type <- aggregate(Emissions ~ year + type, data=subset(NEI, fips=="24510"), sum)
plot3 <-ggplot(data = total_emission_Balt_type, aes(x = year, y = Emissions, color = type)) +
  geom_line()+ scale_x_continuous(breaks=c(1999, 2002, 2005, 2008))
plot3
dev.copy(png, file="plot3.png")#
dev.off()
