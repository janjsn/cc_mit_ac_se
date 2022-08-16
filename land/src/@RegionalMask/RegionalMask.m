classdef RegionalMask
    %REGIONALMASK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        region_name
        lat
        lon
        lat_bnds
        lon_bnds
        cell_area_per_latitude_hectare
        fraction_of_cell_is_region
        area_mask_hectare
        abandoned_cropland_hectare
        abandoned_cropland_fractions
        cropland_hectare
        cropland_fractions
        cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare
        cropland_soil_erosion_above_5_ton_perHa_perYear_unit_fractions
        cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare
        cropland_soil_erosion_above_10_ton_perHa_perYear_unit_fractions
        
        total_available_area_SE_threshold_5_hectare
        total_available_area_SE_threshold_5_fractions
        total_available_area_SE_threshold_10_hectare
        total_available_area_SE_threshold_10_fractions
        
        total_available_area_SE_5_incl_cropland_10_hectare
        total_available_area_SE_5_incl_cropland_20_hectare
        total_available_area_SE_5_incl_cropland_50_hectare
        total_available_area_SE_10_incl_cropland_10_hectare
        total_available_area_SE_10_incl_cropland_20_hectare
        total_available_area_SE_10_incl_cropland_50_hectare
        
        total_available_area_SE_5_incl_cropland_10_fractions
        total_available_area_SE_5_incl_cropland_20_fractions
        total_available_area_SE_5_incl_cropland_50_fractions
        total_available_area_SE_10_incl_cropland_10_fractions
        total_available_area_SE_10_incl_cropland_20_fractions
        total_available_area_SE_10_incl_cropland_50_fractions
        
    end
    
    methods
        function obj = RegionalMask(lon, lat, lon_bnds, lat_bnds)
            if nargin > 0
                obj.region_name = 'no_name';
                obj.lat = lat;
                obj.lon = lon;
                obj.lat_bnds = lat_bnds;
                obj.lon_bnds = lon_bnds;
                obj.cell_area_per_latitude_hectare = get_cell_area_per_latitude( lat_bnds, abs(lon(1)-lon(2)));
                obj.fraction_of_cell_is_region = zeros(length(lon),length(lat));
                obj.area_mask_hectare = zeros(length(lon), length(lat));
                obj.abandoned_cropland_hectare = zeros(length(lon), length(lat));
                obj.cropland_hectare = zeros(length(lon), length(lat));
                obj.cropland_fractions = zeros(length(lon), length(lat));
                obj.cropland_fractions = zeros(length(lon), length(lat));
                obj.cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare = zeros(length(lon), length(lat));
                obj.cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare = zeros(length(lon), length(lat));
            end
        end
        
        function [upscaled_obj] = upscale_regional_mask(obj, new_n_lon, new_n_lat)
            [new_area_mask_hectare, new_lat, new_lon, new_lat_bnds, new_lon_bnds]  = aggregateMatrix2givenDimensions( obj.area_mask_hectare,obj.lon,obj.lat, new_n_lon, new_n_lat );
            upscaled_obj = RegionalMask(new_lon, new_lat, new_lon_bnds, new_lat_bnds);
            upscaled_obj.region_name = obj.region_name;
            upscaled_obj.area_mask_hectare = new_area_mask_hectare;
            [upscaled_obj.abandoned_cropland_hectare,~,~,~,~]  = aggregateMatrix2givenDimensions(obj.abandoned_cropland_hectare,obj.lon,obj.lat, new_n_lon, new_n_lat );
            [upscaled_obj.cropland_hectare,~,~,~,~]  = aggregateMatrix2givenDimensions(obj.cropland_hectare,obj.lon,obj.lat, new_n_lon, new_n_lat );
            [upscaled_obj.cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare,~,~,~,~]  = aggregateMatrix2givenDimensions(obj.cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare,obj.lon,obj.lat, new_n_lon, new_n_lat );
            [upscaled_obj.cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare,~,~,~,~]  = aggregateMatrix2givenDimensions(obj.cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare,obj.lon,obj.lat, new_n_lon, new_n_lat );
            
            upscaled_obj.total_available_area_SE_threshold_5_hectare = upscaled_obj.abandoned_cropland_hectare + upscaled_obj.cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare;
            upscaled_obj.total_available_area_SE_threshold_10_hectare = upscaled_obj.abandoned_cropland_hectare + upscaled_obj.cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare;
            
            upscaled_obj.total_available_area_SE_5_incl_cropland_10_hectare = upscaled_obj.total_available_area_SE_threshold_5_hectare + (upscaled_obj.cropland_hectare-upscaled_obj.cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare)*0.1;
            upscaled_obj.total_available_area_SE_5_incl_cropland_20_hectare = upscaled_obj.total_available_area_SE_threshold_5_hectare + (upscaled_obj.cropland_hectare-upscaled_obj.cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare)*0.2;
            upscaled_obj.total_available_area_SE_5_incl_cropland_50_hectare = upscaled_obj.total_available_area_SE_threshold_5_hectare + (upscaled_obj.cropland_hectare-upscaled_obj.cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare)*0.5;
            
            upscaled_obj.total_available_area_SE_10_incl_cropland_10_hectare = upscaled_obj.total_available_area_SE_threshold_10_hectare + (upscaled_obj.cropland_hectare-upscaled_obj.cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare)*0.1;
            upscaled_obj.total_available_area_SE_10_incl_cropland_20_hectare = upscaled_obj.total_available_area_SE_threshold_10_hectare + (upscaled_obj.cropland_hectare-upscaled_obj.cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare)*0.2;
            upscaled_obj.total_available_area_SE_10_incl_cropland_50_hectare = upscaled_obj.total_available_area_SE_threshold_10_hectare + (upscaled_obj.cropland_hectare-upscaled_obj.cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare)*0.5;
            
            
            areaMatrix = zeros(new_n_lon, new_n_lat);
            for i = 1:new_n_lat
               areaMatrix(:,i) =  upscaled_obj.cell_area_per_latitude_hectare(i);
                
            end
            
            
            %prealloc
            upscaled_obj.abandoned_cropland_fractions = upscaled_obj.abandoned_cropland_hectare./areaMatrix;
            upscaled_obj.cropland_fractions = upscaled_obj.cropland_hectare./areaMatrix;
            upscaled_obj.cropland_soil_erosion_above_5_ton_perHa_perYear_unit_fractions = upscaled_obj.cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare./areaMatrix;
            upscaled_obj.cropland_soil_erosion_above_10_ton_perHa_perYear_unit_fractions = upscaled_obj.cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare./areaMatrix;
            upscaled_obj.total_available_area_SE_threshold_5_fractions = upscaled_obj.total_available_area_SE_threshold_5_hectare./areaMatrix;
            upscaled_obj.total_available_area_SE_threshold_10_fractions = upscaled_obj.total_available_area_SE_threshold_10_hectare./areaMatrix;
            upscaled_obj.total_available_area_SE_5_incl_cropland_10_fractions = upscaled_obj.total_available_area_SE_5_incl_cropland_10_hectare./areaMatrix;
            upscaled_obj.total_available_area_SE_5_incl_cropland_20_fractions = upscaled_obj.total_available_area_SE_5_incl_cropland_20_hectare./areaMatrix;
            upscaled_obj.total_available_area_SE_5_incl_cropland_50_fractions = upscaled_obj.total_available_area_SE_5_incl_cropland_50_hectare./areaMatrix;
            upscaled_obj.total_available_area_SE_10_incl_cropland_10_fractions = upscaled_obj.total_available_area_SE_10_incl_cropland_10_hectare./areaMatrix;
            upscaled_obj.total_available_area_SE_10_incl_cropland_20_fractions = upscaled_obj.total_available_area_SE_10_incl_cropland_10_hectare./areaMatrix;
            upscaled_obj.total_available_area_SE_10_incl_cropland_50_fractions = upscaled_obj.total_available_area_SE_10_incl_cropland_10_hectare./areaMatrix;
            
            
            
            
            %get fractions
