function [ obj ] = calc_bioenergy_carbon_flows( obj, BiorefineryArray, Inputs, CropType_Array)
%CALC_BIOENERGY_CARBON_FLOWS Summary of this function goes here
%   Detailed explanation goes here

n_refineries = length(BiorefineryArray);

temp_biorefinery_energy_carbon_flows(1:n_refineries) = Biorefinery_energy_carbon_flows;





for scens = 1:length(obj.Bioenergy_rf_h)
    
    obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows = temp_biorefinery_energy_carbon_flows;
    for refs = 1:n_refineries
        this_ref = Biorefinery_energy_carbon_flows;
        this_ref.Biorefinery = BiorefineryArray(refs);
        
        
        this_ref.fe_ac = obj.Bioenergy_rf_h(scens).pe_ac*this_ref.Biorefinery.energy_efficiency;
        this_ref.fe_cropland = obj.Bioenergy_rf_h(scens).pe_cropland*this_ref.Biorefinery.energy_efficiency;
        this_ref.fe_cropland_se5 = obj.Bioenergy_rf_h(scens).pe_cropland_se5*this_ref.Biorefinery.energy_efficiency;
        this_ref.fe_cropland_se10 = obj.Bioenergy_rf_h(scens).pe_cropland_se10*this_ref.Biorefinery.energy_efficiency;
        this_ref.fe_cropland_ilswe_1 = obj.Bioenergy_rf_h(scens).pe_cropland_ilswe_1*this_ref.Biorefinery.energy_efficiency;
        this_ref.fe_cropland_ilswe_2 = obj.Bioenergy_rf_h(scens).pe_cropland_ilswe_2*this_ref.Biorefinery.energy_efficiency;
        this_ref.fe_cropland_ilswe_3 = obj.Bioenergy_rf_h(scens).pe_cropland_ilswe_3*this_ref.Biorefinery.energy_efficiency;
        this_ref.fe_cropland_ilswe_4 = obj.Bioenergy_rf_h(scens).pe_cropland_ilswe_4*this_ref.Biorefinery.energy_efficiency;
        this_ref.fe_cropland_ilswe_5 = obj.Bioenergy_rf_h(scens).pe_cropland_ilswe_5*this_ref.Biorefinery.energy_efficiency;
        this_ref.fe_cropland_both_se5_and_ilswe_4_5 = obj.Bioenergy_rf_h(scens).pe_cropland_both_se5_and_ilswe_4_5*this_ref.Biorefinery.energy_efficiency;
        this_ref.fe_cropland_flood = obj.Bioenergy_rf_h(scens).pe_cropland_flood*this_ref.Biorefinery.energy_efficiency;
        
        this_ref.fe_ac_tot = sum(sum(this_ref.fe_ac));
        this_ref.fe_cropland_tot = sum(sum(this_ref.fe_cropland));
        this_ref.fe_cropland_se5_tot = sum(sum(this_ref.fe_cropland_se5));
        this_ref.fe_cropland_se10_tot = sum(sum(this_ref.fe_cropland_se10));
        this_ref.fe_cropland_ilswe_1_tot = sum(sum(this_ref.fe_cropland_ilswe_1));
        this_ref.fe_cropland_ilswe_2_tot = sum(sum(this_ref.fe_cropland_ilswe_2));
        this_ref.fe_cropland_ilswe_3_tot = sum(sum(this_ref.fe_cropland_ilswe_3));
        this_ref.fe_cropland_ilswe_4_tot = sum(sum(this_ref.fe_cropland_ilswe_4));
        this_ref.fe_cropland_ilswe_5_tot = sum(sum(this_ref.fe_cropland_ilswe_5));
        this_ref.fe_cropland_both_se5_and_ilswe_4_5_tot = sum(sum(this_ref.fe_cropland_both_se5_and_ilswe_4_5));
        this_ref.fe_cropland_flood_tot = sum(sum(this_ref.fe_cropland_flood));
        this_ref.fe_cropland_all_se_wb_tot = (Inputs.share_of_cropland_under_wind_erosion_for_bioenergy*(this_ref.fe_cropland_ilswe_4_tot+this_ref.fe_cropland_ilswe_5_tot-this_ref.fe_cropland_both_se5_and_ilswe_4_5_tot))+this_ref.fe_cropland_se5_tot;
        
        this_ref.ethanol_fe_ac_tot = obj.Bioenergy_rf_h(scens).pe_ac_tot*this_ref.Biorefinery.ethanol_efficiency;
        this_ref.ethanol_fe_cropland_tot = obj.Bioenergy_rf_h(scens).pe_cropland_tot*this_ref.Biorefinery.ethanol_efficiency;
        this_ref.ethanol_fe_cropland_se5_tot = obj.Bioenergy_rf_h(scens).pe_cropland_se5_tot*this_ref.Biorefinery.ethanol_efficiency;
        this_ref.ethanol_fe_cropland_se10_tot = obj.Bioenergy_rf_h(scens).pe_cropland_se10_tot*this_ref.Biorefinery.ethanol_efficiency;
        this_ref.ethanol_fe_cropland_ilswe_1_tot = obj.Bioenergy_rf_h(scens).pe_cropland_ilswe_1_tot*this_ref.Biorefinery.ethanol_efficiency;
        this_ref.ethanol_fe_cropland_ilswe_2_tot = obj.Bioenergy_rf_h(scens).pe_cropland_ilswe_2_tot*this_ref.Biorefinery.ethanol_efficiency;
        this_ref.ethanol_fe_cropland_ilswe_3_tot = obj.Bioenergy_rf_h(scens).pe_cropland_ilswe_3_tot*this_ref.Biorefinery.ethanol_efficiency;
        this_ref.ethanol_fe_cropland_ilswe_4_tot = obj.Bioenergy_rf_h(scens).pe_cropland_ilswe_4_tot*this_ref.Biorefinery.ethanol_efficiency;
        this_ref.ethanol_fe_cropland_ilswe_5_tot = obj.Bioenergy_rf_h(scens).pe_cropland_ilswe_5_tot*this_ref.Biorefinery.ethanol_efficiency;
        this_ref.ethanol_fe_cropland_flood_tot = obj.Bioenergy_rf_h(scens).pe_cropland_flood_tot*this_ref.Biorefinery.ethanol_efficiency;       
        
        this_ref.ft_fe_ac_tot = obj.Bioenergy_rf_h(scens).pe_ac_tot*this_ref.Biorefinery.fischer_tropsch_efficiency;
        this_ref.ft_fe_cropland_tot = obj.Bioenergy_rf_h(scens).pe_cropland_tot*this_ref.Biorefinery.fischer_tropsch_efficiency;
        this_ref.ft_fe_cropland_se5_tot = obj.Bioenergy_rf_h(scens).pe_cropland_se5_tot*this_ref.Biorefinery.fischer_tropsch_efficiency;
        this_ref.ft_fe_cropland_se10_tot = obj.Bioenergy_rf_h(scens).pe_cropland_se10_tot*this_ref.Biorefinery.fischer_tropsch_efficiency;
        this_ref.ft_fe_cropland_ilswe_1_tot = obj.Bioenergy_rf_h(scens).pe_cropland_ilswe_1_tot*this_ref.Biorefinery.fischer_tropsch_efficiency;
        this_ref.ft_fe_cropland_ilswe_2_tot = obj.Bioenergy_rf_h(scens).pe_cropland_ilswe_2_tot*this_ref.Biorefinery.fischer_tropsch_efficiency;
        this_ref.ft_fe_cropland_ilswe_3_tot = obj.Bioenergy_rf_h(scens).pe_cropland_ilswe_3_tot*this_ref.Biorefinery.fischer_tropsch_efficiency;
        this_ref.ft_fe_cropland_ilswe_4_tot = obj.Bioenergy_rf_h(scens).pe_cropland_ilswe_4_tot*this_ref.Biorefinery.fischer_tropsch_efficiency;
        this_ref.ft_fe_cropland_ilswe_5_tot = obj.Bioenergy_rf_h(scens).pe_cropland_ilswe_5_tot*this_ref.Biorefinery.fischer_tropsch_efficiency;
        this_ref.ft_fe_cropland_flood_tot = obj.Bioenergy_rf_h(scens).pe_cropland_flood_tot*this_ref.Biorefinery.fischer_tropsch_efficiency;
        
        this_ref.electricity_fe_ac_tot = obj.Bioenergy_rf_h(scens).pe_ac_tot*this_ref.Biorefinery.electricity_efficiency;
        this_ref.electricity_fe_cropland_tot = obj.Bioenergy_rf_h(scens).pe_cropland_tot*this_ref.Biorefinery.electricity_efficiency;
        this_ref.electricity_fe_cropland_se5_tot = obj.Bioenergy_rf_h(scens).pe_cropland_se5_tot*this_ref.Biorefinery.electricity_efficiency;
        this_ref.electricity_fe_cropland_se10_tot = obj.Bioenergy_rf_h(scens).pe_cropland_se10_tot*this_ref.Biorefinery.electricity_efficiency;
        this_ref.electricity_fe_cropland_ilswe_1_tot = obj.Bioenergy_rf_h(scens).pe_cropland_ilswe_1_tot*this_ref.Biorefinery.electricity_efficiency;
        this_ref.electricity_fe_cropland_ilswe_2_tot = obj.Bioenergy_rf_h(scens).pe_cropland_ilswe_2_tot*this_ref.Biorefinery.electricity_efficiency;
        this_ref.electricity_fe_cropland_ilswe_3_tot = obj.Bioenergy_rf_h(scens).pe_cropland_ilswe_3_tot*this_ref.Biorefinery.electricity_efficiency;
        this_ref.electricity_fe_cropland_ilswe_4_tot = obj.Bioenergy_rf_h(scens).pe_cropland_ilswe_4_tot*this_ref.Biorefinery.electricity_efficiency;
        this_ref.electricity_fe_cropland_ilswe_5_tot = obj.Bioenergy_rf_h(scens).pe_cropland_ilswe_5_tot*this_ref.Biorefinery.electricity_efficiency;
        this_ref.electricity_fe_cropland_flood_tot = obj.Bioenergy_rf_h(scens).pe_cropland_flood_tot*this_ref.Biorefinery.electricity_efficiency;
        
        this_ref.carbon_fuel_ac = obj.Bioenergy_rf_h(scens).carbon_ac*this_ref.Biorefinery.fraction_biomass_C_in_fuel;
        this_ref.carbon_fuel_cropland = obj.Bioenergy_rf_h(scens).carbon_cropland*this_ref.Biorefinery.fraction_biomass_C_in_fuel;
        this_ref.carbon_fuel_cropland_se5 = obj.Bioenergy_rf_h(scens).carbon_cropland_se5*this_ref.Biorefinery.fraction_biomass_C_in_fuel;
        this_ref.carbon_fuel_cropland_se10 = obj.Bioenergy_rf_h(scens).carbon_cropland_se10*this_ref.Biorefinery.fraction_biomass_C_in_fuel;
        this_ref.carbon_fuel_cropland_ilswe_1 = obj.Bioenergy_rf_h(scens).carbon_cropland_ilswe_1*this_ref.Biorefinery.fraction_biomass_C_in_fuel;
        this_ref.carbon_fuel_cropland_ilswe_2 = obj.Bioenergy_rf_h(scens).carbon_cropland_ilswe_2*this_ref.Biorefinery.fraction_biomass_C_in_fuel;
        this_ref.carbon_fuel_cropland_ilswe_3 = obj.Bioenergy_rf_h(scens).carbon_cropland_ilswe_3*this_ref.Biorefinery.fraction_biomass_C_in_fuel;
        this_ref.carbon_fuel_cropland_ilswe_4 = obj.Bioenergy_rf_h(scens).carbon_cropland_ilswe_4*this_ref.Biorefinery.fraction_biomass_C_in_fuel;
        this_ref.carbon_fuel_cropland_ilswe_5 = obj.Bioenergy_rf_h(scens).carbon_cropland_ilswe_5*this_ref.Biorefinery.fraction_biomass_C_in_fuel;
        this_ref.carbon_fuel_cropland_flood = obj.Bioenergy_rf_h(scens).carbon_cropland_flood*this_ref.Biorefinery.fraction_biomass_C_in_fuel;
        
        this_ref.carbon_emitted_at_refinery_ac = obj.Bioenergy_rf_h(scens).carbon_ac*this_ref.Biorefinery.fraction_biomass_C_emitted_at_refinery;
        this_ref.carbon_emitted_at_refinery_cropland = obj.Bioenergy_rf_h(scens).carbon_cropland*this_ref.Biorefinery.fraction_biomass_C_emitted_at_refinery;
        this_ref.carbon_emitted_at_refinery_cropland_se5 = obj.Bioenergy_rf_h(scens).carbon_cropland_se5*this_ref.Biorefinery.fraction_biomass_C_emitted_at_refinery;
        this_ref.carbon_emitted_at_refinery_cropland_se10 = obj.Bioenergy_rf_h(scens).carbon_cropland_se10*this_ref.Biorefinery.fraction_biomass_C_emitted_at_refinery;
        this_ref.carbon_emitted_at_refinery_cropland_ilswe_1 = obj.Bioenergy_rf_h(scens).carbon_cropland_ilswe_1*this_ref.Biorefinery.fraction_biomass_C_emitted_at_refinery;
        this_ref.carbon_emitted_at_refinery_cropland_ilswe_2 = obj.Bioenergy_rf_h(scens).carbon_cropland_ilswe_2*this_ref.Biorefinery.fraction_biomass_C_emitted_at_refinery;
        this_ref.carbon_emitted_at_refinery_cropland_ilswe_3 = obj.Bioenergy_rf_h(scens).carbon_cropland_ilswe_3*this_ref.Biorefinery.fraction_biomass_C_emitted_at_refinery;
        this_ref.carbon_emitted_at_refinery_cropland_ilswe_4 = obj.Bioenergy_rf_h(scens).carbon_cropland_ilswe_4*this_ref.Biorefinery.fraction_biomass_C_emitted_at_refinery;
        this_ref.carbon_emitted_at_refinery_cropland_ilswe_5 = obj.Bioenergy_rf_h(scens).carbon_cropland_ilswe_5*this_ref.Biorefinery.fraction_biomass_C_emitted_at_refinery;
        this_ref.carbon_emitted_at_refinery_cropland_flood = obj.Bioenergy_rf_h(scens).carbon_cropland_flood*this_ref.Biorefinery.fraction_biomass_C_emitted_at_refinery;
        
        this_ref.carbon_ccs_or_char_abandoned_cropland = obj.Bioenergy_rf_h(scens).carbon_ac*this_ref.Biorefinery.fraction_biomass_C_sequestered_through_CCS_or_char;
        this_ref.carbon_ccs_or_char_cropland = obj.Bioenergy_rf_h(scens).carbon_cropland*this_ref.Biorefinery.fraction_biomass_C_sequestered_through_CCS_or_char;
        this_ref.carbon_ccs_or_char_cropland_se5 = obj.Bioenergy_rf_h(scens).carbon_cropland_se5*this_ref.Biorefinery.fraction_biomass_C_sequestered_through_CCS_or_char;
        this_ref.carbon_ccs_or_char_cropland_se10 = obj.Bioenergy_rf_h(scens).carbon_cropland_se10*this_ref.Biorefinery.fraction_biomass_C_sequestered_through_CCS_or_char;
        this_ref.carbon_ccs_or_char_cropland_ilswe_1 = obj.Bioenergy_rf_h(scens).carbon_cropland_ilswe_1*this_ref.Biorefinery.fraction_biomass_C_sequestered_through_CCS_or_char;
        this_ref.carbon_ccs_or_char_cropland_ilswe_2 = obj.Bioenergy_rf_h(scens).carbon_cropland_ilswe_2*this_ref.Biorefinery.fraction_biomass_C_sequestered_through_CCS_or_char;
        this_ref.carbon_ccs_or_char_cropland_ilswe_3 = obj.Bioenergy_rf_h(scens).carbon_cropland_ilswe_3*this_ref.Biorefinery.fraction_biomass_C_sequestered_through_CCS_or_char;
        this_ref.carbon_ccs_or_char_cropland_ilswe_4 = obj.Bioenergy_rf_h(scens).carbon_cropland_ilswe_4*this_ref.Biorefinery.fraction_biomass_C_sequestered_through_CCS_or_char;
        this_ref.carbon_ccs_or_char_cropland_ilswe_5 = obj.Bioenergy_rf_h(scens).carbon_cropland_ilswe_5*this_ref.Biorefinery.fraction_biomass_C_sequestered_through_CCS_or_char;
        this_ref.carbon_ccs_or_char_cropland_flood = obj.Bioenergy_rf_h(scens).carbon_cropland_flood*this_ref.Biorefinery.fraction_biomass_C_sequestered_through_CCS_or_char;
        
        
        this_ref.carbon_fuel_ac_tot = sum(sum(this_ref.carbon_fuel_ac));
        this_ref.carbon_fuel_cropland_tot = sum(sum(this_ref.carbon_fuel_cropland));
        this_ref.carbon_fuel_cropland_se5_tot = sum(sum(this_ref.carbon_fuel_cropland_se5));
        this_ref.carbon_fuel_cropland_se10_tot = sum(sum(this_ref.carbon_fuel_cropland_se10));
        this_ref.carbon_fuel_cropland_ilswe_1_tot = sum(sum(this_ref.carbon_fuel_cropland_ilswe_1));
        this_ref.carbon_fuel_cropland_ilswe_2_tot = sum(sum(this_ref.carbon_fuel_cropland_ilswe_2));
        this_ref.carbon_fuel_cropland_ilswe_3_tot = sum(sum(this_ref.carbon_fuel_cropland_ilswe_3));
        this_ref.carbon_fuel_cropland_ilswe_4_tot = sum(sum(this_ref.carbon_fuel_cropland_ilswe_4));
        this_ref.carbon_fuel_cropland_ilswe_5_tot = sum(sum(this_ref.carbon_fuel_cropland_ilswe_5));
        this_ref.carbon_fuel_cropland_flood_tot = sum(sum(this_ref.carbon_fuel_cropland_flood));
        this_ref.carbon_ccs_or_char_cropland_both_se5_and_ilswe_4_5_tot = obj.Bioenergy_rf_h(scens).carbon_cropland_both_se5_and_ilswe_4_5_tot*this_ref.Biorefinery.fraction_biomass_C_sequestered_through_CCS_or_char;
        this_ref.carbon_ccs_or_char_cropland_se_mod_high_4bioenergy_tot = obj.Bioenergy_rf_h(scens).carbon_cropland_se_mod_high_4bioenergy_tot*this_ref.Biorefinery.fraction_biomass_C_sequestered_through_CCS_or_char;
        
        this_ref.carbon_emitted_at_refinery_ac_tot = sum(sum(this_ref.carbon_emitted_at_refinery_ac));
        this_ref.carbon_emitted_at_refinery_cropland_tot = sum(sum(this_ref.carbon_emitted_at_refinery_cropland));
        this_ref.carbon_emitted_at_refinery_cropland_se5_tot = sum(sum(this_ref.carbon_emitted_at_refinery_cropland_se5));
        this_ref.carbon_emitted_at_refinery_cropland_se10_tot = sum(sum(this_ref.carbon_emitted_at_refinery_cropland_se10));
        this_ref.carbon_emitted_at_refinery_cropland_ilswe_1_tot = sum(sum(this_ref.carbon_emitted_at_refinery_cropland_ilswe_1));
        this_ref.carbon_emitted_at_refinery_cropland_ilswe_2_tot = sum(sum(this_ref.carbon_emitted_at_refinery_cropland_ilswe_2));
        this_ref.carbon_emitted_at_refinery_cropland_ilswe_3_tot = sum(sum(this_ref.carbon_emitted_at_refinery_cropland_ilswe_3));
        this_ref.carbon_emitted_at_refinery_cropland_ilswe_4_tot = sum(sum(this_ref.carbon_emitted_at_refinery_cropland_ilswe_4));
        this_ref.carbon_emitted_at_refinery_cropland_ilswe_5_tot = sum(sum(this_ref.carbon_emitted_at_refinery_cropland_ilswe_5));
        this_ref.carbon_emitted_at_refinery_cropland_flood_tot = sum(sum(this_ref.carbon_emitted_at_refinery_cropland_flood));
        
        
        this_ref.carbon_ccs_or_char_abandoned_cropland_tot = sum(sum(this_ref.carbon_ccs_or_char_abandoned_cropland));
        this_ref.carbon_ccs_or_char_cropland_tot = sum(sum(this_ref.carbon_ccs_or_char_cropland));
        this_ref.carbon_ccs_or_char_cropland_se5_tot = sum(sum(this_ref.carbon_ccs_or_char_cropland_se5));
        this_ref.carbon_ccs_or_char_cropland_se10_tot = sum(sum(this_ref.carbon_ccs_or_char_cropland_se10));
        this_ref.carbon_ccs_or_char_cropland_ilswe_1_tot = sum(sum(this_ref.carbon_ccs_or_char_cropland_ilswe_1));
        this_ref.carbon_ccs_or_char_cropland_ilswe_2_tot = sum(sum(this_ref.carbon_ccs_or_char_cropland_ilswe_2));
        this_ref.carbon_ccs_or_char_cropland_ilswe_3_tot = sum(sum(this_ref.carbon_ccs_or_char_cropland_ilswe_3));
        this_ref.carbon_ccs_or_char_cropland_ilswe_4_tot = sum(sum(this_ref.carbon_ccs_or_char_cropland_ilswe_4));
        this_ref.carbon_ccs_or_char_cropland_ilswe_5_tot = sum(sum(this_ref.carbon_ccs_or_char_cropland_ilswe_5));
        this_ref.carbon_ccs_or_char_cropland_flood_tot = sum(sum(this_ref.carbon_ccs_or_char_cropland_flood));
        
        this_ref.fe_aboveground_carbon_clearing = obj.Bioenergy_rf_h(scens).pe_aboveground_carbon_clearing*this_ref.Biorefinery.energy_efficiency; %GJ
        this_ref.ethanol_fe_aboveground_carbon_clearing = obj.Bioenergy_rf_h(scens).pe_aboveground_carbon_clearing*this_ref.Biorefinery.ethanol_efficiency;
        this_ref.ft_fe_aboveground_carbon_clearing = obj.Bioenergy_rf_h(scens).pe_aboveground_carbon_clearing*this_ref.Biorefinery.fischer_tropsch_efficiency;
        this_ref.electricity_fe_aboveground_carbon_clearing = obj.Bioenergy_rf_h(scens).pe_aboveground_carbon_clearing*this_ref.Biorefinery.electricity_efficiency;
        this_ref.carbon_fuel_aboveground_carbon_clearing = Inputs.share_of_aboveground_carbon_harvested_for_bioenergy*obj.Bioenergy_rf_h(scens).carbon_aboveground_carbon_clearing*this_ref.Biorefinery.fraction_biomass_C_in_fuel;
        this_ref.carbon_emitted_at_refinery_aboveground_carbon_clearing = Inputs.share_of_aboveground_carbon_harvested_for_bioenergy*obj.Bioenergy_rf_h(scens).carbon_aboveground_carbon_clearing*this_ref.Biorefinery.fraction_biomass_C_emitted_at_refinery;
        this_ref.carbon_ccs_or_char_aboveground_carbon_clearing = Inputs.share_of_aboveground_carbon_harvested_for_bioenergy*obj.Bioenergy_rf_h(scens).carbon_aboveground_carbon_clearing*this_ref.Biorefinery.fraction_biomass_C_sequestered_through_CCS_or_char;
        %this_ref.carbon_fossil_fuel_substitution_1to1_abc_clearing = -999; %FIX
        
        this_ref.fe_aboveground_carbon_clearing_tot = sum(sum(this_ref.fe_aboveground_carbon_clearing));
        this_ref.ethanol_fe_aboveground_carbon_clearing_tot = sum(sum(this_ref.ethanol_fe_aboveground_carbon_clearing));
        this_ref.ft_fe_aboveground_carbon_clearing_tot = sum(sum(this_ref.ft_fe_aboveground_carbon_clearing));
        this_ref.electricity_fe_aboveground_carbon_clearing_tot = sum(sum(this_ref.electricity_fe_aboveground_carbon_clearing));
        this_ref.carbon_fuel_aboveground_carbon_clearing_tot = sum(sum(this_ref.carbon_fuel_aboveground_carbon_clearing));
        this_ref.carbon_emitted_at_refinery_aboveground_carbon_clearing_tot = sum(sum(this_ref.carbon_emitted_at_refinery_aboveground_carbon_clearing));
        this_ref.carbon_ccs_or_char_aboveground_carbon_clearing_tot = sum(sum(this_ref.carbon_ccs_or_char_aboveground_carbon_clearing));
        %this_ref.carbon_fossil_fuel_substitution_1to1_abc_clearing_tot = sum(sum(this_ref.carbon_fossil_fuel_substitution_1to1_abc_clearing));
        
        %% FOssile fuel substitution
        this_ref.GWP100 = Mitigation;
        
       
        %this_ref.GWP100.tco2eq_accumulated_farm_production = obj.Bioenergy_rf_h(scens).
        
        
        %Save
         obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs) = this_ref;
    end
end
   
end
