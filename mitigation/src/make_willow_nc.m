function  make_willow_nc(  )
%MAKE_WILLOW_NC Summary of this function goes here
%   Detailed explanation goes here

addpath(genpath(pwd()))

filename_in = {'gcbb12332-sup-0001-figs1_WGS84.tif', ...
    'gcbb12332-sup-0002-figs2_WGS84.tif', ...
    'gcbb12332-sup-0003-figs3_WGS84.tif'};

performance_levels_vector = [1 2 3]; %Set in accordance to files. low->high

filename_out = 'willow_dm_yields_Mola_Yudego.nc';

for files = 1:length(filename_in)

[map,georef] = geotiffread(filename_in{files});

map = map';

mSize = size(map);

lat_step = georef.CellExtentInLatitude;
lon_step = georef.CellExtentInLongitude;

lat_lim = georef.LatitudeLimits;
lon_lim = georef.LongitudeLimits;

lat_old = [lat_lim(2)-lat_step/2:-lat_step:lat_lim(1)+lat_step/2];
lon_old = [lon_lim(1)+lon_step/2:lon_step:lon_lim(2)-lon_step/2];

step_30arcsec = 360/43200;
willow_map = zeros(43200,21600);
willow_map(:,:) = -999;


lat = [90-step_30arcsec/2:-step_30arcsec:-90+step_30arcsec/2];
lon = [-180+step_30arcsec/2:step_30arcsec:180-step_30arcsec/2];


[~, idx_lon_lim_1] = min(abs(lon-lon_lim(1)));
[~, idx_lon_lim_2] = min(abs(lon-lon_lim(2)));
[~, idx_lat_lim_1] = min(abs(lat-lat_lim(1)));
[~, idx_lat_lim_2] = min(abs(lat-lat_lim(2)));

if idx_lon_lim_1 > idx_lon_lim_2
    temp = idx_lon_lim_2;
    idx_lon_lim_2 = idx_lon_lim_1;
    idx_lon_lim_1 = temp;
end

if idx_lat_lim_1 > idx_lat_lim_2
   temp = idx_lat_lim_1;
   idx_lat_lim_1 = idx_lat_lim_2;
   idx_lat_lim_2 = temp;
end

for lons = idx_lon_lim_1:idx_lon_lim_2
    [~, idx_lon_old] = min(abs(lon_old-lon(lons)));
    for lats = idx_lat_lim_1:idx_lat_lim_2
        [~, idx_lat_old] = min(abs(lat_old-lat(lats)));
        
        willow_map(lons, lats) = map(idx_lon_old, idx_lat_old);
        
    end
end



% for i = 1:mSize(1)
%     [~,idx_lon(i)] = min(abs(lon-lon_old(i)));
% end
% for i = 1:mSize(2)
%    [~,idx_lat(i)] = min(abs(lat-lat_old(i))); 
% end
% 
% for i = 1:mSize(1)
%     for j = 1:mSize(2)
%         if map(i,j) > -1
%            wse_map(idx_lon(i), idx_lat(j)) = map(i,j);            
%         end
%     
%     end
% end

willow_map(willow_map <0) = -999;

if performance_levels_vector(files) == 1
    dm_yields_low = willow_map;
elseif performance_levels_vector(files) == 2
    dm_yields_medium = willow_map;
elseif performance_levels_vector(files) == 3
    dm_yields_high = willow_map;
end
end

%% EXPORT RESULTS
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

nccreate(filename_out, 'willow_dm_yields_low', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename_out, 'willow_dm_yields_low', 'standard_name', 'willow_dm_yields_low_performance');
ncwriteatt(filename_out, 'willow_dm_yields_low', 'long_name', 'willow_dm_yields_low_performance');
ncwriteatt(filename_out, 'willow_dm_yields_low', 'units', 'ton dm hectare-1');
ncwriteatt(filename_out, 'willow_dm_yields_low', 'missing_value', '-999');

nccreate(filename_out, 'willow_dm_yields_medium', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename_out, 'willow_dm_yields_medium', 'standard_name', 'willow_dm_yields_medium_performance');
ncwriteatt(filename_out, 'willow_dm_yields_medium', 'long_name', 'willow_dm_yields_medium_performance');
ncwriteatt(filename_out, 'willow_dm_yields_medium', 'units', 'ton dm hectare-1');
ncwriteatt(filename_out, 'willow_dm_yields_medium', 'missing_value', '-999');

nccreate(filename_out, 'willow_dm_yields_high', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename_out, 'willow_dm_yields_high', 'standard_name', 'willow_dm_yields_high_performance');
ncwriteatt(filename_out, 'willow_dm_yields_high', 'long_name', 'willow_dm_yields_high_performance');
ncwriteatt(filename_out, 'willow_dm_yields_high', 'units', 'ton dm hectare-1');
ncwriteatt(filename_out, 'willow_dm_yields_high', 'missing_value', '-999');

ncwrite(filename_out, 'lat', lat);
ncwrite(filename_out, 'lon', lon);
ncwrite(filename_out, 'willow_dm_yields_low', dm_yields_low);
ncwrite(filename_out, 'willow_dm_yields_medium', dm_yields_medium);
ncwrite(filename_out, 'willow_dm_yields_high', dm_yields_high);


end




