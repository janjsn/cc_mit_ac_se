classdef GPW_v4_nig
    %GPW_V4_NIG Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        CountryArray
        countryMask
        GeoRef_countryMask
        latitudeVector_mask_centered
        longitudeVector_mask_centered
        latitude_bounds
        longitude_bounds
        cellAreaPerLatitude_hectare
        waterValue = 32767;
    end
    
    methods
        
        function obj = GPW_v4_nig(CountryArray, countryMask, GeoRef)
           obj.CountryArray = CountryArray;
           obj.countryMask = countryMask;
           obj.GeoRef_countryMask = GeoRef;
           %dimensions, center
           obj.latitudeVector_mask_centered = [90-GeoRef.CellExtentInLatitude/2:-GeoRef.CellExtentInLatitude:-90+GeoRef.CellExtentInLatitude/2];
           obj.longitudeVector_mask_centered = [-180+GeoRef.CellExtentInLatitude/2:GeoRef.CellExtentInLatitude:180-GeoRef.CellExtentInLatitude/2];
           %bounds
           obj.latitude_bounds = zeros(2,length(obj.latitudeVector_mask_centered));
           obj.latitude_bounds(1,:) = [90:-GeoRef.CellExtentInLatitude:-90+GeoRef.CellExtentInLatitude];
           obj.latitude_bounds(2,:) = [90-GeoRef.CellExtentInLatitude:-GeoRef.CellExtentInLatitude:-90];
           obj.longitude_bounds = zeros(2,length(obj.longitudeVector_mask_centered));
           obj.longitude_bounds(1,:) = [-180:GeoRef.CellExtentInLongitude:180-GeoRef.CellExtentInLongitude];
           obj.longitude_bounds(2,:) = [-180+GeoRef.CellExtentInLongitude:GeoRef.CellExtentInLongitude:180];
           %cell area per latitude
           Earth = referenceSphere('earth','m');
           surfaceArea_hectare = Earth.SurfaceArea/10000;
                      
           obj.cellAreaPerLatitude_hectare = zeros(1,length(obj.latitudeVector_mask_centered));
               for i = 1:length(obj.cellAreaPerLatitude_hectare)
                   obj.cellAreaPerLatitude_hectare(i) =  areaquad(obj.latitude_bounds(1,i),0,obj.latitude_bounds(2,i),GeoRef.CellExtentInLongitude)*surfaceArea_hectare;           
               end
           
        end
    end
    
end

