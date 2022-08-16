classdef Namelist
    %NAMELIST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        diesel_biomass_transport_energy_use_MJ_per_tkm = 0.811; %EMEP/EEA air pollutant emission Inventory Guidebook 2009 (Update 2012) - 1.A.3.b Road Transport. Tables 3-20 and 3-26.

        
        gwp100_diesel_kgCO2eq_per_MJ = 0.0842;
        gwp100_petrol_kgCO2eq_per_MJ = 0.0871;
        
        gwp100_aboveground_carbon_clearing_kgCO2eq_per_ton = 13.2; %Ecoinvent
        
        share_of_cropland_under_wind_erosion_for_bioenergy = 1/3;
        share_of_aboveground_carbon_harvested_for_bioenergy = 1;
        
        %Measures to save RAM
        remove_gridded_data_from_mem = 1;
        remove_wb_scen_data = 0;
        remove_eo_scen_data = 1;
    end
    
    methods
    end
    
end

