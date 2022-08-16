classdef Rainfed_high
    %@RAINFED_HIGH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        lat
        lon
        year_bioenergy
        
        crop_id_vector
        crop_names
        is_carbon_optimization
        is_energy_optimization
        is_single_crop
        is_wb_scenario = 0;
        
        crop_allocation_ac
        crop_allocation_cropland
        
        Biorefinery_energy_carbon_flows = Biorefinery_energy_carbon_flows;
        
        ghg_footprint_farm2biorefgate_FIELD_et_al
        ghg_footprint_farm2biorefgate_FIELD_et_al_ac
        ghg_footprint_farm2biorefgate_FIELD_et_al_cropland
        unit_ghg_footprint_farm2biorefgate = 'kg CO2e (Mg biomass)-1';
        
        dm_yield
        dm_yield_ac
        dm_yield_cropland
        unit_dm_yield = 'ton dm ha-1 yr-1';
        carbon_yield
        carbon_yield_ac
        carbon_yield_cropland
        unit_carbon_yield = 'ton C ha-1 yr-1';
        bioenergy_yield
        bioenergy_yield_ac
        bioenergy_yield_cropland
        unit_bioenergy_yield = 'GJ ha-1 yr-1';
        
        
        dm_ac
        dm_cropland
        dm_cropland_se5
        dm_cropland_se10
        dm_cropland_ilswe_1
        dm_cropland_ilswe_2
        dm_cropland_ilswe_3
        dm_cropland_ilswe_4
        dm_cropland_ilswe_5
        dm_cropland_flood
        unit_dm = 'ton dm yr-1';
        
        carbon_ac
        carbon_cropland
        carbon_cropland_se5
        carbon_cropland_se10
        carbon_cropland_ilswe_1
        carbon_cropland_ilswe_2
        carbon_cropland_ilswe_3
        carbon_cropland_ilswe_4
        carbon_cropland_ilswe_5
        carbon_cropland_flood
        unit_carbon = 'ton C yr-1';
        
        pe_ac
        pe_cropland
        pe_cropland_se5
        pe_cropland_se10
        pe_cropland_ilswe_1
        pe_cropland_ilswe_2
        pe_cropland_ilswe_3
        pe_cropland_ilswe_4
        pe_cropland_ilswe_5
        pe_cropland_flood
        pe_cropland_both_se5_and_ilswe_4_5
        pe_cropland_se_wat_wind_4bioenergy %Including wb share
        pe_ac_cropland_se_wat_wind_4bioenergy %Including wb share
        unit_pe = 'GJ yr-1';
        
        pe_yield_ac_mean
        pe_yield_cropland_se5_mean
        pe_yield_cropland_se10_mean
        pe_yield_cropland_ilswe4_mean
        pe_yield_cropland_ilswe5_mean
        pe_yield_cropland_pe_cropland_both_se5_and_ilswe_4_5_mean
        pe_yield_cropland_se_wat_wind_4bioenergy_mean
        pe_yield_ac_cropland_se_wat_wind_4bioenergy_mean
        
        dm_ac_tot
        dm_cropland_tot
        dm_cropland_se5_tot
        dm_cropland_se10_tot
        dm_cropland_ilswe_1_tot
        dm_cropland_ilswe_2_tot
        dm_cropland_ilswe_3_tot
        dm_cropland_ilswe_4_tot
        dm_cropland_ilswe_5_tot
        dm_cropland_flood_tot
        
        carbon_ac_tot
        carbon_cropland_tot
        carbon_cropland_se5_tot
        carbon_cropland_se10_tot
        carbon_cropland_ilswe_1_tot
        carbon_cropland_ilswe_2_tot
        carbon_cropland_ilswe_3_tot
        carbon_cropland_ilswe_4_tot
        carbon_cropland_ilswe_5_tot
        carbon_cropland_flood_tot
        carbon_cropland_both_se5_and_ilswe_4_5_tot
        carbon_cropland_se_mod_high_4bioenergy_tot
        
        pe_ac_tot
        pe_cropland_tot
        pe_cropland_se5_tot
        pe_cropland_se10_tot
        pe_cropland_ilswe_1_tot
        pe_cropland_ilswe_2_tot
        pe_cropland_ilswe_3_tot
        pe_cropland_ilswe_4_tot
        pe_cropland_ilswe_5_tot
        pe_cropland_both_se5_and_ilswe_4_5_tot
        pe_cropland_flood_tot
        
        productive_land_ac_tot
        productive_land_cropland_tot
        productive_land_cropland_se5_tot
        productive_land_cropland_se10_tot
        productive_land_cropland_se5_to_10_tot
        productive_land_cropland_ilswe_1_tot
        productive_land_cropland_ilswe_2_tot
        productive_land_cropland_ilswe_3_tot
        productive_land_cropland_ilswe_4_tot
        productive_land_cropland_ilswe_5_tot
        productive_land_cropland_both_ilswe_4_5_se_5
        productive_land_cropland_flood_tot
        productive_land_ac_cropland_se_wind_wat_tot
        
        
        diesel_biomass_transport_emissions_ac
        diesel_biomass_transport_emissions_cropland
        diesel_biomass_transport_emissions_cropland_se5
        diesel_biomass_transport_emissions_cropland_se10
        diesel_biomass_transport_emissions_cropland_ilswe_1
        diesel_biomass_transport_emissions_cropland_ilswe_2
        diesel_biomass_transport_emissions_cropland_ilswe_3
        diesel_biomass_transport_emissions_cropland_ilswe_4
        diesel_biomass_transport_emissions_cropland_ilswe_5
        diesel_biomass_transport_emissions_cropland_flood
        
        diesel_biomass_transport_emissions_ac_tot
        diesel_biomass_transport_emissions_cropland_tot
        diesel_biomass_transport_emissions_cropland_se5_tot
        diesel_biomass_transport_emissions_cropland_se10_tot
        diesel_biomass_transport_emissions_cropland_ilswe_1_tot
        diesel_biomass_transport_emissions_cropland_ilswe_2_tot
        diesel_biomass_transport_emissions_cropland_ilswe_3_tot
        diesel_biomass_transport_emissions_cropland_ilswe_4_tot
        diesel_biomass_transport_emissions_cropland_ilswe_5_tot
        diesel_biomass_transport_emissions_cropland_flood_tot
        unit_diesel_biomass_transport_emissions = 'ton CO2-eq.';
        
        
        
        farm_emissions_gwp100_region_mean_ac
        farm_emissions_gwp100_region_mean_cropland
        farm_emissions_gwp100_ac
        farm_emissions_gwp100_cropland
        farm_emissions_gwp100_cropland_ilswe_4
        farm_emissions_gwp100_cropland_ilswe_5
        farm_emissions_gwp100_cropland_se_5
        farm_emissions_gwp100_cropland_se_10
        
        pe_aboveground_carbon_clearing
        carbon_aboveground_carbon_clearing
        
        
        pe_yield_mean_ac
        pe_yield_mean_cropland_se_wind_wat
        pe_yield_mean_ac_cropland_se_wind_wat
        unit_pe_yield_mean = 'GJ ha-1 yr-1';
        
        crop_allocation_vec_ac_ha
        crop_allocation_vec_cropland_se_ha
        crop_allocation_vec_cropland_ac_se_ha
        
        unit_wheat_production = 'ton dm ha-1 yr-1';
        wheat_production_theoretical_se5_to_se10_prod_bioenergy
        wheat_production_theoretical_se10_prod_bioenergy
        wheat_production_loss_luc_se5_to_se10_no_yield_gain_tot
        wheat_production_loss_luc_se10_no_yield_gain_tot
        yield_gain_vec = [0:0.1:0.50];
        wheat_production_change_after_mean_yield_gain_se5_to_se10
        wheat_production_change_after_mean_yield_gain_se10
        share_productive_se5_to_se10_wheat
        share_productive_se10_wheat
    end
    
    methods
        get_cumulative_nat_reg_on_bioproductive_land( obj )
        plot_wheat_production_losses_after_yield_gains( obj )
    end
    
end

