function  export_src_data_fig4( Region, Biorefinery_ccs )
%EXPORT_SRC_DATA_FIG4 Summary of this function goes here
%   Detailed explanation goes here

filename = 'Output/source_data/fig4.nc';

lat = Region.lat;
lon = Region.lon;

if exist(filename, 'file')
delete(filename);    
end

opt_en_variant = Region.Bioenergy_rf_h([Region.Bioenergy_rf_h.is_energy_optimization] == 1);
crops = Region.Bioenergy_rf_h([Region.Bioenergy_rf_h.is_single_crop] == 1);
switchgrass = crops([crops.crop_id_vector] == 3);
rcg = crops([crops.crop_id_vector] == 2);
willow = crops([crops.crop_id_vector] == 5);

beccs_efficiency = Biorefinery_ccs.fraction_biomass_C_sequestered_through_CCS_or_char;

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

nccreate(filename, 'carbon_yields_switchgrass', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'carbon_yields_switchgrass', 'standard_name', 'aboveground_carbon_yields_switchgrass');
ncwriteatt(filename, 'carbon_yields_switchgrass', 'long_name', 'aboveground_carbon_yields_switchgrass');
ncwriteatt(filename, 'carbon_yields_switchgrass', 'units', 'tonC ha-1 yr-1');
ncwriteatt(filename, 'carbon_yields_switchgrass', 'missing_value', '-999');

nccreate(filename, 'carbon_yields_rcg', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'carbon_yields_rcg', 'standard_name', 'aboveground_carbon_yields_rcg');
ncwriteatt(filename, 'carbon_yields_rcg', 'long_name', 'aboveground_carbon_yields_rcg');
ncwriteatt(filename, 'carbon_yields_rcg', 'units', 'tonC ha-1 yr-1');
ncwriteatt(filename, 'carbon_yields_rcg', 'missing_value', '-999');

nccreate(filename, 'carbon_yields_willow', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'carbon_yields_willow', 'standard_name', 'aboveground_carbon_yields_willow');
ncwriteatt(filename, 'carbon_yields_willow', 'long_name', 'aboveground_carbon_yields_willow');
ncwriteatt(filename, 'carbon_yields_willow', 'units', 'tonC ha-1 yr-1');
ncwriteatt(filename, 'carbon_yields_willow', 'missing_value', '-999');

nccreate(filename, 'carbon_yields_optimal_bioenergy_crop', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'carbon_yields_optimal_bioenergy_crop', 'standard_name', 'aboveground_carbon_yields_optimal');
ncwriteatt(filename, 'carbon_yields_optimal_bioenergy_crop', 'long_name', 'aboveground_carbon_yields_optimal');
ncwriteatt(filename, 'carbon_yields_optimal_bioenergy_crop', 'units', 'tonC ha-1 yr-1');
ncwriteatt(filename, 'carbon_yields_optimal_bioenergy_crop', 'missing_value', '-999');

nccreate(filename, 'beccs_optimal_negative_emission_rate', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'beccs_optimal_negative_emission_rate', 'standard_name', 'beccs_negative_emission_rate');
ncwriteatt(filename, 'beccs_optimal_negative_emission_rate', 'long_name', 'beccs_negative_emission_rate');
ncwriteatt(filename, 'beccs_optimal_negative_emission_rate', 'units', 'tonC ha-1 yr-1');
ncwriteatt(filename, 'beccs_optimal_negative_emission_rate', 'missing_value', '-999');

nccreate(filename, 'beccs_optimal_negative_emission_rate_cropland', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'beccs_optimal_negative_emission_rate_cropland', 'standard_name', 'beccs_optimal_negative_emission_rate_cropland');
ncwriteatt(filename, 'beccs_optimal_negative_emission_rate_cropland', 'long_name', 'beccs_optimal_negative_emission_rate_cropland');
ncwriteatt(filename, 'beccs_optimal_negative_emission_rate_cropland', 'units', 'tonC ha-1 yr-1');
ncwriteatt(filename, 'beccs_optimal_negative_emission_rate_cropland', 'missing_value', '-999');

