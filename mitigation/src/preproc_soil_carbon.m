ncid_ac = netcdf.open('Input/abandoned_cropland_1992_2018_30_arcsec_timestamp_2020_06_29_1847.nc');
abandoned_cropland_30arcsec_hectare = netcdf.getVar(ncid_ac,3);
lat_30arcsec = netcdf.getVar(ncid_ac,0);
lon_30arcsec = netcdf.getVar(ncid_ac,1);


ncid_cropland = netcdf.open('Input/Croplands_Global_2018_30arcsec_timestamp_2020_09_17_1115.nc');
cropland_30arcsec_hectare = netcdf.getVar(ncid_cropland, 3);
%cropland_30arcsec_fractions = netcdf.getVar(ncid_cropland, 4);


ncid_cropland_soil_erosion_threshold_5 = netcdf.open('Input/Cropland_CCI_2018_under_soil_erosion_pressure_2015_GloSEM_30arcsec_threshold_5.nc');
cropland_SE_threshold_5_hectare = netcdf.getVar(ncid_cropland_soil_erosion_threshold_5, 6);
%cropland_SE_threshold_5_fractions = netcdf.getVar(ncid_cropland_soil_erosion_threshold_5, 7);
ncid_cropland_soil_erosion_threshold_10 = netcdf.open('Input/Cropland_CCI_2018_under_soil_erosion_pressure_2015_GloSEM_30arcsec_threshold_10.nc');
cropland_SE_threshold_10_hectare = netcdf.getVar(ncid_cropland_soil_erosion_threshold_10, 6);
%cropland_SE_threshold_10_fractions = netcdf.getVar(ncid_cropland_soil_erosion_threshold_10, 7);
cropland_SE_between_5_and_10_hectare = cropland_SE_threshold_5_hectare-cropland_SE_threshold_10_hectare;

%Import ILSWE
ncid_ilswe = netcdf.open('Input/ILSWE_30arcsec.nc');
ilswe_30arcsec = netcdf.getVar(ncid_ilswe,2);

cropland_ilswe_1_hectare = cropland_30arcsec_hectare.*(ilswe_30arcsec == 1);
cropland_ilswe_2_hectare = cropland_30arcsec_hectare.*(ilswe_30arcsec == 2);
cropland_ilswe_3_hectare = cropland_30arcsec_hectare.*(ilswe_30arcsec == 3);
cropland_ilswe_4_hectare = cropland_30arcsec_hectare.*(ilswe_30arcsec == 4);
cropland_ilswe_5_hectare = cropland_30arcsec_hectare.*(ilswe_30arcsec == 5);

abandoned_cropland_ilswe_4_hectare = abandoned_cropland_30arcsec_hectare.*(ilswe_30arcsec == 4);
abandoned_cropland_ilswe_5_hectare = abandoned_cropland_30arcsec_hectare.*(ilswe_30arcsec == 5);

[soc_sub, R] = geotiffread('HWSDa_OC_Dens_SUB_30SEC_MD_V1.tif');
[soc_top, R] = geotiffread('HWSDa_OC_Dens_TOP_30SEC_MD_V1.tif');

soc_sub =double(soc_sub);
soc_top = double(soc_top);

mSize = size(soc_sub);
if mSize(2) > mSize(1)
   soc_sub = soc_sub';
   soc_top = soc_top';
end

soc_sub(soc_sub > 10^38) = NaN;
soc_top(soc_top > 10^38) = NaN;

soc_tot_per_ha = soc_sub+soc_top;
binary_missing_data = isnan(soc_tot_per_ha);

%Remove all cells with missing data
cropland_30arcsec_hectare(binary_missing_data) = 0;
cropland_ilswe_4_hectare(binary_missing_data) = 0;
cropland_ilswe_5_hectare(binary_missing_data) =0 ;
cropland_SE_between_5_and_10_hectare(binary_missing_data) = 0;
cropland_SE_threshold_10_hectare(binary_missing_data) = 0;
abandoned_cropland_30arcsec_hectare(binary_missing_data)=0;
abandoned_cropland_ilswe_4_hectare(binary_missing_data) =0;
abandoned_cropland_ilswe_5_hectare(binary_missing_data) = 0;

%Set nans to zero
soc_tot_per_ha(binary_missing_data) = 0;

