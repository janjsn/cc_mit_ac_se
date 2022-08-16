function export_src_data_soc_change_and_abc_ac( obj, idx_bioenergy_rf_h, filename )
%EXPORT_SRC_DATA_SOC_CHANGE_AND_ABC_AC Summary of this function goes here
%   Detailed explanation goes here
idx = idx_bioenergy_rf_h;

productive_ac = obj.abandoned_cropland_hectare;
productive_ac(obj.Bioenergy_rf_h(idx).pe_ac <= 0) = 0;
productive_cropland_se = obj.cropland_under_soil_erosion_mod_high_4bioenergy_hectare;
productive_cropland_se(obj.Bioenergy_rf_h(idx).pe_cropland_se_wat_wind_4bioenergy <= 0) = 0;

soc_co2_seq_rate_ac = -3.67*obj.gridded_soil_carbon_seq_rate_nat_regrowth_tonC_per_ha_year;
soc_co2_seq_rate_ac(productive_ac == 0) = -999;
soc_co2_seq_rate_cropland_se = -3.67*obj.gridded_soil_carbon_seq_rate_nat_regrowth_tonC_per_ha_year;
soc_co2_seq_rate_cropland_se(productive_cropland_se == 0) = -999;

abc_present_ac = obj.aboveground_carbon_on_abandoned_cropland_ton_C;
abc_present_ac(productive_ac <= 0) = 0;
abc_present_ac(abc_present_ac == 0) = -999;

%filename = 'Output/soc_change_and_abc_ac.nc';

if exist(filename, 'file')
    delete(filename)
end

lat = obj.lat;
lon = obj.lon;

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

nccreate(filename, 'soc_co2_seq_rate_ac', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'soc_co2_seq_rate_ac', 'standard_name', 'soc_co2_seq_rate_ac');
ncwriteatt(filename, 'soc_co2_seq_rate_ac', 'long_name', 'soc_co2_seq_rate_ac');
ncwriteatt(filename, 'soc_co2_seq_rate_ac', 'units', 'tCO2eq ha-1 yr-1');
ncwriteatt(filename, 'soc_co2_seq_rate_ac', 'missing_value', '-999');

nccreate(filename, 'soc_co2_seq_rate_cropland_se', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'soc_co2_seq_rate_cropland_se', 'standard_name', 'soc_co2_seq_rate_cropland_se');
ncwriteatt(filename, 'soc_co2_seq_rate_cropland_se', 'long_name', 'soc_co2_seq_rate_cropland_se');
ncwriteatt(filename, 'soc_co2_seq_rate_cropland_se', 'units', 'tCO2eq ha-1 yr-1');
ncwriteatt(filename, 'soc_co2_seq_rate_cropland_se', 'missing_value', '-999');

nccreate(filename, 'aboveground_carbon_on_abandoned_cropland', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'aboveground_carbon_on_abandoned_cropland', 'standard_name', 'aboveground_carbon_on_abandoned_cropland');
ncwriteatt(filename, 'aboveground_carbon_on_abandoned_cropland', 'long_name', 'aboveground_carbon_on_abandoned_cropland');
ncwriteatt(filename, 'aboveground_carbon_on_abandoned_cropland', 'units', 'ton C');
ncwriteatt(filename, 'aboveground_carbon_on_abandoned_cropland', 'missing_value', '-999');

ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);
ncwrite(filename, 'soc_co2_seq_rate_ac', soc_co2_seq_rate_ac);
ncwrite(filename, 'soc_co2_seq_rate_cropland_se', soc_co2_seq_rate_cropland_se);
ncwrite(filename, 'aboveground_carbon_on_abandoned_cropland', abc_present_ac)

end