nccreate(filename, 'beccs_optimal_negative_emission_rate_ac', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'beccs_optimal_negative_emission_rate_ac', 'standard_name', 'beccs_optimal_negative_emission_rate_ac');
ncwriteatt(filename, 'beccs_optimal_negative_emission_rate_ac', 'long_name', 'beccs_optimal_negative_emission_rate_ac');
ncwriteatt(filename, 'beccs_optimal_negative_emission_rate_ac', 'units', 'tonC ha-1 yr-1');
ncwriteatt(filename, 'beccs_optimal_negative_emission_rate_ac', 'missing_value', '-999');

nccreate(filename, 'beccs_carbon_sequestration_ac', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'beccs_carbon_sequestration_ac', 'standard_name', 'beccs_carbon_sequestration_ac');
ncwriteatt(filename, 'beccs_carbon_sequestration_ac', 'long_name', 'beccs_carbon_sequestration_ac');
ncwriteatt(filename, 'beccs_carbon_sequestration_ac', 'units', 'tonC yr-1');
ncwriteatt(filename, 'beccs_carbon_sequestration_ac', 'missing_value', '-999');

nccreate(filename, 'beccs_carbon_sequestration_cropland', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'beccs_carbon_sequestration_cropland', 'standard_name', 'beccs_carbon_sequestration_cropland');
ncwriteatt(filename, 'beccs_carbon_sequestration_cropland', 'long_name', 'beccs_carbon_sequestration_cropland');
ncwriteatt(filename, 'beccs_carbon_sequestration_cropland', 'units', 'tonC yr-1');
ncwriteatt(filename, 'beccs_carbon_sequestration_cropland', 'missing_value', '-999');

nccreate(filename, 'nat_reg_carbon_sequestration_rate_ac', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'nat_reg_carbon_sequestration_rate_ac', 'standard_name', 'nat_reg_carbon_sequestration_rate_ac');
ncwriteatt(filename, 'nat_reg_carbon_sequestration_rate_ac', 'long_name', 'nat_reg_carbon_sequestration_rate_ac');
ncwriteatt(filename, 'nat_reg_carbon_sequestration_rate_ac', 'units', 'tonC ha-1 yr-1');
ncwriteatt(filename, 'nat_reg_carbon_sequestration_rate_ac', 'missing_value', '-999');

nccreate(filename, 'nat_reg_carbon_sequestration_rate_cropland', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'nat_reg_carbon_sequestration_rate_cropland', 'standard_name', 'nat_reg_carbon_sequestration_rate_cropland');
ncwriteatt(filename, 'nat_reg_carbon_sequestration_rate_cropland', 'long_name', 'nat_reg_carbon_sequestration_rate_cropland');
ncwriteatt(filename, 'nat_reg_carbon_sequestration_rate_cropland', 'units', 'tonC ha-1 yr-1');
ncwriteatt(filename, 'nat_reg_carbon_sequestration_rate_cropland', 'missing_value', '-999');

nccreate(filename, 'nat_reg_carbon_sequestration_cropland', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'nat_reg_carbon_sequestration_cropland', 'standard_name', 'nat_reg_carbon_sequestration_cropland');
ncwriteatt(filename, 'nat_reg_carbon_sequestration_cropland', 'long_name', 'nat_reg_carbon_sequestration_cropland');
ncwriteatt(filename, 'nat_reg_carbon_sequestration_cropland', 'units', 'tonC yr-1');
ncwriteatt(filename, 'nat_reg_carbon_sequestration_cropland', 'missing_value', '-999');

