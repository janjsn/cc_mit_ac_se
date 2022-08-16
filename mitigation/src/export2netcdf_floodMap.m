function export2netcdf_floodMap( RegionalMask_array )
%EXPORT2NETCDF_FLOODMAP Summary of this function goes here
%   Detailed explanation goes here

[floodMap,lat, lon] = getFloodMap();

for i=1:length(RegionalMask_array)
   region_name = RegionalMask_array(i).region_name;
   
   flooded_croplands = RegionalMask_array(i).cropland_hectare.*(floodMap > 0);
   
   binary_flooded_croplands = flooded_croplands > 0;
   cropland_vector = RegionalMask_array(i).cropland_hectare(binary_flooded_croplands);
   floodValues_vector = floodMap(binary_flooded_croplands);
   
   max_flood_value = max(floodValues_vector);
   
   tenY_flood_threshold = [max_flood_value:-0.01:0];
   
   hectares_above_threshold = zeros(1,length(tenY_flood_threshold));
   
   for j = 1:length(tenY_flood_threshold)
       binary_above = floodValues_vector >= tenY_flood_threshold(j);
       hectares_above_threshold(j) = sum(cropland_vector(binary_above));    
   end
   
   save([region_name '_cropland_above_ten_years_flood_thresholds_m.mat'], 'tenY_flood_threshold', 'hectares_above_threshold');
   
   [flooded_croplands_hectare_5arcmin,lat_5arcmin, lon_5arcmin, latitudeBounds, longitudeBounds]  = aggregateMatrix2givenDimensions(flooded_croplands,lon, lat, 4320, 2160 ); 
   
   [ areaPerLatitude_hectare ] = get_cell_area_per_latitude( latitudeBounds, abs(longitudeBounds(1,1)-longitudeBounds(2,1)));
   
   flooded_croplands_fraction_of_cell_5arcmin = flooded_croplands_hectare_5arcmin;
   for k = 1:length(areaPerLatitude_hectare)
       flooded_croplands_fraction_of_cell_5arcmin(:,k) = flooded_croplands_fraction_of_cell_5arcmin(:,k)/areaPerLatitude_hectare(k);       
   end
   sum(sum(flooded_croplands))
   sum(sum(cropland_vector))
   sum(sum(flooded_croplands_hectare_5arcmin))
  
    
   %% WRITE TO NETCDF
   export2netcdf = 0;
   if export2netcdf == 1
       filename = [region_name '_cropland_under_ten_year_flood_risk.nc'];
       
       nccreate(filename, 'region', 'Datatype', 'char', 'Dimensions', {'dim1', inf});
       ncwriteatt(filename, 'region', 'standard_name', 'region');
       ncwriteatt(filename, 'region', 'long_name', 'region');
       
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
       
       nccreate(filename, 'cropland_under_ten_year_flood_risk_hectare', 'Dimensions', {'lon' length(lon_5arcmin) 'lat' length(lat_5arcmin)}, 'DeflateLevel', 4);
       ncwriteatt(filename, 'cropland_under_ten_year_flood_risk_hectare', 'standard_name', 'cropland_under_ten_year_flood_risk_hectare');
       ncwriteatt(filename, 'cropland_under_ten_year_flood_risk_hectare', 'long_name', 'cropland_under_ten_year_flood_risk_hectare');
       ncwriteatt(filename, 'cropland_under_ten_year_flood_risk_hectare', 'units', 'hectare');
       ncwriteatt(filename, 'cropland_under_ten_year_flood_risk_hectare', 'missing_value', '-999');
       
       nccreate(filename, 'cropland_under_ten_year_flood_risk_fractions', 'Dimensions', {'lon' length(lon_5arcmin) 'lat' length(lat_5arcmin)}, 'DeflateLevel', 4);
       ncwriteatt(filename, 'cropland_under_ten_year_flood_risk_fractions', 'standard_name', 'cropland_under_ten_year_flood_risk_fractions');
       ncwriteatt(filename, 'cropland_under_ten_year_flood_risk_fractions', 'long_name', 'cropland_under_ten_year_flood_risk_fractions');
       ncwriteatt(filename, 'cropland_under_ten_year_flood_risk_fractions', 'units', '');
       ncwriteatt(filename, 'cropland_under_ten_year_flood_risk_fractions', 'missing_value', '-999');
       
       ncwrite(filename, 'region', region_name);
       ncwrite(filename, 'lat', lat_5arcmin);
       ncwrite(filename, 'lon', lon_5arcmin);
       ncwrite(filename, 'cropland_under_ten_year_flood_risk_hectare', flooded_croplands_hectare_5arcmin);
       ncwrite(filename, 'cropland_under_ten_year_flood_risk_fractions', flooded_croplands_fraction_of_cell_5arcmin);
       
   end
   
end

end

