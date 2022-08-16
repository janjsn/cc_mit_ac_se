classdef RUSLE
    %RUSLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        latitudeVector_centered
        longitudeVector_centered
        year
        soil_erosion
        soil_erosion_unit = 'ton ha-1 yr-1'
    end
    
    methods
        
        function obj = RUSLE(filename)
            
            ncid = netcdf.open(filename);
            obj.latitudeVector_centered = netcdf.getVar(ncid,0);
            obj.longitudeVector_centered = netcdf.getVar(ncid,1);
            obj.year = netcdf.getVar(ncid,2);
            obj.soil_erosion = netcdf.getVar(ncid,3);
            netcdf.close(ncid);
            
        end
    end
    
end

