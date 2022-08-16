classdef RegionalMask
    %REGIONALMASK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        region_name
        lat
        lon
        lat_bnds
        lon_bnds
        year_landCover
        cell_area_per_latitude_hectare
        geocentric_radius_at_lat_km
        fraction_of_cell_is_region
        area_mask_hectare
        
        Bioenergy_rf_h
        
        abandoned_cropland_hectare
        abandoned_cropland_fractions
        abandoned_cropland_ilswe_4_hectare
        abandoned_cropland_ilswe_5_hectare
        abandoned_cropland_wse_above_5_ton_perHa_perYear_unit_hectare
        abandoned_cropland_wse_above_10_ton_perHa_perYear_unit_hectare
        abandoned_cropland_wse_between_5_10_hectare
        
        aboveground_carbon_on_abandoned_cropland_ton_C
        pe_aboveground_carbon_on_abandoned_cropland
        
        cropland_hectare
        cropland_fractions
        cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare
        cropland_soil_erosion_above_5_ton_perHa_perYear_unit_fractions
        cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare
        cropland_soil_erosion_above_10_ton_perHa_perYear_unit_fractions
        cropland_ilswe_1_hectare
        cropland_ilswe_2_hectare
        cropland_ilswe_3_hectare
        cropland_ilswe_4_hectare
        cropland_ilswe_5_hectare
        cropland_floods_hectare
        cropland_floods_10y_mean_m
        cropland_both_ilswe_4_5_se_5
        share_of_cropland_ilswe_also_under_se
        cropland_under_soil_erosion_mod_high_all_hectare
        cropland_under_soil_erosion_mod_high_4bioenergy_hectare
        
        cropland_under_pressure
        cropland_under_pressure_categories = {'SE5', 'SE10', 'ILSWE4', 'ILSWE5', 'Floods', 'Two impacts', 'Three impacts'};
        
        %These below include abandoned cropland
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
        
        description_acs_nr = 'Aboveground carbon sequestration of natural regrowth';
        unit_acs_nr_rate = 'ton C ha-1 yr-1';
        acs_nr_rate
        acs_nr_rate_cropland
        acs_nr_rate_abandoned_cropland
        unit_acs_nr = 'ton C yr-1';
        acs_nr_cropland
        acs_nr_abandoned_cropland
        acs_nr_cropland_se5
        acs_nr_cropland_se10
        acs_nr_cropland_ilswe1
        acs_nr_cropland_ilswe2
        acs_nr_cropland_ilswe3
        acs_nr_cropland_ilswe4
        acs_nr_cropland_ilswe5
        acs_nr_cropland_floods
        
        distance_from_nearest_refinery_km
        nearest_refinery_ID
        gwp100_diesel_transport_biomass_farm2ref_kg_co2eq_per_ton_dm
        gwp100_farm_em_willow_kg_co2eq_per_ton_dm
        soc_change_15y_tonC_per_ha
        soc_change_15y_tonC
        
        gwp100_region_mean_switchgrass_farm_em_kg_co2eq_per_ton_dm
        gwp100_region_mean_rcg_farm_em_kg_co2eq_per_ton_dm
        gwp100_region_mean_willow_farm_em_kg_co2eq_per_ton_dm
        
        gcam_projected_bioenergy_lu_ssp126_2050_total_ha
        gcam_projected_bioenergy_lu_ssp226_2050_total_ha
        gcam_projected_bioenergy_lu_ssp426_2050_total_ha
        gcam_projected_bioenergy_lu_ssp526_2050_total_ha
        
        gcam_projected_bioenergy_lu_ssp126_2100_total_ha
        gcam_projected_bioenergy_lu_ssp226_2100_total_ha
        gcam_projected_bioenergy_lu_ssp426_2100_total_ha
        gcam_projected_bioenergy_lu_ssp526_2100_total_ha
        
        mean_natural_regrowth_ac_tonC_per_ha_year
        mean_natural_regrowth_cropland_se5_ilswe_45_tonC_per_ha_year
        share_ac_per_biome
        share_cropland_se5_ilswe_45_per_biome
        mean_soil_carbon_seq_rate_of_nat_regrowth_tonC_per_ha_year
        mean_soil_carbon_seq_rate_cropland_se5_ilswe_45
        gridded_soil_carbon_seq_rate_nat_regrowth_tonC_per_ha_year
        
        
        
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
        
        function export_productive_area_wb(obj)
            
            lat = obj.lat;
            lon = obj.lon;
            
            filename = ['Output/' obj.region_name '_wb_productive_areas.nc'];
            
            if exist(filename, 'file')
               delete(filename); 
            end
            
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
            
            nccreate(filename, 'productive_area_ac', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'productive_area_ac', 'standard_name', 'productive_area_abandoned_cropland');
            ncwriteatt(filename, 'productive_area_ac', 'long_name', 'productive_area_abandoned_cropland');
            ncwriteatt(filename, 'productive_area_ac', 'units', 'ha');
            ncwriteatt(filename, 'productive_area_ac', 'missing_value', '-999');
            
            nccreate(filename, 'productive_area_cropland_under_soil_erosion', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'productive_area_cropland_under_soil_erosion', 'standard_name', 'productive_area_cropland_under_soil_erosion');
            ncwriteatt(filename, 'productive_area_cropland_under_soil_erosion', 'long_name', 'productive_area_cropland_under_soil_erosion');
            ncwriteatt(filename, 'productive_area_cropland_under_soil_erosion', 'units', 'ha');
            ncwriteatt(filename, 'productive_area_cropland_under_soil_erosion', 'missing_value', '-999');
            
            for i = 1:length(obj.Bioenergy_rf_h)
               if  obj.Bioenergy_rf_h(i).is_wb_scenario == 1
                   idx = i;
                   break
               end
            end
            
            productive_area_ac = obj.abandoned_cropland_hectare;
            productive_area_ac(obj.Bioenergy_rf_h(idx).pe_ac <= 0) = 0;
            productive_area_cropland_se = obj.cropland_under_soil_erosion_mod_high_4bioenergy_hectare;
            productive_area_cropland_se(obj.Bioenergy_rf_h(idx).pe_cropland_se_wat_wind_4bioenergy <= 0) = 0;
            
            ncwrite(filename, 'lat', obj.lat);
            ncwrite(filename, 'lon', obj.lon);
            ncwrite(filename, 'productive_area_ac',productive_area_ac)
            ncwrite(filename, 'productive_area_cropland_under_soil_erosion', productive_area_cropland_se)
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
            
            
            [upscaled_obj.cropland_ilswe_1_hectare,~,~,~,~]  = aggregateMatrix2givenDimensions(obj.cropland_ilswe_1_hectare,obj.lon,obj.lat, new_n_lon, new_n_lat );
            [upscaled_obj.cropland_ilswe_2_hectare,~,~,~,~]  = aggregateMatrix2givenDimensions(obj.cropland_ilswe_2_hectare,obj.lon,obj.lat, new_n_lon, new_n_lat );
            [upscaled_obj.cropland_ilswe_3_hectare,~,~,~,~]  = aggregateMatrix2givenDimensions(obj.cropland_ilswe_3_hectare,obj.lon,obj.lat, new_n_lon, new_n_lat );
            [upscaled_obj.cropland_ilswe_4_hectare,~,~,~,~]  = aggregateMatrix2givenDimensions(obj.cropland_ilswe_4_hectare,obj.lon,obj.lat, new_n_lon, new_n_lat );
            [upscaled_obj.cropland_ilswe_5_hectare,~,~,~,~]  = aggregateMatrix2givenDimensions(obj.cropland_ilswe_5_hectare,obj.lon,obj.lat, new_n_lon, new_n_lat );
            [upscaled_obj.cropland_floods_hectare,~,~,~,~]  = aggregateMatrix2givenDimensions(obj.cropland_floods_hectare,obj.lon,obj.lat, new_n_lon, new_n_lat );
            [upscaled_obj.abandoned_cropland_ilswe_4_hectare,~,~,~,~]  = aggregateMatrix2givenDimensions(obj.abandoned_cropland_ilswe_4_hectare,obj.lon,obj.lat, new_n_lon, new_n_lat );
            [upscaled_obj.abandoned_cropland_ilswe_5_hectare,~,~,~,~]  = aggregateMatrix2givenDimensions(obj.abandoned_cropland_ilswe_5_hectare,obj.lon,obj.lat, new_n_lon, new_n_lat );
            
            %Abandoned cropland and soil erosion
            Soil_erosion_water = RUSLE('Input/GloSEM_SE_2015_IMAGE_LU_5arcmin.nc');
            upscaled_obj.abandoned_cropland_wse_above_5_ton_perHa_perYear_unit_hectare = upscaled_obj.abandoned_cropland_hectare.*(Soil_erosion_water.soil_erosion > 5);
            upscaled_obj.abandoned_cropland_wse_above_10_ton_perHa_perYear_unit_hectare = upscaled_obj.abandoned_cropland_hectare.*(Soil_erosion_water.soil_erosion > 10);
            upscaled_obj.abandoned_cropland_wse_between_5_10_hectare = upscaled_obj.abandoned_cropland_wse_above_5_ton_perHa_perYear_unit_hectare-upscaled_obj.abandoned_cropland_wse_above_10_ton_perHa_perYear_unit_hectare;
            
            %mean flood rate
            temp = obj.cropland_floods_10y_mean_m;
            temp(temp < 0) = 0;
            
            [upscaled_obj.cropland_floods_10y_mean_m,~,~,~,~]  = aggregateMatrix2givenDimensions(temp.*obj.cropland_floods_hectare,obj.lon,obj.lat, new_n_lon, new_n_lat );
            
            upscaled_obj.cropland_floods_10y_mean_m = upscaled_obj.cropland_floods_10y_mean_m./upscaled_obj.cropland_floods_hectare;
            upscaled_obj.cropland_floods_10y_mean_m(isnan(upscaled_obj.cropland_floods_10y_mean_m)) = -999;
            
            
            
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
            
            filename = ['Output/' obj.region_name '_bienergy_crop_land_availability' num2str(n_lon) 'x' num2str(n_lat) '_v3_.nc'];
            
            
            
            
            
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
            
            nccreate(filename, 'description', 'Datatype', 'char', 'Dimensions', {'dim1', inf});
            ncwriteatt(filename, 'description', 'standard_name', 'description');
            ncwriteatt(filename, 'description', 'long_name', 'description');
            
            nccreate(filename, 'region', 'Datatype', 'char', 'Dimensions', {'dim1', inf});
            ncwriteatt(filename, 'region', 'standard_name', 'region');
            ncwriteatt(filename, 'region', 'long_name', 'region');
            
            nccreate(filename, 'year');
            ncwriteatt(filename, 'year', 'standard_name', 'year');
            ncwriteatt(filename, 'year', 'long_name', 'year');
            
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
            
            nccreate(filename, 'cropland_ilswe_1_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'cropland_ilswe_1_hectare', 'standard_name', 'cropland_ilswe_1_hectare');
            ncwriteatt(filename, 'cropland_ilswe_1_hectare', 'long_name', 'cropland_ilswe_1_hectare');
            ncwriteatt(filename, 'cropland_ilswe_1_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'cropland_ilswe_1_hectare', 'missing_value', '-999');
            
            nccreate(filename, 'cropland_ilswe_2_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'cropland_ilswe_2_hectare', 'standard_name', 'cropland_ilswe_2_hectare');
            ncwriteatt(filename, 'cropland_ilswe_2_hectare', 'long_name', 'cropland_ilswe_2_hectare');
            ncwriteatt(filename, 'cropland_ilswe_2_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'cropland_ilswe_2_hectare', 'missing_value', '-999');
            
            nccreate(filename, 'cropland_ilswe_3_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'cropland_ilswe_3_hectare', 'standard_name', 'cropland_ilswe_3_hectare');
            ncwriteatt(filename, 'cropland_ilswe_3_hectare', 'long_name', 'cropland_ilswe_3_hectare');
            ncwriteatt(filename, 'cropland_ilswe_3_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'cropland_ilswe_3_hectare', 'missing_value', '-999');
            
            nccreate(filename, 'cropland_ilswe_4_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'cropland_ilswe_4_hectare', 'standard_name', 'cropland_ilswe_4_hectare');
            ncwriteatt(filename, 'cropland_ilswe_4_hectare', 'long_name', 'cropland_ilswe_4_hectare');
            ncwriteatt(filename, 'cropland_ilswe_4_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'cropland_ilswe_4_hectare', 'missing_value', '-999');
            
            nccreate(filename, 'cropland_ilswe_5_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'cropland_ilswe_5_hectare', 'standard_name', 'cropland_ilswe_5_hectare');
            ncwriteatt(filename, 'cropland_ilswe_5_hectare', 'long_name', 'cropland_ilswe_5_hectare');
            ncwriteatt(filename, 'cropland_ilswe_5_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'cropland_ilswe_5_hectare', 'missing_value', '-999');
            
            nccreate(filename, 'cropland_floods_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'cropland_floods_hectare', 'standard_name', 'cropland_floods_hectare');
            ncwriteatt(filename, 'cropland_floods_hectare', 'long_name', 'cropland_floods_hectare');
            ncwriteatt(filename, 'cropland_floods_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'cropland_floods_hectare', 'missing_value', '-999');
            
            nccreate(filename, 'cropland_floods_10y_mean_m', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'cropland_floods_10y_mean_m', 'standard_name', 'cropland_floods_10y_mean_m');
            ncwriteatt(filename, 'cropland_floods_10y_mean_m', 'long_name', 'cropland_floods_10y_mean_m');
            ncwriteatt(filename, 'cropland_floods_10y_mean_m', 'units', 'hectare');
            ncwriteatt(filename, 'cropland_floods_10y_mean_m', 'missing_value', '-999');
            
            nccreate(filename, 'abandoned_cropland_ilswe_4_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'abandoned_cropland_ilswe_4_hectare', 'standard_name', 'abandoned_cropland_ilswe_4_hectare');
            ncwriteatt(filename, 'abandoned_cropland_ilswe_4_hectare', 'long_name', 'abandoned_cropland_ilswe_4_hectare');
            ncwriteatt(filename, 'abandoned_cropland_ilswe_4_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'abandoned_cropland_ilswe_4_hectare', 'missing_value', '-999');
            
            nccreate(filename, 'abandoned_cropland_ilswe_5_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'abandoned_cropland_ilswe_5_hectare', 'standard_name', 'abandoned_cropland_ilswe_5_hectare');
            ncwriteatt(filename, 'abandoned_cropland_ilswe_5_hectare', 'long_name', 'abandoned_cropland_ilswe_5_hectare');
            ncwriteatt(filename, 'abandoned_cropland_ilswe_5_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'abandoned_cropland_ilswe_5_hectare', 'missing_value', '-999');
            
            nccreate(filename, 'abandoned_cropland_wse_between_5_10_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'abandoned_cropland_wse_between_5_10_hectare', 'standard_name', 'abandoned_cropland_ilswe_5_hectare');
            ncwriteatt(filename, 'abandoned_cropland_wse_between_5_10_hectare', 'long_name', 'abandoned_cropland_ilswe_5_hectare');
            ncwriteatt(filename, 'abandoned_cropland_wse_between_5_10_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'abandoned_cropland_wse_between_5_10_hectare', 'missing_value', '-999');
            
            nccreate(filename, 'abandoned_cropland_wse_above_10_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'abandoned_cropland_wse_above_10_hectare', 'standard_name', 'abandoned_cropland_wse_above_10_ton_per_ha_per_year_unit_hectare');
            ncwriteatt(filename, 'abandoned_cropland_wse_above_10_hectare', 'long_name', 'abandoned_cropland_wse_above_10_ton_per_ha_per_year_unit_hectare');
            ncwriteatt(filename, 'abandoned_cropland_wse_above_10_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'abandoned_cropland_wse_above_10_hectare', 'missing_value', '-999');
            
            nccreate(filename, 'abandoned_cropland_wse_above_5_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'abandoned_cropland_wse_above_5_hectare', 'standard_name', 'abandoned_cropland_wse_above_5_ton_per_ha_per_year_unit_hectare');
            ncwriteatt(filename, 'abandoned_cropland_wse_above_5_hectare', 'long_name', 'abandoned_cropland_wse_above_5_ton_per_ha_per_year_unit_hectare');
            ncwriteatt(filename, 'abandoned_cropland_wse_above_5_hectare', 'units', 'hectare');
            ncwriteatt(filename, 'abandoned_cropland_wse_above_5_hectare', 'missing_value', '-999');
            
            
            
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
            
            if ~isempty(obj.total_available_area_SE_threshold_5_hectare)
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
            
            ncwrite(filename, 'cropland_ilswe_1_hectare', obj.cropland_ilswe_1_hectare);
            ncwrite(filename, 'cropland_ilswe_2_hectare', obj.cropland_ilswe_2_hectare);
            ncwrite(filename, 'cropland_ilswe_3_hectare', obj.cropland_ilswe_3_hectare);
            ncwrite(filename, 'cropland_ilswe_4_hectare', obj.cropland_ilswe_4_hectare);
            ncwrite(filename, 'cropland_ilswe_5_hectare', obj.cropland_ilswe_5_hectare);
            ncwrite(filename, 'cropland_floods_hectare', obj.cropland_floods_hectare);
            ncwrite(filename, 'cropland_floods_10y_mean_m', obj.cropland_floods_10y_mean_m);
            ncwrite(filename, 'abandoned_cropland_ilswe_4_hectare', obj.abandoned_cropland_ilswe_4_hectare);
            ncwrite(filename, 'abandoned_cropland_ilswe_5_hectare', obj.abandoned_cropland_ilswe_5_hectare);
            ncwrite(filename, 'abandoned_cropland_wse_between_5_10_hectare', obj.abandoned_cropland_wse_between_5_10_hectare);
            ncwrite(filename, 'abandoned_cropland_wse_above_10_hectare', obj.abandoned_cropland_wse_above_10_ton_perHa_perYear_unit_hectare);
            ncwrite(filename, 'abandoned_cropland_wse_above_5_hectare', obj.abandoned_cropland_wse_above_5_ton_perHa_perYear_unit_hectare);
            
        end
        
        function obj = calc_gcam_projected_values(obj,GCAM_array)
            %sum(sum(obj.fraction_of_cell_is_region))
            
            regional_mask_05deg = zeros(length(GCAM_array(1).lon), length(GCAM_array(1).lat));
            
            idx_lat = zeros(1,length(GCAM_array(1).lat));
            idx_lon = zeros(1,length(GCAM_array(1).lon));
            for lats = 1:length(GCAM_array(1).lat)
                [~,idx_lat(lats)] = min(abs((GCAM_array(1).lat(lats)-obj.lat)));
            end
            for lons = 1:length(GCAM_array(1).lon)
                [~,idx_lon(lons)] = min(abs((GCAM_array(1).lon(lons)-obj.lon)));
            end
            
            for lons = 1:length(GCAM_array(1).lon)
                
                %[~,idx_lon] = min(abs((GCAM_array(1).lon(lons)-obj.lon)));
                
                
                for lats = 1:length(GCAM_array(1).lat)
                    %[~,idx_lat] = min(abs((GCAM_array(1).lat(lats)-obj.lat)));
                    
                    regional_mask_05deg(lons,lats) = obj.fraction_of_cell_is_region(idx_lon(lons), idx_lat(lats));
                    
                end
            end
            
            %sum(sum(regional_mask_05deg))
            
            fprintf(['GCAM projections of bioenergy land user (Mha) for: ' obj.region_name '\n']);
            
            for i = 1:length(GCAM_array)
                bioenergy_crops_rf_ha_tot = sum(sum(GCAM_array(i).bioenergy_crops_rf_hectare.*regional_mask_05deg));
                bioenergy_crops_ir_ha_tot = sum(sum(GCAM_array(i).bioenergy_crops_ir_hectare.*regional_mask_05deg));
                
                fprintf(GCAM_array(i).description);
                fprintf(['. Rainfed: ' num2str(bioenergy_crops_rf_ha_tot*10^-6) '. Irrigated: ' num2str(bioenergy_crops_ir_ha_tot*10^-6) '\n']);
                
                if GCAM_array(i).year == 2050
                    if GCAM_array(i).SSP == 1
                        obj.gcam_projected_bioenergy_lu_ssp126_2050_total_ha = bioenergy_crops_rf_ha_tot+bioenergy_crops_ir_ha_tot;
                    elseif GCAM_array(i).SSP == 2
                        obj.gcam_projected_bioenergy_lu_ssp226_2050_total_ha = bioenergy_crops_rf_ha_tot+bioenergy_crops_ir_ha_tot;
                    elseif GCAM_array(i).SSP == 4
                        obj.gcam_projected_bioenergy_lu_ssp426_2050_total_ha = bioenergy_crops_rf_ha_tot+bioenergy_crops_ir_ha_tot;
                    elseif GCAM_array(i).SSP == 5
                        obj.gcam_projected_bioenergy_lu_ssp526_2050_total_ha = bioenergy_crops_rf_ha_tot+bioenergy_crops_ir_ha_tot;
                        
                    end
                elseif GCAM_array(i).year == 2100
                    if GCAM_array(i).SSP == 1
                        obj.gcam_projected_bioenergy_lu_ssp126_2100_total_ha = bioenergy_crops_rf_ha_tot+bioenergy_crops_ir_ha_tot;
                    elseif GCAM_array(i).SSP == 2
                        obj.gcam_projected_bioenergy_lu_ssp226_2100_total_ha = bioenergy_crops_rf_ha_tot+bioenergy_crops_ir_ha_tot;
                    elseif GCAM_array(i).SSP == 4
                        obj.gcam_projected_bioenergy_lu_ssp426_2100_total_ha = bioenergy_crops_rf_ha_tot+bioenergy_crops_ir_ha_tot;
                    elseif GCAM_array(i).SSP == 5
                        obj.gcam_projected_bioenergy_lu_ssp526_2100_total_ha = bioenergy_crops_rf_ha_tot+bioenergy_crops_ir_ha_tot;
                        
                    end
                end
                
                
            end
            
        end
        
        function obj = get_regional_mask(obj, CountryMask)
            binary_isRegion = zeros(length(CountryMask.longitudeVector_mask_centered),length(CountryMask.latitudeVector_mask_centered));
            
            
            nordic_countries = {'Norway', 'Sweden', 'Finland', 'Denmark'};
            
            all_countries = CountryMask.countryMask;
            
            if strcmp(obj.region_name, 'Nordic_region')
                for i = 1:length(nordic_countries)
                    for j = 1:length(CountryMask.CountryArray)
                        if strcmp(nordic_countries{i},CountryMask.CountryArray(j).country_name)
                            this_id = CountryMask.CountryArray(j).GPW_country_ISO_numeric;
                            binary_isRegion(all_countries == this_id) = 1;
                            
                        end
                    end
                end
                
            end
            
            if strcmp(obj.region_name, 'Norway')
                for j = 1:length(CountryMask.CountryArray)
                    if strcmp('Norway',CountryMask.CountryArray(j).country_name)
                        this_id = CountryMask.CountryArray(j).GPW_country_ISO_numeric;
                        binary_isRegion(all_countries == this_id) = 1;
                    end
                end
                
            end
            
            if strcmp(obj.region_name, 'Denmark')
                for j = 1:length(CountryMask.CountryArray)
                    if strcmp('Denmark',CountryMask.CountryArray(j).country_name)
                        this_id = CountryMask.CountryArray(j).GPW_country_ISO_numeric;
                        binary_isRegion(all_countries == this_id) = 1;
                    end
                end
                
            end
            
            if strcmp(obj.region_name, 'Sweden')
                for j = 1:length(CountryMask.CountryArray)
                    if strcmp('Sweden',CountryMask.CountryArray(j).country_name)
                        this_id = CountryMask.CountryArray(j).GPW_country_ISO_numeric;
                        binary_isRegion(all_countries == this_id) = 1;
                    end
                end
                
            end
            
            if strcmp(obj.region_name, 'Finland')
                for j = 1:length(CountryMask.CountryArray)
                    if strcmp('Finland',CountryMask.CountryArray(j).country_name)
                        this_id = CountryMask.CountryArray(j).GPW_country_ISO_numeric;
                        binary_isRegion(all_countries == this_id) = 1;
                    end
                end
                
            end
            
            [fraction_region_5arcmin, lat_5arcmin, lon_5arcmin, ~, ~]  = aggregateMatrix2givenDimensions( binary_isRegion,CountryMask.longitudeVector_mask_centered,CountryMask.latitudeVector_mask_centered, 4320, 2160 );
            
            n_dif = (length(CountryMask.longitudeVector_mask_centered)/4320)^2;
            
            obj.fraction_of_cell_is_region = fraction_region_5arcmin/n_dif;
        end
        
        function obj = get_mean_soc_rate(obj,Biome)
            soc_tot = 0;
            temp = 0;
            
            soc_tot_crop = 0;
            temp_crop = 0;
            
            for i = 1:length(obj.share_ac_per_biome)
                if isnan(Biome.lockup_table_soil_carbon_seq_rates_nat_reg(i))
                    soc_tot = soc_tot+(obj.share_ac_per_biome(i)*Biome.lockup_table_soil_carbon_seq_rates_nat_reg(6));
                    temp = temp+obj.share_ac_per_biome(i);
                    
                    soc_tot_crop = soc_tot_crop+(obj.share_cropland_se5_ilswe_45_per_biome(i)*Biome.lockup_table_soil_carbon_seq_rates_nat_reg(6));
                    temp_crop = temp_crop+obj.share_cropland_se5_ilswe_45_per_biome(i);
                else
                    soc_tot = soc_tot + obj.share_ac_per_biome(i)*Biome.lockup_table_soil_carbon_seq_rates_nat_reg(i);
                    temp = temp+obj.share_ac_per_biome(i);
                    
                    soc_tot_crop = soc_tot_crop + obj.share_cropland_se5_ilswe_45_per_biome(i)*Biome.lockup_table_soil_carbon_seq_rates_nat_reg(i);
                    temp_crop = temp_crop+obj.share_cropland_se5_ilswe_45_per_biome(i);
                end
            end
            obj.mean_soil_carbon_seq_rate_of_nat_regrowth_tonC_per_ha_year = soc_tot/temp;
            obj.mean_soil_carbon_seq_rate_cropland_se5_ilswe_45 = soc_tot_crop/temp_crop;
        end
        
        [ obj ] = calc_nat_regrowth( obj, Natural_regrowth )
        [ obj ] = calc_bioenergy_carbon_flows( obj, BiorefineryArray, Inputs, CropType_Array)
        obj = calc_distance_to_nearest_refinery( obj, Ref_array )
        obj = calc_mitigation( obj, Inputs )
        plot_ac_distribution_after_abandonment( obj, ABC )
        obj = export_willow_farm_emissions( obj )
        plot_mitigation_per_ha_with_std_30y( obj, Inputs )
        get_cumulative_nat_reg_on_bioproductive_land( obj )
        export_src_data_soc_change_and_abc_ac( obj, idx_bioenergy_rf_h, filename )
        print_crop_allocation( obj, idx_rf_h)
        plot_carbon_yield_comparisons( obj )
        plot_dm_yield_vs_soc_bio( obj, SOC_change )
    end
    
end

