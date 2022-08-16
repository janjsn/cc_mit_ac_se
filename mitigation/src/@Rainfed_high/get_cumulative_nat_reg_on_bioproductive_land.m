function get_cumulative_nat_reg_on_bioproductive_land( obj )

c_to_co2 = 3.67;

soc_rate = c_to_co2*obj.gridded_soil_carbon_seq_rate_nat_regrowth_tonC_per_ha_year;
abc_rate_ac = c_to_co2*obj.acs_nr_rate_abandoned_cropland;
abc_rate_cropland = c_to_co2*obj.acs_nr_rate_cropland;

for scens = 1:length(obj.Bioenergy_rf_h)
    
    if obj.Bioenergy_rf_h(scens).is_wb_scenario == 1
        scen_description ='wb_scen';
    elseif obj.Bioenergy_rf_h(scens).is_energy_optimization == 1
        scen_description ='eo_scen';
    elseif obj.Bioenergy_rf_h(scens).is_carbon_optimization == 1
        scen_description ='co_scen';
    elseif obj.Bioenergy_rf_h(scens).is_single_crop == 1
        
        scen_description =obj.Bioenergy_rf_h(scens).crop_names;
    end
    
    prod_land_ac = obj.abandoned_cropland_hectare;
    prod_land_ac(obj.Bioenergy_rf_h(scens).dm_ac <=0) = 0;
    binary_ac = prod_land_ac > 0;
    prod_land_cropland_se = obj.cropland_under_soil_erosion_mod_high_4bioenergy_hectare;
    prod_land_cropland_se(obj.Bioenergy_rf_h(scens).pe_cropland_se_wat_wind_4bioenergy <= 0) = 0;
    binary_cropland_se = prod_land_cropland_se > 0;
    
    mean_abc_co2_seq_rate_ac = sum(sum(abc_rate_ac.*prod_land_ac))/sum(sum(prod_land_ac));
    mean_soc_co2_seq_rate_ac = sum(sum(soc_rate.*prod_land_ac))/sum(sum(prod_land_ac);
    co2_seq_rate_ac = abc_rate_ac+soc_rate;
    co2_seq_rate_ac(prod_land_ac <= 0) = 0;
    mean_co2_seq_per_ha_ac = sum(sum(co2_seq_rate_ac.*prod_land_ac))/sum(sum(prod_land_ac));
    
    mean_abc_co2_seq_rate_cropland_se = sum(sum(abc_rate_cropland.*prod_land_cropland_se))/sum(sum(prod_land_cropland_se));
    mean_soc_co2_seq_rate_cropland_se = sum(sum(soc_rate.*prod_land_cropland_se))/sum(sum(prod_land_cropland_se));
    co2_seq_rate_cropland_se = soc_rate+abc_rate_cropland;
    co2_seq_rate_cropland_se(binary_cropland_se == 0) = 0;
    mean_co2_seq_rate_cropland_se = sum(sum(co2_seq_rate_cropland_se.*prod_land_cropland_se))/sum(sum(prod_land_cropland_se));
    
    std_co2_seq_per_ha_ac = std(co2_seq_rate_ac(binary_ac),prod_land_ac(binary_ac));
    std_co2_seq_per_ha_cropland_se = std(co2_seq_rate_cropland_se(binary_cropland_se), prod_land_cropland_se(binary_cropland_se));
    
    filename = [ 'Output/src_data/src_data_' obj.region_name '_' scen_description 'nat_reg_co2seq_per_year_with_std.mat'];
    
    save(filename, 'mean_abc_co2_seq_rate_ac', 'mean_soc_co2_seq_rate_ac', 'mean_co2_seq_per_ha_ac', 'std_co2_seq_per_ha_ac', 'mean_abc_co2_seq_rate_cropland_se',...
        'mean_soc_co2_seq_rate_cropland_se', 'mean_co2_seq_rate_cropland_se', 'std_co2_seq_per_ha_cropland_se')
    
    
end


end

