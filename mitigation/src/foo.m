% filename = 'ILSWE_30arcsec.nc';
% 
% nccreate(filename,'lat','Dimensions',{'lat' length(lat)});
% ncwriteatt(filename, 'lat', 'standard_name', 'latitude');
% ncwriteatt(filename, 'lat', 'long_name', 'latitude');
% ncwriteatt(filename, 'lat', 'units', 'degrees_north');
% ncwriteatt(filename, 'lat', '_CoordinateAxisType', 'Lat');
% ncwriteatt(filename, 'lat', 'axis', 'Y');
% 
% nccreate(filename,'lon','Dimensions',{'lon' length(lon)});
% ncwriteatt(filename, 'lon', 'standard_name', 'longitude');
% ncwriteatt(filename, 'lon', 'long_name', 'longitude');
% ncwriteatt(filename, 'lon', 'units', 'degrees_east');
% ncwriteatt(filename, 'lon', '_CoordinateAxisType', 'Lon');
% ncwriteatt(filename, 'lon', 'axis', 'X');
% 
% nccreate(filename, 'ilswe', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
% ncwriteatt(filename, 'ilswe', 'standard_name', 'land_susceptability_to_wind_erosion');
% ncwriteatt(filename, 'ilswe', 'long_name', 'land_susceptability_to_wind_erosion');
% ncwriteatt(filename, 'ilswe', 'units', '');
% ncwriteatt(filename, 'ilswe', 'missing_value', '-999');

ncwrite(filename, 'lat', lat)
ncwrite(filename, 'lon', lon)
ncwrite(filename, 'ilswe', wse_map);