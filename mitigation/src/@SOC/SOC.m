classdef SOC
    %SOC Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        lat
        lon
        years_of_new_luc
        soc_change_annual_crop_2_agroforestry
        soc_change_annual_crop_2_bioenergy_grass
        soc_change_annual_crop_2_food_and_bio_products
        soc_change_fallow_2_agroforestry
        soc_change_fallow_2_bioenergy_grass
        soc_change_fallow_2_food_and_bio_products
        soc_change_grassland_2_agroforestry
        soc_change_grassland_2_bioenergy_grass
        soc_change_grassland_2_food_and_bio_products
        soc_change_natural_forest_2_agroforestry
        soc_change_natural_forest_2_bioenergy_grass
        soc_change_natural_forest_2_food_and_bio_products
        
        soc_stock_change_annual_crop_2_agroforestry
        soc_stock_change_annual_crop_2_bioenergy_grass
        soc_stock_change_annual_crop_2_food_and_bio_products
        soc_stock_change_fallow_2_agroforestry
        soc_stock_change_fallow_2_bioenergy_grass
        soc_stock_change_fallow_2_food_and_bio_products
        soc_stock_change_grassland_2_agroforestry
        soc_stock_change_grassland_2_bioenergy_grass
        soc_stock_change_grassland_2_food_and_bio_products
        soc_stock_change_natural_forest_2_agroforestry
        soc_stock_change_natural_forest_2_bioenergy_grass
        soc_stock_change_natural_forest_2_food_and_bio_products
    end
    
    methods
        function obj = SOC(filename)
            
            obj.years_of_new_luc = 15;
            
            fieldnames = {'lat'
                'lon'
                'years_of_new_luc'
                'soc_change_annual_crop_2_agroforestry'
                'soc_change_annual_crop_2_bioenergy_grass'
                'soc_change_annual_crop_2_food_and_bio_products'
                'soc_change_fallow_2_agroforestry'
                'soc_change_fallow_2_bioenergy_grass'
                'soc_change_fallow_2_food_and_bio_products'
                'soc_change_grassland_2_agroforestry'
                'soc_change_grassland_2_bioenergy_grass'
                'soc_change_grassland_2_food_and_bio_products'
                'soc_change_natural_forest_2_agroforestry'
                'soc_change_natural_forest_2_bioenergy_grass'
                'soc_change_natural_forest_2_food_and_bio_products'
                'soc_stock_change_annual_crop_2_agroforestry'
                'soc_stock_change_annual_crop_2_bioenergy_grass'
                'soc_stock_change_annual_crop_2_food_and_bio_products'
                'soc_stock_change_fallow_2_agroforestry'
                'soc_stock_change_fallow_2_bioenergy_grass'
                'soc_stock_change_fallow_2_food_and_bio_products'
                'soc_stock_change_grassland_2_agroforestry'
                'soc_stock_change_grassland_2_bioenergy_grass'
                'soc_stock_change_grassland_2_food_and_bio_products'
                'soc_stock_change_natural_forest_2_agroforestry'
                'soc_stock_change_natural_forest_2_bioenergy_grass'
                'soc_stock_change_natural_forest_2_food_and_bio_products'};
            
            ncid = netcdf.open(filename);
            [ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
            
            for i = 0:nvars-1
               varname = netcdf.inqVar(ncid,i);
               for j = 1:length(fieldnames)
                  if strcmp(varname, fieldnames{j})
                     this_var = netcdf.getVar(ncid,i); 
                     mSize = size(this_var);
                     if length(mSize) == 2
                         this_var(this_var == -999) = 0;
                     end
                     obj.(fieldnames{j})= this_var;
                  end
               end
            end
            
            
        end
    end
    
end

