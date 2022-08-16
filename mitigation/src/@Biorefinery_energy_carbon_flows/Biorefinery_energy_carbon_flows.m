classdef Biorefinery_energy_carbon_flows
    %BIOREFINERY_CARBON_FLOWS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Biorefinery = Biorefinery;
        
        fe_description = 'final energy';
        unit_fe = 'GJ yr-1';
        fe_ac
        fe_cropland
        fe_cropland_se5
        fe_cropland_se10
        fe_cropland_ilswe_1
        fe_cropland_ilswe_2
        fe_cropland_ilswe_3
        fe_cropland_ilswe_4
        fe_cropland_ilswe_5
        fe_cropland_both_se5_and_ilswe_4_5
        fe_cropland_flood
        
        fe_ac_tot
        fe_cropland_tot
        fe_cropland_se5_tot
        fe_cropland_se10_tot
        fe_cropland_ilswe_1_tot
        fe_cropland_ilswe_2_tot
        fe_cropland_ilswe_3_tot
        fe_cropland_ilswe_4_tot
        fe_cropland_ilswe_5_tot
        fe_cropland_both_se5_and_ilswe_4_5_tot
        fe_cropland_flood_tot
        fe_cropland_all_se_wb_tot
        
        ethanol_fe_ac_tot
        ethanol_fe_cropland_tot
        ethanol_fe_cropland_se5_tot
        ethanol_fe_cropland_se10_tot
        ethanol_fe_cropland_ilswe_1_tot
        ethanol_fe_cropland_ilswe_2_tot
        ethanol_fe_cropland_ilswe_3_tot
        ethanol_fe_cropland_ilswe_4_tot
        ethanol_fe_cropland_ilswe_5_tot
        ethanol_fe_cropland_flood_tot        
        
        ft_fe_ac_tot
        ft_fe_cropland_tot
        ft_fe_cropland_se5_tot
        ft_fe_cropland_se10_tot
        ft_fe_cropland_ilswe_1_tot
        ft_fe_cropland_ilswe_2_tot
        ft_fe_cropland_ilswe_3_tot
        ft_fe_cropland_ilswe_4_tot
        ft_fe_cropland_ilswe_5_tot
        ft_fe_cropland_flood_tot
        
        electricity_fe_ac_tot
        electricity_fe_cropland_tot
        electricity_fe_cropland_se5_tot
        electricity_fe_cropland_se10_tot
        electricity_fe_cropland_ilswe_1_tot
        electricity_fe_cropland_ilswe_2_tot
        electricity_fe_cropland_ilswe_3_tot
        electricity_fe_cropland_ilswe_4_tot
        electricity_fe_cropland_ilswe_5_tot
        electricity_fe_cropland_flood_tot
        
        unit_carbon = 'ton C yr-1';
        carbon_fuel_ac
        carbon_fuel_cropland
        carbon_fuel_cropland_se5
        carbon_fuel_cropland_se10
        carbon_fuel_cropland_ilswe_1
        carbon_fuel_cropland_ilswe_2
        carbon_fuel_cropland_ilswe_3
        carbon_fuel_cropland_ilswe_4
        carbon_fuel_cropland_ilswe_5
        carbon_fuel_cropland_flood
        
        carbon_emitted_at_refinery_ac
        carbon_emitted_at_refinery_cropland
        carbon_emitted_at_refinery_cropland_se5
        carbon_emitted_at_refinery_cropland_se10
        carbon_emitted_at_refinery_cropland_ilswe_1
        carbon_emitted_at_refinery_cropland_ilswe_2
        carbon_emitted_at_refinery_cropland_ilswe_3
        carbon_emitted_at_refinery_cropland_ilswe_4
        carbon_emitted_at_refinery_cropland_ilswe_5
        carbon_emitted_at_refinery_cropland_flood
        
        carbon_ccs_or_char_abandoned_cropland
        carbon_ccs_or_char_cropland
        carbon_ccs_or_char_cropland_se5
        carbon_ccs_or_char_cropland_se10
        carbon_ccs_or_char_cropland_ilswe_1
        carbon_ccs_or_char_cropland_ilswe_2
        carbon_ccs_or_char_cropland_ilswe_3
        carbon_ccs_or_char_cropland_ilswe_4
        carbon_ccs_or_char_cropland_ilswe_5
        carbon_ccs_or_char_cropland_flood
        
        carbon_fuel_ac_tot
        carbon_fuel_cropland_tot
        carbon_fuel_cropland_se5_tot
        carbon_fuel_cropland_se10_tot
        carbon_fuel_cropland_ilswe_1_tot
        carbon_fuel_cropland_ilswe_2_tot
        carbon_fuel_cropland_ilswe_3_tot
        carbon_fuel_cropland_ilswe_4_tot
        carbon_fuel_cropland_ilswe_5_tot
        carbon_fuel_cropland_flood_tot
        
        carbon_emitted_at_refinery_ac_tot
        carbon_emitted_at_refinery_cropland_tot
        carbon_emitted_at_refinery_cropland_se5_tot
        carbon_emitted_at_refinery_cropland_se10_tot
        carbon_emitted_at_refinery_cropland_ilswe_1_tot
        carbon_emitted_at_refinery_cropland_ilswe_2_tot
        carbon_emitted_at_refinery_cropland_ilswe_3_tot
        carbon_emitted_at_refinery_cropland_ilswe_4_tot
        carbon_emitted_at_refinery_cropland_ilswe_5_tot
        carbon_emitted_at_refinery_cropland_flood_tot        
        
        carbon_ccs_or_char_abandoned_cropland_tot
        carbon_ccs_or_char_cropland_tot
        carbon_ccs_or_char_cropland_se5_tot
        carbon_ccs_or_char_cropland_se10_tot
        carbon_ccs_or_char_cropland_ilswe_1_tot
        carbon_ccs_or_char_cropland_ilswe_2_tot
        carbon_ccs_or_char_cropland_ilswe_3_tot
        carbon_ccs_or_char_cropland_ilswe_4_tot
        carbon_ccs_or_char_cropland_ilswe_5_tot
        carbon_ccs_or_char_cropland_flood_tot
        carbon_ccs_or_char_cropland_both_se5_and_ilswe_4_5_tot
        carbon_ccs_or_char_cropland_se_mod_high_4bioenergy_tot
        
        carbon_fossil_fuel_substitution_1to1_ac
        carbon_fossil_fuel_substitution_1to1_cropland
        carbon_fossil_fuel_substitution_1to1_se5
        carbon_fossil_fuel_substitution_1to1_se10
        carbon_fossil_fuel_substitution_1to1_ilswe_1
        carbon_fossil_fuel_substitution_1to1_ilswe_2
        carbon_fossil_fuel_substitution_1to1_ilswe_3
        carbon_fossil_fuel_substitution_1to1_ilswe_4
        carbon_fossil_fuel_substitution_1to1_ilswe_5
        carbon_fossil_fuel_substitution_1to1_flood
        
        carbon_fossil_fuel_substitution_1to1_ac_tot
        carbon_fossil_fuel_substitution_1to1_cropland_tot
        carbon_fossil_fuel_substitution_1to1_se5_tot
        carbon_fossil_fuel_substitution_1to1_se10_tot
        carbon_fossil_fuel_substitution_1to1_ilswe_1_tot
        carbon_fossil_fuel_substitution_1to1_ilswe_2_tot
        carbon_fossil_fuel_substitution_1to1_ilswe_3_tot
        carbon_fossil_fuel_substitution_1to1_ilswe_4_tot
        carbon_fossil_fuel_substitution_1to1_ilswe_5_tot
        carbon_fossil_fuel_substitution_1to1_flood_tot
        
        fe_aboveground_carbon_clearing
        ethanol_fe_aboveground_carbon_clearing
        ft_fe_aboveground_carbon_clearing
        electricity_fe_aboveground_carbon_clearing
        carbon_fuel_aboveground_carbon_clearing
        carbon_emitted_at_refinery_aboveground_carbon_clearing
        carbon_ccs_or_char_aboveground_carbon_clearing
        tco2eq_fossil_fuel_substitution_1to1_abc_clearing_ft
        tco2eq_fossil_fuel_substitution_1to1_abc_clearing_ethanol
        tco2eq_electricity_substitution_1to1_abc_clearing
        
        fe_aboveground_carbon_clearing_tot
        ethanol_fe_aboveground_carbon_clearing_tot
        ft_fe_aboveground_carbon_clearing_tot
        electricity_fe_aboveground_carbon_clearing_tot
        carbon_fuel_aboveground_carbon_clearing_tot
        carbon_emitted_at_refinery_aboveground_carbon_clearing_tot
        carbon_ccs_or_char_aboveground_carbon_clearing_tot
        carbon_fossil_fuel_substitution_1to1_abc_clearing_tot
        
        GWP100
        GWP100_ac
        GWP100_cropland
        GWP100_cropland_ilswe_4
        GWP100_cropland_ilswe_5
        GWP100_cropland_se5
        GWP100_cropland_se5to10
        GWP100_cropland_se10
        GWP100_cropland_both_ilswe_4_5_se_5
        GWP100_cropland_under_soil_erosion_mod_high_4bioenergy
    end
        
        
    methods
    end
    
end

