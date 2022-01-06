###NMC471/2001H1S Winter 2022

#-----------------------------------------------------------------
### Lesson 3, Basic Mapping
### Coordinate systems, reading vector and raster data, creating basic maps
#-----------------------------------------------------------------
#Install packages
install.packages("sf")  #main R package for dealing with spatial data, replaced "sp"
install.packages("tmap") # for plotting maps
install.packages("maptools") #spatial data (dependency)
install.packages("rgdal") #spatial data (dependency)
install.packages("raster") #for raster data
install.packages("spatstat") #for spatial statistics

#Load libraries
library(dplyr)
library(ggplot2)
library(archdata)
library(sf) 
library(tmap) 
library(rgdal) 
library(maptools) 
library(raster)
library(spatstat)

#data(package = "archdata")
#data(Acheulean)

#Data from Near East Radiocarbon Database (NERD): https://github.com/apalmisano82/NERD
nerd<-read.csv("data/nerd.csv")

#Plotting simple points
simple_plot<-ggplot(nerd,aes(Longitude,Latitude))+geom_point()
simple_plot

#------------------------------------
#Getting more complex

#Define projections
wgs84<-"+proj=longlat +datum=WGS84 +no_defs"  #Lat Long
wgs84_37N<-"+proj=utm +zone=37 +datum=WGS84 +units=m +no_defs" #UTM Zone 37N

#Read coordinates from csv file
#Long way
long<-nerd%>%select(Longitude)
lat<-nerd%>%select(Latitude)
longlat<-cbind(long,lat)  #bind columns
points2<-SpatialPoints(longlat, proj4string=CRS(wgs84))
showDefault(points2)

#Short way (but not SpatialPoints class)
points<-st_as_sf(nerd, coords=c("Longitude", "Latitude"), crs=wgs84)

#Open shapefile, two ways
mideast_shp<-shapefile("data/LC6k_ME_mask.shp")
mideast<-readOGR("data/LC6k_ME_mask.shp")
mideast_prj<-readOGR("data/LC6k_ME_mask_37N.shp")

#Read attributes from shapefile
#df<-data.frame(shp)
#head(df)
#g<-geom(shp) #not commonly used
#head(g)

#Create mask using shapefile
mask<-as.owin(mideast_prj) # create research mask corresponding to research area

#Plot points
sites<-tm_shape(mideast_prj)+
  tm_polygons(col="lightgrey",border.col="lightgrey")+
  tm_shape(points)+
  tm_dots(shape=1,size=.1,border.lwd=.5)+
  tm_layout(title=paste("All samples\n(n=",nrow(point.all),")"),title.position=c("right", "top"))+
  tm_scale_bar(position="left")
map.all<-tmap_arrange(sites)
map.all
tmap_save(map.all, filename="allsites.jpg", dpi=600)

#Load raster (DEM)
gtopo<-raster("data/gtopo_me2.ovr") #load DEM from ovr
gtopo_37N<-raster("data/gtopo_me_37n1.tif") #load DEM from tif
gtopo_proj<-projectRaster(gtopo_37N, wgs84)
plot(gtopo_37N)

#Crop raster
gtopo_clip<-crop(gtopo_37N, mideast_prj)
plot(gtopo_clip)

#Reproject raster
gtopo_proj<-projectRaster(gtopo_clip, crs=wgs84)

#Mask raster
gtopo_mask<-mask(gtopo_proj,mideast)
plot(gtopo_mask)
gtopo_df<-as.data.frame(gtopo_mask)

#Plot
map_plot<-ggplot()+geom_raster(data=gtopo_df, aes(x=x, y=y, fill=value))
ggsave("MapPlot.jpg",plot=map_plot,units="in", width=12, height=8, dpi=600, limitsize=FALSE)
#map_plot<-plot(gtopo_mask)
#map_plot<-plot(points, colour="black", add=TRUE)

#Opening multi-band rasters
#raster(file, band=2)
#brick(file) #all bands as single object
#stack(file) #less efficient

#------------------------------------------------
#Lesson 4, Spatial Statistics
#Various topics
#------------------------------------------------

#KDE

#Writing results to raster
#writeRaster(raster, output.tif, overwrite=TRUE)

