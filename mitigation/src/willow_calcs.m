function willow_calcs( )
%WILLOW_CALCS Summary of this function goes here
%   Detailed explanation goes here

addpath(genpath(pwd()));

nordic_countries = {'Norway', 'Sweden', 'Finland', 'Denmark'};

IDs = zeros(1,length(nordic_countries));

CountryMasks = importCountryMasks();

ncid_ac = netcdf.open('Input/abandoned_cropland_1992_2018_30_arcsec_timestamp_2020_06_29_1847.nc');
abandoned_cropland_30arcsec_hectare = netcdf.getVar(ncid_ac,3);
abandoned_cropland_30arcsec_fractions = netcdf.getVar(ncid_ac,4);
lat_30arcsec = netcdf.getVar(ncid_ac,0);
lon_30arcsec = netcdf.getVar(ncid_ac,1);

ncid_cropland = netcdf.open('Input/Croplands_Global_2018_30arcsec_timestamp_2020_09_17_1115.nc');
cropland_30arcsec_hectare = netcdf.getVar(ncid_cropland, 3);
cropland_30arcsec_fractions = netcdf.getVar(ncid_cropland, 4);

ncid_cropland_soil_erosion_threshold_5 = netcdf.open('Input/Cropland_CCI_2018_under_soil_erosion_pressure_2015_GloSEM_30arcsec_threshold_5.nc');
cropland_SE_threshold_5_hectare = netcdf.getVar(ncid_cropland_soil_erosion_threshold_5, 6);
cropland_SE_threshold_5_fractions = netcdf.getVar(ncid_cropland_soil_erosion_threshold_5, 7);
ncid_cropland_soil_erosion_threshold_10 = netcdf.open('Input/Cropland_CCI_2018_under_soil_erosion_pressure_2015_GloSEM_30arcsec_threshold_10.nc');
cropland_SE_threshold_10_hectare = netcdf.getVar(ncid_cropland_soil_erosion_threshold_10, 6);
cropland_SE_threshold_10_fractions = netcdf.getVar(ncid_cropland_soil_erosion_threshold_10, 7);

%Import ILSWE
ncid_ilswe = netcdf.open('Input/ILSWE_30arcsec.nc');
ilswe_30arcsec = netcdf.getVar(ncid_ilswe,2);

cropland_ilswe_1_hectare = cropland_30arcsec_hectare.*(ilswe_30arcsec == 1);
cropland_ilswe_2_hectare = cropland_30arcsec_hectare.*(ilswe_30arcsec == 2);
cropland_ilswe_3_hectare = cropland_30arcsec_hectare.*(ilswe_30arcsec == 3);
cropland_ilswe_4_hectare = cropland_30arcsec_hectare.*(ilswe_30arcsec == 4);
cropland_ilswe_5_hectare = cropland_30arcsec_hectare.*(ilswe_30arcsec == 5);

% Import 10y Flood
[ floodMap, ~, ~] = getFloodMap(  );
cropland_floods = cropland_30arcsec_hectare.*(floodMap > 0);

RegionalMask_array(1:length(nordic_countries)+1) = RegionalMask(CountryMasks.longitudeVector_mask_centered, CountryMasks.latitudeVector_mask_centered, CountryMasks.longitude_bounds, CountryMasks.latitude_bounds);


fprintf('Creating regional masks. \n');
for i = 1:length(nordic_countries)
   country = nordic_countries{i};
   
   for j = 1:length(CountryMasks.CountryArray)
       if strcmp(CountryMasks.CountryArray(j).country_name, nordic_countries{i})
          IDs(i) = CountryMasks.CountryArray(j).GPW_country_ISO_numeric;
          RegionalMask_array(1).fraction_of_cell_is_region(CountryMasks.countryMask == IDs(i)) = 1;
          RegionalMask_array(i+1).fraction_of_cell_is_region(CountryMasks.countryMask == IDs(i)) = 1;
          RegionalMask_array(i+1).area_mask_hectare = RegionalMask_array(i+1).fraction_of_cell_is_region*diag(RegionalMask_array(i+1).cell_area_per_latitude_hectare);
          RegionalMask_array(i+1).region_name = CountryMasks.CountryArray(j).country_name;
          RegionalMask_array(i+1)
          fprintf('One \n')
          break
       end
   end