%Calculate soil carbon on remaining cells
cropland_soc_ton = cropland_30arcsec_hectare.*soc_tot_per_ha;
cropland_ilswe4_soc_ton = cropland_ilswe_4_hectare.*soc_tot_per_ha;
cropland_ilswe5_soc_ton = cropland_ilswe_5_hectare.*soc_tot_per_ha;
cropland_wse_5_to_10_soc_ton = cropland_SE_between_5_and_10_hectare.*soc_tot_per_ha;
cropland_wse_above_10_soc_ton = cropland_SE_threshold_10_hectare.*soc_tot_per_ha;
ac_soc_ton = abandoned_cropland_30arcsec_hectare.*soc_tot_per_ha;
ac_ilswe_4_ton = abandoned_cropland_ilswe_4_hectare.*soc_tot_per_ha;
ac_ilswe_5_ton = abandoned_cropland_ilswe_5_hectare.*soc_tot_per_ha;

%Upscale
new_n_lon = 4320;
new_n_lat = 2160;
[cropland_soc_ton_5arcmin,lat_5arcmin,lon_5arcmin,~,~]  = aggregateMatrix2givenDimensions(cropland_soc_ton,lon_30arcsec,lat_30arcsec, new_n_lon, new_n_lat );
[cropland_ilswe4_soc_ton_5arcmin,lat_5arcmin,lon_5arcmin,~,~]  = aggregateMatrix2givenDimensions(cropland_ilswe4_soc_ton,lon_30arcsec,lat_30arcsec, new_n_lon, new_n_lat );
[cropland_ilswe5_soc_ton_5arcmin,~,~,~,~]  = aggregateMatrix2givenDimensions(cropland_ilswe5_soc_ton,lon_30arcsec,lat_30arcsec, new_n_lon, new_n_lat );

[cropland_wse_5_to_10_soc_ton_5arcmin,~,~,~,~]  = aggregateMatrix2givenDimensions(cropland_wse_5_to_10_soc_ton,lon_30arcsec,lat_30arcsec, new_n_lon, new_n_lat );
[cropland_wse_above_10_soc_ton_5arcmin,~,~,~,~]  = aggregateMatrix2givenDimensions(cropland_wse_above_10_soc_ton,lon_30arcsec,lat_30arcsec, new_n_lon, new_n_lat );

[ac_soc_ton_5arcmin,~,~,~,~]  = aggregateMatrix2givenDimensions(ac_soc_ton,lon_30arcsec,lat_30arcsec, new_n_lon, new_n_lat );
[ac_ilswe_4_ton_5arcmin,~,~,~,~]  = aggregateMatrix2givenDimensions(ac_ilswe_4_ton,lon_30arcsec,lat_30arcsec, new_n_lon, new_n_lat );
[ac_ilswe_5_ton_5arcmin,~,~,~,~]  = aggregateMatrix2givenDimensions(ac_ilswe_5_ton,lon_30arcsec,lat_30arcsec, new_n_lon, new_n_lat );


[cropland_hectare_5arcmin,~,~,~,~]  = aggregateMatrix2givenDimensions(cropland_30arcsec_hectare,lon_30arcsec,lat_30arcsec, new_n_lon, new_n_lat );
[cropland_ilswe_4_hectare_5arcmin,~,~,~,~]  = aggregateMatrix2givenDimensions(cropland_ilswe_4_hectare,lon_30arcsec,lat_30arcsec, new_n_lon, new_n_lat );
[cropland_ilswe_5_hectare_5arcmin,~,~,~,~]  = aggregateMatrix2givenDimensions(cropland_ilswe_5_hectare,lon_30arcsec,lat_30arcsec, new_n_lon, new_n_lat );

[cropland_SE_between_5_and_10_hectare_5arcmin,~,~,~,~]  = aggregateMatrix2givenDimensions(cropland_SE_between_5_and_10_hectare,lon_30arcsec,lat_30arcsec, new_n_lon, new_n_lat );
[cropland_SE_threshold_10_hectare_5arcmin,~,~,~,~]  = aggregateMatrix2givenDimensions(cropland_SE_threshold_10_hectare,lon_30arcsec,lat_30arcsec, new_n_lon, new_n_lat );

[abandoned_cropland_hectare_5arcmin,~,~,~,~]  = aggregateMatrix2givenDimensions(abandoned_cropland_30arcsec_hectare,lon_30arcsec,lat_30arcsec, new_n_lon, new_n_lat );
[abandoned_cropland_ilswe_4_hectare_5arcmin,~,~,~,~]  = aggregateMatrix2givenDimensions(abandoned_cropland_ilswe_4_hectare,lon_30arcsec,lat_30arcsec, new_n_lon, new_n_lat );
[abandoned_cropland_ilswe_5_hectare_5arcmin,~,~,~,~]  = aggregateMatrix2givenDimensions(abandoned_cropland_ilswe_5_hectare,lon_30arcsec,lat_30arcsec, new_n_lon, new_n_lat );

