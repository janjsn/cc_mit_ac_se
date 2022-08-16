classdef Willow_data
    %WILLOW_DATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        agricultural_management_intensity
        crop_ID = 5;
        lat
        lon
        dm_yield_ac
        dm_yield_cropland
        dm_yield_ac_cropland
        
    end
    
    methods
        
        function obj = Willow_data(filename)
            if nargin > 0
                ncid = netcdf.open(filename);
                obj.lat = netcdf.getVar(ncid,0);
                obj.lon = netcdf.getVar(ncid,1);
                obj.dm_yield_ac = netcdf.getVar(ncid,4);
                obj.dm_yield_cropland = netcdf.getVar(ncid,5);
                obj.dm_yield_ac_cropland = netcdf.getVar(ncid,6);
                
                obj.dm_yield_cropland(isnan(obj.dm_yield_cropland)) = 0;
                obj.dm_yield_ac(isnan(obj.dm_yield_ac)) = 0;
                obj.dm_yield_ac_cropland(isnan(obj.dm_yield_ac_cropland)) = 0;
                
            end
        end
    end
    
end

