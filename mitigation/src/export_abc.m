
fprintf('Importing aboveground carbon on abandoned cropland.. \n')
ABC = ABC_ac('Input/standing_carbon_on_abandoned_cropland_2019.nc');
ncid = netcdf.open('Input/seq_C_abandoned_cropland_1992_2018_5arcmin.nc');
ABC.mean_nat_regrowth_carbon_seq_rate_ton_C_per_ha_year_ac_2018 = netcdf.getVar(ncid,4);
netcdf.close(ncid);

ac_1992_2018 = sum(ABC.ac_hectare_after_change(:,:,1:26),3) ;
ac_1992_2018 = zeros(length(ABC.lon), length(ABC.lat));
ac_1992_2018(:,:) = temp(1,:,:);
abc_tot_2018 = sum(ABC.aboveground_carbon_ac_after_change_ton_C(:,:,1:26),3) + (ac_1992_2018.*(ABC.mean_nat_regrowth_carbon_seq_rate_ton_C_per_ha_year_ac_2018*2));
abc_tot_2021 = abc_tot_2018 + (ac_1992_2018.*(ABC.mean_nat_regrowth_carbon_seq_rate_ton_C_per_ha_year_ac_2018*3));


filename = 'natural_regrowth_aboveground_carbon_on_abandoned_cropland.nc';

if exist(filename, 'file')
    delete(filename);
end

lat = ABC.lat;
lon = ABC.lon;

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

nccreate(filename, 'abandoned_cropland', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'abandoned_cropland', 'standard_name', 'abandoned_cropland');
ncwriteatt(filename, 'abandoned_cropland', 'long_name', 'abandoned_cropland');
ncwriteatt(filename, 'abandoned_cropland', 'units', 'hectare');
ncwriteatt(filename, 'abandoned_cropland', 'missing_value', '-999');

nccreate(filename, 'aboveground_carbon_on_abandoned_cropland_in_2018', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'aboveground_carbon_on_abandoned_cropland_in_2018', 'standard_name', 'aboveground_carbon_on_abandoned_cropland_in_2018');
ncwriteatt(filename, 'aboveground_carbon_on_abandoned_cropland_in_2018', 'long_name', 'aboveground_carbon_on_abandoned_cropland_in_2018');
ncwriteatt(filename, 'aboveground_carbon_on_abandoned_cropland_in_2018', 'units', 'tonC');
ncwriteatt(filename, 'aboveground_carbon_on_abandoned_cropland_in_2018', 'missing_value', '-999');

nccreate(filename, 'aboveground_carbon_on_abandoned_cropland_in_2021', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'aboveground_carbon_on_abandoned_cropland_in_2021', 'standard_name', 'aboveground_carbon_on_abandoned_cropland_in_2021');
ncwriteatt(filename, 'aboveground_carbon_on_abandoned_cropland_in_2021', 'long_name', 'aboveground_carbon_on_abandoned_cropland_in_2021');
ncwriteatt(filename, 'aboveground_carbon_on_abandoned_cropland_in_2021', 'units', 'tonC');
ncwriteatt(filename, 'aboveground_carbon_on_abandoned_cropland_in_2021', 'missing_value', '-999');

nccreate(filename, 'natural_regrowth_rate', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'natural_regrowth_rate', 'standard_name', 'mean_natural_regrowth_rate_on_cropland_abandoned_between_1992_and_2018');
ncwriteatt(filename, 'natural_regrowth_rate', 'long_name', 'mean_natural_regrowth_rate_on_cropland_abandoned_between_1992_and_2018');
ncwriteatt(filename, 'natural_regrowth_rate', 'units', 'tonC ha-1 yr-1');
ncwriteatt(filename, 'natural_regrowth_rate', 'missing_value', '-999');

ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);
ncwrite(filename, 'abandoned_cropland', ac_1992_2018);
ncwrite(filename, 'aboveground_carbon_on_abandoned_cropland_in_2018', abc_tot_2018);
ncwrite(filename, 'aboveground_carbon_on_abandoned_cropland_in_2021', abc_tot_2021 );
ncwrite(filename, 'natural_regrowth_rate', ABC.mean_nat_regrowth_carbon_seq_rate_ton_C_per_ha_year_ac_2018);


