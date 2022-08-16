function obj = get_bioenergy_rf_h( obj, BiorefineryArray, Bioenergy_crops_array, GAEZ_array, Willow, Inputs, Wheat )
%GET_BIOENERGY_RF_H Summary of this function goes here
%   Detailed explanation goes here

GAEZ_array = GAEZ_array([GAEZ_array.year] == 2020 & [GAEZ_array.climate_scenario_ID] == 2 & [GAEZ_array.irrigation_is_assumed] == 0 & [GAEZ_array.agricultural_management_intensity] == 3);

n_gaez = length(GAEZ_array);

Bio_crop(1:n_gaez+1) = Rainfed_high;


n_crops = n_gaez+1; % + willow

ac_cropland_hectare = obj.cropland_hectare + obj.abandoned_cropland_hectare;
share_cropland = obj.cropland_hectare./ac_cropland_hectare;
share_ac = obj.abandoned_cropland_hectare./ac_cropland_hectare;
share_cropland(isnan(share_cropland)) = 0;
share_ac(isnan(share_ac)) = 0;
lat = GAEZ_array(1).lat;
lon = GAEZ_array(1).lon;

%% PERRENNIAL GRASSES
for crop = 1:n_gaez
    Bio_crop(crop).year_bioenergy = 2020;
    Bio_crop(crop).lat = GAEZ_array(crop).lat;
    Bio_crop(crop).lon = GAEZ_array(crop).lon;
    Bio_crop(crop).crop_id_vector = GAEZ_array(crop).crop_ID;
    Bio_crop(crop).crop_names = GAEZ_array(crop).crop_name;
    Bio_crop(crop).is_carbon_optimization = 0;
    Bio_crop(crop).is_energy_optimization = 0;
    Bio_crop(crop).is_single_crop = 1;
    Bio_crop(crop).crop_allocation_ac = obj.abandoned_cropland_hectare;
    Bio_crop(crop).crop_allocation_ac(Bio_crop(crop).crop_allocation_ac > 0) = GAEZ_array(crop).crop_ID;
    Bio_crop(crop).crop_allocation_cropland = obj.cropland_hectare;
    Bio_crop(crop).crop_allocation_cropland(Bio_crop(crop).crop_allocation_cropland > 0) = GAEZ_array(crop).crop_ID;
    
    Bio_crop(crop).dm_yield = GAEZ_array(crop).dm_yield;
    Bio_crop(crop).dm_yield(obj.abandoned_cropland_hectare == 0 & obj.cropland_hectare == 0) = 0;
    
    Bio_crop(crop).dm_yield_ac = GAEZ_array(crop).dm_yield;
    Bio_crop(crop).dm_yield_ac(obj.abandoned_cropland_hectare == 0) = 0;
    Bio_crop(crop).dm_yield_cropland = GAEZ_array(crop).dm_yield;
    Bio_crop(crop).dm_yield_ac(obj.cropland_hectare == 0) = 0;
    
    This_crop = Bioenergy_crops_array([Bioenergy_crops_array.ID] == Bio_crop(crop).crop_id_vector);
    Bio_crop(crop).carbon_yield = Bio_crop(crop).dm_yield*This_crop.carbon_content_of_dry_mass;
    Bio_crop(crop).carbon_yield_ac = Bio_crop(crop).dm_yield_ac*This_crop.carbon_content_of_dry_mass;
    Bio_crop(crop).carbon_yield_cropland = Bio_crop(crop).dm_yield_cropland*This_crop.carbon_content_of_dry_mass;
    Bio_crop(crop).bioenergy_yield = Bio_crop(crop).dm_yield*This_crop.calorificValue_weighted_MJperKgYieldModelOutput_lhv;
    Bio_crop(crop).bioenergy_yield_ac = Bio_crop(crop).dm_yield_ac*This_crop.calorificValue_weighted_MJperKgYieldModelOutput_lhv;
    Bio_crop(crop).bioenergy_yield_cropland = Bio_crop(crop).dm_yield_cropland*This_crop.calorificValue_weighted_MJperKgYieldModelOutput_lhv;
    
    
    
end

%% WILLOW
Bio_crop(n_crops).year_bioenergy = 2020;
Bio_crop(n_crops).lat = Willow.lat;
Bio_crop(n_crops).lon = Willow.lon;
Bio_crop(n_crops).crop_id_vector = Willow.crop_ID;
Bio_crop(n_crops).crop_names = 'Willow';
Bio_crop(n_crops).is_carbon_optimization = 0;
Bio_crop(n_crops).is_energy_optimization = 0;
Bio_crop(n_crops).is_single_crop = 1;
Bio_crop(n_crops).crop_allocation_ac = obj.abandoned_cropland_hectare;
Bio_crop(n_crops).crop_allocation_ac(Bio_crop(n_crops).crop_allocation_ac > 0) = Willow.crop_ID;
Bio_crop(n_crops).crop_allocation_cropland = obj.cropland_hectare;
Bio_crop(n_crops).crop_allocation_cropland(Bio_crop(n_crops).crop_allocation_cropland > 0) = Willow.crop_ID;
Bio_crop(n_crops).dm_yield = Willow.dm_yield_ac_cropland;
Bio_crop(n_crops).dm_yield_ac = Willow.dm_yield_ac;
Bio_crop(n_crops).dm_yield_cropland = Willow.dm_yield_cropland;

% REMOVE negatives
Bio_crop(n_crops).dm_yield(Bio_crop(n_crops).dm_yield  < 0) = 0;
Bio_crop(n_crops).dm_yield_ac(Bio_crop(n_crops).dm_yield_ac  < 0) = 0;
Bio_crop(n_crops).dm_yield_cropland(Bio_crop(n_crops).dm_yield_cropland  < 0) = 0;