ac_soc_intensity = ac_soc_ton_5arcmin./abandoned_cropland_hectare_5arcmin;
ac_ilswe4_soc_intensity = ac_ilswe_4_ton_5arcmin./abandoned_cropland_ilswe_4_hectare_5arcmin;
ac_ilswe5_soc_intensity = ac_ilswe_5_ton_5arcmin./abandoned_cropland_ilswe_5_hectare_5arcmin;

cropland_soc_intensity = cropland_soc_ton_5arcmin./cropland_hectare_5arcmin;
cropland_soc_intensity(cropland_hectare_5arcmin == 0) = -999;
cropland_ilswe_4_soc_intensity = cropland_ilswe4_soc_ton_5arcmin./cropland_ilswe_4_hectare_5arcmin;
cropland_ilswe_4_soc_intensity(cropland_ilswe_4_hectare_5arcmin == 0) = -999;
cropland_ilswe_5_soc_intensity = cropland_ilswe5_soc_ton_5arcmin./cropland_ilswe_5_hectare_5arcmin;
cropland_ilswe_5_soc_intensity(cropland_ilswe_5_hectare_5arcmin == 0) = -999;
cropland_wse_5_to_10_soc_intensity = cropland_wse_5_to_10_soc_ton_5arcmin./cropland_SE_between_5_and_10_hectare_5arcmin;
cropland_wse_5_to_10_soc_intensity(cropland_wse_5_to_10_soc_ton_5arcmin == 0) = -999;
cropland_wse_above_10_soc_intensity = cropland_wse_above_10_soc_ton_5arcmin./cropland_SE_threshold_10_hectare_5arcmin;
cropland_wse_above_10_soc_intensity(cropland_SE_threshold_10_hectare_5arcmin == 0) = -999;

%ac_soc_intensity = ac_soc_ton_5arcmin./abandoned_cropland_hectare_5arcmin;
ac_soc_intensity(abandoned_cropland_hectare_5arcmin == 0) = -999;
ac_ilswe4_soc_intensity(abandoned_cropland_ilswe_4_hectare_5arcmin == 0) = -999;
ac_ilswe5_soc_intensity(abandoned_cropland_ilswe_5_hectare_5arcmin == 0) = -999;

lat = lat_5arcmin;
lon = lon_5arcmin;


%% EXPORT RESULTS TO 5armcin
filename = 'soc_5arcmin.nc';

nccreate(filename,'lat','Dimensions',{'lat' length(lat)});
ncwriteatt(filename, 'lat', 'standard_name', 'latitude');
ncwriteatt(filename, 'lat', 'long_name', 'latitude');
ncwriteatt(filename, 'lat', 'units', 'degrees_north');
ncwriteatt(filename, 'lat', '_CoordinateAxisType', 'Lat');
ncwriteatt(filename, 'lat', 'axis', 'Y');

nccreate(filename,'lon','Dimensions',{'lon' length(lon)});
ncwriteatt(filename, 'lon', 'standard_name', 'longitude');
ncwriteatt(filename, 'lon', 'long_name', 'longitude');
ncwriteatt(filename, 'lon', 'units', 'degrees_east');
ncwriteatt(filename, 'lon', '_CoordinateAxisType', 'Lon');
ncwriteatt(filename, 'lon', 'axis', 'X');
            
nccreate(filename, 'cropland_soc_intensity', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'cropland_soc_intensity', 'standard_name', 'cropland_soc_intensity');
ncwriteatt(filename, 'cropland_soc_intensity', 'long_name', 'cropland_soc_intensity');
ncwriteatt(filename, 'cropland_soc_intensity', 'units', 'ton ha-1');
ncwriteatt(filename, 'cropland_soc_intensity', 'missing_value', '-999');

nccreate(filename, 'cropland_ilswe_4_soc_intensity', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'cropland_ilswe_4_soc_intensity', 'standard_name', 'cropland_ilswe_4_soc_intensity');
ncwriteatt(filename, 'cropland_ilswe_4_soc_intensity', 'long_name', 'cropland_ilswe_4_soc_intensity');
ncwriteatt(filename, 'cropland_ilswe_4_soc_intensity', 'units', 'ton ha-1');
ncwriteatt(filename, 'cropland_ilswe_4_soc_intensity', 'missing_value', '-999');