end

RegionalMask_array(1).area_mask_hectare = RegionalMask_array(1).fraction_of_cell_is_region*diag(RegionalMask_array(1).cell_area_per_latitude_hectare);
RegionalMask_array(1).region_name = 'Nordic region';

for i = 1:length(RegionalMask_array)
    fprintf(['Calculating for: ' RegionalMask_array(i).region_name '\n']);
RegionalMask_array(i).abandoned_cropland_hectare = abandoned_cropland_30arcsec_hectare.*RegionalMask_array(i).fraction_of_cell_is_region;
RegionalMask_array(i).abandoned_cropland_fractions = abandoned_cropland_30arcsec_fractions.*RegionalMask_array(i).fraction_of_cell_is_region;
RegionalMask_array(i).cropland_hectare = cropland_30arcsec_hectare.*RegionalMask_array(i).fraction_of_cell_is_region;
RegionalMask_array(i).cropland_fractions = cropland_30arcsec_hectare.*RegionalMask_array(i).fraction_of_cell_is_region;
RegionalMask_array(i).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare = cropland_SE_threshold_5_hectare.*RegionalMask_array(i).fraction_of_cell_is_region;
RegionalMask_array(i).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_fractions = cropland_SE_threshold_5_fractions.*RegionalMask_array(i).fraction_of_cell_is_region;
RegionalMask_array(i).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare = cropland_SE_threshold_10_hectare.*RegionalMask_array(i).fraction_of_cell_is_region;
RegionalMask_array(i).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_fractions = cropland_SE_threshold_10_fractions.*RegionalMask_array(i).fraction_of_cell_is_region;
RegionalMask_array(i).cropland_ilswe_1_hectare = cropland_ilswe_1_hectare.*RegionalMask_array(i).fraction_of_cell_is_region;
RegionalMask_array(i).cropland_ilswe_2_hectare = cropland_ilswe_2_hectare.*RegionalMask_array(i).fraction_of_cell_is_region;
RegionalMask_array(i).cropland_ilswe_3_hectare = cropland_ilswe_3_hectare.*RegionalMask_array(i).fraction_of_cell_is_region;
RegionalMask_array(i).cropland_ilswe_4_hectare = cropland_ilswe_4_hectare.*RegionalMask_array(i).fraction_of_cell_is_region;
RegionalMask_array(i).cropland_ilswe_5_hectare = cropland_ilswe_5_hectare.*RegionalMask_array(i).fraction_of_cell_is_region;
RegionalMask_array(i).cropland_floods_hectare = cropland_floods.*RegionalMask_array(i).fraction_of_cell_is_region;
%Binary masks gives:
RegionalMask_array(i).cropland_floods_10y_mean_m = floodMap.*RegionalMask_array(i).fraction_of_cell_is_region;
end

%% Import willow data
ncid = netcdf.open('Input/Willow/willow_dm_yields_Mola_Yudego.nc');
willow_low = netcdf.getVar(ncid,2);
willow_mid = netcdf.getVar(ncid,3);
willow_high = netcdf.getVar(ncid,4);

n_cases = sum(sum(RegionalMask_array(i).cropland_hectare > 0 & willow_high < 0));
fprintf(['Number of missing values: ' num2str(n_cases)]);



willow_low(willow_low < 0) = 0;
willow_mid(willow_mid < 0) = 0;
willow_high(willow_high < 0) = 0;


lat = lat_30arcsec;
lon = lon_30arcsec;

RegionalMask_array = RegionalMask_array(1:3);