This_crop = Bioenergy_crops_array([Bioenergy_crops_array.ID] == Bio_crop(n_crops).crop_id_vector);
Bio_crop(n_crops).carbon_yield = Bio_crop(n_crops).dm_yield*This_crop.carbon_content_of_dry_mass;
Bio_crop(n_crops).carbon_yield_ac = Bio_crop(n_crops).dm_yield_ac*This_crop.carbon_content_of_dry_mass;
Bio_crop(n_crops).carbon_yield_cropland = Bio_crop(n_crops).dm_yield_cropland*This_crop.carbon_content_of_dry_mass;
Bio_crop(n_crops).bioenergy_yield = Bio_crop(n_crops).dm_yield*This_crop.calorificValue_weighted_MJperKgYieldModelOutput_lhv;
Bio_crop(n_crops).bioenergy_yield_ac = Bio_crop(n_crops).dm_yield_ac*This_crop.calorificValue_weighted_MJperKgYieldModelOutput_lhv;
Bio_crop(n_crops).bioenergy_yield_cropland = Bio_crop(n_crops).dm_yield_cropland*This_crop.calorificValue_weighted_MJperKgYieldModelOutput_lhv;
Bio_crop(n_crops).bioenergy_yield(obj.cropland_hectare == 0 & obj.abandoned_cropland_hectare == 0) = 0;

%% Carbon optimization
Bio_carbon = Rainfed_high;
Bio_carbon.lat = Bio_crop(1).lat;
Bio_carbon.lon = Bio_crop(1).lon;
Bio_carbon.year_bioenergy = 2020;
Bio_carbon.is_carbon_optimization = 1;
Bio_carbon.is_energy_optimization = 0;
Bio_carbon.is_single_crop = 0;
Bio_carbon.crop_allocation_ac = zeros(length(lon), length(lat));
Bio_carbon.crop_allocation_cropland = zeros(length(lon), length(lat));
Bio_carbon.dm_yield = zeros(length(lon), length(lat));
Bio_carbon.carbon_yield = zeros(length(lon), length(lat));
Bio_carbon.bioenergy_yield = zeros(length(lon), length(lat));
Bio_carbon.dm_yield_ac = zeros(length(lon), length(lat));
Bio_carbon.carbon_yield_ac = zeros(length(lon), length(lat));
Bio_carbon.bioenergy_yield_ac = zeros(length(lon), length(lat));
Bio_carbon.dm_yield_cropland = zeros(length(lon), length(lat));
Bio_carbon.carbon_yield_cropland = zeros(length(lon), length(lat));
Bio_carbon.bioenergy_yield_cropland = zeros(length(lon), length(lat));
Bio_carbon.crop_id_vector = zeros(1,n_crops);

% GET YIELDS FROM BEST CROPS
for crop = 1:n_crops
    this_ID = Bio_crop(crop).crop_id_vector;
    Bio_carbon.crop_id_vector(crop) = this_ID;
    
    binary_carbon_yields_higher_ac = Bio_crop(crop).carbon_yield_ac > Bio_carbon.carbon_yield_ac;
    Bio_carbon.crop_allocation_ac(binary_carbon_yields_higher_ac) = this_ID;
    Bio_carbon.dm_yield_ac(binary_carbon_yields_higher_ac) = Bio_crop(crop).dm_yield_ac(binary_carbon_yields_higher_ac);
    Bio_carbon.bioenergy_yield_ac(binary_carbon_yields_higher_ac) = Bio_crop(crop).bioenergy_yield_ac(binary_carbon_yields_higher_ac);
    Bio_carbon.carbon_yield_ac(binary_carbon_yields_higher_ac) = Bio_crop(crop).carbon_yield_ac(binary_carbon_yields_higher_ac);
    
    binary_carbon_yields_higher_cropland = Bio_crop(crop).carbon_yield_cropland > Bio_carbon.carbon_yield_cropland;
    Bio_carbon.crop_allocation_cropland(binary_carbon_yields_higher_cropland) = this_ID;
    Bio_carbon.dm_yield_cropland(binary_carbon_yields_higher_cropland) = Bio_crop(crop).dm_yield_cropland(binary_carbon_yields_higher_cropland);
    Bio_carbon.bioenergy_yield_cropland(binary_carbon_yields_higher_cropland) = Bio_crop(crop).bioenergy_yield_cropland(binary_carbon_yields_higher_cropland);
    Bio_carbon.carbon_yield_cropland(binary_carbon_yields_higher_cropland) = Bio_crop(crop).carbon_yield_cropland(binary_carbon_yields_higher_cropland);
    
end

Bio_carbon.dm_yield = Bio_carbon.dm_yield_ac.*share_ac + Bio_carbon.dm_yield_cropland.*share_cropland;
Bio_carbon.bioenergy_yield = Bio_carbon.bioenergy_yield_ac.*share_ac + Bio_carbon.bioenergy_yield_cropland.*share_cropland;
Bio_carbon.carbon_yield = Bio_carbon.carbon_yield_ac.*share_ac + Bio_carbon.carbon_yield_cropland.*share_cropland;

Bio_carbon.crop_allocation_cropland(obj.cropland_hectare == 0) = 0;