nccreate(filename, 'cropland_ilswe_5_soc_intensity', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'cropland_ilswe_5_soc_intensity', 'standard_name', 'cropland_ilswe_5_soc_intensity');
ncwriteatt(filename, 'cropland_ilswe_5_soc_intensity', 'long_name', 'cropland_ilswe_5_soc_intensity');
ncwriteatt(filename, 'cropland_ilswe_5_soc_intensity', 'units', 'ton ha-1');
ncwriteatt(filename, 'cropland_ilswe_5_soc_intensity', 'missing_value', '-999');

nccreate(filename, 'cropland_wse_5_to_10_soc_intensity', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'cropland_wse_5_to_10_soc_intensity', 'standard_name', 'cropland_wse_5_to_10_soc_intensity');
ncwriteatt(filename, 'cropland_wse_5_to_10_soc_intensity', 'long_name', 'cropland_wse_5_to_10_soc_intensity');
ncwriteatt(filename, 'cropland_wse_5_to_10_soc_intensity', 'units', 'ton ha-1');
ncwriteatt(filename, 'cropland_wse_5_to_10_soc_intensity', 'missing_value', '-999');

nccreate(filename, 'cropland_wse_above_10_soc_intensity', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'cropland_wse_above_10_soc_intensity', 'standard_name', 'cropland_wse_above_10_soc_intensity');
ncwriteatt(filename, 'cropland_wse_above_10_soc_intensity', 'long_name', 'cropland_wse_above_10_soc_intensity');
ncwriteatt(filename, 'cropland_wse_above_10_soc_intensity', 'units', 'ton ha-1');
ncwriteatt(filename, 'cropland_wse_above_10_soc_intensity', 'missing_value', '-999');

nccreate(filename, 'abandoned_cropland_soc_intensity', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'abandoned_cropland_soc_intensity', 'standard_name', 'abandoned_cropland_soc_intensity');
ncwriteatt(filename, 'abandoned_cropland_soc_intensity', 'long_name', 'abandoned_cropland_soc_intensity');
ncwriteatt(filename, 'abandoned_cropland_soc_intensity', 'units', 'ton ha-1');
ncwriteatt(filename, 'abandoned_cropland_soc_intensity', 'missing_value', '-999');

nccreate(filename, 'abandoned_cropland_ilswe_4_soc_intensity', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'abandoned_cropland_ilswe_4_soc_intensity', 'standard_name', 'abandoned_cropland_ilswe_4_soc_intensity');
ncwriteatt(filename, 'abandoned_cropland_ilswe_4_soc_intensity', 'long_name', 'abandoned_cropland_ilswe_4_soc_intensity');
ncwriteatt(filename, 'abandoned_cropland_ilswe_4_soc_intensity', 'units', 'ton ha-1');
ncwriteatt(filename, 'abandoned_cropland_ilswe_4_soc_intensity', 'missing_value', '-999');

nccreate(filename, 'abandoned_cropland_ilswe_5_soc_intensity', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'abandoned_cropland_ilswe_5_soc_intensity', 'standard_name', 'abandoned_cropland_ilswe_5_soc_intensity');
ncwriteatt(filename, 'abandoned_cropland_ilswe_5_soc_intensity', 'long_name', 'abandoned_cropland_ilswe_5_soc_intensity');
ncwriteatt(filename, 'abandoned_cropland_ilswe_5_soc_intensity', 'units', 'ton ha-1');
ncwriteatt(filename, 'abandoned_cropland_ilswe_5_soc_intensity', 'missing_value', '-999');

ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);
ncwrite(filename, 'cropland_soc_intensity', cropland_soc_intensity);
ncwrite(filename, 'cropland_ilswe_4_soc_intensity', cropland_ilswe_4_soc_intensity);
ncwrite(filename, 'cropland_ilswe_5_soc_intensity', cropland_ilswe_5_soc_intensity);
ncwrite(filename, 'cropland_wse_5_to_10_soc_intensity', cropland_wse_5_to_10_soc_intensity);
ncwrite(filename, 'cropland_wse_above_10_soc_intensity', cropland_wse_above_10_soc_intensity);
ncwrite(filename, 'abandoned_cropland_soc_intensity', ac_soc_intensity);
ncwrite(filename, 'abandoned_cropland_ilswe_4_soc_intensity', ac_ilswe4_soc_intensity);
ncwrite(filename, 'abandoned_cropland_ilswe_5_soc_intensity', ac_ilswe5_soc_intensity);





