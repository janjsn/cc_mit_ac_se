function print_crop_allocation( obj, idx_rf_h)
%PRINT_CROP_ALLOCATION Summary of this function goes here
%   Detailed explanation goes here

productive_land_ac = obj.abandoned_cropland_hectare;
productive_land_cropland_se = obj.cropland_under_soil_erosion_mod_high_4bioenergy_hectare;
pe_ac = obj.Bioenergy_rf_h(idx_rf_h).pe_ac;
pe_cropland_se = obj.Bioenergy_rf_h(idx_rf_h).pe_cropland_se_wat_wind_4bioenergy;


productive_land_ac(pe_ac <= 0) = 0;
productive_land_cropland_se(pe_cropland_se <= 0) =0;

crop_ids = obj.Bioenergy_rf_h(idx_rf_h).crop_id_vector;

crop_allocation_ac = obj.Bioenergy_rf_h(idx_rf_h).crop_allocation_ac;
crop_allocation_cropland = obj.Bioenergy_rf_h(idx_rf_h).crop_allocation_cropland;

land_per_crop_ac = zeros(1,length(crop_ids));
land_per_crop_cropland_se = zeros(1,length(crop_ids));

for i = 1:length(crop_ids)
    land_per_crop_ac(i) = sum(sum(productive_land_ac(crop_allocation_ac == crop_ids(i))));
    land_per_crop_cropland_se(i) = sum(sum(productive_land_cropland_se(crop_allocation_cropland == crop_ids(i))));
end

productive_land_not_allocated_ac = sum(sum(productive_land_ac))-sum(sum(land_per_crop_ac))
productive_land_not_allocated_cropland_se = sum(sum(productive_land_cropland_se))-sum(sum(land_per_crop_cropland_se))

crop_ids
land_per_crop_ac
land_per_crop_cropland_se

sum(sum(land_per_crop_ac))
sum(sum(land_per_crop_cropland_se))
end

