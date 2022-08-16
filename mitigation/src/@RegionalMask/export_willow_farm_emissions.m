function obj = export_willow_farm_emissions( obj )
%EXPORT_WILLOW_FARM_EMISSIONS Summary of this function goes here
%   Detailed explanation goes here
filename = 'Output/source_data/willow_farm_em.nc';

if exist(filename, 'file')
    delete(filename)
end

lat = obj.lat;
lon = obj.lon;
willow_em = obj.gwp100_farm_em_willow_kg_co2eq_per_ton_dm;

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

nccreate(filename, 'farm_em', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'farm_em', 'standard_name', 'farm_em');
ncwriteatt(filename, 'farm_em', 'long_name', 'farm_em');
ncwriteatt(filename, 'farm_em', 'units', 'kgCO2eq tdm-1');
ncwriteatt(filename, 'farm_em', 'missing_value', '-999');

ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);
ncwrite(filename, 'farm_em', willow_em);

end