%             for i = 1:length(upscaled_obj.lat)
%                 upscaled_obj.abandoned_cropland_fractions(:,i) = upscaled_obj.abandoned_cropland_hectare(:,i)/upscaled_obj.cell_area_per_latitude_hectare(i);
%                 upscaled_obj.cropland_fractions(:,i) = upscaled_obj.cropland_hectare(:,i)/upscaled_obj.cell_area_per_latitude_hectare(i);
%                 upscaled_obj.cropland_soil_erosion_above_5_ton_perHa_perYear_unit_fractions(:,i) = upscaled_obj.cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare(:,i)/upscaled_obj.cell_area_per_latitude_hectare(i);
%                 upscaled_obj.cropland_soil_erosion_above_10_ton_perHa_perYear_unit_fractions(:,i) = upscaled_obj.cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare(:,i)/upscaled_obj.cell_area_per_latitude_hectare(i);
%                 upscaled_obj.total_available_area_SE_threshold_5_fractions(:,i) = upscaled_obj.total_available_area_SE_threshold_5_hectare(:,i)/upscaled_obj.cell_area_per_latitude_hectare(i);
%                 upscaled_obj.total_available_area_SE_threshold_10_fractions(:,i) = upscaled_obj.total_available_area_SE_threshold_10_hectare(:,i)/upscaled_obj.cell_area_per_latitude_hectare(i);
%                 
%                 upscaled_obj.total_available_area_SE_5_incl_cropland_10_fractions(:,i) = upscaled_obj.total_available_area_SE_5_incl_cropland_10_hectare(:,i)/upscaled_obj.cell_area_per_latitude_hectare(i);
%                 upscaled_obj.total_available_area_SE_5_incl_cropland_20_fractions(:,i) = upscaled_obj.total_available_area_SE_5_incl_cropland_20_hectare(:,i)/upscaled_obj.cell_area_per_latitude_hectare(i);
%                 upscaled_obj.total_available_area_SE_5_incl_cropland_50_fractions(:,i) = upscaled_obj.total_available_area_SE_5_incl_cropland_50_hectare(:,i)/upscaled_obj.cell_area_per_latitude_hectare(i);
%                 upscaled_obj.total_available_area_SE_10_incl_cropland_10_fractions(:,i) = upscaled_obj.total_available_area_SE_10_incl_cropland_10_hectare(:,i)/upscaled_obj.cell_area_per_latitude_hectare(i);
%                 upscaled_obj.total_available_area_SE_10_incl_cropland_20_fractions(:,i) = upscaled_obj.total_available_area_SE_10_incl_cropland_20_hectare(:,i)/upscaled_obj.cell_area_per_latitude_hectare(i);
%                 upscaled_obj.total_available_area_SE_10_incl_cropland_50_fractions(:,i) = upscaled_obj.total_available_area_SE_10_incl_cropland_50_hectare(:,i)/upscaled_obj.cell_area_per_latitude_hectare(i); 
%             end
            
        end
        
        function export2netcdf(obj)
            lat = obj.lat;
            lon = obj.lon;
            
            n_lat = length(lat);
            n_lon = length(lon);
            
            filename = [obj.region_name '_bienergy_crop_land_availability' num2str(n_lon) 'x' num2str(n_lat) '_.nc'];
            
          
            
            nccreate(filename, 'description', 'Datatype', 'char', 'Dimensions', {'dim1', inf});
            ncwriteatt(filename, 'description', 'standard_name', 'description');
            ncwriteatt(filename, 'description', 'long_name', 'description');
            
            nccreate(filename, 'region', 'Datatype', 'char', 'Dimensions', {'dim1', inf});
            ncwriteatt(filename, 'region', 'standard_name', 'region');
            ncwriteatt(filename, 'region', 'long_name', 'region');
            
            nccreate(filename, 'year');
            ncwriteatt(filename, 'year', 'standard_name', 'year');
            ncwriteatt(filename, 'year', 'long_name', 'year');
            
            nccreate(filename,'lat','Dimensions',{'lat' length(lat)});
            ncwriteatt(filename, 'lat', 'standard_name', 'latitude');
            ncwriteatt(filename, 'lat', 'long_name', 'latitude');
            ncwriteatt(filename, 'lat', 'units', 'degrees_north');
            ncwriteatt(filename, 'lat', '_CoordinateAxisType', 'Lat');
            ncwriteatt(filename, 'lat', 'axis', 'Y');
            
            nccreate(filename,'lon','Dimensions',{'lon' length(lon)});
            ncwriteatt(filename, 'lon', 'standard_name', 'longitude');
            ncwriteatt(filename, 'lon', 'long_name', 'longitude');
            ncwriteatt(filename, 'lon', 'units', 'degrees_east');
            ncwriteatt(filename, 'lon', '_CoordinateAxisType', 'Lon');
            ncwriteatt(filename, 'lon', 'axis', 'X');
            
            nccreate(filename, 'abandoned_cropland_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'abandoned_cropland_hectare', 'standard_name', 'abandoned_cropland_hectare');
            ncwriteatt(filename, 'abandoned_cropland_hectare', 'long_name', 'abandoned_cropland_hectare');
            ncwriteatt(filename, 'abandoned_cropland_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'abandoned_cropland_hectare', 'missing_value', '-999');
            
            nccreate(filename, 'abandoned_cropland_fractions', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'abandoned_cropland_fractions', 'standard_name', 'abandoned_cropland_fractions');
            ncwriteatt(filename, 'abandoned_cropland_fractions', 'long_name', 'abandoned_cropland_fractions');
            ncwriteatt(filename, 'abandoned_cropland_fractions', 'units', '');
            ncwriteatt(filename, 'abandoned_cropland_fractions', 'missing_value', '-999');
            
            nccreate(filename, 'cropland_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'cropland_hectare', 'standard_name', 'cropland_hectare');
            ncwriteatt(filename, 'cropland_hectare', 'long_name', 'cropland_hectare');
            ncwriteatt(filename, 'cropland_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'cropland_hectare', 'missing_value', '-999');
            
            nccreate(filename, 'cropland_fractions', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'cropland_fractions', 'standard_name', 'cropland_fractions');
            ncwriteatt(filename, 'cropland_fractions', 'long_name', 'cropland_fractions');
            ncwriteatt(filename, 'cropland_fractions', 'units', '');
            ncwriteatt(filename, 'cropland_fractions', 'missing_value', '-999');
            
            nccreate(filename, 'cropland_SE5_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'cropland_SE5_hectare', 'standard_name', 'cropland_SE5_hectare');
            ncwriteatt(filename, 'cropland_SE5_hectare', 'long_name', 'cropland_with_soil_erosion_above_5_ton_per_hectare_per_year_in_hectare');
            ncwriteatt(filename, 'cropland_SE5_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'cropland_SE5_hectare', 'missing_value', '-999');
            
            nccreate(filename, 'cropland_SE5_fractions', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'cropland_SE5_fractions', 'standard_name', 'cropland_SE5_fractions');
            ncwriteatt(filename, 'cropland_SE5_fractions', 'long_name', 'cropland_with_soil_erosion_above_5_ton_per_hectare_per_year_in_fraction_of_cell');
            ncwriteatt(filename, 'cropland_SE5_fractions', 'units', '');
            ncwriteatt(filename, 'cropland_SE5_fractions', 'missing_value', '-999');
            
            nccreate(filename, 'cropland_SE10_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'cropland_SE10_hectare', 'standard_name', 'cropland_SE10_hectare');
            ncwriteatt(filename, 'cropland_SE10_hectare', 'long_name', 'cropland_with_soil_erosion_above_10_ton_per_hectare_per_year_in_hectare');
            ncwriteatt(filename, 'cropland_SE10_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'cropland_SE10_hectare', 'missing_value', '-999');
            
            nccreate(filename, 'cropland_SE10_fractions', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'cropland_SE10_fractions', 'standard_name', 'cropland_SE10_fractions');
            ncwriteatt(filename, 'cropland_SE10_fractions', 'long_name', 'cropland_with_soil_erosion_above_10_ton_per_hectare_per_year_in_fraction_of_cell');
            ncwriteatt(filename, 'cropland_SE10_fractions', 'units', '');
            ncwriteatt(filename, 'cropland_SE10_fractions', 'missing_value', '-999');
            
            nccreate(filename, 'AC_CSE5_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'AC_CSE5_hectare', 'standard_name', 'AC_CSE10_hectare');
            ncwriteatt(filename, 'AC_CSE5_hectare', 'long_name', 'abandoned_cropland_and_cropland_with_soil_erosion_above_5_ton_per_hectare_per_year_in_hectare');
            ncwriteatt(filename, 'AC_CSE5_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'AC_CSE5_hectare', 'missing_value', '-999');
            
            nccreate(filename, 'AC_CSE5_fractions', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'AC_CSE5_fractions', 'standard_name', 'AC_CSE10_fractions');
            ncwriteatt(filename, 'AC_CSE5_fractions', 'long_name', 'abandoned_cropland_and_cropland_with_soil_erosion_above_5_ton_per_hectare_per_year_in_fraction_of_cell');
            ncwriteatt(filename, 'AC_CSE5_fractions', 'units', '');
            ncwriteatt(filename, 'AC_CSE5_fractions', 'missing_value', '-999');
            
            nccreate(filename, 'AC_CSE10_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'AC_CSE10_hectare', 'standard_name', 'AC_CSE10_hectare');
            ncwriteatt(filename, 'AC_CSE10_hectare', 'long_name', 'abandoned_cropland_and_cropland_with_soil_erosion_above_10_ton_per_hectare_per_year_in_hectare');
            ncwriteatt(filename, 'AC_CSE10_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'AC_CSE10_hectare', 'missing_value', '-999');
            
            nccreate(filename, 'AC_CSE10_fractions', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'AC_CSE10_fractions', 'standard_name', 'AC_CSE10_fractions');
            ncwriteatt(filename, 'AC_CSE10_fractions', 'long_name', 'abandoned_cropland_and_cropland_with_soil_erosion_above_10_ton_per_hectare_per_year_in_fraction_of_cell');
            ncwriteatt(filename, 'AC_CSE10_fractions', 'units', '');
            ncwriteatt(filename, 'AC_CSE10_fractions', 'missing_value', '-999');
            
            nccreate(filename, 'C10_AC_CSE5_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'C10_AC_CSE5_hectare', 'standard_name', 'C10_AC_CSE10_hectare');
            ncwriteatt(filename, 'C10_AC_CSE5_hectare', 'long_name', 'ten_percent_of_croplands_abandoned_cropland_and_cropland_with_soil_erosion_above_5_ton_per_hectare_per_year_in_hectare');
            ncwriteatt(filename, 'C10_AC_CSE5_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'C10_AC_CSE5_hectare', 'missing_value', '-999');
            
            nccreate(filename, 'C10_AC_CSE5_fractions', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'C10_AC_CSE5_fractions', 'standard_name', 'C10_AC_CSE10_fractions');
            ncwriteatt(filename, 'C10_AC_CSE5_fractions', 'long_name', 'ten_percent_of_croplands_abandoned_cropland_and_cropland_with_soil_erosion_above_5_ton_per_hectare_per_year_in_fraction_of_cell');
            ncwriteatt(filename, 'C10_AC_CSE5_fractions', 'units', '');
            ncwriteatt(filename, 'C10_AC_CSE5_fractions', 'missing_value', '-999');
            
            nccreate(filename, 'C20_AC_CSE5_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'C20_AC_CSE5_hectare', 'standard_name', 'C20_AC_CSE10_hectare');
            ncwriteatt(filename, 'C20_AC_CSE5_hectare', 'long_name', 'twenty_percent_of_croplands_abandoned_cropland_and_cropland_with_soil_erosion_above_5_ton_per_hectare_per_year_in_hectare');
            ncwriteatt(filename, 'C20_AC_CSE5_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'C20_AC_CSE5_hectare', 'missing_value', '-999');
            
            nccreate(filename, 'C20_AC_CSE5_fractions', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'C20_AC_CSE5_fractions', 'standard_name', 'C20_AC_CSE10_fractions');
            ncwriteatt(filename, 'C20_AC_CSE5_fractions', 'long_name', 'twenty_percent_of_croplands_abandoned_cropland_and_cropland_with_soil_erosion_above_5_ton_per_hectare_per_year_in_fraction_of_cell');
            ncwriteatt(filename, 'C20_AC_CSE5_fractions', 'units', '');
            ncwriteatt(filename, 'C20_AC_CSE5_fractions', 'missing_value', '-999');
            
            nccreate(filename, 'C50_AC_CSE5_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'C50_AC_CSE5_hectare', 'standard_name', 'C50_AC_CSE10_hectare');
            ncwriteatt(filename, 'C50_AC_CSE5_hectare', 'long_name', 'fifty_percent_of_croplands_abandoned_cropland_and_cropland_with_soil_erosion_above_5_ton_per_hectare_per_year_in_hectare');
            ncwriteatt(filename, 'C50_AC_CSE5_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'C50_AC_CSE5_hectare', 'missing_value', '-999');
            
            nccreate(filename, 'C50_AC_CSE5_fractions', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'C50_AC_CSE5_fractions', 'standard_name', 'C50_AC_CSE10_fractions');
            ncwriteatt(filename, 'C50_AC_CSE5_fractions', 'long_name', 'fifty_percent_of_croplands_abandoned_cropland_and_cropland_with_soil_erosion_above_5_ton_per_hectare_per_year_in_fraction_of_cell');
            ncwriteatt(filename, 'C50_AC_CSE5_fractions', 'units', '');
            ncwriteatt(filename, 'C50_AC_CSE5_fractions', 'missing_value', '-999');
            
            nccreate(filename, 'C10_AC_CSE10_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'C10_AC_CSE10_hectare', 'standard_name', 'C10_AC_CSE10_hectare');
            ncwriteatt(filename, 'C10_AC_CSE10_hectare', 'long_name', 'ten_percent_of_croplands_abandoned_cropland_and_cropland_with_soil_erosion_above_5_ton_per_hectare_per_year_in_hectare');
            ncwriteatt(filename, 'C10_AC_CSE10_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'C10_AC_CSE10_hectare', 'missing_value', '-999');
            
            nccreate(filename, 'C10_AC_CSE10_fractions', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'C10_AC_CSE10_fractions', 'standard_name', 'C10_AC_CSE10_fractions');
            ncwriteatt(filename, 'C10_AC_CSE10_fractions', 'long_name', 'ten_percent_of_croplands_abandoned_cropland_and_cropland_with_soil_erosion_above_5_ton_per_hectare_per_year_in_fraction_of_cell');
            ncwriteatt(filename, 'C10_AC_CSE10_fractions', 'units', '');
            ncwriteatt(filename, 'C10_AC_CSE10_fractions', 'missing_value', '-999');
            
            nccreate(filename, 'C20_AC_CSE10_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'C20_AC_CSE10_hectare', 'standard_name', 'C20_AC_CSE10_hectare');
            ncwriteatt(filename, 'C20_AC_CSE10_hectare', 'long_name', 'twenty_percent_of_croplands_abandoned_cropland_and_cropland_with_soil_erosion_above_5_ton_per_hectare_per_year_in_hectare');
            ncwriteatt(filename, 'C20_AC_CSE10_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'C20_AC_CSE10_hectare', 'missing_value', '-999');
            
            nccreate(filename, 'C20_AC_CSE10_fractions', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'C20_AC_CSE10_fractions', 'standard_name', 'C20_AC_CSE10_fractions');
            ncwriteatt(filename, 'C20_AC_CSE10_fractions', 'long_name', 'twenty_percent_of_croplands_abandoned_cropland_and_cropland_with_soil_erosion_above_5_ton_per_hectare_per_year_in_fraction_of_cell');
            ncwriteatt(filename, 'C20_AC_CSE10_fractions', 'units', '');
            ncwriteatt(filename, 'C20_AC_CSE10_fractions', 'missing_value', '-999');
            
            nccreate(filename, 'C50_AC_CSE10_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'C50_AC_CSE10_hectare', 'standard_name', 'C50_AC_CSE10_hectare');
            ncwriteatt(filename, 'C50_AC_CSE10_hectare', 'long_name', 'fifty_percent_of_croplands_abandoned_cropland_and_cropland_with_soil_erosion_above_5_ton_per_hectare_per_year_in_hectare');
            ncwriteatt(filename, 'C50_AC_CSE10_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'C50_AC_CSE10_hectare', 'missing_value', '-999');
            
            nccreate(filename, 'C50_AC_CSE10_fractions', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'C50_AC_CSE10_fractions', 'standard_name', 'C50_AC_CSE10_fractions');
            ncwriteatt(filename, 'C50_AC_CSE10_fractions', 'long_name', 'fifty_percent_of_croplands_abandoned_cropland_and_cropland_with_soil_erosion_above_5_ton_per_hectare_per_year_in_fraction_of_cell');
            ncwriteatt(filename, 'C50_AC_CSE10_fractions', 'units', '');
            ncwriteatt(filename, 'C50_AC_CSE10_fractions', 'missing_value', '-999');
            
            
            ncwrite(filename, 'description', 'Land availability scenarios for bioenergy')
            ncwrite(filename, 'region', obj.region_name);
            ncwrite(filename, 'year', 2018);
            ncwrite(filename, 'lat', lat);
            ncwrite(filename, 'lon', lon);
            ncwrite(filename, 'abandoned_cropland_hectare', obj.abandoned_cropland_hectare);
            ncwrite(filename, 'abandoned_cropland_fractions', obj.abandoned_cropland_fractions);
            ncwrite(filename, 'cropland_hectare', obj.cropland_hectare);
            ncwrite(filename, 'cropland_fractions', obj.cropland_fractions);
            ncwrite(filename, 'cropland_SE5_hectare', obj.cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare);
            ncwrite(filename, 'cropland_SE5_fractions',obj.cropland_soil_erosion_above_5_ton_perHa_perYear_unit_fractions);
            ncwrite(filename, 'cropland_SE10_hectare', obj.cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare);
            ncwrite(filename, 'cropland_SE10_fractions',obj.cropland_soil_erosion_above_10_ton_perHa_perYear_unit_fractions);
            ncwrite(filename, 'AC_CSE5_hectare', obj.total_available_area_SE_threshold_5_hectare);
            ncwrite(filename, 'AC_CSE5_fractions', obj.total_available_area_SE_threshold_5_fractions);
            ncwrite(filename, 'AC_CSE10_hectare', obj.total_available_area_SE_threshold_10_hectare);
            ncwrite(filename, 'AC_CSE10_fractions', obj.total_available_area_SE_threshold_10_fractions);
            ncwrite(filename, 'C10_AC_CSE5_hectare', obj.total_available_area_SE_5_incl_cropland_10_hectare);
            ncwrite(filename, 'C20_AC_CSE5_hectare', obj.total_available_area_SE_5_incl_cropland_20_hectare);
            ncwrite(filename, 'C50_AC_CSE5_hectare', obj.total_available_area_SE_5_incl_cropland_50_hectare);
            ncwrite(filename, 'C10_AC_CSE10_hectare', obj.total_available_area_SE_10_incl_cropland_10_hectare);
            ncwrite(filename, 'C20_AC_CSE10_hectare', obj.total_available_area_SE_10_incl_cropland_20_hectare);
            ncwrite(filename, 'C50_AC_CSE10_hectare', obj.total_available_area_SE_10_incl_cropland_50_hectare);
            
            ncwrite(filename, 'C10_AC_CSE5_fractions', obj.total_available_area_SE_5_incl_cropland_10_fractions);
            ncwrite(filename, 'C20_AC_CSE5_fractions', obj.total_available_area_SE_5_incl_cropland_20_fractions);
            ncwrite(filename, 'C50_AC_CSE5_fractions', obj.total_available_area_SE_5_incl_cropland_50_fractions);
            ncwrite(filename, 'C10_AC_CSE10_fractions', obj.total_available_area_SE_10_incl_cropland_10_fractions);
            ncwrite(filename, 'C20_AC_CSE10_fractions', obj.total_available_area_SE_10_incl_cropland_20_fractions);
            ncwrite(filename, 'C50_AC_CSE10_fractions', obj.total_available_area_SE_10_incl_cropland_50_fractions);
        end
    end
    
end

