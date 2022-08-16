% for reg = 1:length(Regions)
%    for scens = 1:length(Regions(reg).Bioenergy_rf_h)
%        if reg == 4 && scens == 1
%            continue
%        end
%        Regions(reg).plot_mitigation(scens, Inputs)
% %        pe = sum(sum(Regions(reg).Bioenergy_rf_h(scens).pe_ac))
% %        for refs = 1:length(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows)
% %        fe = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).fe_ac))
% %        eff = fe/pe
% %        end
%    end
% end
% for idx = 1:5
% this_rf_h = Regions(idx).Bioenergy_rf_h(2);
% 
% productive_ac = Regions(idx).abandoned_cropland_hectare;
% productive_ac(this_rf_h.dm_yield <=0) = 0;
% 
% pe_ac = this_rf_h.pe_ac;
% em_ac = this_rf_h.farm_emissions_gwp100_ac;
% 
% productive_c_se = Regions(idx).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare+Regions(idx).cropland_ilswe_4_hectare+Regions(idx).cropland_ilswe_5_hectare-Regions(idx).cropland_both_ilswe_4_5_se_5;
% em_c_se = this_rf_h.farm_emissions_gwp100_cropland_se_5+((this_rf_h.farm_emissions_gwp100_cropland_ilswe_4+this_rf_h.farm_emissions_gwp100_cropland_ilswe_5).*(1-Regions(idx).share_of_cropland_ilswe_also_under_se));
% 
% %em_intensity_ac = sum(sum(em_ac))/sum(sum(productive_ac))
% %em_intensity_c_se = sum(sum(em_c_se))/sum(sum(productive_c_se))
% 
% 
% 
% 
% % 
% % end
% 
% 
for reg = 1:length(Regions)
        
       Regions(reg).plot_ac_distribution_after_abandonment( ABC );

       
   for scens = 1:length(Regions(reg).Bioenergy_rf_h)
   
       if reg == 4 && scens == 1
           continue
       end
       Regions(reg).plot_mitigation(scens, Inputs,Natural_regrowth);
   end
end


