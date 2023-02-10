rm(list = ls())

library(ncdf4)
library(lubridate)

nc_fname <- "~/Downloads/613005.prcp.prcp-tas.tasonthly_1948-2008.nc/613005.shum.shum_monthly_1948-2008.nc"
nc_ds <- nc_open(nc_fname)

dim_lon <- ncvar_get(nc_ds, "longitude")
dim_lat <- ncvar_get(nc_ds, "latitude")
#dim_depth <- ncvar_get(nc_ds, "depth")
dim_time <- ncvar_get(nc_ds, "time")

t_units <- ncatt_get(nc_ds, "time", "units")
t_ustr <- strsplit(t_units$value, " ")
t_dstr <- strsplit(unlist(t_ustr)[3], "-")
date <- ymd(t_dstr) + dmonths(dim_time)
date

coords <- as.matrix(expand.grid(dim_lon, dim_lat, date))

nc_ds

var1 <- ncvar_get(nc_ds, "shum", collapse_degen=FALSE)
#var2 <- ncvar_get(nc_ds, "var2", collapse_degen=FALSE)


nc_df <- data.frame(cbind(coords,var1))
names(nc_df) <- c("lon", "lat","date","humidity")
head(na.omit(nc_df), 5)  # Display some non-NaN values for a visual check
csv_fname <- "~/OneDrive - UCB-O365/CricketCC/Data/loc-climate/monthly-humidity.csv"
write.table(nc_df, csv_fname, row.names=FALSE, sep=";")
