function  preproc_CookPatton(  )
%PREPROC_COOKPATTON Summary of this function goes here
%   Detailed explanation goes here

file_seq = 'Input/nat_veg_regrowth/sequestration_rate_layer_in_full_extent.tif';


[seq_C_per_ha,R] = geotiffread(file_seq);

seq_C_per_ha = double(seq_C_per_ha');

seq_C_per_ha(isnan(seq_C_per_ha)) = 0;

mSize = size(seq_C_per_ha);
lat_step = 180/mSize(2);
lon_step = 360/mSize(1);

lat = [90-lat_step/2:-lat_step:-90+lat_step/2];
lon = [-180+lon_step/2:lon_step:180-lon_step/2];

lat_bnds = zeros(2,mSize(2));
lat_bnds(1,:) = [90:-lat_step:-90+lat_step];
lat_bnds(2,:) = [90-lat_step:-lat_step:-90];

areaPerLatitude_hectare = get_cell_area_per_latitude(lat_bnds, lon_step);


%% Import cropland
description_cropland = 'Cropland in 2018 from ESA CCI-LC';
ncid_cropland = netcdf.open('Input/Croplands_Global_2018_30arcsec_timestamp_2020_09_17_1115.nc');
cropland_30arcsec_hectare = netcdf.getVar(ncid_cropland, 3);

%% Import abandoned cropland
description_ac = 'Abandoned cropland between 1992 and 2018 from ESA CCI-LC';
ncid_ac = netcdf.open('Input/abandoned_cropland_1992_2018_30_arcsec_timestamp_2020_06_29_1847.nc');
abandoned_cropland_30arcsec_hectare = netcdf.getVar(ncid_ac,3);


seq_C_cropland_30arcsec  = seq_C_per_ha.*cropland_30arcsec_hectare;
seq_C_abandoned_cropland_30arcsec = seq_C_per_ha.*abandoned_cropland_30arcsec_hectare;


export_30arcsec = 0;
if export_30arcsec == 1
    filename = 'seq_C_per_ha_30arcsec.nc';
    
    if exist(filename)
       delete(filename); 
    end
    
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
    
    nccreate(filename, 'ref', 'Datatype', 'char', 'Dimensions', {'dim1', inf});
    ncwriteatt(filename, 'ref', 'standard_name', 'ref_data');
    ncwriteatt(filename, 'ref', 'long_name', 'ref_data');
    
    nccreate(filename, 'area_after_latitude', 'Dimensions', { 'lat' length(lat)}, 'DeflateLevel', 4);
    ncwriteatt(filename, 'area_after_latitude', 'standard_name', 'area_after_latitude');
    ncwriteatt(filename, 'area_after_latitude', 'long_name', 'area_after_latitude');
    ncwriteatt(filename, 'area_after_latitude', 'units', 'ha');
    ncwriteatt(filename, 'area_after_latitude', 'missing_value', '-999');
    
    
    nccreate(filename, 'carbon_sequestration', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
    ncwriteatt(filename, 'carbon_sequestration', 'standard_name', 'carbon_sequestration');
    ncwriteatt(filename, 'carbon_sequestration', 'long_name', 'carbon_sequestration_natural_regrowth_ton_per_hectare_per_year');
    ncwriteatt(filename, 'carbon_sequestration', 'units', 'tonC ha-1 yr-1');
    ncwriteatt(filename, 'carbon_sequestration', 'missing_value', '-999');
    
    ncwrite(filename, 'lat', lat);
    ncwrite(filename, 'lon', lon);
    ncwrite(filename, 'ref', 'Cook-Patton et al. (2020)');
    ncwrite(filename, 'area_after_latitude', areaPerLatitude_hectare);
    ncwrite(filename, 'carbon_sequestration', seq_C_per_ha);
    
end




export_5arcmin = 1;
if export_5arcmin == 1
    
    seq_C = seq_C_per_ha*diag(areaPerLatitude_hectare);
    
    fprintf('upscaling_global. \n');
    [seq_C_5arcmin, ~, ~, ~, ~] = aggregateMatrix2givenDimensions(seq_C, lon, lat, 4320, 2160);
    fprintf('upscaling_cropland');
    [seq_C_cropland_5arcmin, ~, ~, ~, ~] = aggregateMatrix2givenDimensions(seq_C_cropland_30arcsec, lon, lat, 4320, 2160);
    [cropland_hectare_5arcmin, ~, ~, ~, ~] = aggregateMatrix2givenDimensions(cropland_30arcsec_hectare, lon, lat, 4320, 2160);
    
    seq_C_per_ha_cropland_5arcmin = seq_C_cropland_5arcmin./cropland_hectare_5arcmin;
    seq_C_per_ha_cropland_5arcmin(isnan(seq_C_per_ha_cropland_5arcmin)) = -999;
    
    fprintf('upscaling_abandoned_cropland');
    [seq_C_abandoned_cropland_5arcmin, ~, ~, ~, ~] = aggregateMatrix2givenDimensions(seq_C_abandoned_cropland_30arcsec, lon, lat, 4320, 2160);
    [abandoned_cropland_hectare_5arcmin, lat_5arcmin, lon_5arcmin, lat_bnds_5arcmin, ~] = aggregateMatrix2givenDimensions(abandoned_cropland_30arcsec_hectare, lon, lat, 4320, 2160);
    
    seq_C_per_ha_abandoned_cropland_5arcmin = seq_C_abandoned_cropland_5arcmin./abandoned_cropland_hectare_5arcmin;
    seq_C_per_ha_abandoned_cropland_5arcmin(isnan(seq_C_per_ha_abandoned_cropland_5arcmin)) = -999;
    
    seq_C_per_ha_5arcmin = seq_C_5arcmin;
    
    areaPerLatitude_hectare_5arcmin = get_cell_area_per_latitude(lat_bnds_5arcmin, 180/2160);
    
    for i = 1:2160
        seq_C_per_ha_5arcmin(:,i) = seq_C_per_ha_5arcmin(:,i)/areaPerLatitude_hectare_5arcmin(i);
    end
    
    filename = 'seq_C_per_ha_5arcmin.nc';
    
    nccreate(filename,'lat','Dimensions',{'lat' length(lat_5arcmin)});
    ncwriteatt(filename, 'lat', 'standard_name', 'latitude');
    ncwriteatt(filename, 'lat', 'long_name', 'latitude');
    ncwriteatt(filename, 'lat', 'units', 'degrees_north');
    ncwriteatt(filename, 'lat', '_CoordinateAxisType', 'Lat');
    ncwriteatt(filename, 'lat', 'axis', 'Y');
    
    nccreate(filename,'lon','Dimensions',{'lon' length(lon_5arcmin)});
    ncwriteatt(filename, 'lon', 'standard_name', 'longitude');
    ncwriteatt(filename, 'lon', 'long_name', 'longitude');
    ncwriteatt(filename, 'lon', 'units', 'degrees_east');
    ncwriteatt(filename, 'lon', '_CoordinateAxisType', 'Lon');
    ncwriteatt(filename, 'lon', 'axis', 'X');
    
    nccreate(filename, 'ref_nat_reg', 'Datatype', 'char', 'Dimensions', {'dim1', inf});
    ncwriteatt(filename, 'ref_nat_reg', 'standard_name', 'ref_nat_reg');
    ncwriteatt(filename, 'ref_nat_reg', 'long_name', 'ref_nat_reg');
    
    nccreate(filename, 'ref_lc', 'Datatype', 'char', 'Dimensions', {'dim1', inf});
    ncwriteatt(filename, 'ref_lc', 'standard_name', 'ref_lc');
    ncwriteatt(filename, 'ref_lc', 'long_name', 'ref_lc');
    
    nccreate(filename, 'area_after_latitude', 'Dimensions', { 'lat' length(lat_5arcmin)}, 'DeflateLevel', 4);
    ncwriteatt(filename, 'area_after_latitude', 'standard_name', 'area_after_latitude');
    ncwriteatt(filename, 'area_after_latitude', 'long_name', 'area_after_latitude');
    ncwriteatt(filename, 'area_after_latitude', 'units', 'ha');
    ncwriteatt(filename, 'area_after_latitude', 'missing_value', '-999');
    
    
    nccreate(filename, 'carbon_sequestration_rate', 'Dimensions', {'lon' length(lon_5arcmin) 'lat' length(lat_5arcmin)}, 'DeflateLevel', 4);
    ncwriteatt(filename, 'carbon_sequestration_rate', 'standard_name', 'carbon_sequestration');
    ncwriteatt(filename, 'carbon_sequestration_rate', 'long_name', 'carbon_sequestration_natural_regrowth_ton_per_hectare_per_year');
    ncwriteatt(filename, 'carbon_sequestration_rate', 'units', 'tonC ha-1 yr-1');
    ncwriteatt(filename, 'carbon_sequestration_rate', 'missing_value', '-999');
    
    nccreate(filename, 'carbon_sequestration_rate_cropland', 'Dimensions', {'lon' length(lon_5arcmin) 'lat' length(lat_5arcmin)}, 'DeflateLevel', 4);
    ncwriteatt(filename, 'carbon_sequestration_rate_cropland', 'standard_name', 'carbon_sequestration_rate_cropland');
    ncwriteatt(filename, 'carbon_sequestration_rate_cropland', 'long_name', 'carbon_sequestration_rate_cropland_natural_regrowth_ton_per_hectare_per_year');
    ncwriteatt(filename, 'carbon_sequestration_rate_cropland', 'units', 'tonC ha-1 yr-1');
    ncwriteatt(filename, 'carbon_sequestration_rate_cropland', 'missing_value', '-999');
    
    nccreate(filename, 'carbon_sequestration_rate_abandoned_cropland', 'Dimensions', {'lon' length(lon_5arcmin) 'lat' length(lat_5arcmin)}, 'DeflateLevel', 4);
    ncwriteatt(filename, 'carbon_sequestration_rate_abandoned_cropland', 'standard_name', 'carbon_sequestration_rate_abandoned_cropland');
    ncwriteatt(filename, 'carbon_sequestration_rate_abandoned_cropland', 'long_name', 'carbon_sequestration_rate_abandoned_cropland_natural_regrowth_ton_per_hectare_per_year');
    ncwriteatt(filename, 'carbon_sequestration_rate_abandoned_cropland', 'units', 'tonC ha-1 yr-1');
    ncwriteatt(filename, 'carbon_sequestration_rate_abandoned_cropland', 'missing_value', '-999');
    
    nccreate(filename, 'cropland', 'Dimensions', {'lon' length(lon_5arcmin) 'lat' length(lat_5arcmin)}, 'DeflateLevel', 4);
    ncwriteatt(filename, 'cropland', 'standard_name', 'cropland_hectare');
    ncwriteatt(filename, 'cropland', 'long_name', 'cropland_hectare');
    ncwriteatt(filename, 'cropland', 'units', 'hectare');
    ncwriteatt(filename, 'cropland', 'missing_value', '-999');
    
    nccreate(filename, 'abandoned_cropland', 'Dimensions', {'lon' length(lon_5arcmin) 'lat' length(lat_5arcmin)}, 'DeflateLevel', 4);
    ncwriteatt(filename, 'abandoned_cropland', 'standard_name', 'abandoned_cropland_hectare');
    ncwriteatt(filename, 'abandoned_cropland', 'long_name', 'abandoned_cropland_hectare');
    ncwriteatt(filename, 'abandoned_cropland', 'units', 'hectare');
    ncwriteatt(filename, 'abandoned_cropland', 'missing_value', '-999');
    
    nccreate(filename, 'carbon_sequestration_cropland', 'Dimensions', {'lon' length(lon_5arcmin) 'lat' length(lat_5arcmin)}, 'DeflateLevel', 4);
    ncwriteatt(filename, 'carbon_sequestration_cropland', 'standard_name', 'carbon_sequestration_cropland');
    ncwriteatt(filename, 'carbon_sequestration_cropland', 'long_name', 'carbon_sequestration_cropland_ton_per_year');
    ncwriteatt(filename, 'carbon_sequestration_cropland', 'units', 'tonC ha-1 yr-1');
    ncwriteatt(filename, 'carbon_sequestration_cropland', 'missing_value', '-999');
    
    nccreate(filename, 'carbon_sequestration_abandoned_cropland', 'Dimensions', {'lon' length(lon_5arcmin) 'lat' length(lat_5arcmin)}, 'DeflateLevel', 4);
    ncwriteatt(filename, 'carbon_sequestration_abandoned_cropland', 'standard_name', 'carbon_sequestration_abandoned_cropland');
    ncwriteatt(filename, 'carbon_sequestration_abandoned_cropland', 'long_name', 'carbon_sequestration_abandoned_cropland_ton_per_year');
    ncwriteatt(filename, 'carbon_sequestration_abandoned_cropland', 'units', 'tonC ha-1 yr-1');
    ncwriteatt(filename, 'carbon_sequestration_abandoned_cropland', 'missing_value', '-999');
    
    ncwrite(filename, 'lat', lat_5arcmin);
    ncwrite(filename, 'lon', lon_5arcmin);
    ncwrite(filename, 'ref_nat_reg', 'Cook-Patton et al. (2020)');
    ncwrite(filename, 'ref_lc', 'ESA CCI-LC');
    ncwrite(filename, 'area_after_latitude', areaPerLatitude_hectare_5arcmin);
    ncwrite(filename, 'carbon_sequestration_rate', seq_C_per_ha_5arcmin);
    ncwrite(filename, 'carbon_sequestration_rate_cropland', seq_C_per_ha_cropland_5arcmin);
    ncwrite(filename, 'carbon_sequestration_rate_abandoned_cropland', seq_C_per_ha_abandoned_cropland_5arcmin);
    
    ncwrite(filename, 'cropland', cropland_hectare_5arcmin);
    ncwrite(filename, 'abandoned_cropland', abandoned_cropland_hectare_5arcmin);
    
    ncwrite(filename, 'carbon_sequestration_cropland', seq_C_cropland_5arcmin);
    ncwrite(filename, 'carbon_sequestration_abandoned_cropland', seq_C_abandoned_cropland_5arcmin);

end

end

