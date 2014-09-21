if (!exists("Data")) {
  dir.create("Data")
}
if (!file.exists("./Data/NEI_data.zip")){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "./Data/NEI_data.zip")
  unzip("./Data/NEI_data.zip")
}
if (!exists("NEI"))  NEI <- readRDS("summarySCC_PM25.rds")
if (!exists("SCC"))  SCC <- readRDS("Source_Classification_Code.rds")



#Plot4
subset_coal <- subset(SCC, EI.Sector == "Fuel Comb - Electric Generation - Coal")
data_coal <- merge(NEI, subset_coal, by="SCC")
coal_aggregate <- aggregate(Emissions ~ year, data=data_coal, sum)
plot4 <-ggplot(data = coal_aggregate, aes(x = year, y = Emissions), ylab="Emmisions in tons") +
  geom_line()+ scale_x_continuous(breaks=c(1999, 2002, 2005, 2008))
plot4 + ylab("Total Emissions of PM25 (in tons)")
dev.copy(png, file="plot4.png")#
dev.off()