%% Bioenergy optimization
Bio_energy = Rainfed_high;
Bio_energy.lat = Bio_crop(1).lat;
Bio_energy.lon = Bio_crop(1).lon;
Bio_energy.year_bioenergy = 2020;
Bio_energy.is_carbon_optimization = 0;
Bio_energy.is_energy_optimization = 1;
Bio_energy.is_single_crop = 0;
Bio_energy.crop_allocation_ac = zeros(length(lon), length(lat));
Bio_energy.crop_allocation_cropland = zeros(length(lon), length(lat));
Bio_energy.dm_yield = zeros(length(lon), length(lat));
Bio_energy.carbon_yield = zeros(length(lon), length(lat));
Bio_energy.bioenergy_yield = zeros(length(lon), length(lat));
Bio_energy.dm_yield_ac = zeros(length(lon), length(lat));
Bio_energy.carbon_yield_ac = zeros(length(lon), length(lat));
Bio_energy.bioenergy_yield_ac = zeros(length(lon), length(lat));
Bio_energy.dm_yield_cropland = zeros(length(lon), length(lat));
Bio_energy.carbon_yield_cropland = zeros(length(lon), length(lat));
Bio_energy.bioenergy_yield_cropland = zeros(length(lon), length(lat));
Bio_energy.crop_id_vector = zeros(1,n_crops);

% GET YIELDS FROM BEST CROPS
for crop = 1:n_crops
    this_ID = Bio_crop(crop).crop_id_vector;
    Bio_energy.crop_id_vector(crop) = this_ID;
    
    binary_bioenergy_yields_higher_ac = Bio_crop(crop).bioenergy_yield_ac > Bio_energy.bioenergy_yield_ac;
    Bio_energy.crop_allocation_ac(binary_bioenergy_yields_higher_ac) = this_ID;
    Bio_energy.dm_yield_ac(binary_bioenergy_yields_higher_ac) = Bio_crop(crop).dm_yield_ac(binary_bioenergy_yields_higher_ac);
    Bio_energy.bioenergy_yield_ac(binary_bioenergy_yields_higher_ac) = Bio_crop(crop).bioenergy_yield_ac(binary_bioenergy_yields_higher_ac);
    Bio_energy.carbon_yield_ac(binary_bioenergy_yields_higher_ac) = Bio_crop(crop).carbon_yield_ac(binary_bioenergy_yields_higher_ac);
    
    binary_bioenergy_yields_higher_cropland = Bio_crop(crop).bioenergy_yield_cropland > Bio_energy.bioenergy_yield_cropland;
    Bio_energy.crop_allocation_cropland(binary_bioenergy_yields_higher_cropland) = this_ID;
    Bio_energy.dm_yield_cropland(binary_bioenergy_yields_higher_cropland) = Bio_crop(crop).dm_yield_cropland(binary_bioenergy_yields_higher_cropland);
    Bio_energy.bioenergy_yield_cropland(binary_bioenergy_yields_higher_cropland) = Bio_crop(crop).bioenergy_yield_cropland(binary_bioenergy_yields_higher_cropland);
    Bio_energy.carbon_yield_cropland(binary_bioenergy_yields_higher_cropland) = Bio_crop(crop).carbon_yield_cropland(binary_bioenergy_yields_higher_cropland);
    Bio_energy.carbon_yield_cropland(obj.cropland_hectare == 0) = 0;
end

Bio_energy.dm_yield = Bio_energy.dm_yield_ac.*share_ac + Bio_energy.dm_yield_cropland.*share_cropland;
Bio_energy.bioenergy_yield = Bio_energy.bioenergy_yield_ac.*share_ac + Bio_energy.bioenergy_yield_cropland.*share_cropland;
Bio_energy.carbon_yield = Bio_energy.carbon_yield_ac.*share_ac + Bio_energy.carbon_yield_cropland.*share_cropland;

Bio_energy.crop_allocation_cropland(obj.cropland_hectare == 0) = 0;

%% Bioenergy wind breaks scenario
Bio_wb = Bio_energy; %Start from this one.
Bio_wb.is_wb_scenario = 1;
Bio_wb.is_energy_optimization = 0;

%Check if abandoned cropland under wind erosion pressure dominates cell, or
%not. If yes, set Willow to dominant crop.
Bio_wb.crop_allocation_ac((obj.abandoned_cropland_ilswe_4_hectare + obj.abandoned_cropland_ilswe_5_hectare) > (obj.abandoned_cropland_hectare./2)) = Willow.crop_ID;
%Bio_wb.crop_allocation_ac(obj.abandoned_cropland_ilswe_5_hectare > 0) = Willow.crop_ID;

%Set willow to dominant crop where wind erosion is an issue
cropland_ilswe_ha = obj.cropland_ilswe_4_hectare +obj.cropland_ilswe_5_hectare;
cropland_se5_ha = obj.cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare;

binary_more_ilswe = cropland_ilswe_ha > cropland_se5_ha;

Bio_wb.crop_allocation_cropland(binary_more_ilswe) = Willow.crop_ID;
Bio_wb.crop_allocation_cropland(binary_more_ilswe) = Willow.crop_ID;

share_ac_willow = (obj.abandoned_cropland_ilswe_4_hectare+obj.abandoned_cropland_ilswe_5_hectare)./obj.abandoned_cropland_hectare;
share_ac_willow(isnan(share_ac_willow)) = 0;

Bio_wb.dm_yield(Bio_wb.crop_allocation_ac == Willow.crop_ID | Bio_wb.crop_allocation_cropland == Willow.crop_ID) = Bio_crop(n_crops).dm_yield(Bio_wb.crop_allocation_ac == Willow.crop_ID | Bio_wb.crop_allocation_cropland == Willow.crop_ID);

