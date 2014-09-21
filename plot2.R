if (!exists("Data")) {
  dir.create("Data")
}
if (!file.exists("./Data/NEI_data.zip")){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "./Data/NEI_data.zip")
  unzip("./Data/NEI_data.zip")
}
if (!exists("NEI"))  NEI <- readRDS("summarySCC_PM25.rds")
if (!exists("SCC"))  SCC <- readRDS("Source_Classification_Code.rds")


#Total Emissions over year for Baltimore
total_emission_Balt <- aggregate(Emissions ~ year, data=subset(NEI, fips=="24510"), sum)

#Plot2
plot(total_emission_Balt$year, total_emission_Balt$Emissions, type="l", ylab ="Total Emissions of PM25 in Baltimore city (in tons)", xlab="Year", xaxt="n") 
axis(1, total_emission_Balt$year)
dev.copy(png, file="plot2.png")#
dev.off()