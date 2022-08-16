
addpath(genpath(pwd()));

nordic_countries = {'Norway', 'Sweden', 'Finland', 'Denmark', 'Iceland'};

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
RegionalMask_array(i).abandoned_cropland_hectare = abandoned_cropland_30arcsec_hectare.*RegionalMask_array(i).fraction_of_cell_is_region;
RegionalMask_array(i).abandoned_cropland_fractions = abandoned_cropland_30arcsec_fractions.*RegionalMask_array(i).fraction_of_cell_is_region;
RegionalMask_array(i).cropland_hectare = cropland_30arcsec_hectare.*RegionalMask_array(i).fraction_of_cell_is_region;
RegionalMask_array(i).cropland_fractions = cropland_30arcsec_hectare.*RegionalMask_array(i).fraction_of_cell_is_region;
RegionalMask_array(i).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare = cropland_SE_threshold_5_hectare.*RegionalMask_array(i).fraction_of_cell_is_region;
RegionalMask_array(i).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_fractions = cropland_SE_threshold_5_fractions.*RegionalMask_array(i).fraction_of_cell_is_region;
RegionalMask_array(i).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare = cropland_SE_threshold_10_hectare.*RegionalMask_array(i).fraction_of_cell_is_region;
RegionalMask_array(i).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_fractions = cropland_SE_threshold_10_fractions.*RegionalMask_array(i).fraction_of_cell_is_region;
end

fprintf('Upscale and export. \n')

RegionalMask_5arcmin_array(1:length(RegionalMask_array)) = RegionalMask;
for i = 1:length(RegionalMask_array)
    RegionalMask_5arcmin_array(i) = RegionalMask_array(i).upscale_regional_mask(4320, 2160);    
    RegionalMask_5arcmin_array(i).export2netcdf();
end
%Nordic_5arcmin = RegionalMask_array(1).upscale_regional_mask(4320, 2160);