Bio_wb.dm_yield_ac = Bio_wb.dm_yield_ac.*(1-share_ac_willow)+Bio_crop(n_crops).dm_yield_ac.*share_ac_willow;
%(Bio_wb.crop_allocation_ac == Willow.crop_ID) = Bio_crop(n_crops).dm_yield_ac(Bio_wb.crop_allocation_ac == Willow.crop_ID);
Bio_wb.dm_yield_cropland(Bio_wb.crop_allocation_cropland == Willow.crop_ID) = Bio_crop(n_crops).dm_yield_cropland(Bio_wb.crop_allocation_cropland == Willow.crop_ID);

Bio_wb.bioenergy_yield(Bio_wb.crop_allocation_ac == Willow.crop_ID | Bio_wb.crop_allocation_cropland == Willow.crop_ID) = Bio_crop(n_crops).bioenergy_yield(Bio_wb.crop_allocation_ac == Willow.crop_ID | Bio_wb.crop_allocation_cropland == Willow.crop_ID);
Bio_wb.bioenergy_yield_ac = Bio_wb.bioenergy_yield_ac.*(1-share_ac_willow)+Bio_crop(n_crops).bioenergy_yield_ac.*share_ac_willow; %% HERE
%Bio_wb.bioenergy_yield_ac(Bio_wb.crop_allocation_ac == Willow.crop_ID) = Bio_crop(n_crops).bioenergy_yield_ac(Bio_wb.crop_allocation_ac == Willow.crop_ID);
Bio_wb.bioenergy_yield_cropland(Bio_wb.crop_allocation_cropland == Willow.crop_ID) = Bio_crop(n_crops).bioenergy_yield_cropland(Bio_wb.crop_allocation_cropland == Willow.crop_ID);

Bio_wb.carbon_yield(Bio_wb.crop_allocation_ac == Willow.crop_ID | Bio_wb.crop_allocation_cropland == Willow.crop_ID) = Bio_crop(n_crops).carbon_yield(Bio_wb.crop_allocation_ac == Willow.crop_ID | Bio_wb.crop_allocation_cropland == Willow.crop_ID);
%Bio_wb.carbon_yield_ac(Bio_wb.crop_allocation_ac == Willow.crop_ID) = Bio_crop(n_crops).carbon_yield_ac(Bio_wb.crop_allocation_ac == Willow.crop_ID);
Bio_wb.carbon_yield_ac = Bio_wb.carbon_yield_ac.*(1-share_ac_willow)+Bio_crop(n_crops).carbon_yield_ac.*share_ac_willow; %% HERE
Bio_wb.carbon_yield_cropland(Bio_wb.crop_allocation_cropland == Willow.crop_ID) = Bio_crop(n_crops).carbon_yield_cropland(Bio_wb.crop_allocation_cropland == Willow.crop_ID);

Bio_wb.crop_allocation_cropland(obj.cropland_hectare == 0) = 0;

%Crop allocations, hectares
Bio_wb.crop_allocation_vec_ac_ha = zeros(1,length(Bio_wb.crop_id_vector));
Bio_wb.crop_allocation_vec_cropland_se_ha = zeros(1,length(Bio_wb.crop_id_vector));
Bio_wb.crop_allocation_vec_cropland_ac_se_ha = zeros(1,length(Bio_wb.crop_id_vector));

ac_no_ilswe = obj.abandoned_cropland_hectare-(obj.abandoned_cropland_ilswe_4_hectare + obj.abandoned_cropland_ilswe_5_hectare);
cropland_no_ilswe = obj.cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare - (obj.cropland_both_ilswe_4_5_se_5);

for ids = 1:length(Bio_wb.crop_id_vector)
    
    if Bio_wb.crop_id_vector(ids) == Willow.crop_ID
        %AC
        Bio_wb.crop_allocation_vec_ac_ha(ids) = sum(sum(obj.abandoned_cropland_ilswe_4_hectare + obj.abandoned_cropland_ilswe_5_hectare));
        Bio_wb.crop_allocation_vec_ac_ha(ids) = Bio_wb.crop_allocation_vec_ac_ha(ids)  + sum(sum(ac_no_ilswe(Bio_energy.crop_allocation_ac == Willow.crop_ID)));
        %Cropland
        Bio_wb.crop_allocation_vec_cropland_se_ha(ids) = sum(sum(obj.cropland_ilswe_4_hectare + obj.cropland_ilswe_5_hectare))*Inputs.share_of_cropland_under_wind_erosion_for_bioenergy;
        sum(sum(Bio_wb.crop_allocation_vec_cropland_se_ha(ids)))
        Bio_wb.crop_allocation_vec_cropland_se_ha(ids) = Bio_wb.crop_allocation_vec_cropland_se_ha(ids) + sum(sum(cropland_no_ilswe(Bio_energy.crop_allocation_cropland == Willow.crop_ID)));
        
    else
        Bio_wb.crop_allocation_vec_ac_ha(ids) = sum(sum(ac_no_ilswe(Bio_wb.crop_allocation_ac == Bio_wb.crop_id_vector(ids))));
        Bio_wb.crop_allocation_vec_cropland_se_ha(ids) = sum(sum(cropland_no_ilswe(Bio_energy.crop_allocation_cropland ==  Bio_wb.crop_id_vector(ids))));
    end
end

Bio_wb.crop_allocation_vec_cropland_ac_se_ha = Bio_wb.crop_allocation_vec_ac_ha + Bio_wb.crop_allocation_vec_cropland_se_ha;


%% MERGE
Bioenergy_array(n_crops+2) = Rainfed_high;
Bioenergy_array(1:n_crops) = Bio_crop;
Bioenergy_array(n_crops+1) = Bio_energy;
Bioenergy_array(n_crops+2) = Bio_carbon;
Bioenergy_array(n_crops+3) = Bio_wb;

