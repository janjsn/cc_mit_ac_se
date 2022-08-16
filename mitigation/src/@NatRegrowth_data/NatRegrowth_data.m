classdef NatRegrowth_data

    properties
        lat
        lon
        aboveground_carbon_sequestration_rate_ton_per_ha
        aboveground_carbon_sequestration_rate_cropland_ton_per_ha
        aboveground_carbon_sequestration_rate_ac_ton_per_ha
    end
    
    methods
        function obj = NatRegrowth_data(filename)
            ncid = netcdf.open(filename);
            obj.lat = netcdf.getVar(ncid,0);
            obj.lon = netcdf.getVar(ncid,1);
            obj.aboveground_carbon_sequestration_rate_ton_per_ha = netcdf.getVar(ncid,5);
            obj.aboveground_carbon_sequestration_rate_cropland_ton_per_ha = netcdf.getVar(ncid,6);
            obj.aboveground_carbon_sequestration_rate_ac_ton_per_ha = netcdf.getVar(ncid,7);          
        end
        
    end
    
end

