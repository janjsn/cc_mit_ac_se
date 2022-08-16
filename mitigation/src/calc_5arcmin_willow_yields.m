ncid = netcdf.open('Input/Willow/willow_dm_yields_Mola_Yudego.nc');
%willow_high = netcdf.getVar(ncid,4); %high
%willow_low = netcdf.getVar(ncid,2); %low
willow_this = netcdf.getVar(ncid,3); %mid
filename_out = 'willow_yields_medium.nc';

ncid_land = netcdf.open('Nordic region_bienergy_crop_land_availability43200x21600.nc');

lat = netcdf.getVar(ncid_land,0);
lon = netcdf.getVar(ncid_land,1);
region = netcdf.getVar(ncid_land,3)';
ac = netcdf.getVar(ncid_land,5);
cropland = netcdf.getVar(ncid_land,7);

cropland_ac = ac+cropland;

ac_with_values = ac;
ac_with_values(willow_this < 0) = 0;
cropland_with_values = cropland;
cropland_with_values(willow_this < 0) = 0;
cropland_ac_with_values = cropland_ac;
cropland_ac_with_values(willow_this < 0) = 0;


[cropland_ac_with_values_5arcmin, lat_5arcmin, lon_5arcmin, lat_bnds_5arcmin, lon_bnds_5arcmin]  = aggregateMatrix2givenDimensions( cropland_ac_with_values,lon,lat, 4320, 2160 );
[ac_with_values_5arcmin, ~, ~, ~, ~]  = aggregateMatrix2givenDimensions( ac_with_values,lon,lat, 4320, 2160 );
[cropland_with_values_5arcmin, ~, ~, ~, ~]  = aggregateMatrix2givenDimensions( cropland_with_values,lon,lat, 4320, 2160 );

willow_this(willow_this < 0) = 0;

dm_willow_high_ac = willow_this.*ac;
dm_willow_high_cropland = willow_this.*cropland;
dm_willow_high_cropland_ac = willow_this.*cropland_ac;

[dm_willow_high_ac_5arcmin, ~, ~, ~, ~]  = aggregateMatrix2givenDimensions( dm_willow_high_ac,lon,lat, 4320, 2160 );
[dm_willow_high_cropland_5arcmin, ~, ~, ~, ~]  = aggregateMatrix2givenDimensions( dm_willow_high_cropland,lon,lat, 4320, 2160 );

[dm_willow_high_cropland_ac_5arcmin, ~, ~, ~, ~]  = aggregateMatrix2givenDimensions( dm_willow_high_cropland_ac,lon,lat, 4320, 2160 );

mean_dm_yield_willow_cropland_ac_5arcmin = dm_willow_high_cropland_ac_5arcmin./cropland_ac_with_values_5arcmin;
mean_dm_yield_willow_cropland_ac_5arcmin(isnan(mean_dm_yield_willow_cropland_ac_5arcmin)) = -999;

mean_dm_yield_willow_ac_5arcmin = dm_willow_high_ac_5arcmin./ac_with_values_5arcmin;
mean_dm_yield_willow_ac_5arcmin(isnan(mean_dm_yield_willow_ac_5arcmin)) = -999;

mean_dm_yield_willow_cropland_5arcmin = dm_willow_high_cropland_5arcmin./cropland_with_values_5arcmin;
mean_dm_yield_willow_cropland_5arcmin(isnan(mean_dm_yield_willow_ac_5arcmin)) = -999;

lhv_willow = 18.49;
carbon_content = 0.498;


%% EXPORT


lat = lat_5arcmin;
lon = lon_5arcmin;

nccreate(filename_out,'lat','Dimensions',{'lat' length(lat)});
ncwriteatt(filename_out, 'lat', 'standard_name', 'latitude');
ncwriteatt(filename_out, 'lat', 'long_name', 'latitude');
ncwriteatt(filename_out, 'lat', 'units', 'degrees_north');
ncwriteatt(filename_out, 'lat', '_CoordinateAxisType', 'Lat');
ncwriteatt(filename_out, 'lat', 'axis', 'Y');

