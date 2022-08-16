
addpath(genpath(pwd()));

nordic_countries = {'Norway', 'Sweden', 'Finland', 'Denmark'};

IDs = zeros(1,length(nordic_countries));

CountryMasks = importCountryMasks();
Soil_erosion_water = RUSLE('Input/GloSEM_SE_2015_IMAGE_LU_5arcmin.nc');

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

abandoned_cropland_ilswe_4_hectare = abandoned_cropland_30arcsec_hectare.*(ilswe_30arcsec == 4);
abandoned_cropland_ilswe_5_hectare = abandoned_cropland_30arcsec_hectare.*(ilswe_30arcsec == 5);


skipRest = 0;
if skipRest == 1
    binary_ilswe = ilswe_30arcsec >3; 
    cropland_both_ilswe4_5_and_se_5 = cropland_SE_threshold_5_hectare;
    cropland_both_ilswe4_5_and_se_5(binary_ilswe == 0) = 0;
    [cropland_both_ilswe4_5_and_se_5_5arcmin,lat_5arcmin,lon_5arcmin,~,~]  = aggregateMatrix2givenDimensions(cropland_both_ilswe4_5_and_se_5,lon_30arcsec,lat_30arcsec, 4320, 2160 );
    
    
filename = 'Output/cropland_both_ilswe_4_5_and_se_5.nc';

if exist(filename, 'file')
   delete(filename); 
end

lat = lat_5arcmin;
lon = lon_5arcmin;


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

nccreate(filename, 'cropland_ilswe_4_5_and_se_5', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'cropland_ilswe_4_5_and_se_5', 'standard_name', 'cropland_ilswe_4_5_and_se_5');
ncwriteatt(filename, 'cropland_ilswe_4_5_and_se_5', 'long_name', 'cropland_ilswe_4_5_and_se_5');
ncwriteatt(filename, 'cropland_ilswe_4_5_and_se_5', 'units', 'hectare');
ncwriteatt(filename, 'cropland_ilswe_4_5_and_se_5', 'missing_value', '-999');

ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);
ncwrite(filename, 'cropland_ilswe_4_5_and_se_5', cropland_both_ilswe4_5_and_se_5_5arcmin);
    
else
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
        
        RegionalMask_array(i).abandoned_cropland_ilswe_4_hectare = abandoned_cropland_ilswe_4_hectare.*RegionalMask_array(i).fraction_of_cell_is_region;
        RegionalMask_array(i).abandoned_cropland_ilswe_5_hectare = abandoned_cropland_ilswe_5_hectare.*RegionalMask_array(i).fraction_of_cell_is_region;
        
        %Binary masks gives:
        RegionalMask_array(i).cropland_floods_10y_mean_m = floodMap.*RegionalMask_array(i).fraction_of_cell_is_region;
    end
    
    clear cropland_*
    clear abandoned_cropland*
    
    fprintf('Upscale and export. \n')
    
    RegionalMask_5arcmin_array(1:length(RegionalMask_array)) = RegionalMask;
    for i = 1:length(RegionalMask_array)
        fprintf(['Upscaling for: ' RegionalMask_array(i).region_name '\n']);
        RegionalMask_5arcmin_array(i) = RegionalMask_array(i).upscale_regional_mask(4320, 2160);
        RegionalMask_5arcmin_array(i).export2netcdf();
    end
    
    
    
    
    
end
%Nordic_5arcmin = RegionalMask_array(1).upscale_regional_mask(4320, 2160);