if (!exists("Data")) {
   dir.create("Data")
}
if (!file.exists("./Data/NEI_data.zip")){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "./Data/NEI_data.zip")
}
unzip("./Data/NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#total submissions over years
total_emission <- aggregate(Emissions ~ year, data=NEI, sum)

#Plot1
plot(total_emission$year, total_emission$Emissions/1000, type="l", ylab ="Total Emissions of PM25 (in thousand tons)", xlab="Year", xaxt="n") 
 axis(1, total_emission$year)



#Total Emissions over year for Baltimore
total_emission_Balt <- aggregate(Emissions ~ year + type, data=subset(NEI, fips=="24510"), sum)

#Plot2
plot(total_emission_Balt$year, total_emission_Balt$Emissions, type="l", ylab ="Total Emissions of PM25 in Baltimore city (in tons)", xlab="Year", xaxt="n") 
axis(1, total_emission_Balt$year)



#Plot3
library(ggplot2)
#Total Emissions over year for Baltimore with type
total_emission_Balt_type <- aggregate(Emissions ~ year + type, data=subset(NEI, fips=="24510"), sum)
plot3 <-ggplot(data = total_emission_Balt_type, aes(x = year, y = Emissions, color = type)) +
  geom_line()+ scale_x_continuous(breaks=c(1999, 2002, 2005, 2008))

#Plot4
subset_coal <- subset(SCC, EI.Sector == "Fuel Comb - Electric Generation - Coal")
data_coal <- merge(NEI, subset_coal, by="SCC")
coal_aggregate <- aggregate(Emissions ~ year, data=data_coal, sum)
plot4 <-ggplot(data = coal_aggregate, aes(x = year, y = Emissions), ylab="Emmisions in tons") +
  geom_line()+ scale_x_continuous(breaks=c(1999, 2002, 2005, 2008))
plot4 + ylab("Total Emissions of PM25 (in tons)")


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

#Plot6
data_vehicle_comp <- merge(subset(NEI, fips=="24510" | fips=="06037" ), subset_vehicle, by="SCC")
data_vehicle_comp$fips <- factor(data_vehicle_comp$fips, levels=c("24510","06037"), labels=c("Baltimore","LA"))
total_emission_vehicle_comp <- aggregate(Emissions ~ year + fips, data=data_vehicle_comp, sum)
total_emission_vehicle_comp$

plot6 <-ggplot(data = total_emission_vehicle_comp, aes(x = year, y = Emissions/Emissions[1], col=fips)) +
  geom_line() + geom_point(aes(shape=fips), size=4)+ scale_x_continuous(breaks=c(1999, 2002, 2005, 2008))
plot6 + ylab("Vehicle Emmisions in tons ")