nccreate(filename_out,'lon','Dimensions',{'lon' length(lon)});
ncwriteatt(filename_out, 'lon', 'standard_name', 'longitude');
ncwriteatt(filename_out, 'lon', 'long_name', 'longitude');
ncwriteatt(filename_out, 'lon', 'units', 'degrees_east');
ncwriteatt(filename_out, 'lon', '_CoordinateAxisType', 'Lon');
ncwriteatt(filename_out, 'lon', 'axis', 'X');

nccreate(filename_out, 'dm_ac_high', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename_out, 'dm_ac_high', 'standard_name', 'willow_dm_high_performance');
ncwriteatt(filename_out, 'dm_ac_high', 'long_name', 'willow_dm_abandoned_cropland_high_performance');
ncwriteatt(filename_out, 'dm_ac_high', 'units', 'ton dm yr-1');
ncwriteatt(filename_out, 'dm_ac_high', 'missing_value', '-999');

nccreate(filename_out, 'dm_cropland_high', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename_out, 'dm_cropland_high', 'standard_name', 'willow_dm_cropland_high_performance');
ncwriteatt(filename_out, 'dm_cropland_high', 'long_name', 'willow_dm_cropland_high_performance');
ncwriteatt(filename_out, 'dm_cropland_high', 'units', 'ton dm yr-1');
ncwriteatt(filename_out, 'dm_cropland_high', 'missing_value', '-999');

nccreate(filename_out, 'dm_yield_ac_high', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename_out, 'dm_yield_ac_high', 'standard_name', 'willow_dm_yield_high_performance');
ncwriteatt(filename_out, 'dm_yield_ac_high', 'long_name', 'willow_dm_yield_abandoned_cropland_high_performance');
ncwriteatt(filename_out, 'dm_yield_ac_high', 'units', 'ton dm ha-1 yr-1');
ncwriteatt(filename_out, 'dm_yield_ac_high', 'missing_value', '-999');

nccreate(filename_out, 'dm_yield_cropland_high', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename_out, 'dm_yield_cropland_high', 'standard_name', 'willow_dm_yield_cropland_high_performance');
ncwriteatt(filename_out, 'dm_yield_cropland_high', 'long_name', 'willow_dm_yield_cropland_high_performance');
ncwriteatt(filename_out, 'dm_yield_cropland_high', 'units', 'ton dm ha-1 yr-1');
ncwriteatt(filename_out, 'dm_yield_cropland_high', 'missing_value', '-999');

nccreate(filename_out, 'dm_yield_ac_cropland_high', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename_out, 'dm_yield_ac_cropland_high', 'standard_name', 'willow_dm_yield_cropland_high_performance');
ncwriteatt(filename_out, 'dm_yield_ac_cropland_high', 'long_name', 'willow_dm_yield_cropland_high_performance');
ncwriteatt(filename_out, 'dm_yield_ac_cropland_high', 'units', 'ton dm ha-1 yr-1');
ncwriteatt(filename_out, 'dm_yield_ac_cropland_high', 'missing_value', '-999');

ncwrite(filename_out, 'lat', lat);
ncwrite(filename_out, 'lon', lon);
ncwrite(filename_out, 'dm_ac_high', dm_willow_high_ac_5arcmin);
ncwrite(filename_out, 'dm_cropland_high', dm_willow_high_cropland_5arcmin),
ncwrite(filename_out, 'dm_yield_ac_high', mean_dm_yield_willow_ac_5arcmin)
ncwrite(filename_out, 'dm_yield_cropland_high', mean_dm_yield_willow_cropland_5arcmin)
ncwrite(filename_out, 'dm_yield_ac_cropland_high', mean_dm_yield_willow_cropland_ac_5arcmin)