nccreate(filename, 'nat_reg_carbon_sequestration_ac', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'nat_reg_carbon_sequestration_ac', 'standard_name', 'nat_reg_carbon_sequestration_ac');
ncwriteatt(filename, 'nat_reg_carbon_sequestration_ac', 'long_name', 'nat_reg_carbon_sequestration_ac');
ncwriteatt(filename, 'nat_reg_carbon_sequestration_ac', 'units', 'tonC yr-1');
ncwriteatt(filename, 'nat_reg_carbon_sequestration_ac', 'missing_value', '-999');

nccreate(filename, 'delta_beccs_nat_reg_carbon_sequestration_rate_cropland', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'delta_beccs_nat_reg_carbon_sequestration_rate_cropland', 'standard_name', 'delta_beccs_nat_reg_carbon_sequestration_rate_cropland');
ncwriteatt(filename, 'delta_beccs_nat_reg_carbon_sequestration_rate_cropland', 'long_name', 'delta_beccs_nat_reg_carbon_sequestration_rate_cropland');
ncwriteatt(filename, 'delta_beccs_nat_reg_carbon_sequestration_rate_cropland', 'units', 'tonC ha-1 yr-1');
ncwriteatt(filename, 'delta_beccs_nat_reg_carbon_sequestration_rate_cropland', 'missing_value', '-999');

nccreate(filename, 'delta_beccs_nat_reg_carbon_sequestration_rate_ac', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'delta_beccs_nat_reg_carbon_sequestration_rate_ac', 'standard_name', 'delta_beccs_nat_reg_carbon_sequestration_rate_ac');
ncwriteatt(filename, 'delta_beccs_nat_reg_carbon_sequestration_rate_ac', 'long_name', 'delta_beccs_nat_reg_carbon_sequestration_rate_ac');
ncwriteatt(filename, 'delta_beccs_nat_reg_carbon_sequestration_rate_ac', 'units', 'tonC ha-1 yr-1');
ncwriteatt(filename, 'delta_beccs_nat_reg_carbon_sequestration_rate_ac', 'missing_value', '-999');

nccreate(filename, 'delta_beccs_nat_reg_carbon_sequestration_cropland', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'delta_beccs_nat_reg_carbon_sequestration_cropland', 'standard_name', 'delta_beccs_nat_reg_carbon_sequestration_cropland');
ncwriteatt(filename, 'delta_beccs_nat_reg_carbon_sequestration_cropland', 'long_name', 'delta_beccs_nat_reg_carbon_sequestration_cropland');
ncwriteatt(filename, 'delta_beccs_nat_reg_carbon_sequestration_cropland', 'units', 'tonC yr-1');
ncwriteatt(filename, 'delta_beccs_nat_reg_carbon_sequestration_cropland', 'missing_value', '-999');

nccreate(filename, 'delta_beccs_nat_reg_carbon_sequestration_ac', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'delta_beccs_nat_reg_carbon_sequestration_ac', 'standard_name', 'delta_beccs_nat_reg_carbon_sequestration_ac');
ncwriteatt(filename, 'delta_beccs_nat_reg_carbon_sequestration_ac', 'long_name', 'delta_beccs_nat_reg_carbon_sequestration_ac');
ncwriteatt(filename, 'delta_beccs_nat_reg_carbon_sequestration_ac', 'units', 'tonC yr-1');
ncwriteatt(filename, 'delta_beccs_nat_reg_carbon_sequestration_ac', 'missing_value', '-999');

nccreate(filename, 'optimal_net', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'optimal_net', 'standard_name', 'optimal_net');
ncwriteatt(filename, 'optimal_net', 'long_name', 'optimal_net_aboveground_carbon');
ncwriteatt(filename, 'optimal_net', 'units', '1=BECCS,2=Natural regrowth');
ncwriteatt(filename, 'optimal_net', 'missing_value', '-999');

