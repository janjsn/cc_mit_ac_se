function wse_map = get_ILSWE( input_args )
%GET_ILSWE Summary of this function goes here
%   Detailed explanation goes here
filename = 'ILSWE_WGS_083.tif';

[map,georef] = geotiffread(filename);

map = map';

mSize = size(map);

lat_step = georef.CellExtentInLatitude;
lon_step = georef.CellExtentInLongitude;

lat_lim = georef.LatitudeLimits;
lon_lim = georef.LongitudeLimits;

lat_old = [lat_lim(2)-lat_step/2:-lat_step:lat_lim(1)+lat_step/2];
lon_old = [lon_lim(1)+lon_step/2:lon_step:lon_lim(2)-lon_step/2];

step_30arcsec = 360/43200;

wse_map = zeros(43200,21600);
wse_map(:,:) = -999;


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
        
        wse_map(lons, lats) = map(idx_lon_old, idx_lat_old);
        
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

wse_map(wse_map == 15) = -999;


end