%% GET GRIDDED MITIGATION NUMBERS, TARGETTED NORDIC WB Scenario
% for reg = 1:length(Regions)
%     for refs = 1:length(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows)
%         scens = 7; %HARDCODE
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.calc_gridded_nets;
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.calc_gridded_nets;
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.calc_gridded_nets;
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.calc_gridded_nets;
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.calc_gridded_nets;
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.calc_gridded_nets;
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.calc_gridded_nets;
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.calc_gridded_nets;
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.calc_gridded_nets;
%         
%         %Get annual mitigation
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_per_ha_year_gridded_net_mitigation_annual = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_per_year_gridded_net_mitigation_annual./Regions(reg).abandoned_cropland_hectare;
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_per_ha_year_gridded_net_mitigation_annual(isnan(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_per_ha_year_gridded_net_mitigation_annual)) = 0;
%         
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_per_ha_year_gridded_net_mitigation_annual = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_per_year_gridded_net_mitigation_annual./Regions(reg).cropland_hectare;
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_per_ha_year_gridded_net_mitigation_annual(isnan(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_per_ha_year_gridded_net_mitigation_annual)) = 0;
%         
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_per_ha_year_gridded_net_mitigation_annual = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_per_year_gridded_net_mitigation_annual./Regions(reg).cropland_ilswe_4_hectare;
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_per_ha_year_gridded_net_mitigation_annual(isnan(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_per_ha_year_gridded_net_mitigation_annual)) = 0;
%         
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_per_ha_year_gridded_net_mitigation_annual = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_per_year_gridded_net_mitigation_annual./Regions(reg).cropland_ilswe_5_hectare;
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_per_ha_year_gridded_net_mitigation_annual(isnan(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_per_ha_year_gridded_net_mitigation_annual)) = 0;
%         
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.tco2eq_per_ha_year_gridded_net_mitigation_annual = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.tco2eq_per_year_gridded_net_mitigation_annual./Regions(reg).cropland_both_ilswe_4_5_se_5;
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.tco2eq_per_ha_year_gridded_net_mitigation_annual(isnan(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.tco2eq_per_ha_year_gridded_net_mitigation_annual)) = 0;
%         
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_per_ha_year_gridded_net_mitigation_annual = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_per_year_gridded_net_mitigation_annual./Regions(reg).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare;
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_per_ha_year_gridded_net_mitigation_annual(isnan(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_per_ha_year_gridded_net_mitigation_annual)) = 0;
%         
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_per_ha_year_gridded_net_mitigation_annual = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_per_year_gridded_net_mitigation_annual./Regions(reg).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare;
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_per_ha_year_gridded_net_mitigation_annual(isnan(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_per_ha_year_gridded_net_mitigation_annual)) = 0;
%         
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_per_ha_year_gridded_net_mitigation_annual = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_per_year_gridded_net_mitigation_annual./(Regions(reg).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare-Regions(reg).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare);
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_per_ha_year_gridded_net_mitigation_annual(isnan(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_per_ha_year_gridded_net_mitigation_annual)) = 0;
%         
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.tco2eq_per_ha_year_gridded_net_mitigation_annual = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.tco2eq_per_year_gridded_net_mitigation_annual./(Regions(reg).cropland_under_soil_erosion_mod_high_4bioenergy_hectare);
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.tco2eq_per_ha_year_gridded_net_mitigation_annual(isnan(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.tco2eq_per_ha_year_gridded_net_mitigation_annual)) = 0;
%         
%         
%         %Get annual mean mitigation per hectare
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_per_year_gridded_net_mitigation_annual))/sum(sum(Regions(reg).abandoned_cropland_hectare));
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_per_year_gridded_net_mitigation_annual))/sum(sum(Regions(reg).cropland_hectare));
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_per_year_gridded_net_mitigation_annual))/sum(sum(Regions(reg).cropland_ilswe_4_hectare));
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_per_year_gridded_net_mitigation_annual))/sum(sum(Regions(reg).cropland_ilswe_5_hectare));
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.tco2eq_per_year_gridded_net_mitigation_annual))/sum(sum(Regions(reg).cropland_both_ilswe_4_5_se_5));
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_per_year_gridded_net_mitigation_annual))/sum(sum(Regions(reg).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare));
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_per_year_gridded_net_mitigation_annual))/sum(sum(Regions(reg).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare));
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_per_year_gridded_net_mitigation_annual))/sum(sum(Regions(reg).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare-Regions(reg).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare));
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.tco2eq_per_year_gridded_net_mitigation_annual))/sum(sum(Regions(reg).cropland_under_soil_erosion_mod_high_4bioenergy_hectare));
%         
%         %Calc standard deviations
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.calc_standard_deviation(Regions(reg).abandoned_cropland_hectare);
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.calc_standard_deviation(Regions(reg).cropland_hectare);
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.calc_standard_deviation(Regions(reg).cropland_ilswe_4_hectare);
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.calc_standard_deviation(Regions(reg).cropland_ilswe_5_hectare);
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.calc_standard_deviation(Regions(reg).cropland_both_ilswe_4_5_se_5);
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.calc_standard_deviation(Regions(reg).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare);
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.calc_standard_deviation(Regions(reg).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare);
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.calc_standard_deviation(Regions(reg).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare-Regions(reg).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare);
%         Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.calc_standard_deviation(Regions(reg).cropland_under_soil_erosion_mod_high_4bioenergy_hectare);
%     end
% end
% for i = 1:3
%     
%     if i  == 1
%         filename = 'current_ref_gridded_mitigation';
%     elseif i == 2
%         filename = 'future_ref_gridded_mitigation';
%     elseif i == 3
%        filename = 'beccs_ref_gridded_mitigation'; 
%     end
%     
%     productive_area_ac = Regions(1).abandoned_cropland_hectare;
%     productive_area_ac(Regions(1).Bioenergy_rf_h(7).pe_ac <= 0) = 0;
%     productive_area_cropland_se = Regions(1).cropland_under_soil_erosion_mod_high_4bioenergy_hectare;
%     productive_area_cropland_se(Regions(1).Bioenergy_rf_h(7).pe_cropland_se_wat_wind_4bioenergy <= 0) = 0;
%     nat_reg_rate_ac = -(Regions(1).acs_nr_rate_abandoned_cropland+Regions(1).gridded_soil_carbon_seq_rate_nat_regrowth_tonC_per_ha_year);
%     nat_reg_rate_ac = nat_reg_rate_ac*3.67;
%     nat_reg_ac =-(Regions(1).acs_nr_rate_abandoned_cropland+Regions(1).gridded_soil_carbon_seq_rate_nat_regrowth_tonC_per_ha_year).*productive_area_ac*3.67;
%     nat_reg_cropland_se = -(Regions(1).acs_nr_rate_cropland+Regions(1).gridded_soil_carbon_seq_rate_nat_regrowth_tonC_per_ha_year).*productive_area_cropland_se*3.67;
%     nat_reg_rate_cropland_se = -(Regions(1).acs_nr_rate_cropland+Regions(1).gridded_soil_carbon_seq_rate_nat_regrowth_tonC_per_ha_year)*3.67;
% Regions(1).Bioenergy_rf_h(7).Biorefinery_energy_carbon_flows(i).GWP100_ac.write_gridded_mitigation_to_netcdf([filename '_ac.nc'],Regions(1).lat, Regions(1).lon, nat_reg_rate_ac, nat_reg_ac)
% Regions(1).Bioenergy_rf_h(7).Biorefinery_energy_carbon_flows(i).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.write_gridded_mitigation_to_netcdf([filename '_cropland_se.nc'],Regions(1).lat, Regions(1).lon, nat_reg_rate_cropland_se, nat_reg_cropland_se)
% 
% end
% 
%     productive_area_ac = Regions(1).abandoned_cropland_hectare;
%     productive_area_ac(Regions(1).Bioenergy_rf_h(7).pe_ac <= 0) = 0;
%     productive_area_cropland_se = Regions(1).cropland_under_soil_erosion_mod_high_4bioenergy_hectare;
%     productive_area_cropland_se(Regions(1).Bioenergy_rf_h(7).pe_cropland_se_wat_wind_4bioenergy <= 0) = 0;
%     
%     
