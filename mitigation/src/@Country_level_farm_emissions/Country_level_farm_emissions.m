classdef Country_level_farm_emissions
    %COUNTRY_LEVEL_FARM_EMISSIONS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        lat
        lon
        crop_name
        crop_ID
        country_name
        gwp100
        unit_gwp100 = 'kg CO2eq ton dm-1';
        
        lat_5arcmin = [90-(180/2160)/2:-(180/2160):-90+(180/2160)/2];
        lon_5arcmin = [-180+(360/4320)/2:(360/4320):180-(360/4320)/2];
        gwp100_5arcmin
        
    end
    
    methods
    end
    
end

