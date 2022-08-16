function [ floodMap, lat, lon] = getFloodMap(  )
%GETFLOODMAP Summary of this function goes here
%   Detailed explanation goes here

[map,georef] = geotiffread('floodMapGL_rp10y.tif');
map = map';

mSize = size(map);

lat_step = georef.CellExtentInLatitude;
lon_step = georef.CellExtentInLongitude;

lat_lim = georef.LatitudeLimits;
lon_lim = georef.LongitudeLimits;

lat_old = [lat_lim(2)-lat_step/2:-lat_step:lat_lim(1)+lat_step/2];
lon_old = [lon_lim(1)+lon_step/2:lon_step:lon_lim(2)-lon_step/2];


floodMap = zeros(43200,21600);
lat = [90-lat_step/2:-lat_step:-90+lat_step/2];
lon = [-180+lon_step/2:lon_step:180-lon_step/2];

floodMap(:,:) = -999;

idx_lat = zeros(1,length(lat_old));
idx_lon = zeros(1,length(lon_old));

for i = 1:mSize(1)
    [~,idx_lon(i)] = min(abs(lon-lon_old(i)));
end
for i = 1:mSize(2)
   [~,idx_lat(i)] = min(abs(lat-lat_old(i))); 
end

for i = 1:mSize(1)
    for j = 1:mSize(2)
        if map(i,j) > -1
           floodMap(idx_lon(i), idx_lat(j)) = map(i,j);            
        end    
    end
end



end

