function export_key_results_2mat( Regions_array )
%EXPORT_FE_TOTAL_2MAT Summary of this function goes here
%   Detailed explanation goes here

output = cell(100,2);

scens_idx = [2 3 4 5 6 7];
c=1;

wb_share = 1/3; %Share of ilswe land under bioenergy crops

for regs = 1:length(Regions_array)
    
    name = Regions_array(regs).region_name;
    
    output{c,1} = [name '|Abandoned cropland'];
    output{c,2} = sum(sum(Regions_array(regs).abandoned_cropland_hectare));
    output{c,3} = 'ha';
    c=c+1;
    output{c,1} = [name '|Cropland|se10'];
    output{c,2} = sum(sum(Regions_array(regs).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare));
    output{c,3} = 'ha';
    c=c+1;
    output{c,1} = [name '|Cropland|se5-10'];
    output{c,2} = sum(sum(Regions_array(regs).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare))-sum(sum(Regions_array(regs).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare));
    output{c,3} = 'ha';
    c=c+1;
    output{c,1} = [name '|Cropland|ilswe4'];
    output{c,2} = sum(sum(Regions_array(regs).cropland_ilswe_4_hectare));
    output{c,3} = 'ha';
    c=c+1;
    output{c,1} = [name '|Cropland|ilswe5'];
    output{c,2} = sum(sum(Regions_array(regs).cropland_ilswe_5_hectare));
    output{c,3} = 'ha';
    c=c+1;
    output{c,1} = [name '|Cropland|se5 ilswe4 ilswe5'];
    output{c,2} = sum(sum(Regions_array(regs).cropland_under_soil_erosion_mod_high_all_hectare));
    output{c,3} = 'ha';
    c=c+1;
    output{c,1} = [name '|Cropland|under soil erosion deployed for bioenergy'];
    output{c,2} = sum(sum(Regions_array(regs).cropland_under_soil_erosion_mod_high_4bioenergy_hectare));
    output{c,3} = 'ha';
    c=c+1;
    output{c,1} = [name '|Abandoned Cropland|se10'];
    output{c,2} = sum(sum(Regions_array(regs).abandoned_cropland_wse_above_10_ton_perHa_perYear_unit_hectare));
    output{c,3} = 'ha';
    c=c+1;
    output{c,1} = [name '|Abandoned Cropland|se5-10'];
    output{c,2} = sum(sum(Regions_array(regs).abandoned_cropland_wse_between_5_10_hectare));
    output{c,3} = 'ha';
    c=c+1;
    output{c,1} = [name '|Abandoned Cropland|ilswe4'];
    output{c,2} = sum(sum(Regions_array(regs).abandoned_cropland_ilswe_4_hectare));
    output{c,3} = 'ha';
    c=c+1;
    output{c,1} = [name '|Abandoned Cropland|ilswe5'];
    output{c,2} = sum(sum(Regions_array(regs).abandoned_cropland_ilswe_5_hectare));
    output{c,3} = 'ha';
    c=c+1;
    output{c,1} = [name '|All land deployed for bioenergy'];
    output{c,2} = sum(sum(Regions_array(regs).cropland_under_soil_erosion_mod_high_4bioenergy_hectare))+sum(sum(Regions_array(regs).abandoned_cropland_hectare));
    output{c,3} = 'ha';
    c=c+1;
    
    output{c,1} = [name '|natural regrowth|aboveground carbon|Abandoned cropland|'];
    output{c,2} = 3.67*10^-6*sum(sum(Regions_array(regs).abandoned_cropland_hectare.*Regions_array(regs).acs_nr_rate_abandoned_cropland));
    temp = output{c,2};
    output{c,3} = 'MtCO2 year-1';
    c=c+1;
    
    output{c,1} = [name '|natural regrowth|aboveground carbon|Cropland|under soil erosion deployed for bioenergy'];
    output{c,2} = 3.67*10^-6*sum(sum(Regions_array(regs).cropland_under_soil_erosion_mod_high_4bioenergy_hectare.*Regions_array(regs).acs_nr_rate_cropland));
    temp = temp+output{c,2};
    output{c,3} = 'MtCO2 year-1';
    c=c+1;
    
    output{c,1} = [name '|natural regrowth|aboveground carbon|All abandoned cropland and cropland threathened by soil erosion|'];
    output{c,2} = temp;
    output{c,3} = 'MtCO2 year-1';
    c=c+1;
    
    output{c,1} = [name '|natural regrowth|soil carbon|Abandoned cropland|'];
    output{c,2} = 3.67*10^-6*sum(sum(Regions_array(regs).abandoned_cropland_hectare.*Regions_array(regs).gridded_soil_carbon_seq_rate_nat_regrowth_tonC_per_ha_year));
    temp = output{c,2};
    output{c,3} = 'MtCO2 year-1';
    c=c+1;
    
    output{c,1} = [name '|natural regrowth|soil carbon|Cropland|under soil erosion deployed for bioenergy'];
    output{c,2} = 3.67*10^-6*sum(sum(Regions_array(regs).cropland_under_soil_erosion_mod_high_4bioenergy_hectare.*Regions_array(regs).gridded_soil_carbon_seq_rate_nat_regrowth_tonC_per_ha_year));
    temp = temp+output{c,2};
    output{c,3} = 'MtCO2 year-1';
    c=c+1;
    
    output{c,1} = [name '|natural regrowth|soil carbon|All abandoned cropland and cropland threathened by soil erosion|'];
    output{c,2} = temp;
    output{c,3} = 'MtCO2 year-1';
    c=c+1;
    
    for scens = 1:length(scens_idx)
        scen = scens_idx(scens);
        if Regions_array(regs).Bioenergy_rf_h(scen).is_wb_scenario == 1
            scen_desc = 'windbreaks and eo';
        elseif Regions_array(regs).Bioenergy_rf_h(scen).is_carbon_optimization == 1
            scen_desc = 'co';
        elseif Regions_array(regs).Bioenergy_rf_h(scen).is_energy_optimization == 1
            scen_desc = 'eo';
        elseif Regions_array(regs).Bioenergy_rf_h(scen).is_single_crop == 1
            scen_desc = Regions_array(regs).Bioenergy_rf_h(scen).crop_names;
        end
        Rf_h = Regions_array(regs).Bioenergy_rf_h(scen);
        
        GJ2PJ = 10^-6;
        
        output{c,1} = [name '|' scen_desc '|Primary energy|Abandoned cropland'];
        output{c,2} = Rf_h.pe_ac_tot*GJ2PJ;
        output{c,3} = 'PJ year-1';
        c=c+1;
        output{c,1} = [name '|' scen_desc '|Primary energy|Cropland|se10'];
        output{c,2} = Rf_h.pe_cropland_se10_tot*GJ2PJ;
        output{c,3} = 'PJ year-1';
        c=c+1;
        output{c,1} = [name '|' scen_desc '|Primary energy|Cropland|se5-10'];
        output{c,2} = (Rf_h.pe_cropland_se5_tot-Rf_h.pe_cropland_se10_tot)*GJ2PJ;
        output{c,3} = 'PJ year-1';
        c=c+1;
        output{c,1} = [name '|' scen_desc '|Primary energy|Cropland|ilswe4'];
        output{c,2} = Rf_h.pe_cropland_ilswe_4_tot*GJ2PJ;
        output{c,3} = 'PJ year-1';
        c=c+1;
        output{c,1} = [name '|' scen_desc '|Primary energy|Cropland|ilswe5'];
        output{c,2} = Rf_h.pe_cropland_ilswe_5_tot*GJ2PJ;
        output{c,3} = 'PJ year-1';
        c=c+1;
        output{c,1} = [name '|' scen_desc '|Primary energy|Cropland|under soil erosion deployed for bioenergy'];
        output{c,2} = sum(sum(Rf_h.pe_cropland_se_wat_wind_4bioenergy))*GJ2PJ;
        output{c,3} = 'PJ year-1';
        c=c+1;
        output{c,1} = [name '|' scen_desc '|Primary energy|All land deployed for bioenergy'];
        output{c,2} = sum(sum(Rf_h.pe_ac_cropland_se_wat_wind_4bioenergy))*GJ2PJ;
        output{c,3} = 'PJ year-1';
        c=c+1;
        
        output{c,1} = [name '|' scen_desc '|Productive land|Abandoned cropland'];
        output{c,2} = Rf_h.productive_land_ac_tot;
        output{c,3} = 'ha';
        c=c+1;
        output{c,1} = [name '|' scen_desc '|Productive land|Cropland|se10'];
        output{c,2} = Rf_h.productive_land_cropland_se10_tot;
        output{c,3} = 'ha';
        c=c+1;
        output{c,1} = [name '|' scen_desc '|Productive land|Cropland|se5-10'];
        output{c,2} = Rf_h.productive_land_cropland_se5_to_10_tot;
        output{c,3} = 'ha';
        c=c+1;
        output{c,1} = [name '|' scen_desc '|Productive land|Cropland|ilswe4'];
        output{c,2} = Rf_h.productive_land_cropland_ilswe_4_tot;
        output{c,3} = 'ha';
        c=c+1;
        output{c,1} = [name '|' scen_desc '|Productive land|Cropland|ilswe5'];
        output{c,2} = Rf_h.productive_land_cropland_ilswe_5_tot;
        output{c,3} = 'ha';
        c=c+1;
        output{c,1} = [name '|' scen_desc '|Productive land|Cropland|under soil erosion deployed for bioenergy'];
        output{c,2} = sum(sum(Regions_array(regs).cropland_under_soil_erosion_mod_high_4bioenergy_hectare(Rf_h.pe_cropland_se_wat_wind_4bioenergy >0)));
        output{c,3} = 'ha';
        c=c+1;
        output{c,1} = [name '|' scen_desc '|Productive land|All land deployed for bioenergy'];
        temp = Regions_array(regs).cropland_under_soil_erosion_mod_high_4bioenergy_hectare+Regions_array(regs).abandoned_cropland_hectare;
        output{c,3} = 'ha';
        output{c,2} = sum(sum(temp(Rf_h.pe_ac_cropland_se_wat_wind_4bioenergy > 0)));
        c=c+1;
        
        %Bioenergy yields
        output{c,1} = [name '|' scen_desc '|Mean primary bioenergy yield|Abandoned cropland'];
        output{c,3} = 'GJ ha-1 yr-1';
        output{c,2} = Rf_h.pe_yield_ac_mean;
        c=c+1;
        output{c,1} = [name '|' scen_desc '|Mean primary bioenergy yield|Cropland|se10'];
        output{c,3} = 'GJ ha-1 yr-1';
        output{c,2} = Rf_h.pe_yield_cropland_se10_mean;
        c=c+1;
        output{c,1} = [name '|' scen_desc '|Mean primary bioenergy yield|Cropland|se5-10'];
        output{c,3} = 'GJ ha-1 yr-1';
        output{c,2} = sum(sum((Rf_h.pe_cropland_se5-Rf_h.pe_cropland_se10)))/Rf_h.productive_land_cropland_se5_to_10_tot;
        c=c+1;
        output{c,1} = [name '|' scen_desc '|Mean primary bioenergy yield|Cropland|ilswe4'];
        output{c,3} = 'GJ ha-1 yr-1';
        output{c,2} = Rf_h.pe_yield_cropland_ilswe4_mean;
        c=c+1;
        output{c,1} = [name '|' scen_desc '|Mean primary bioenergy yield|Cropland|ilswe5'];
        output{c,3} = 'GJ ha-1 yr-1';
        output{c,2} = Rf_h.pe_yield_cropland_ilswe5_mean;
        c=c+1;
        output{c,1} = [name '|' scen_desc '|Mean primary bioenergy yield|Cropland|under soil erosion deployed for bioenergy'];
        output{c,3} = 'GJ ha-1 yr-1';
        output{c,2} = Rf_h.pe_yield_cropland_pe_cropland_both_se5_and_ilswe_4_5_mean;
        c=c+1;
        output{c,1} = [name '|' scen_desc '|Mean primary bioenergy yield|All land deployed for bioenergy'];
        output{c,3} = 'GJ ha-1 yr-1';
        output{c,2} = sum(sum(Rf_h.pe_ac_cropland_se_wat_wind_4bioenergy))/(Rf_h.productive_land_ac_cropland_se_wind_wat_tot);
        c=c+1;
        
        for refs = 1:length(Regions_array(regs).Bioenergy_rf_h(scen).Biorefinery_energy_carbon_flows)
            fe_this = Regions_array(regs).Bioenergy_rf_h(scen).Biorefinery_energy_carbon_flows(refs);
            this_ref = fe_this.Biorefinery;
            ref_name = this_ref.description;
            
            output{c,1} = [name '|' scen_desc '|' ref_name '|Final energy| Abandoned cropland'];
            output{c,2} = fe_this.fe_ac_tot*GJ2PJ;
            output{c,3} = 'PJ year-1';
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Final energy|Cropland|se10'];
            output{c,2} = fe_this.fe_cropland_se10_tot*GJ2PJ;
            output{c,3} = 'PJ year-1';
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Final energy|Cropland|se5-10'];
            output{c,2} = (fe_this.fe_cropland_se5_tot-fe_this.fe_cropland_se10_tot)*GJ2PJ;
            output{c,3} = 'PJ year-1';
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Final energy|Cropland|ilswe4'];
            output{c,2} = fe_this.fe_cropland_ilswe_4_tot*GJ2PJ;
            output{c,3} = 'PJ year-1';
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Final energy|Cropland|ilswe5'];
            output{c,2} = fe_this.fe_cropland_ilswe_5_tot*GJ2PJ;
            output{c,3} = 'PJ year-1';
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Final energy|Cropland|under soil erosion deployed for bioenergy'];
            fe_se_bio = fe_this.fe_cropland_se5+wb_share*(fe_this.fe_cropland_ilswe_4+fe_this.fe_cropland_ilswe_5-fe_this.fe_cropland_both_se5_and_ilswe_4_5);
            output{c,2} = sum(sum(fe_se_bio))*GJ2PJ;
            output{c,3} = 'PJ year-1';
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Final energy|All land deployed for bioenergy'];
            output{c,2} = (sum(sum(fe_se_bio))+fe_this.fe_ac_tot)*GJ2PJ;
            output{c,3} = 'PJ year-1';
            c=c+1;
            
            bioeth_eff = this_ref.ethanol_efficiency/this_ref.energy_efficiency;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Final energy|Bioethanol|Abandoned cropland'];
            output{c,2} = fe_this.fe_ac_tot*bioeth_eff*GJ2PJ;
            output{c,3} = 'PJ year-1';
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Final energy|Bioethanol|Cropland|under soil erosion deployed for bioenergy'];
            output{c,2} = sum(sum(fe_se_bio))*bioeth_eff*GJ2PJ;
            output{c,3} = 'PJ year-1';
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Final energy|Bioethanol|All land deployed for bioenergy'];
            output{c,2} = (sum(sum(fe_se_bio))+fe_this.fe_ac_tot)*bioeth_eff*GJ2PJ;
            output{c,3} = 'PJ year-1';
            c=c+1;
            
            ft_d_eff = this_ref.fischer_tropsch_efficiency*this_ref.share_ft_to_diesel/this_ref.energy_efficiency;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Final energy|FT diesel|Abandoned cropland'];
            output{c,2} = fe_this.fe_ac_tot*ft_d_eff*GJ2PJ;
            output{c,3} = 'PJ year-1';
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Final energy|FT diesel|Cropland|under soil erosion deployed for bioenergy'];
            output{c,2} = sum(sum(fe_se_bio))*ft_d_eff*GJ2PJ;
            output{c,3} = 'PJ year-1';
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Final energy|FT diesel|All land deployed for bioenergy'];
            output{c,2} = (sum(sum(fe_se_bio))+fe_this.fe_ac_tot)*ft_d_eff*GJ2PJ;
            output{c,3} = 'PJ year-1';
            c=c+1;
            
            ft_g_eff = this_ref.fischer_tropsch_efficiency*this_ref.share_ft_to_gasoline/this_ref.energy_efficiency;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Final energy|FT gasoline|Abandoned cropland'];
            output{c,2} = fe_this.fe_ac_tot*ft_g_eff*GJ2PJ;
            output{c,3} = 'PJ year-1';
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Final energy|FT gasoline|Cropland|under soil erosion deployed for bioenergy'];
            output{c,2} = sum(sum(fe_se_bio))*ft_g_eff*GJ2PJ;
            output{c,3} = 'PJ year-1';
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Final energy|FT gasoline|All land deployed for bioenergy'];
            output{c,2} = (sum(sum(fe_se_bio))+fe_this.fe_ac_tot)*ft_g_eff*GJ2PJ;
            output{c,3} = 'PJ year-1';
            c=c+1;
            
            el_eff = this_ref.electricity_efficiency/this_ref.energy_efficiency;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Final energy|Electricity|Abandoned cropland'];
            output{c,2} = fe_this.fe_ac_tot*el_eff*GJ2PJ;
            output{c,3} = 'PJ year-1';
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Final energy|Electricity|Cropland|under soil erosion deployed for bioenergy'];
            output{c,2} = sum(sum(fe_se_bio))*el_eff*GJ2PJ;
            output{c,3} = 'PJ year-1';
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Final energy|Electricity|All land deployed for bioenergy'];
            output{c,2} = (sum(sum(fe_se_bio))+fe_this.fe_ac_tot)*el_eff*GJ2PJ;
            output{c,3} = 'PJ year-1';
            c=c+1;
            
            % CCS
            C_to_CO2 = 3.67;
            t_to_Mt = 10^-6;
            
            plotVec_ccs = zeros(1,5);
            
            output{c,1} = [name '|' scen_desc '|' ref_name '|CCS|CO2|Abandoned cropland'];
            output{c,2} = fe_this.carbon_ccs_or_char_abandoned_cropland_tot*C_to_CO2*t_to_Mt;
            output{c,3} = 'MtCO2 year-1';
            plotVec_ccs(1) = output{c,2};
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|CCS|CO2|Cropland|se10'];
            output{c,2} = fe_this.carbon_ccs_or_char_cropland_se10_tot*C_to_CO2*t_to_Mt;
            output{c,3} = 'MtCO2 year-1';
            plotVec_ccs(3) = output{c,2};
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|CCS|CO2|Cropland|se5-10'];
            output{c,2} = (fe_this.carbon_ccs_or_char_cropland_se5_tot-fe_this.carbon_ccs_or_char_cropland_se10_tot)*C_to_CO2*t_to_Mt;
            output{c,3} = 'MtCO2 year-1';
            plotVec_ccs(2) = output{c,2};
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|CCS|CO2|Cropland|ilswe4'];
            output{c,2} = (fe_this.carbon_ccs_or_char_cropland_ilswe_4_tot)*C_to_CO2*t_to_Mt;
            output{c,3} = 'MtCO2 year-1';
            plotVec_ccs(4) = output{c,2}*wb_share;
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|CCS|CO2|Cropland|ilswe5'];
            output{c,2} = (fe_this.carbon_ccs_or_char_cropland_ilswe_5_tot*C_to_CO2*t_to_Mt);
            output{c,3} = 'MtCO2 year-1';
            plotVec_ccs(5) = output{c,2}*wb_share;
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|CCS|CO2|Cropland|Under soil erosion deployed for bioenergy'];
            output{c,2} = (fe_this.carbon_ccs_or_char_cropland_se_mod_high_4bioenergy_tot*C_to_CO2*t_to_Mt);
            output{c,3} = 'MtCO2 year-1';
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|CCS|CO2|All land deployed for bioenergy'];
            output{c,2} = (fe_this.carbon_ccs_or_char_cropland_se_mod_high_4bioenergy_tot+fe_this.carbon_ccs_or_char_abandoned_cropland_tot)*C_to_CO2*t_to_Mt;
            output{c,3} = 'MtCO2 year-1';
            c=c+1;
            
            %Mitigation
            n_years = fe_this.GWP100_ac.time_period_years;
            n_years_string = num2str(n_years);
            
            output{c,1} = [name '|' scen_desc '|' ref_name '|Mitigation|Mitigation intensity|Abandoned cropland|' n_years_string ' year average'];
            output{c,2} = fe_this.GWP100_ac.tco2eq_total_mitigation_per_ha_year_with_abc_mean;
            output{c,3} = 'tCO2eq ha-1 year-1';
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Mitigation|Mitigation intensity|Cropland|se10|' n_years_string ' year average'];
            output{c,2} = fe_this.GWP100_cropland_se10.tco2eq_total_mitigation_per_ha_year_with_abc_mean;
            output{c,3} = 'tCO2eq ha-1 year-1';
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Mitigation|Mitigation intensity|Cropland|se5-10|' n_years_string ' year average'];
            output{c,2} = fe_this.GWP100_cropland_se5to10.tco2eq_total_mitigation_per_ha_year_with_abc_mean;
            output{c,3} = 'tCO2eq ha-1 year-1';
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Mitigation|Mitigation intensity|Cropland|ilswe4|' n_years_string ' year average'];
            output{c,2} = fe_this.GWP100_cropland_ilswe_4.tco2eq_total_mitigation_per_ha_year_with_abc_mean;
            output{c,3} = 'tCO2eq ha-1 year-1';
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Mitigation|Mitigation intensity|Cropland|ilswe5|' n_years_string ' year average'];
            output{c,2} = fe_this.GWP100_cropland_ilswe_5.tco2eq_total_mitigation_per_ha_year_with_abc_mean;
            output{c,3} = 'tCO2eq ha-1 year-1';
            c=c+1;
            output{c,1} = [name '|' scen_desc '|' ref_name '|Mitigation|Mitigation intensity|Cropland|Under soil erosion deployed for bioenergy|' n_years_string ' year average'];
            output{c,2} = fe_this.GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.tco2eq_total_mitigation_per_ha_year_with_abc_mean;
            output{c,3} = 'tCO2eq ha-1 year-1';
            c=c+1;
            %Standard deviations
            if fe_this.GWP100_ac.standard_deviation_computed == 1
                output{c,1} = [name '|' scen_desc '|' ref_name '|Mitigation|Mitigation intensity|Abandoned cropland|' n_years_string ' year average|Standard deviation'];
                output{c,2} = fe_this.GWP100_ac.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean_std_dev;
                output{c,3} = 'tCO2eq ha-1 year-1';
                c=c+1;
            end
            if fe_this.GWP100_cropland_se10.standard_deviation_computed == 1
                output{c,1} = [name '|' scen_desc '|' ref_name '|Mitigation|Mitigation intensity|Cropland|se10|' n_years_string ' year average|Standard deviation'];
                output{c,2} = fe_this.GWP100_cropland_se10.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean_std_dev;
                output{c,3} = 'tCO2eq ha-1 year-1';
                c=c+1;
            end
            if fe_this.GWP100_cropland_se5to10.standard_deviation_computed == 1
                output{c,1} = [name '|' scen_desc '|' ref_name '|Mitigation|Mitigation intensity|Cropland|se5-10|' n_years_string ' year average|Standard deviation'];
                output{c,2} = fe_this.GWP100_cropland_se5to10.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean_std_dev;
                output{c,3} = 'tCO2eq ha-1 year-1';
                c=c+1;
            end
            if fe_this.GWP100_cropland_ilswe_4.standard_deviation_computed == 1
                output{c,1} = [name '|' scen_desc '|' ref_name '|Mitigation|Mitigation intensity|Cropland|ilswe4|' n_years_string ' year average|Standard deviation'];
                output{c,2} = fe_this.GWP100_cropland_ilswe_4.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean_std_dev;
                output{c,3} = 'tCO2eq ha-1 year-1';
                c=c+1;
            end
            if fe_this.GWP100_cropland_ilswe_5.standard_deviation_computed == 1
                output{c,1} = [name '|' scen_desc '|' ref_name '|Mitigation|Mitigation intensity|Cropland|ilswe5|' n_years_string ' year average|Standard deviation'];
                output{c,2} = fe_this.GWP100_cropland_ilswe_5.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean_std_dev;
                output{c,3} = 'tCO2eq ha-1 year-1';
                c=c+1;
            end
            if fe_this.GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.standard_deviation_computed == 1
                output{c,1} = [name '|' scen_desc '|' ref_name '|Mitigation|Mitigation intensity|Cropland|Under soil erosion deployed for bioenergy|' n_years_string ' year average|Standard deviation'];
                output{c,2} = fe_this.GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean_std_dev;
                output{c,3} = 'tCO2eq ha-1 year-1';
                c=c+1;
            end
            %             output{c,1} = [name '|' scen_desc '|' ref_name '|Mitigation|Mean mitigation intensity|Cropland|All land deployed for bioenergy'];
            %             output{c,2} = fe_this.GWP100_ac.tco2eq_total_mitigation_per_ha_year_with_abc_mean;
            %             output{c,3} = 'tCO2eq ha-1 year-1';
            %             c=c+1;
            
            fe_this.GWP100_ac.tco2eq_total_mitigation_per_year_with_abc_mean;
            if sum(plotVec_ccs > 0)
                figure
                bar(plotVec_ccs);
                ylabel('MtCO2 year-1');
                xticklabels({'Abandoned cropland','Moderate water erosion', 'High water erosion', 'Moderate wind erosion', 'High wind erosion'});
                filename = ['Output/plots/' name '_' scen_desc '_CCS.pdf'];
                print('-painters','-dpdf', '-r1000', filename)
            end
        end
    end
    
end

output
filename_mat_results = 'Output/key_results_2005.mat';
if exist(filename_mat_results, 'file')
    delete(filename_mat_results)
end
save(filename_mat_results, 'output')

end