nccreate(filename, 'optimal_net_carbon_sequestration_rate_cropland', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'optimal_net_carbon_sequestration_rate_cropland', 'standard_name', 'optimal_net_carbon_sequestration_rate_cropland');
ncwriteatt(filename, 'optimal_net_carbon_sequestration_rate_cropland', 'long_name', 'optimal_net_carbon_sequestration_rate_cropland');
ncwriteatt(filename, 'optimal_net_carbon_sequestration_rate_cropland', 'units', 'tonC ha-1 yr-1');
ncwriteatt(filename, 'optimal_net_carbon_sequestration_rate_cropland', 'missing_value', '-999');




ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);
ncwrite(filename, 'carbon_yields_switchgrass', switchgrass.carbon_yield);
ncwrite(filename, 'carbon_yields_rcg', rcg.carbon_yield);
ncwrite(filename, 'carbon_yields_willow', willow.carbon_yield);
ncwrite(filename, 'carbon_yields_optimal_bioenergy_crop', opt_en_variant.carbon_yield);
ncwrite(filename, 'beccs_optimal_negative_emission_rate', opt_en_variant.carbon_yield*beccs_efficiency);
ncwrite(filename, 'beccs_optimal_negative_emission_rate_cropland', opt_en_variant.carbon_yield_cropland*beccs_efficiency);
ncwrite(filename, 'beccs_optimal_negative_emission_rate_ac', opt_en_variant.carbon_yield_ac*beccs_efficiency);
ncwrite(filename, 'beccs_carbon_sequestration_ac', opt_en_variant.carbon_ac*beccs_efficiency);
ncwrite(filename, 'beccs_carbon_sequestration_cropland', opt_en_variant.carbon_cropland*beccs_efficiency);


ncwrite(filename, 'nat_reg_carbon_sequestration_rate_ac', Region.acs_nr_rate_abandoned_cropland);

temp = Region.acs_nr_rate_cropland;
temp(Region.cropland_hectare <= 0) = -999;
ncwrite(filename, 'nat_reg_carbon_sequestration_rate_cropland', temp);

temp = Region.acs_nr_abandoned_cropland;
temp(Region.cropland_hectare <= 0) = -999;
ncwrite(filename, 'nat_reg_carbon_sequestration_ac', temp);

ncwrite(filename, 'nat_reg_carbon_sequestration_cropland', Region.acs_nr_cropland);
ncwrite(filename, 'delta_beccs_nat_reg_carbon_sequestration_rate_cropland', (opt_en_variant.carbon_yield_cropland*beccs_efficiency)-Region.acs_nr_rate_cropland);
ncwrite(filename, 'delta_beccs_nat_reg_carbon_sequestration_rate_ac', (opt_en_variant.carbon_yield_ac*beccs_efficiency)-Region.acs_nr_rate_abandoned_cropland);
ncwrite(filename, 'delta_beccs_nat_reg_carbon_sequestration_cropland', (opt_en_variant.carbon_cropland*beccs_efficiency)-Region.acs_nr_cropland);
ncwrite(filename, 'delta_beccs_nat_reg_carbon_sequestration_ac', (opt_en_variant.carbon_ac*beccs_efficiency)-Region.acs_nr_abandoned_cropland);

optimal_net = zeros(4320,2160);
optimal_net((opt_en_variant.carbon_cropland*beccs_efficiency) > Region.acs_nr_cropland) = 1;
optimal_net((opt_en_variant.carbon_cropland*beccs_efficiency) <= Region.acs_nr_cropland) = 2;
optimal_net(Region.cropland_hectare <= 0) = -999;
ncwrite(filename, 'optimal_net', optimal_net);

optimal_net_rate_cs_cropland = opt_en_variant.carbon_yield_cropland*beccs_efficiency;
optimal_net_rate_cs_cropland(optimal_net == 2) = Region.acs_nr_rate_cropland(optimal_net == 2);
ncwrite(filename, 'optimal_net_carbon_sequestration_rate_cropland', optimal_net_rate_cs_cropland);


end

