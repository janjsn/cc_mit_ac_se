function export_src_data_fig1( Region )
%EXPORT_SRC_DATA_FIG1 Summary of this function goes here
%   Detailed explanation goes here

filename = 'Output/source_data/fig1.nc';

if exist(filename, 'file')
   delete(filename); 
end

lat = Region.lat;
lon = Region.lon;


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

nccreate(filename, 'cropland_fractions', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'cropland_fractions', 'standard_name', 'cropland_fractions');
ncwriteatt(filename, 'cropland_fractions', 'long_name', 'cropland_fractions');
ncwriteatt(filename, 'cropland_fractions', 'units', 'fractions');
ncwriteatt(filename, 'cropland_fractions', 'missing_value', '-999');

nccreate(filename, 'abandoned_cropland_fractions', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'abandoned_cropland_fractions', 'standard_name', 'abandoned_cropland_fractions');
ncwriteatt(filename, 'abandoned_cropland_fractions', 'long_name', 'abandoned_cropland_fractions');
ncwriteatt(filename, 'abandoned_cropland_fractions', 'units', 'fractions');
ncwriteatt(filename, 'abandoned_cropland_fractions', 'missing_value', '-999');

nccreate(filename, 'cropland_under_pressure', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'cropland_under_pressure', 'standard_name', 'cropland_under_pressure');
ncwriteatt(filename, 'cropland_under_pressure', 'long_name', 'cropland_under_pressure');
ncwriteatt(filename, 'cropland_under_pressure', 'categories', '1: SE5, 2: SE10, 3: ILSWE4, 4: ILSWE5, 5: Floods, 6: Two impacts, 7: Three impacts');
ncwriteatt(filename, 'cropland_under_pressure', 'units', '');
ncwriteatt(filename, 'cropland_under_pressure', 'missing_value', '-999')

nccreate(filename, 'cropland_under_se_fractions', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'cropland_under_se_fractions', 'standard_name', 'cropland_fractions');
ncwriteatt(filename, 'cropland_under_se_fractions', 'long_name', 'cropland_fractions');
ncwriteatt(filename, 'cropland_under_se_fractions', 'units', 'fractions');
ncwriteatt(filename, 'cropland_under_se_fractions', 'missing_value', '-999');

ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);

croplands = Region.cropland_fractions;
ac = Region.abandoned_cropland_fractions;
cropland_pressure = Region.cropland_under_pressure;
croplands(croplands == 0) = -999;
ac(ac == 0) = -999;
cropland_pressure(cropland_pressure == 0) =-999;


cropland_se_fractions = croplands;
cropland_se_fractions(cropland_pressure <= 0) = 0;
cropland_se_fractions( cropland_se_fractions <= 0) = -999;

% Set cells outside regions to NaN
% cropland_pressure(Region.fraction_of_cell_is_region == 0) = -999;
% ac(Region.fraction_of_cell_is_region == 0) = -999;
% croplands(Region.fraction_of_cell_is_region == 0) = -999;

ncwrite(filename, 'cropland_fractions', croplands);
ncwrite(filename, 'abandoned_cropland_fractions', ac);
ncwrite(filename, 'cropland_under_pressure', cropland_pressure);
ncwrite(filename, 'cropland_under_se_fractions', cropland_se_fractions);


end

