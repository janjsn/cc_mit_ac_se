function export2netcdf_windErosion_Europe( wind_erosion_map, lat, lon )
%EXPORT2NETCDF_WINDEROSION Summary of this function goes here
%   Detailed explanation goes here

filename = 'wind_erosion_Europe.nc';

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

nccreate(filename, 'wind_soil_loss', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'wind_soil_loss', 'standard_name', 'wind_soil_loss');
ncwriteatt(filename, 'wind_soil_loss', 'long_name', 'wind_soil_loss');
ncwriteatt(filename, 'wind_soil_loss', 'units', 'ton ha-1 yr-1');
ncwriteatt(filename, 'wind_soil_loss', 'missing_value', '-999');

nccreate(filename, 'ref', 'Datatype', 'char', 'Dimensions', {'dim1', inf});
ncwriteatt(filename, 'ref', 'standard_name', 'reference');
ncwriteatt(filename, 'ref', 'long_name', 'reference');


ncwrite(filename, 'lat', lat)
ncwrite(filename, 'lon', lon);
ncwrite(filename, 'wind_soil_loss', wind_erosion_map);
ncwrite(filename, 'ref', 'Borelli et al. (2016) - A new assessment of soil loss due to wind erosion in european agricultural soils using a quantititive spatially distributed modelling approach');




end

