if (!exists("Data")) {
   dir.create("Data")
}
if (!file.exists("./Data/NEI_data.zip")){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "./Data/NEI_data.zip")
  unzip("./Data/NEI_data.zip")
}

if (!exists("NEI"))  NEI <- readRDS("summarySCC_PM25.rds")
if (!exists("SCC"))  SCC <- readRDS("Source_Classification_Code.rds")

#total submissions over years
total_emission <- aggregate(Emissions ~ year, data=NEI, sum)

#Plot1
plot(total_emission$year, total_emission$Emissions/1000, type="l", ylab ="Total Emissions of PM25 (in thousand tons)", xlab="Year", xaxt="n") 
 axis(1, total_emission$year)
dev.copy(png, file="plot1.png")#
dev.off()
