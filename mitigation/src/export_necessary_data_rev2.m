%Export nordic results

% Regions(1).export_src_data_soc_change_and_abc_ac( 7, 'Output/soc_change_and_abc_nat_reg.nc');
% 
% Regions(1).plot_mitigation_per_ha_with_std_30y(Inputs);
% 
% Regions(1).plot_mitigation(7,Inputs, Natural_regrowth);

for i = 1:3
    
    if i  == 1
        filename = 'current_ref_gridded_mitigation';
    elseif i == 2
        filename = 'future_ref_gridded_mitigation';
    elseif i == 3
       filename = 'beccs_ref_gridded_mitigation'; 
    end
    
    fprintf(filename);
    fprintf('\n');
    
    productive_area_ac = Regions(1).abandoned_cropland_hectare;
    productive_area_ac(Regions(1).Bioenergy_rf_h(7).pe_ac <= 0) = 0;
    productive_area_cropland_se = Regions(1).cropland_under_soil_erosion_mod_high_4bioenergy_hectare;
    productive_area_cropland_se(Regions(1).Bioenergy_rf_h(7).pe_cropland_se_wat_wind_4bioenergy <= 0) = 0;
    nat_reg_rate_ac = -(Regions(1).acs_nr_rate_abandoned_cropland+Regions(1).gridded_soil_carbon_seq_rate_nat_regrowth_tonC_per_ha_year);
    nat_reg_rate_ac = nat_reg_rate_ac*3.67;
    nat_reg_ac =-(Regions(1).acs_nr_rate_abandoned_cropland+Regions(1).gridded_soil_carbon_seq_rate_nat_regrowth_tonC_per_ha_year).*productive_area_ac*3.67;
    nat_reg_cropland_se = -(Regions(1).acs_nr_rate_cropland+Regions(1).gridded_soil_carbon_seq_rate_nat_regrowth_tonC_per_ha_year).*productive_area_cropland_se*3.67;
    nat_reg_rate_cropland_se = -(Regions(1).acs_nr_rate_cropland+Regions(1).gridded_soil_carbon_seq_rate_nat_regrowth_tonC_per_ha_year)*3.67;
best_ac = Regions(1).Bioenergy_rf_h(7).Biorefinery_energy_carbon_flows(i).GWP100_ac.write_gridded_mitigation_to_netcdf([filename '_ac.nc'],Regions(1).lat, Regions(1).lon, nat_reg_rate_ac, nat_reg_ac);
best_se = Regions(1).Bioenergy_rf_h(7).Biorefinery_energy_carbon_flows(i).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.write_gridded_mitigation_to_netcdf([filename '_cropland_se.nc'],Regions(1).lat, Regions(1).lon, nat_reg_rate_cropland_se, nat_reg_cropland_se);

best_bio_ac_ha = sum(sum(productive_area_ac.*(best_ac == 1)))
best_nat_ac_ha = sum(sum(productive_area_ac.*(best_ac == 2)))
best_bio_se_ha = sum(sum(productive_area_cropland_se.*(best_se == 1)))
best_nat_se_ha = sum(sum(productive_area_cropland_se.*(best_se == 2)))


end

export_src_data_fig2(Regions(1));
plot_final_energy(Regions);