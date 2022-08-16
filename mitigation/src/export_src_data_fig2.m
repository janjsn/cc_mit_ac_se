function  export_src_data_fig2( Region )
%EXPORT_SRC_DATA_FIG2 Summary of this function goes here
%   Detailed explanation goes here

filename = 'Output/source_data/fig2_v2.nc';

lat = Region.lat;
lon = Region.lon;

if exist(filename, 'file')
delete(filename);    
end

opt_en_variant = Region.Bioenergy_rf_h([Region.Bioenergy_rf_h.is_energy_optimization] == 1);
wb_variant = Region.Bioenergy_rf_h([Region.Bioenergy_rf_h.is_wb_scenario] == 1);
crops = Region.Bioenergy_rf_h([Region.Bioenergy_rf_h.is_single_crop] == 1);
switchgrass = crops([crops.crop_id_vector] == 3);
rcg = crops([crops.crop_id_vector] == 2);
willow = crops([crops.crop_id_vector] == 5);

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

nccreate(filename, 'bioenergy_yields_switchgrass', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'bioenergy_yields_switchgrass', 'standard_name', 'bioenergy_yields_switchgrass');
ncwriteatt(filename, 'bioenergy_yields_switchgrass', 'long_name', 'bioenergy_yields_switchgrass');
ncwriteatt(filename, 'bioenergy_yields_switchgrass', 'units', 'GJ ha-1 yr-1');
ncwriteatt(filename, 'bioenergy_yields_switchgrass', 'missing_value', '-999');

nccreate(filename, 'bioenergy_yields_rcg', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'bioenergy_yields_rcg', 'standard_name', 'bioenergy_yields_rcg');
ncwriteatt(filename, 'bioenergy_yields_rcg', 'long_name', 'bioenergy_yields_rcg');
ncwriteatt(filename, 'bioenergy_yields_rcg', 'units', 'GJ ha-1 yr-1');
ncwriteatt(filename, 'bioenergy_yields_rcg', 'missing_value', '-999');

nccreate(filename, 'bioenergy_yields_willow', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'bioenergy_yields_willow', 'standard_name', 'bioenergy_yields_willow');
ncwriteatt(filename, 'bioenergy_yields_willow', 'long_name', 'bioenergy_yields_willow');
ncwriteatt(filename, 'bioenergy_yields_willow', 'units', 'GJ ha-1 yr-1');
ncwriteatt(filename, 'bioenergy_yields_willow', 'missing_value', '-999');

nccreate(filename, 'eo_crop_allocation', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'eo_crop_allocation', 'standard_name', 'energy_optimization_crop_allocation');
ncwriteatt(filename, 'eo_crop_allocation', 'long_name', 'energy_optimization_crop_allocation');
ncwriteatt(filename, 'eo_crop_allocation', 'units', '');
ncwriteatt(filename, 'eo_crop_allocation', 'missing_value', '-999');

nccreate(filename, 'wb_crop_allocation', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'wb_crop_allocation', 'standard_name', 'windbreak_scenario_crop_allocation');
ncwriteatt(filename, 'wb_crop_allocation', 'long_name', 'windbreak_scenario_crop_allocation');
ncwriteatt(filename, 'wb_crop_allocation', 'units', '');
ncwriteatt(filename, 'wb_crop_allocation', 'missing_value', '-999');

nccreate(filename, 'wb_crop_allocation_ac', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'wb_crop_allocation_ac', 'standard_name', 'windbreak_scenario_crop_allocation_ac');
ncwriteatt(filename, 'wb_crop_allocation_ac', 'long_name', 'windbreak_scenario_crop_allocation_ac');
ncwriteatt(filename, 'wb_crop_allocation_ac', 'units', '');
ncwriteatt(filename, 'wb_crop_allocation_ac', 'missing_value', '-999');

nccreate(filename, 'pe_opt_bioenergy_potential_ac', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'pe_opt_bioenergy_potential_ac', 'standard_name', 'pe_opt_bioenergy_potential_abandoned_cropland');
ncwriteatt(filename, 'pe_opt_bioenergy_potential_ac', 'long_name', 'primary_energy_optimal_bioenergy_potential_abandoned_cropland');
ncwriteatt(filename, 'pe_opt_bioenergy_potential_ac', 'units', 'TJ yr-1');
ncwriteatt(filename, 'pe_opt_bioenergy_potential_ac', 'missing_value', '-999');

