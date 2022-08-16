classdef ABC_ac
    %ABC_AC Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        lat
        lon
        time
        ac_hectare_after_change
        aboveground_carbon_ac_after_change_ton_C
        aboveground_carbon_ac_tot_ton_C
        mean_nat_regrowth_carbon_seq_rate_ton_C_per_ha_year_after_t
        mean_nat_regrowth_carbon_seq_rate_ton_C_per_ha_year_ac_2018
        
        carbon_content_of_dry_mass = 0.46;
        lhv = 18;
        
        
    end
    
    methods
        function obj = ABC_ac(filename)
            ncid = netcdf.open(filename);
            obj.lat = netcdf.getVar(ncid,0);
            obj.lon = netcdf.getVar(ncid,1);
            obj.time = netcdf.getVar(ncid,2);
            obj.ac_hectare_after_change = netcdf.getVar(ncid,3);
            obj.aboveground_carbon_ac_after_change_ton_C = netcdf.getVar(ncid,5);
            obj.aboveground_carbon_ac_tot_ton_C = netcdf.getVar(ncid,7);
            obj.mean_nat_regrowth_carbon_seq_rate_ton_C_per_ha_year_after_t = netcdf.getVar(ncid,6);
            netcdf.close(ncid);
        end
        
    end
    
end

