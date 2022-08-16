classdef Bioenergy_dm_yields_Li
    %BIOENERGY_DM_YIELDS_LI Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        lat
        lon
        dm_yields_optimal
        crop_allocation_Li_IDs
        
        dm_yields_miscanthus
        dm_yields_switchgrass
        dm_yields_willow
        dm_yields_poplar
        dm_yields_eucalypt
        
        lat_5arcmin
        lon_5arcmin 
        
        dm_yields_optimal_5arcmin
        dm_yields_miscanthus_5arcmin
        dm_yields_switchgrass_5arcmin
        dm_yields_willow_5arcmin
        dm_yields_poplar_5arcmin
        dm_yields_eucalypt_5arcmin
        
        unit_pe_yields = 'GJ ha-1 yr-1';
        pe_yields_miscanthus_5arcmin 
        pe_yields_switchgrass_5arcmin
        pe_yields_willow_5arcmin
        pe_yields_poplar_5arcmin
        pe_yields_eucalypt_5arcmin
        pe_yields_energy_optimal_5arcmin
        energy_optimal_crop_allocation_5arcmin
        crop_IDs_energy_optimal_crop_allocation
        crop_names_energy_optimal_crop_allocation
       
        
    end
    
    methods
        function obj = Bioenergy_dm_yields_Li(filename)
            
            ncid = netcdf.open(filename);
            obj.lat = netcdf.getVar(ncid,0);
            obj.lon = netcdf.getVar(ncid,1);
            obj.dm_yields_miscanthus = netcdf.getVar(ncid,3);
            obj.dm_yields_switchgrass = netcdf.getVar(ncid,5);
            obj.dm_yields_eucalypt = netcdf.getVar(ncid,2);
            obj.dm_yields_poplar = netcdf.getVar(ncid,4);
            obj.dm_yields_willow = netcdf.getVar(ncid,6);
            obj.dm_yields_optimal = netcdf.getVar(ncid,7);
            obj.crop_allocation_Li_IDs = netcdf.getVar(ncid,8);
            
            
            obj.dm_yields_miscanthus(isnan(obj.dm_yields_miscanthus)) = 0;
            obj.dm_yields_switchgrass(isnan(obj.dm_yields_switchgrass)) = 0;
            obj.dm_yields_eucalypt(isnan(obj.dm_yields_eucalypt)) = 0;
            obj.dm_yields_poplar(isnan(obj.dm_yields_poplar)) = 0;
            obj.dm_yields_willow(isnan(obj.dm_yields_willow)) = 0;
            obj.dm_yields_optimal(isnan(obj.dm_yields_optimal)) = 0;
            
            lat_step  = 180/2160;
            lon_step  = 360/4320;
            
            obj.lat_5arcmin = [90-lat_step/2:-lat_step:-90+lat_step/2];
            obj.lon_5arcmin = [-180+lon_step/2:lon_step:180-lon_step/2];
            
            idx_raw_to_5arcmin_lat = zeros(1,2160);
            idx_raw_to_5arcmin_lon = zeros(1,4320);
            
            for i = 1:length(obj.lat_5arcmin)
                [~, idx_raw_to_5arcmin_lat(i)] = min(abs(obj.lat-obj.lat_5arcmin(i)));
            end
            for i = 1:length(obj.lon_5arcmin)
                [~,idx_raw_to_5arcmin_lon(i)] = min(abs(obj.lon-obj.lon_5arcmin(i)));
            end
            
            obj.dm_yields_miscanthus_5arcmin = zeros(4320,2160);
            obj.dm_yields_switchgrass_5arcmin = zeros(4320,2160);
            obj.dm_yields_willow_5arcmin = zeros(4320,2160);
            obj.dm_yields_poplar_5arcmin = zeros(4320,2160);
            obj.dm_yields_eucalypt_5arcmin = zeros(4320,2160);
            
            for i = 1:4320
                for j = 1:2160
                    obj.dm_yields_optimal_5arcmin(i,j) = obj.dm_yields_optimal(idx_raw_to_5arcmin_lon(i), idx_raw_to_5arcmin_lat(j));
                    obj.dm_yields_miscanthus_5arcmin(i,j) = obj.dm_yields_miscanthus(idx_raw_to_5arcmin_lon(i), idx_raw_to_5arcmin_lat(j));
                    obj.dm_yields_switchgrass_5arcmin(i,j) = obj.dm_yields_switchgrass(idx_raw_to_5arcmin_lon(i), idx_raw_to_5arcmin_lat(j));
                    obj.dm_yields_willow_5arcmin(i,j) = obj.dm_yields_willow(idx_raw_to_5arcmin_lon(i), idx_raw_to_5arcmin_lat(j));
                    obj.dm_yields_poplar_5arcmin(i,j) = obj.dm_yields_poplar(idx_raw_to_5arcmin_lon(i), idx_raw_to_5arcmin_lat(j));
                    obj.dm_yields_eucalypt_5arcmin(i,j) = obj.dm_yields_eucalypt(idx_raw_to_5arcmin_lon(i), idx_raw_to_5arcmin_lat(j));
                end
            end
            
            
            
        end
        
        function obj = get_bioenergy_yields_5armcin(obj, Crop_type_array)
            c=1;
            
            best_pe_yields = zeros(4320,2160);
            obj.energy_optimal_crop_allocation_5arcmin = zeros(4320,2160);
            obj.pe_yields_energy_optimal_5arcmin = zeros(4320,2160);
            
            
            for i = 1:length(Crop_type_array)
               if strcmp(Crop_type_array(i).name, 'Miscanthus') 
                   obj.pe_yields_miscanthus_5arcmin = obj.dm_yields_miscanthus_5arcmin*Crop_type_array(i).calorificValue_weighted_MJperKgYieldModelOutput_lhv;
                   obj.crop_IDs_energy_optimal_crop_allocation(c) = Crop_type_array(i).ID;
                   obj.crop_names_energy_optimal_crop_allocation{c} = Crop_type_array(i).name;
                   
                   binary_yields_higher = obj.pe_yields_miscanthus_5arcmin > best_pe_yields;
                   obj.pe_yields_energy_optimal_5arcmin(binary_yields_higher) = obj.pe_yields_miscanthus_5arcmin(binary_yields_higher);
                   obj.energy_optimal_crop_allocation_5arcmin(binary_yields_higher) = Crop_type_array(i).ID;
                   c=c+1;
               elseif strcmp(Crop_type_array(i).name, 'Switchgrass') 
                   obj.pe_yields_switchgrass_5arcmin = obj.dm_yields_switchgrass_5arcmin*Crop_type_array(i).calorificValue_weighted_MJperKgYieldModelOutput_lhv;
                   
                   obj.crop_IDs_energy_optimal_crop_allocation(c) = Crop_type_array(i).ID;
                   obj.crop_names_energy_optimal_crop_allocation{c} = Crop_type_array(i).name;
                   
                   binary_yields_higher = obj.pe_yields_switchgrass_5arcmin > best_pe_yields;
                   obj.pe_yields_energy_optimal_5arcmin(binary_yields_higher) = obj.pe_yields_switchgrass_5arcmin(binary_yields_higher);
                   obj.energy_optimal_crop_allocation_5arcmin(binary_yields_higher) = Crop_type_array(i).ID;
                   c=c+1;
                   
               elseif strcmp(Crop_type_array(i).name, 'Willow') 
                   obj.pe_yields_willow_5arcmin = obj.dm_yields_willow_5arcmin*Crop_type_array(i).calorificValue_weighted_MJperKgYieldModelOutput_lhv;
                   
                   obj.crop_IDs_energy_optimal_crop_allocation(c) = Crop_type_array(i).ID;
                   obj.crop_names_energy_optimal_crop_allocation{c} = Crop_type_array(i).name;
                   
                   binary_yields_higher = obj.pe_yields_willow_5arcmin > best_pe_yields;
                   obj.pe_yields_energy_optimal_5arcmin(binary_yields_higher) = obj.pe_yields_willow_5arcmin(binary_yields_higher);
                   obj.energy_optimal_crop_allocation_5arcmin(binary_yields_higher) = Crop_type_array(i).ID;
                   c=c+1;
                   
               elseif strcmp(Crop_type_array(i).name, 'Poplar') 
                   obj.pe_yields_poplar_5arcmin = obj.dm_yields_poplar_5arcmin*Crop_type_array(i).calorificValue_weighted_MJperKgYieldModelOutput_lhv;
                                      
                   obj.crop_IDs_energy_optimal_crop_allocation(c) = Crop_type_array(i).ID;
                   obj.crop_names_energy_optimal_crop_allocation{c} = Crop_type_array(i).name;
                   
                   binary_yields_higher = obj.pe_yields_poplar_5arcmin > best_pe_yields;
                   obj.pe_yields_energy_optimal_5arcmin(binary_yields_higher) = obj.pe_yields_poplar_5arcmin(binary_yields_higher);
                   obj.energy_optimal_crop_allocation_5arcmin(binary_yields_higher) = Crop_type_array(i).ID;
                   c=c+1;
               elseif strcmp(Crop_type_array(i).name, 'Eucalypt') 
                   obj.pe_yields_eucalypt_5arcmin = obj.dm_yields_eucalypt_5arcmin*Crop_type_array(i).calorificValue_weighted_MJperKgYieldModelOutput_lhv;
                                      
                   obj.crop_IDs_energy_optimal_crop_allocation(c) = Crop_type_array(i).ID;
                   obj.crop_names_energy_optimal_crop_allocation{c} = Crop_type_array(i).name;
                   
                   binary_yields_higher = obj.pe_yields_eucalypt_5arcmin > best_pe_yields;
                   obj.pe_yields_energy_optimal_5arcmin(binary_yields_higher) = obj.pe_yields_eucalypt_5arcmin(binary_yields_higher);
                   obj.energy_optimal_crop_allocation_5arcmin(binary_yields_higher) = Crop_type_array(i).ID;
                   c=c+1;
               end
            end
            
            
        end
    end
    
end