clear('temp_array', 'Bio_energy', 'Bio_carbon', 'Bio_crop');

%% Calculate potentials
for i = 1:length(Bioenergy_array)
    % DM
    Bioenergy_array(i).dm_ac = obj.abandoned_cropland_hectare.*Bioenergy_array(i).dm_yield_ac;
    Bioenergy_array(i).dm_cropland = obj.cropland_hectare.*Bioenergy_array(i).dm_yield_cropland;
    Bioenergy_array(i).dm_cropland_se5 = obj.cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare.*Bioenergy_array(i).dm_yield_cropland;
    Bioenergy_array(i).dm_cropland_se10 = obj.cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare.*Bioenergy_array(i).dm_yield_cropland;
    Bioenergy_array(i).dm_cropland_ilswe_1 = obj.cropland_ilswe_1_hectare.*Bioenergy_array(i).dm_yield_cropland;
    Bioenergy_array(i).dm_cropland_ilswe_2 = obj.cropland_ilswe_2_hectare.*Bioenergy_array(i).dm_yield_cropland;
    Bioenergy_array(i).dm_cropland_ilswe_3 = obj.cropland_ilswe_3_hectare.*Bioenergy_array(i).dm_yield_cropland;
    Bioenergy_array(i).dm_cropland_ilswe_4 = obj.cropland_ilswe_4_hectare.*Bioenergy_array(i).dm_yield_cropland;
    Bioenergy_array(i).dm_cropland_ilswe_5 = obj.cropland_ilswe_5_hectare.*Bioenergy_array(i).dm_yield_cropland;
    Bioenergy_array(i).dm_cropland_flood = obj.cropland_floods_hectare.*Bioenergy_array(i).dm_yield_cropland;
    
    Bioenergy_array(i).dm_ac_tot = sum(sum(Bioenergy_array(i).dm_ac));
    Bioenergy_array(i).dm_cropland_tot = sum(sum(Bioenergy_array(i).dm_cropland));
    Bioenergy_array(i).dm_cropland_se5_tot = sum(sum(Bioenergy_array(i).dm_cropland_se5));
    Bioenergy_array(i).dm_cropland_se10_tot = sum(sum(Bioenergy_array(i).dm_cropland_se10));
    Bioenergy_array(i).dm_cropland_ilswe_1_tot = sum(sum(Bioenergy_array(i).dm_cropland_ilswe_1));
    Bioenergy_array(i).dm_cropland_ilswe_2_tot = sum(sum(Bioenergy_array(i).dm_cropland_ilswe_2));
    Bioenergy_array(i).dm_cropland_ilswe_3_tot = sum(sum(Bioenergy_array(i).dm_cropland_ilswe_3));
    Bioenergy_array(i).dm_cropland_ilswe_4_tot = sum(sum(Bioenergy_array(i).dm_cropland_ilswe_4));
    Bioenergy_array(i).dm_cropland_ilswe_5_tot = sum(sum(Bioenergy_array(i).dm_cropland_ilswe_5));
    Bioenergy_array(i).dm_cropland_flood_tot = sum(sum(Bioenergy_array(i).dm_cropland_flood));
    
    %Carbon
    Bioenergy_array(i).carbon_ac = obj.abandoned_cropland_hectare.*Bioenergy_array(i).carbon_yield_ac;
    Bioenergy_array(i).carbon_cropland = obj.cropland_hectare.*Bioenergy_array(i).carbon_yield_cropland;
    Bioenergy_array(i).carbon_cropland_se5 = obj.cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare.*Bioenergy_array(i).carbon_yield_cropland;
    Bioenergy_array(i).carbon_cropland_se10 = obj.cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare.*Bioenergy_array(i).carbon_yield_cropland;
    Bioenergy_array(i).carbon_cropland_ilswe_1 = obj.cropland_ilswe_1_hectare.*Bioenergy_array(i).carbon_yield_cropland;
    Bioenergy_array(i).carbon_cropland_ilswe_2 = obj.cropland_ilswe_2_hectare.*Bioenergy_array(i).carbon_yield_cropland;
    Bioenergy_array(i).carbon_cropland_ilswe_3 = obj.cropland_ilswe_3_hectare.*Bioenergy_array(i).carbon_yield_cropland;
    Bioenergy_array(i).carbon_cropland_ilswe_4 = obj.cropland_ilswe_4_hectare.*Bioenergy_array(i).carbon_yield_cropland;
    Bioenergy_array(i).carbon_cropland_ilswe_5 = obj.cropland_ilswe_5_hectare.*Bioenergy_array(i).carbon_yield_cropland;
    Bioenergy_array(i).carbon_cropland_flood = obj.cropland_floods_hectare.*Bioenergy_array(i).carbon_yield_cropland;
    
    Bioenergy_array(i).carbon_ac_tot = sum(sum(Bioenergy_array(i).carbon_ac));
    Bioenergy_array(i).carbon_cropland_tot = sum(sum(Bioenergy_array(i).carbon_cropland));
    Bioenergy_array(i).carbon_cropland_se5_tot = sum(sum(Bioenergy_array(i).carbon_cropland_se5));
    Bioenergy_array(i).carbon_cropland_se10_tot = sum(sum(Bioenergy_array(i).carbon_cropland_se10));
    Bioenergy_array(i).carbon_cropland_ilswe_1_tot = sum(sum(Bioenergy_array(i).carbon_cropland_ilswe_1));
    Bioenergy_array(i).carbon_cropland_ilswe_2_tot = sum(sum(Bioenergy_array(i).carbon_cropland_ilswe_2));
    Bioenergy_array(i).carbon_cropland_ilswe_3_tot = sum(sum(Bioenergy_array(i).carbon_cropland_ilswe_3));
    Bioenergy_array(i).carbon_cropland_ilswe_4_tot = sum(sum(Bioenergy_array(i).carbon_cropland_ilswe_4));
    Bioenergy_array(i).carbon_cropland_ilswe_5_tot = sum(sum(Bioenergy_array(i).carbon_cropland_ilswe_5));
    Bioenergy_array(i).carbon_cropland_flood_tot = sum(sum(Bioenergy_array(i).carbon_cropland_flood));
    
    Bioenergy_array(i).carbon_cropland_both_se5_and_ilswe_4_5_tot = sum(sum(obj.cropland_both_ilswe_4_5_se_5.*Bioenergy_array(i).carbon_yield_cropland));
    Bioenergy_array(i).carbon_cropland_se_mod_high_4bioenergy_tot = sum(sum(obj.cropland_under_soil_erosion_mod_high_4bioenergy_hectare.*Bioenergy_array(i).carbon_yield_cropland));
    
    %Bioenergy
    Bioenergy_array(i).pe_ac = obj.abandoned_cropland_hectare.*Bioenergy_array(i).bioenergy_yield_ac;
    Bioenergy_array(i).pe_cropland = obj.cropland_hectare.*Bioenergy_array(i).bioenergy_yield_cropland;
    Bioenergy_array(i).pe_cropland_se5 = obj.cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare.*Bioenergy_array(i).bioenergy_yield_cropland;
    Bioenergy_array(i).pe_cropland_se10 = obj.cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare.*Bioenergy_array(i).bioenergy_yield_cropland;
    Bioenergy_array(i).pe_cropland_ilswe_1 = obj.cropland_ilswe_1_hectare.*Bioenergy_array(i).bioenergy_yield_cropland;
    Bioenergy_array(i).pe_cropland_ilswe_2 = obj.cropland_ilswe_2_hectare.*Bioenergy_array(i).bioenergy_yield_cropland;
    Bioenergy_array(i).pe_cropland_ilswe_3 = obj.cropland_ilswe_3_hectare.*Bioenergy_array(i).bioenergy_yield_cropland;
    Bioenergy_array(i).pe_cropland_ilswe_4 = obj.cropland_ilswe_4_hectare.*Bioenergy_array(i).bioenergy_yield_cropland;
    Bioenergy_array(i).pe_cropland_ilswe_5 = obj.cropland_ilswe_5_hectare.*Bioenergy_array(i).bioenergy_yield_cropland;
    Bioenergy_array(i).pe_cropland_flood = obj.cropland_floods_hectare.*Bioenergy_array(i).bioenergy_yield_cropland;
    Bioenergy_array(i).pe_cropland_both_se5_and_ilswe_4_5 = obj.cropland_both_ilswe_4_5_se_5.*Bioenergy_array(i).bioenergy_yield_cropland;
    
    Bioenergy_array(i).pe_ac_tot = sum(sum(Bioenergy_array(i).pe_ac));
    Bioenergy_array(i).pe_cropland_tot = sum(sum(Bioenergy_array(i).pe_cropland));
    Bioenergy_array(i).pe_cropland_se5_tot = sum(sum(Bioenergy_array(i).pe_cropland_se5));
    Bioenergy_array(i).pe_cropland_se10_tot = sum(sum(Bioenergy_array(i).pe_cropland_se10));
    Bioenergy_array(i).pe_cropland_ilswe_1_tot = sum(sum(Bioenergy_array(i).pe_cropland_ilswe_1));
    Bioenergy_array(i).pe_cropland_ilswe_2_tot = sum(sum(Bioenergy_array(i).pe_cropland_ilswe_2));
    Bioenergy_array(i).pe_cropland_ilswe_3_tot = sum(sum(Bioenergy_array(i).pe_cropland_ilswe_3));
    Bioenergy_array(i).pe_cropland_ilswe_4_tot = sum(sum(Bioenergy_array(i).pe_cropland_ilswe_4));
    Bioenergy_array(i).pe_cropland_ilswe_5_tot = sum(sum(Bioenergy_array(i).pe_cropland_ilswe_5));
    Bioenergy_array(i).pe_cropland_flood_tot = sum(sum(Bioenergy_array(i).pe_cropland_flood));
    Bioenergy_array(i).pe_cropland_both_se5_and_ilswe_4_5_tot = sum(sum(Bioenergy_array(i).pe_cropland_both_se5_and_ilswe_4_5));
    
    %Calculate GHG footprint farm to biorefinery gate, Field et al.
    Bioenergy_array(i).ghg_footprint_farm2biorefgate_FIELD_et_al = 350.38*(Bioenergy_array(i).dm_yield.^-0.63);
    Bioenergy_array(i).ghg_footprint_farm2biorefgate_FIELD_et_al_ac = 350.38*(Bioenergy_array(i).dm_yield_ac.^-0.63);
    Bioenergy_array(i).ghg_footprint_farm2biorefgate_FIELD_et_al_cropland = 350.38*(Bioenergy_array(i).dm_yield_cropland.^-0.63);
    
    %Calculate primary energy potential from aboveground carbon clearing
    Bioenergy_array(i).pe_aboveground_carbon_clearing = obj.pe_aboveground_carbon_on_abandoned_cropland;
    Bioenergy_array(i).carbon_aboveground_carbon_clearing = obj.aboveground_carbon_on_abandoned_cropland_ton_C;
    Bioenergy_array(i).pe_aboveground_carbon_clearing(Bioenergy_array(i).pe_ac <= 0) = 0;
    Bioenergy_array(i).carbon_aboveground_carbon_clearing(Bioenergy_array(i).pe_ac <= 0) = 0;
    
    
    %Productive area
    Bioenergy_array(i).productive_land_ac_tot = sum(sum(obj.abandoned_cropland_hectare(Bioenergy_array(i).dm_yield_ac > 0)));
    Bioenergy_array(i).productive_land_cropland_tot = sum(sum(obj.cropland_hectare(Bioenergy_array(i).dm_yield_cropland > 0)));
    Bioenergy_array(i).productive_land_cropland_se5_tot = sum(sum(obj.cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare(Bioenergy_array(i).dm_yield_cropland > 0)));
    Bioenergy_array(i).productive_land_cropland_se10_tot = sum(sum(obj.cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare(Bioenergy_array(i).dm_yield_cropland > 0)));
    Bioenergy_array(i).productive_land_cropland_se5_to_10_tot = sum(sum(obj.cropland_both_ilswe_4_5_se_5(Bioenergy_array(i).dm_yield_cropland > 0)));
    Bioenergy_array(i).productive_land_cropland_ilswe_1_tot = sum(sum(obj.cropland_ilswe_1_hectare(Bioenergy_array(i).dm_yield_cropland > 0)));
    Bioenergy_array(i).productive_land_cropland_ilswe_2_tot = sum(sum(obj.cropland_ilswe_2_hectare(Bioenergy_array(i).dm_yield_cropland > 0)));
    Bioenergy_array(i).productive_land_cropland_ilswe_3_tot = sum(sum(obj.cropland_ilswe_3_hectare(Bioenergy_array(i).dm_yield_cropland > 0)));
    Bioenergy_array(i).productive_land_cropland_ilswe_4_tot = sum(sum(obj.cropland_ilswe_4_hectare(Bioenergy_array(i).dm_yield_cropland > 0)));
    Bioenergy_array(i).productive_land_cropland_ilswe_5_tot = sum(sum(obj.cropland_ilswe_5_hectare(Bioenergy_array(i).dm_yield_cropland > 0)));
    Bioenergy_array(i).productive_land_cropland_both_ilswe_4_5_se_5 = sum(sum(obj.cropland_both_ilswe_4_5_se_5(Bioenergy_array(i).dm_yield_cropland > 0)));
    Bioenergy_array(i).productive_land_cropland_flood_tot = sum(sum(obj.cropland_floods_hectare(Bioenergy_array(i).dm_yield_cropland > 0)));
    
    %Primary energy on all available land
    Bioenergy_array(i).pe_cropland_se_wat_wind_4bioenergy = Bioenergy_array(i).pe_cropland_se5 + Inputs.share_of_cropland_under_wind_erosion_for_bioenergy*(Bioenergy_array(i).pe_cropland_ilswe_4 +Bioenergy_array(i).pe_cropland_ilswe_5 -Bioenergy_array(i).pe_cropland_both_se5_and_ilswe_4_5);
    Bioenergy_array(i).pe_ac_cropland_se_wat_wind_4bioenergy = Bioenergy_array(i).pe_cropland_se_wat_wind_4bioenergy + Bioenergy_array(i).pe_ac;
    
    %Mean pe yields
    Bioenergy_array(i).pe_yield_mean_ac = sum(sum(Bioenergy_array(i).pe_ac))/sum(sum(obj.abandoned_cropland_hectare(Bioenergy_array(i).pe_ac > 0)));
    Bioenergy_array(i).pe_yield_mean_cropland_se_wind_wat = sum(sum(Bioenergy_array(i).pe_cropland_se_wat_wind_4bioenergy))/sum(sum(obj.cropland_under_soil_erosion_mod_high_4bioenergy_hectare(Bioenergy_array(i).pe_cropland_se_wat_wind_4bioenergy > 0)));
    binary = Bioenergy_array(i).pe_ac_cropland_se_wat_wind_4bioenergy > 0;
    Bioenergy_array(i).pe_yield_mean_ac_cropland_se_wind_wat = sum(sum(Bioenergy_array(i).pe_ac_cropland_se_wat_wind_4bioenergy))/sum(sum(obj.cropland_under_soil_erosion_mod_high_4bioenergy_hectare(binary)+obj.abandoned_cropland_hectare(binary)));
    Bioenergy_array(i).productive_land_ac_cropland_se_wind_wat_tot = sum(sum(obj.cropland_under_soil_erosion_mod_high_4bioenergy_hectare(binary)));
    
    Bioenergy_array(i).pe_yield_ac_mean = Bioenergy_array(i).pe_yield_mean_ac;
    Bioenergy_array(i).pe_yield_cropland_se5_mean = sum(sum(Bioenergy_array(i).pe_cropland_se5))/sum(sum(obj.cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare(Bioenergy_array(i).pe_cropland_se5 > 0)));
    Bioenergy_array(i).pe_yield_cropland_se10_mean = sum(sum(Bioenergy_array(i).pe_cropland_se10))/sum(sum(obj.cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare(Bioenergy_array(i).pe_cropland_se10 > 0)));
    Bioenergy_array(i).pe_yield_cropland_ilswe4_mean = sum(sum(Bioenergy_array(i).pe_cropland_ilswe_4))/sum(sum(obj.cropland_ilswe_4_hectare(Bioenergy_array(i).pe_cropland_ilswe_4 > 0)));
    Bioenergy_array(i).pe_yield_cropland_ilswe5_mean = sum(sum(Bioenergy_array(i).pe_cropland_ilswe_5))/sum(sum(obj.cropland_ilswe_5_hectare(Bioenergy_array(i).pe_cropland_ilswe_5 > 0)));
    Bioenergy_array(i).pe_yield_cropland_pe_cropland_both_se5_and_ilswe_4_5_mean = sum(sum(Bioenergy_array(i).pe_cropland_both_se5_and_ilswe_4_5))/sum(sum(obj.cropland_both_ilswe_4_5_se_5(Bioenergy_array(i).pe_cropland_both_se5_and_ilswe_4_5 > 0)));
    Bioenergy_array(i).pe_yield_cropland_se_wat_wind_4bioenergy_mean = sum(sum(Bioenergy_array(i).pe_cropland_se_wat_wind_4bioenergy))/sum(sum(obj.cropland_under_soil_erosion_mod_high_4bioenergy_hectare(Bioenergy_array(i).pe_cropland_se_wat_wind_4bioenergy > 0)));
    temp = sum(sum(obj.abandoned_cropland_hectare(Bioenergy_array(i).pe_ac > 0)))+sum(sum(obj.cropland_under_soil_erosion_mod_high_4bioenergy_hectare(Bioenergy_array(i).pe_ac_cropland_se_wat_wind_4bioenergy > 0)));
    Bioenergy_array(i).pe_yield_ac_cropland_se_wat_wind_4bioenergy_mean = sum(sum(Bioenergy_array(i).pe_ac_cropland_se_wat_wind_4bioenergy))/temp;
    
    %% Calc theoretical wheat loss from windbreak deployment
    binary_productive_bioenergy_cropland = Bioenergy_array(i).dm_yield_cropland > 0;
    land_ilswe4_productive_bioenergy = obj.cropland_ilswe_4_hectare;
    land_ilswe4_productive_bioenergy(binary_productive_bioenergy_cropland == 0) = 0;
    land_ilswe5_productive_bioenergy = obj.cropland_ilswe_5_hectare;
    land_ilswe5_productive_bioenergy(binary_productive_bioenergy_cropland == 0) = 0;


    
    Bioenergy_array(i).wheat_production_theoretical_se5_to_se10_prod_bioenergy = land_ilswe4_productive_bioenergy.*Wheat.dm_yield;
    Bioenergy_array(i).wheat_production_theoretical_se10_prod_bioenergy = land_ilswe5_productive_bioenergy.*Wheat.dm_yield;
    Bioenergy_array(i).wheat_production_loss_luc_se5_to_se10_no_yield_gain_tot = -sum(sum(Bioenergy_array(i).wheat_production_theoretical_se5_to_se10_prod_bioenergy)).*Inputs.share_of_cropland_under_wind_erosion_for_bioenergy;
    Bioenergy_array(i).wheat_production_loss_luc_se10_no_yield_gain_tot = -sum(sum(Bioenergy_array(i).wheat_production_theoretical_se10_prod_bioenergy)).*Inputs.share_of_cropland_under_wind_erosion_for_bioenergy;
    Bioenergy_array(i).wheat_production_change_after_mean_yield_gain_se5_to_se10 = zeros(1,length(Bioenergy_array(i).yield_gain_vec));
    Bioenergy_array(i).wheat_production_change_after_mean_yield_gain_se10 = zeros(1,length(Bioenergy_array(i).yield_gain_vec));
    
    land_converted_to_bioenergy_ilswe4  = land_ilswe4_productive_bioenergy*Inputs.share_of_cropland_under_wind_erosion_for_bioenergy;
    land_converted_to_bioenergy_ilswe5  = land_ilswe5_productive_bioenergy*Inputs.share_of_cropland_under_wind_erosion_for_bioenergy;
    land_left_for_food_production_ilswe4 = land_ilswe4_productive_bioenergy-land_converted_to_bioenergy_ilswe4;
    land_left_for_food_production_ilswe5 = land_ilswe5_productive_bioenergy-land_converted_to_bioenergy_ilswe5;
    remaining_food_production_ilswe4_no_yield_gain = land_left_for_food_production_ilswe4.*Wheat.dm_yield;
    remaining_food_production_ilswe5_no_yield_gain = land_left_for_food_production_ilswe5.*Wheat.dm_yield;
    
    Bioenergy_array(i).share_productive_se5_to_se10_wheat = sum(sum(land_ilswe4_productive_bioenergy(Wheat.dm_yield > 0)))/sum(sum(land_ilswe4_productive_bioenergy));
    Bioenergy_array(i).share_productive_se10_wheat = sum(sum(land_ilswe5_productive_bioenergy(Wheat.dm_yield > 0)))/sum(sum(land_ilswe5_productive_bioenergy));
    
    for rates = 1:length(Bioenergy_array(i).yield_gain_vec)
        
        Bioenergy_array(i).wheat_production_change_after_mean_yield_gain_se5_to_se10(rates) = ...
            sum(sum(remaining_food_production_ilswe4_no_yield_gain*(1+Bioenergy_array(i).yield_gain_vec(rates))...
            -Bioenergy_array(i).wheat_production_theoretical_se5_to_se10_prod_bioenergy));
        
        Bioenergy_array(i).wheat_production_change_after_mean_yield_gain_se10(rates) = ...
            sum(sum(remaining_food_production_ilswe5_no_yield_gain*(1+Bioenergy_array(i).yield_gain_vec(rates))...
            -Bioenergy_array(i).wheat_production_theoretical_se10_prod_bioenergy));
    end
    
end

%% Get information about crop distribution
for i = 1:length(Bioenergy_array)
    
    
end

%% SAVE
obj.Bioenergy_rf_h = Bioenergy_array;
end