nccreate(filename, 'pe_opt_bioenergy_potential_cropland', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'pe_opt_bioenergy_potential_cropland', 'standard_name', 'pe_opt_bioenergy_potential_cropland');
ncwriteatt(filename, 'pe_opt_bioenergy_potential_cropland', 'long_name', 'primary_energy_optimal_bioenergy_potential_cropland');
ncwriteatt(filename, 'pe_opt_bioenergy_potential_cropland', 'units', 'TJ yr-1');
ncwriteatt(filename, 'pe_opt_bioenergy_potential_cropland', 'missing_value', '-999');

nccreate(filename, 'wb_opt_bioenergy_potential_ac', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'wb_opt_bioenergy_potential_ac', 'standard_name', 'pe_opt_bioenergy_potential_abandoned_cropland');
ncwriteatt(filename, 'wb_opt_bioenergy_potential_ac', 'long_name', 'primary_energy_windbreak_scenario_bioenergy_potential_abandoned_cropland');
ncwriteatt(filename, 'wb_opt_bioenergy_potential_ac', 'units', 'TJ yr-1');
ncwriteatt(filename, 'wb_opt_bioenergy_potential_ac', 'missing_value', '-999');

nccreate(filename, 'wb_opt_bioenergy_potential_cropland', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'wb_opt_bioenergy_potential_cropland', 'standard_name', 'wb_opt_bioenergy_potential_cropland');
ncwriteatt(filename, 'wb_opt_bioenergy_potential_cropland', 'long_name', 'primary_energy_windbreak_scenario_bioenergy_potential_cropland');
ncwriteatt(filename, 'wb_opt_bioenergy_potential_cropland', 'units', 'TJ yr-1');
ncwriteatt(filename, 'wb_opt_bioenergy_potential_cropland', 'missing_value', '-999');

nccreate(filename, 'wb_ac_se_bioenergy_potential', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'wb_ac_se_bioenergy_potential', 'standard_name', 'wb_ac_se_bioenergy_potential');
ncwriteatt(filename, 'wb_ac_se_bioenergy_potential', 'long_name', 'primary_energy_windbreak_scenario_bioenergy_potential_abandoned_cropland_and_cropland_under_wind_and_water_erosion');
ncwriteatt(filename, 'wb_ac_se_bioenergy_potential', 'units', 'TJ yr-1');
ncwriteatt(filename, 'wb_ac_se_bioenergy_potential', 'missing_value', '-999');

ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);




bioenergy_yields_switchgrass = switchgrass.bioenergy_yield;
bioenergy_yields_switchgrass(bioenergy_yields_switchgrass == 0) = -999;


bioenergy_yields_rcg = rcg.bioenergy_yield;
bioenergy_yields_rcg(bioenergy_yields_rcg == 0) = -999;
bioenergy_yields_willow = willow.bioenergy_yield;
bioenergy_yields_willow(bioenergy_yields_willow == 0) = -999;

crop_allocation_eo = opt_en_variant.crop_allocation_cropland;
crop_allocation_eo(crop_allocation_eo == 0) = -999;

crop_allocation_wb = wb_variant.crop_allocation_cropland;
crop_allocation_wb(crop_allocation_wb == 0) = -999;
binary_cropland_under_erosion = zeros(length(lon), length(lat));
binary_cropland_under_erosion(wb_variant.pe_cropland_se5 > 0) = 1;
binary_cropland_under_erosion(wb_variant.pe_cropland_ilswe_4 > 0) = 1;
binary_cropland_under_erosion(wb_variant.pe_cropland_ilswe_5 > 0) = 1;
crop_allocation_wb(binary_cropland_under_erosion == 0) = -999;

crop_allocation_wb_ac = wb_variant.crop_allocation_ac;
crop_allocation_wb_ac(crop_allocation_wb_ac == 0) = -999;

binary_landAvailable = binary_cropland_under_erosion;
binary_landAvailable(crop_allocation_wb_ac > 0) = 1;

bioenergy_yields_switchgrass(binary_landAvailable == 0) = -999;
bioenergy_yields_rcg(binary_landAvailable == 0) = -999;
bioenergy_yields_willow(binary_landAvailable == 0) = -999;


eo_bioenergy_potential_cropland = opt_en_variant.pe_cropland*10^-3;
eo_bioenergy_potential_cropland(eo_bioenergy_potential_cropland == 0) = -999;
eo_bioenergy_potential_ac = opt_en_variant.pe_ac*10^-3;
eo_bioenergy_potential_ac(eo_bioenergy_potential_ac == 0) = -999;

