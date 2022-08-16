function obj= calc_biomass_transport_emissions_farm2ref( obj, Inputs )
%CALC_BIOMASS_TRANSPORT_EMISSIONS_FARM2REF Summary of this function goes here
%   Detailed explanation goes here

calc_transport_distance_by_refinery_coordinates = 0;

if calc_transport_distance_by_refinery_coordinates == 1
    fprintf('Calculating biomass transport based on refinery coordinates.. \n')
    obj.gwp100_diesel_transport_biomass_farm2ref_kg_co2eq_per_ton_dm = obj.distance_from_nearest_refinery_km.*Inputs.diesel_biomass_transport_energy_use_MJ_per_tkm.*Inputs.gwp100_diesel_kgCO2eq_per_MJ;
else
    fprintf('Using 200km as biomass transport distance.. \n')
    obj.gwp100_diesel_transport_biomass_farm2ref_kg_co2eq_per_ton_dm = 200*Inputs.diesel_biomass_transport_energy_use_MJ_per_tkm.*Inputs.gwp100_diesel_kgCO2eq_per_MJ;
end
for i = 1:length(obj.Bioenergy_rf_h)
obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_ac = 10^-3*obj.Bioenergy_rf_h(i).dm_ac.*obj.gwp100_diesel_transport_biomass_farm2ref_kg_co2eq_per_ton_dm;
obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland = 10^-3*obj.Bioenergy_rf_h(i).dm_cropland.*obj.gwp100_diesel_transport_biomass_farm2ref_kg_co2eq_per_ton_dm;
obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_se5 = 10^-3*obj.Bioenergy_rf_h(i).dm_cropland_se5.*obj.gwp100_diesel_transport_biomass_farm2ref_kg_co2eq_per_ton_dm;
obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_se10 = 10^-3*obj.Bioenergy_rf_h(i).dm_cropland_se10.*obj.gwp100_diesel_transport_biomass_farm2ref_kg_co2eq_per_ton_dm;
obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_ilswe_1 = 10^-3*obj.Bioenergy_rf_h(i).dm_cropland_ilswe_1.*obj.gwp100_diesel_transport_biomass_farm2ref_kg_co2eq_per_ton_dm;
obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_ilswe_2 = 10^-3*obj.Bioenergy_rf_h(i).dm_cropland_ilswe_2.*obj.gwp100_diesel_transport_biomass_farm2ref_kg_co2eq_per_ton_dm;
obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_ilswe_3 = 10^-3*obj.Bioenergy_rf_h(i).dm_cropland_ilswe_3.*obj.gwp100_diesel_transport_biomass_farm2ref_kg_co2eq_per_ton_dm;
obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_ilswe_4 = 10^-3*obj.Bioenergy_rf_h(i).dm_cropland_ilswe_4.*obj.gwp100_diesel_transport_biomass_farm2ref_kg_co2eq_per_ton_dm;
obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_ilswe_5 = 10^-3*obj.Bioenergy_rf_h(i).dm_cropland_ilswe_5.*obj.gwp100_diesel_transport_biomass_farm2ref_kg_co2eq_per_ton_dm;
obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_flood = 10^-3*obj.Bioenergy_rf_h(i).dm_cropland_flood.*obj.gwp100_diesel_transport_biomass_farm2ref_kg_co2eq_per_ton_dm;

obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_ac_tot = sum(sum(obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_ac ));
obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_tot  = sum(sum(obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland ));
obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_se5_tot  = sum(sum(obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_se5 ));
obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_se10_tot = sum(sum(obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_se10 ));
obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_ilswe_1_tot = sum(sum(obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_ilswe_1 ));
obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_ilswe_2_tot = sum(sum(obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_ilswe_2 ));
obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_ilswe_3_tot = sum(sum(obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_ilswe_3 ));
obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_ilswe_4_tot = sum(sum(obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_ilswe_4 ));
obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_ilswe_5_tot = sum(sum(obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_ilswe_5 ));
obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_flood_tot = sum(sum(obj.Bioenergy_rf_h(i).diesel_biomass_transport_emissions_cropland_flood ));
end

end