for i=1:length(RegionalMask_array)
    fprintf(['DM willow calcs for: '  RegionalMask_array(i).region_name]);
    dm_ac_low = willow_low.*RegionalMask_array(i).abandoned_cropland_hectare;
    dm_ac_mid = willow_mid.*RegionalMask_array(i).abandoned_cropland_hectare;
    dm_ac_high = willow_high.*RegionalMask_array(i).abandoned_cropland_hectare;
    
    dm_cropland_low = willow_low.*RegionalMask_array(i).cropland_hectare;
    dm_cropland_mid = willow_mid.*RegionalMask_array(i).cropland_hectare;
    dm_cropland_high = willow_high.*RegionalMask_array(i).cropland_hectare;
    
    dm_cropland_wse5_low = willow_low.*RegionalMask_array(i).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare;
    dm_cropland_wse5_mid = willow_mid.*RegionalMask_array(i).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare;
    dm_cropland_wse5_high = willow_high.*RegionalMask_array(i).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare;
    
    dm_cropland_wse10_low = willow_low.*RegionalMask_array(i).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare;
    dm_cropland_wse10_mid = willow_mid.*RegionalMask_array(i).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare;
    dm_cropland_wse10_high = willow_high.*RegionalMask_array(i).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare;
    
    dm_cropland_ilswe_1_low = willow_low.*RegionalMask_array(i).cropland_ilswe_1_hectare;
    dm_cropland_ilswe_2_low = willow_low.*RegionalMask_array(i).cropland_ilswe_2_hectare;
    dm_cropland_ilswe_3_low = willow_low.*RegionalMask_array(i).cropland_ilswe_3_hectare;
    dm_cropland_ilswe_4_low = willow_low.*RegionalMask_array(i).cropland_ilswe_4_hectare;
    dm_cropland_ilswe_5_low = willow_low.*RegionalMask_array(i).cropland_ilswe_5_hectare;
    
    dm_cropland_ilswe_1_mid = willow_mid.*RegionalMask_array(i).cropland_ilswe_1_hectare;
    dm_cropland_ilswe_2_mid = willow_mid.*RegionalMask_array(i).cropland_ilswe_2_hectare;
    dm_cropland_ilswe_3_mid = willow_mid.*RegionalMask_array(i).cropland_ilswe_3_hectare;
    dm_cropland_ilswe_4_mid = willow_mid.*RegionalMask_array(i).cropland_ilswe_4_hectare;
    dm_cropland_ilswe_5_mid = willow_mid.*RegionalMask_array(i).cropland_ilswe_5_hectare;
    
    dm_cropland_ilswe_1_high = willow_high.*RegionalMask_array(i).cropland_ilswe_1_hectare;
    dm_cropland_ilswe_2_high = willow_high.*RegionalMask_array(i).cropland_ilswe_2_hectare;
    dm_cropland_ilswe_3_high = willow_high.*RegionalMask_array(i).cropland_ilswe_3_hectare;
    dm_cropland_ilswe_4_high = willow_high.*RegionalMask_array(i).cropland_ilswe_4_hectare;
    dm_cropland_ilswe_5_high = willow_high.*RegionalMask_array(i).cropland_ilswe_5_hectare;
    
    
    dm_cropland_floods_low = willow_low.*RegionalMask_array(i).cropland_floods_hectare;
    dm_cropland_floods_mid = willow_mid.*RegionalMask_array(i).cropland_floods_hectare;
    dm_cropland_floods_high = willow_high.*RegionalMask_array(i).cropland_floods_hectare;
    
    export_30arcsec = 1;
    if export_30arcsec == 1
        filename_out = ['Willow_' RegionalMask_array(i).region_name '_30arcsec.nc'];
        
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
        
        nccreate(filename_out, 'dm_ac_low', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_ac_low', 'standard_name', 'willow_dm_ac_low_performance');
        ncwriteatt(filename_out, 'dm_ac_low', 'long_name', 'willow_dm_abandoned_cropland_low_performance');
        ncwriteatt(filename_out, 'dm_ac_low', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_ac_low', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_ac_med', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_ac_med', 'standard_name', 'willow_dm_ac_medium_performance');
        ncwriteatt(filename_out, 'dm_ac_med', 'long_name', 'willow_dm_abandoned_cropland_medium_performance');
        ncwriteatt(filename_out, 'dm_ac_med', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_ac_med', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_ac_high', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_ac_high', 'standard_name', 'willow_dm_high_performance');
        ncwriteatt(filename_out, 'dm_ac_high', 'long_name', 'willow_dm_abandoned_cropland_high_performance');
        ncwriteatt(filename_out, 'dm_ac_high', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_ac_high', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_low', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_low', 'standard_name', 'willow_dm_cropland_low_performance');
        ncwriteatt(filename_out, 'dm_cropland_low', 'long_name', 'willow_dm_cropland_low_performance');
        ncwriteatt(filename_out, 'dm_cropland_low', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_low', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_med', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_med', 'standard_name', 'willow_dm_cropland_medium_performance');
        ncwriteatt(filename_out, 'dm_cropland_med', 'long_name', 'willow_dm_cropland_medium_performance');
        ncwriteatt(filename_out, 'dm_cropland_med', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_med', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_high', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_high', 'standard_name', 'willow_dm_cropland_high_performance');
        ncwriteatt(filename_out, 'dm_cropland_high', 'long_name', 'willow_dm_cropland_high_performance');
        ncwriteatt(filename_out, 'dm_cropland_high', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_high', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_wse5_low', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_wse5_low', 'standard_name', 'willow_dm_cropland_wse5_low_performance');
        ncwriteatt(filename_out, 'dm_cropland_wse5_low', 'long_name', 'willow_dm_cropland_wse5_low_performance');
        ncwriteatt(filename_out, 'dm_cropland_wse5_low', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_wse5_low', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_wse5_med', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_wse5_med', 'standard_name', 'willow_dm_cropland_wse5_medium_performance');
        ncwriteatt(filename_out, 'dm_cropland_wse5_med', 'long_name', 'willow_dm_cropland_wse5_medium_performance');
        ncwriteatt(filename_out, 'dm_cropland_wse5_med', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_wse5_med', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_wse5_high', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_wse5_high', 'standard_name', 'willow_dm_cropland_wse5_high_performance');
        ncwriteatt(filename_out, 'dm_cropland_wse5_high', 'long_name', 'willow_dm_cropland_wse5_high_performance');
        ncwriteatt(filename_out, 'dm_cropland_wse5_high', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_wse5_high', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_wse10_low', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_wse10_low', 'standard_name', 'willow_dm_cropland_wse10_low_performance');
        ncwriteatt(filename_out, 'dm_cropland_wse10_low', 'long_name', 'willow_dm_cropland_wse10_low_performance');
        ncwriteatt(filename_out, 'dm_cropland_wse10_low', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_wse10_low', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_wse10_med', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_wse10_med', 'standard_name', 'willow_dm_cropland_wse10_medium_performance');
        ncwriteatt(filename_out, 'dm_cropland_wse10_med', 'long_name', 'willow_dm_cropland_wse10_medium_performance');
        ncwriteatt(filename_out, 'dm_cropland_wse10_med', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_wse10_med', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_wse10_high', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_wse10_high', 'standard_name', 'willow_dm_cropland_wse10_high_performance');
        ncwriteatt(filename_out, 'dm_cropland_wse10_high', 'long_name', 'willow_dm_cropland_wse10_high_performance');
        ncwriteatt(filename_out, 'dm_cropland_wse10_high', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_wse10_high', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_ilswe1_low', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_ilswe1_low', 'standard_name', 'willow_dm_cropland_ilswe1_low_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe1_low', 'long_name', 'willow_dm_cropland_ilswe1_low_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe1_low', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_ilswe1_low', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_ilswe2_low', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_ilswe2_low', 'standard_name', 'willow_dm_cropland_ilswe2_low_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe2_low', 'long_name', 'willow_dm_cropland_ilswe2_low_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe2_low', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_ilswe2_low', 'missing_value', '-999');
        
        
        nccreate(filename_out, 'dm_cropland_ilswe3_low', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_ilswe3_low', 'standard_name', 'willow_dm_cropland_ilswe3_low_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe3_low', 'long_name', 'willow_dm_cropland_ilswe3_low_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe3_low', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_ilswe3_low', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_ilswe4_low', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_ilswe4_low', 'standard_name', 'willow_dm_cropland_ilswe4_low_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe4_low', 'long_name', 'willow_dm_cropland_ilswe4_low_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe4_low', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_ilswe4_low', 'missing_value', '-999');      
        
        nccreate(filename_out, 'dm_cropland_ilswe5_low', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_ilswe5_low', 'standard_name', 'willow_dm_cropland_ilswe5_low_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe5_low', 'long_name', 'willow_dm_cropland_ilswe5_low_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe5_low', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_ilswe5_low', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_ilswe1_med', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_ilswe1_med', 'standard_name', 'willow_dm_cropland_ilswe1_med_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe1_med', 'long_name', 'willow_dm_cropland_ilswe1_med_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe1_med', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_ilswe1_med', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_ilswe2_med', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_ilswe2_med', 'standard_name', 'willow_dm_cropland_ilswe2_med_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe2_med', 'long_name', 'willow_dm_cropland_ilswe2_med_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe2_med', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_ilswe2_med', 'missing_value', '-999');
        
        
        nccreate(filename_out, 'dm_cropland_ilswe3_med', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_ilswe3_med', 'standard_name', 'willow_dm_cropland_ilswe3_med_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe3_med', 'long_name', 'willow_dm_cropland_ilswe3_med_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe3_med', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_ilswe3_med', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_ilswe4_med', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_ilswe4_med', 'standard_name', 'willow_dm_cropland_ilswe4_med_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe4_med', 'long_name', 'willow_dm_cropland_ilswe4_med_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe4_med', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_ilswe4_med', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_ilswe5_med', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_ilswe5_med', 'standard_name', 'willow_dm_cropland_ilswe5_med_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe5_med', 'long_name', 'willow_dm_cropland_ilswe5_med_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe5_med', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_ilswe5_med', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_ilswe1_high', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_ilswe1_high', 'standard_name', 'willow_dm_cropland_ilswe1_high_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe1_high', 'long_name', 'willow_dm_cropland_ilswe1_high_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe1_high', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_ilswe1_high', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_ilswe2_high', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_ilswe2_high', 'standard_name', 'willow_dm_cropland_ilswe2_high_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe2_high', 'long_name', 'willow_dm_cropland_ilswe2_high_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe2_high', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_ilswe2_high', 'missing_value', '-999');
        
        
        nccreate(filename_out, 'dm_cropland_ilswe3_high', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_ilswe3_high', 'standard_name', 'willow_dm_cropland_ilswe3_high_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe3_high', 'long_name', 'willow_dm_cropland_ilswe3_high_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe3_high', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_ilswe3_high', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_ilswe4_high', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_ilswe4_high', 'standard_name', 'willow_dm_cropland_ilswe4_high_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe4_high', 'long_name', 'willow_dm_cropland_ilswe4_high_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe4_high', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_ilswe4_high', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_ilswe5_high', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_ilswe5_high', 'standard_name', 'willow_dm_cropland_ilswe5_high_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe5_high', 'long_name', 'willow_dm_cropland_ilswe5_high_performance');
        ncwriteatt(filename_out, 'dm_cropland_ilswe5_high', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_ilswe5_high', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_floods_low', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_floods_low', 'standard_name', 'willow_dm_cropland_floods_low_performance');
        ncwriteatt(filename_out, 'dm_cropland_floods_low', 'long_name', 'willow_dm_cropland_floods_low_performance');
        ncwriteatt(filename_out, 'dm_cropland_floods_low', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_floods_low', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_floods_med', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_floods_med', 'standard_name', 'willow_dm_cropland_floods_med_performance');
        ncwriteatt(filename_out, 'dm_cropland_floods_med', 'long_name', 'willow_dm_cropland_floods_med_performance');
        ncwriteatt(filename_out, 'dm_cropland_floods_med', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_floods_med', 'missing_value', '-999');
        
        nccreate(filename_out, 'dm_cropland_floods_high', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
        ncwriteatt(filename_out, 'dm_cropland_floods_high', 'standard_name', 'willow_dm_cropland_floods_high_performance');
        ncwriteatt(filename_out, 'dm_cropland_floods_high', 'long_name', 'willow_dm_cropland_floods_high_performance');
        ncwriteatt(filename_out, 'dm_cropland_floods_high', 'units', 'ton dm yr-1');
        ncwriteatt(filename_out, 'dm_cropland_floods_high', 'missing_value', '-999');
        
        
        
        ncwrite(filename_out, 'lat', lat);
        ncwrite(filename_out, 'lon', lon);
        ncwrite(filename_out, 'dm_ac_low', dm_ac_low);
        ncwrite(filename_out, 'dm_ac_med', dm_ac_mid);
        ncwrite(filename_out, 'dm_ac_high', dm_ac_high);
        ncwrite(filename_out, 'dm_cropland_low', dm_cropland_low);
        ncwrite(filename_out, 'dm_cropland_med', dm_cropland_mid);
        ncwrite(filename_out, 'dm_cropland_high', dm_cropland_high);
        ncwrite(filename_out, 'dm_cropland_wse5_low', dm_cropland_wse5_low);
        ncwrite(filename_out, 'dm_cropland_wse5_med', dm_cropland_wse5_mid);
        ncwrite(filename_out, 'dm_cropland_wse5_high', dm_cropland_wse5_high);
        ncwrite(filename_out, 'dm_cropland_wse10_low', dm_cropland_wse10_low);
        ncwrite(filename_out, 'dm_cropland_wse10_med', dm_cropland_wse10_mid);
        ncwrite(filename_out, 'dm_cropland_wse10_high', dm_cropland_wse10_high);
        ncwrite(filename_out, 'dm_cropland_ilswe1_low', dm_cropland_ilswe_1_low);
        ncwrite(filename_out, 'dm_cropland_ilswe2_low', dm_cropland_ilswe_2_low);
        ncwrite(filename_out, 'dm_cropland_ilswe3_low', dm_cropland_ilswe_3_low);
        ncwrite(filename_out, 'dm_cropland_ilswe4_low', dm_cropland_ilswe_4_low);
        ncwrite(filename_out, 'dm_cropland_ilswe5_low', dm_cropland_ilswe_5_low);
        ncwrite(filename_out, 'dm_cropland_ilswe1_med', dm_cropland_ilswe_1_mid);
        ncwrite(filename_out, 'dm_cropland_ilswe2_med', dm_cropland_ilswe_2_mid);
        ncwrite(filename_out, 'dm_cropland_ilswe3_med', dm_cropland_ilswe_3_mid);
        ncwrite(filename_out, 'dm_cropland_ilswe4_med', dm_cropland_ilswe_4_mid);
        ncwrite(filename_out, 'dm_cropland_ilswe5_med', dm_cropland_ilswe_5_mid);    
        ncwrite(filename_out, 'dm_cropland_ilswe1_high', dm_cropland_ilswe_1_high);
        ncwrite(filename_out, 'dm_cropland_ilswe2_high', dm_cropland_ilswe_2_high);
        ncwrite(filename_out, 'dm_cropland_ilswe3_high', dm_cropland_ilswe_3_high);
        ncwrite(filename_out, 'dm_cropland_ilswe4_high', dm_cropland_ilswe_4_high);
        ncwrite(filename_out, 'dm_cropland_ilswe5_high', dm_cropland_ilswe_5_high);
        ncwrite(filename_out, 'dm_cropland_floods_low', dm_cropland_floods_low);
        ncwrite(filename_out, 'dm_cropland_floods_low', dm_cropland_floods_med);
        ncwrite(filename_out, 'dm_cropland_floods_low', dm_cropland_floods_high);
    end
    
end



end