wb_bioenergy_potential_cropland = wb_variant.pe_cropland*10^-3;
wb_bioenergy_potential_cropland(wb_bioenergy_potential_cropland == 0) = -999;
wb_bioenergy_potential_ac = wb_variant.pe_ac*10^-3;
wb_bioenergy_potential_ac(wb_bioenergy_potential_ac == 0) = -999;

wb_pe_ac_se = 10^-3*wb_variant.pe_ac_cropland_se_wat_wind_4bioenergy;
wb_pe_ac_se(wb_pe_ac_se == 0) = -999;


ncwrite(filename, 'bioenergy_yields_switchgrass', bioenergy_yields_switchgrass);
ncwrite(filename, 'bioenergy_yields_rcg', bioenergy_yields_rcg);
ncwrite(filename, 'bioenergy_yields_willow', bioenergy_yields_willow);
ncwrite(filename, 'eo_crop_allocation', crop_allocation_eo);
ncwrite(filename, 'wb_crop_allocation', crop_allocation_wb);
ncwrite(filename, 'pe_opt_bioenergy_potential_ac', eo_bioenergy_potential_ac);
ncwrite(filename, 'pe_opt_bioenergy_potential_cropland', eo_bioenergy_potential_cropland);
ncwrite(filename, 'wb_opt_bioenergy_potential_ac', wb_bioenergy_potential_ac);
ncwrite(filename, 'wb_opt_bioenergy_potential_cropland', wb_bioenergy_potential_cropland);
ncwrite(filename, 'wb_crop_allocation_ac', crop_allocation_wb_ac);
ncwrite(filename, 'wb_ac_se_bioenergy_potential', wb_pe_ac_se);


%% PRINT AREA FIGURE
cropland_ilswe4 = Region.cropland_ilswe_4_hectare;
cropland_ilswe5 = Region.cropland_ilswe_5_hectare;
ac = Region.abandoned_cropland_hectare;
ac_ilswe4 = Region.abandoned_cropland_ilswe_4_hectare;
ac_ilswe5 = Region.abandoned_cropland_ilswe_5_hectare;
ac_no_wind_erosion = ac-ac_ilswe4-ac_ilswe5;
cropland_se10 = Region.cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare;
cropland_se5 = Region.cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare-cropland_se10;
cropland_se = cropland_se10+cropland_se5;
cropland_ilswe = cropland_ilswe4+cropland_ilswe5;
cropland_erosion = cropland_se+cropland_ilswe;


plotMatrix = zeros(2,3);

% Abandoned cropland
%Switchgrass
plotMatrix(1,3) = sum(sum(ac_no_wind_erosion(Region.Bioenergy_rf_h(5).crop_allocation_ac == 3)));
%Reed canary grass
plotMatrix(1,2) = sum(sum(ac_no_wind_erosion(Region.Bioenergy_rf_h(5).crop_allocation_ac == 2)));
% Willow
plotMatrix(1,1) = sum(sum(ac))-plotMatrix(1,3)-plotMatrix(1,2);

%Cropland
cropland_water_erosion_no_ilswe = cropland_se;
cropland_water_erosion_no_ilswe(cropland_water_erosion_no_ilswe > 0) = cropland_water_erosion_no_ilswe(cropland_water_erosion_no_ilswe > 0)-cropland_ilswe(cropland_water_erosion_no_ilswe > 0);
plotMatrix(2,1) = sum(sum((1/3)*cropland_ilswe(bioenergy_yields_willow > 0))) + sum(sum((cropland_water_erosion_no_ilswe(Region.Bioenergy_rf_h(7).crop_allocation_cropland == 5))));

plotMatrix(2,3) = sum(sum(cropland_water_erosion_no_ilswe(Region.Bioenergy_rf_h(5).crop_allocation_ac == 3)));
plotMatrix(2,2) = sum(sum(cropland_water_erosion_no_ilswe(Region.Bioenergy_rf_h(5).crop_allocation_ac == 2)));

figure
bar(10^-3*plotMatrix, 'stacked');
xticklabels({'Abandoned cropland', 'Cropland subject to soil erosion'});
ylabel('kha');
legend({'Willow', 'Reed canary grass', 'Switchgrass'} , 'Location', 'northwest')

filename = 'fig2f.pdf';
print('-painters','-dpdf', '-r1000', filename)
end

