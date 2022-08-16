tic

clear

plot_stuff = 0;

addpath(genpath(pwd()));

use_GAEZ_v3 = 0;
use_GAEZ_v4 = 1;

stop_at_break = 0;

fprintf('Importing land availability.. \n');
Regions = import_land_availability();
fprintf('Importing biorefineries.. \n');
BiorefineryArray = makeBiorefineryArray();
fprintf('Importing crops.. \n');
Bioenergy_crops_array  = makeCropTypeArray();
fprintf('Importing namelist.. \n');
Inputs = Namelist;
if use_GAEZ_v3 == 1
    fprintf('Importing crop yields from GAEZ v3.. \n');
    GAEZ_array = getGAEZ_v3();
elseif use_GAEZ_v4 == 1
    fprintf('Importing crop yields from GAEZ v4.. \n');
    [GAEZ_array, Wheat] = getGAEZ_v4(Bioenergy_crops_array);
end

Willow = Willow_data('Input/Willow/willow_yields_high_5arcmin.nc');
Willow.agricultural_management_intensity = 3;
fprintf('Importing natural regrowth data.. \n');
Natural_regrowth = NatRegrowth_data('Input/natural_regrowth_5arcmin.nc');
fprintf('Importing biomes.. \n');
Biomes = get_biomes('Input/terrestrial_biomes.nc');
fprintf('Importing soil organic carbon change.. \n');
SOC_change = SOC('Input/soc_change_ssp245_2021_2040.nc');
fprintf('Importing GCAM.. \n');
GCAM_array = get_GCAM();
fprintf('Importing country masks.. \n');
[ CountryMask ] = importCountryMasks(  );
fprintf('Importing existing oil refineries.. \n');
Ref =get_existing_oil_refineries_Kramel('Input/existing_oil_refineries.xlsx');
fprintf('Importing aboveground carbon on abandoned cropland.. \n')
ABC = ABC_ac('Input/standing_carbon_on_abandoned_cropland_2019.nc');
ncid = netcdf.open('Input/seq_C_abandoned_cropland_1992_2018_5arcmin.nc');
ABC.mean_nat_regrowth_carbon_seq_rate_ton_C_per_ha_year_ac_2018 = netcdf.getVar(ncid,4);
netcdf.close(ncid);

fprintf('Import biomes data..');
Biome = get_biomes('Input/terrestrial_biomes.nc');

fprintf('Get on farm emissions, Iordan... \n')
Farm_em = get_country_level_farm_emissions_Iordan();

fprintf('Importing cropland under both wind and water soil erosion.. \n');
ncid = netcdf.open('Input/cropland_both_ilswe_4_5_and_se_5.nc');
cropland_both_ilswe_4_5_and_se_5_hectare = netcdf.getVar(ncid,2);
netcdf.close(ncid);

for reg = 1:length(Regions)
    fprintf('-- Region: ');
    fprintf(Regions(reg).region_name);
    fprintf(' -- \n');
    fprintf('Creating country mask.. \n');
    Regions(reg) = Regions(reg).get_regional_mask(CountryMask);
    
    fprintf('Getting area under both water and wind erosion.. \n');
    Regions(reg).cropland_both_ilswe_4_5_se_5 = Regions(reg).fraction_of_cell_is_region.*cropland_both_ilswe_4_5_and_se_5_hectare;
    temp = Regions(reg).cropland_ilswe_4_hectare + Regions(reg).cropland_ilswe_5_hectare;
    Regions(reg).share_of_cropland_ilswe_also_under_se = Regions(reg).cropland_both_ilswe_4_5_se_5./temp;
    Regions(reg).share_of_cropland_ilswe_also_under_se(isnan(Regions(reg).share_of_cropland_ilswe_also_under_se)) = 0;
    Regions(reg).cropland_under_soil_erosion_mod_high_all_hectare = temp + Regions(reg).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare-Regions(reg).cropland_both_ilswe_4_5_se_5;
    Regions(reg).cropland_under_soil_erosion_mod_high_4bioenergy_hectare = (temp*Inputs.share_of_cropland_under_wind_erosion_for_bioenergy) + Regions(reg).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare-(Regions(reg).cropland_both_ilswe_4_5_se_5*Inputs.share_of_cropland_under_wind_erosion_for_bioenergy);
    
    fprintf('Calc aboveground carbon on abandoned cropland.. \n')
    %Get aboveground carbon on ac
    Regions(reg).aboveground_carbon_on_abandoned_cropland_ton_C = sum(ABC.aboveground_carbon_ac_after_change_ton_C(:,:,1:26),3);
    Regions(reg).aboveground_carbon_on_abandoned_cropland_ton_C = Regions(reg).aboveground_carbon_on_abandoned_cropland_ton_C.*Regions(reg).fraction_of_cell_is_region;
    Regions(reg).aboveground_carbon_on_abandoned_cropland_ton_C(Regions(reg).abandoned_cropland_hectare <= 0) = 0;
    Regions(reg).aboveground_carbon_on_abandoned_cropland_ton_C = Regions(reg).aboveground_carbon_on_abandoned_cropland_ton_C + (Regions(reg).abandoned_cropland_hectare.*(ABC.mean_nat_regrowth_carbon_seq_rate_ton_C_per_ha_year_ac_2018*2)); %Add two years to make it 2021.
    Regions(reg).pe_aboveground_carbon_on_abandoned_cropland = Inputs.share_of_aboveground_carbon_harvested_for_bioenergy*Regions(reg).aboveground_carbon_on_abandoned_cropland_ton_C*(ABC.carbon_content_of_dry_mass^-1)*ABC.lhv; %GJ
    Regions(reg).mean_natural_regrowth_ac_tonC_per_ha_year = sum(sum(ABC.mean_nat_regrowth_carbon_seq_rate_ton_C_per_ha_year_ac_2018.*Regions(reg).abandoned_cropland_hectare))/sum(sum(Regions(reg).abandoned_cropland_hectare));
    Regions(reg).mean_natural_regrowth_cropland_se5_ilswe_45_tonC_per_ha_year = sum(sum(Natural_regrowth.aboveground_carbon_sequestration_rate_cropland_ton_per_ha.*Regions(reg).cropland_under_soil_erosion_mod_high_4bioenergy_hectare))/sum(sum(Regions(reg).cropland_under_soil_erosion_mod_high_4bioenergy_hectare));
    
    fprintf('Calc share ac and cropland under erosion per biome.. \n');
    Regions(reg).share_ac_per_biome = zeros(1,length(Biome.lockup_table_biome_IDs));
    Regions(reg).share_cropland_se5_ilswe_45_per_biome = zeros(1,length(Biome.lockup_table_biome_IDs));
    tot_ac = sum(sum(Regions(reg).abandoned_cropland_hectare));
    tot_cropland_se5_ilswe_45 = sum(sum(Regions(reg).cropland_under_soil_erosion_mod_high_4bioenergy_hectare));
    
    Regions(reg).gridded_soil_carbon_seq_rate_nat_regrowth_tonC_per_ha_year = zeros(length(Regions(reg).lon), length(Regions(reg).lat));
    
    for i = 1:length(Biome.lockup_table_biome_IDs)
        Regions(reg).share_ac_per_biome(i) = sum(sum(Regions(reg).abandoned_cropland_hectare.*(Biome.biome_gridded == Biome.lockup_table_biome_IDs(i))))/tot_ac;
        Regions(reg).share_cropland_se5_ilswe_45_per_biome(i) = sum(sum(Regions(reg).cropland_under_soil_erosion_mod_high_4bioenergy_hectare.*(Biome.biome_gridded == Biome.lockup_table_biome_IDs(i))))/tot_cropland_se5_ilswe_45;
        
        rate_this = Biome.lockup_table_soil_carbon_seq_rates_nat_reg(i);
        if isnan(rate_this)
            rate_this = Biome.lockup_table_soil_carbon_seq_rates_nat_reg(6);
        end
        Regions(reg).gridded_soil_carbon_seq_rate_nat_regrowth_tonC_per_ha_year(Biome.biome_gridded == Biome.lockup_table_biome_IDs(i)) = rate_this;
    end
    
    
    %Get geocentric radius
    fprintf('Get geocentric radius.. \n');
    Regions(reg).geocentric_radius_at_lat_km = zeros(1, length(Regions(reg).lat));
    for lats = 1:length(Regions(reg).lat)
        Regions(reg).geocentric_radius_at_lat_km(lats) = calc_earth_geocentric_radius_at_latitude(Regions(reg).lat(lats));
    end
    fprintf('Calc distances to existing refineries.. \n');
    Regions(reg) = Regions(reg).calc_distance_to_nearest_refinery(Ref);
    fprintf('Calc bioenergy potentials.. \n');
    Regions(reg) = Regions(reg).get_bioenergy_rf_h(BiorefineryArray, Bioenergy_crops_array, GAEZ_array, Willow, Inputs, Wheat);
    fprintf('Calc biomass transportation emissions.. \n');
    Regions(reg) = Regions(reg).calc_biomass_transport_emissions_farm2ref( Inputs );
    fprintf('Calc natural regrowth.. \n');
    Regions(reg) = Regions(reg).calc_nat_regrowth(Natural_regrowth);
    fprintf('Calc biorefinery carbon flows.. \n');
    Regions(reg) = Regions(reg).calc_bioenergy_carbon_flows(BiorefineryArray, Inputs, Bioenergy_crops_array);
    fprintf('Calc GCAM projected values.. \n');
    Regions(reg) = Regions(reg).calc_gcam_projected_values(GCAM_array);
end

if stop_at_break == 0
    
    %% Further calcs
    %Get crop IDs
    for i = 1:length(Bioenergy_crops_array)
        if strcmp(Bioenergy_crops_array(i).name, 'Reed Canary Grass')
            rcg_ID = Bioenergy_crops_array(i).ID;
        elseif strcmp(Bioenergy_crops_array(i).name, 'Switchgrass')
            swi_ID = Bioenergy_crops_array(i).ID;
        elseif strcmp(Bioenergy_crops_array(i).name, 'Willow')
            willow_ID = Bioenergy_crops_array(i).ID;
        end
        
    end
    
    fprintf('Calculating farm emissions.. \n');
    for reg = 1:length(Regions)
        for i = 1:length(Farm_em)
            if strcmp(Farm_em(i).country_name, Regions(reg).region_name)
                binary_have_data = Farm_em(i).gwp100_5arcmin > 0;
                tot_area = Regions(reg).cropland_hectare+Regions(reg).abandoned_cropland_hectare;
                binary_have_data(tot_area <=0) = 0;
                mean_gwp_this = 10^3*sum(sum(Farm_em(i).gwp100_5arcmin(binary_have_data).*tot_area(binary_have_data)))/sum(sum(tot_area(binary_have_data)));
                if strcmp(Farm_em(i).crop_name,'Reed Canary Grass')
                    Regions(reg).gwp100_region_mean_rcg_farm_em_kg_co2eq_per_ton_dm = mean_gwp_this;
                elseif strcmp(Farm_em(i).crop_name,'Switchgrass')
                    Regions(reg).gwp100_region_mean_switchgrass_farm_em_kg_co2eq_per_ton_dm = mean_gwp_this;
                end
            end
        end
        
        Regions(reg).gwp100_farm_em_willow_kg_co2eq_per_ton_dm = zeros(length(Regions(reg).lon), length(Regions(reg).lat));
        binary_have_data = Willow.dm_yield_ac_cropland > 0;
        binary_have_data((Regions(reg).cropland_hectare+Regions(reg).abandoned_cropland_hectare) <= 0) = 0;
        tot_area = Regions(reg).cropland_hectare+Regions(reg).abandoned_cropland_hectare;
        Regions(reg).gwp100_farm_em_willow_kg_co2eq_per_ton_dm(binary_have_data) = 1130.9*Willow.dm_yield_ac_cropland(binary_have_data).^-0.788;
        Regions(reg).gwp100_region_mean_willow_farm_em_kg_co2eq_per_ton_dm = sum(sum(Regions(reg).gwp100_farm_em_willow_kg_co2eq_per_ton_dm(binary_have_data).*tot_area(binary_have_data)))/sum(sum(tot_area(binary_have_data)));
        
        for scens = 1:length(Regions(reg).Bioenergy_rf_h)
            %Get farm emissions
            binary_isWillow_ac = Regions(reg).Bioenergy_rf_h(scens).crop_allocation_ac == willow_ID;
            binary_isWillow_cropland = Regions(reg).Bioenergy_rf_h(scens).crop_allocation_cropland == willow_ID;
            binary_isSwithcgrass_ac  = Regions(reg).Bioenergy_rf_h(scens).crop_allocation_ac == swi_ID;
            binary_isSwitchgrass_cropland = Regions(reg).Bioenergy_rf_h(scens).crop_allocation_cropland == swi_ID;
            binary_isRCG_ac  = Regions(reg).Bioenergy_rf_h(scens).crop_allocation_ac == rcg_ID;
            binary_isRCG_cropland = Regions(reg).Bioenergy_rf_h(scens).crop_allocation_cropland == rcg_ID;
            
            
            Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_ac = zeros(length(Regions(reg).lon), length(Regions(reg).lat));
            
            Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland = zeros(length(Regions(reg).lon),length(Regions(reg).lat));
            Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_4 = zeros(length(Regions(reg).lon),length(Regions(reg).lat));
            Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_5 = zeros(length(Regions(reg).lon),length(Regions(reg).lat));
            Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_se_5 = zeros(length(Regions(reg).lon),length(Regions(reg).lat));
            Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_se_10 = zeros(length(Regions(reg).lon),length(Regions(reg).lat));
            
            
            
            Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_ac(binary_isWillow_ac) = 10^-3*Regions(reg).Bioenergy_rf_h(scens).dm_ac(binary_isWillow_ac).*Regions(reg).gwp100_farm_em_willow_kg_co2eq_per_ton_dm(binary_isWillow_ac);
            Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland(binary_isWillow_cropland) = 10^-3*Regions(reg).Bioenergy_rf_h(scens).dm_cropland(binary_isWillow_cropland).*Regions(reg).gwp100_farm_em_willow_kg_co2eq_per_ton_dm(binary_isWillow_cropland);
            
            Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_4(binary_isWillow_cropland) = 10^-3*Regions(reg).Bioenergy_rf_h(scens).dm_cropland_ilswe_4(binary_isWillow_cropland).*Regions(reg).gwp100_farm_em_willow_kg_co2eq_per_ton_dm(binary_isWillow_cropland);
            Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_5(binary_isWillow_cropland) = 10^-3*Regions(reg).Bioenergy_rf_h(scens).dm_cropland_ilswe_5(binary_isWillow_cropland).*Regions(reg).gwp100_farm_em_willow_kg_co2eq_per_ton_dm(binary_isWillow_cropland);
            Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_se_5(binary_isWillow_cropland) = 10^-3*Regions(reg).Bioenergy_rf_h(scens).dm_cropland_se5(binary_isWillow_cropland).*Regions(reg).gwp100_farm_em_willow_kg_co2eq_per_ton_dm(binary_isWillow_cropland);
            Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_se_10(binary_isWillow_cropland) = 10^-3*Regions(reg).Bioenergy_rf_h(scens).dm_cropland_se10(binary_isWillow_cropland).*Regions(reg).gwp100_farm_em_willow_kg_co2eq_per_ton_dm(binary_isWillow_cropland);
            
            %         sum(sum(Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_ac(binary_isWillow_ac)))
            %         sum(sum(Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_ac(binary_isWillow_ac)))/sum(sum(Regions(reg).abandoned_cropland_hectare(binary_isWillow_ac)))
            
            
            for i = 1:length(Farm_em)
                if strcmp(Farm_em(i).country_name, Regions(reg).region_name)
                    if strcmp(Farm_em(i).crop_name,'Reed Canary Grass')
                        binary_rcg_and_Iordan_data_ac = binary_isRCG_ac & Farm_em(i).gwp100_5arcmin > 0;
                        binary_rcg_and_no_Iordan_data_ac = binary_isRCG_ac & Farm_em(i).gwp100_5arcmin <= 0;
                        binary_rcg_and_Iordan_data_cropland = binary_isRCG_cropland & Farm_em(i).gwp100_5arcmin > 0;
                        binary_rcg_and_no_Iordan_data_cropland = binary_isRCG_cropland & Farm_em(i).gwp100_5arcmin <= 0;
                        
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_ac(binary_rcg_and_Iordan_data_ac) = Regions(reg).Bioenergy_rf_h(scens).dm_ac(binary_rcg_and_Iordan_data_ac).*Farm_em(i).gwp100_5arcmin(binary_rcg_and_Iordan_data_ac);
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_ac(binary_rcg_and_no_Iordan_data_ac) = Regions(reg).Bioenergy_rf_h(scens).dm_ac(binary_rcg_and_no_Iordan_data_ac)*Regions(reg).gwp100_region_mean_rcg_farm_em_kg_co2eq_per_ton_dm*10^-3; %%%%%%%%%
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland(binary_rcg_and_Iordan_data_cropland) = Regions(reg).Bioenergy_rf_h(scens).dm_cropland(binary_rcg_and_Iordan_data_cropland).*Farm_em(i).gwp100_5arcmin(binary_rcg_and_Iordan_data_cropland);
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland(binary_rcg_and_no_Iordan_data_cropland) = Regions(reg).Bioenergy_rf_h(scens).dm_cropland(binary_rcg_and_no_Iordan_data_cropland)*Regions(reg).gwp100_region_mean_rcg_farm_em_kg_co2eq_per_ton_dm*10^-3;
                        
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_4(binary_rcg_and_Iordan_data_cropland) = Regions(reg).Bioenergy_rf_h(scens).dm_cropland_ilswe_4(binary_rcg_and_Iordan_data_cropland).*Farm_em(i).gwp100_5arcmin(binary_rcg_and_Iordan_data_cropland);
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_4(binary_rcg_and_no_Iordan_data_cropland) = Regions(reg).Bioenergy_rf_h(scens).dm_cropland_ilswe_4(binary_rcg_and_no_Iordan_data_cropland)*Regions(reg).gwp100_region_mean_rcg_farm_em_kg_co2eq_per_ton_dm*10^-3;
                        
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_5(binary_rcg_and_Iordan_data_cropland) = Regions(reg).Bioenergy_rf_h(scens).dm_cropland_ilswe_5(binary_rcg_and_Iordan_data_cropland).*Farm_em(i).gwp100_5arcmin(binary_rcg_and_Iordan_data_cropland);
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_5(binary_rcg_and_no_Iordan_data_cropland) = Regions(reg).Bioenergy_rf_h(scens).dm_cropland_ilswe_5(binary_rcg_and_no_Iordan_data_cropland)*Regions(reg).gwp100_region_mean_rcg_farm_em_kg_co2eq_per_ton_dm*10^-3;
                        
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_se_5(binary_rcg_and_Iordan_data_cropland) = Regions(reg).Bioenergy_rf_h(scens).dm_cropland_se5(binary_rcg_and_Iordan_data_cropland).*Farm_em(i).gwp100_5arcmin(binary_rcg_and_Iordan_data_cropland);
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_se_5(binary_rcg_and_no_Iordan_data_cropland) = Regions(reg).Bioenergy_rf_h(scens).dm_cropland_se5(binary_rcg_and_no_Iordan_data_cropland)*Regions(reg).gwp100_region_mean_rcg_farm_em_kg_co2eq_per_ton_dm*10^-3;
                        
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_se_10(binary_rcg_and_Iordan_data_cropland) = Regions(reg).Bioenergy_rf_h(scens).dm_cropland_se10(binary_rcg_and_Iordan_data_cropland).*Farm_em(i).gwp100_5arcmin(binary_rcg_and_Iordan_data_cropland);
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_se_10(binary_rcg_and_no_Iordan_data_cropland) = Regions(reg).Bioenergy_rf_h(scens).dm_cropland_se10(binary_rcg_and_no_Iordan_data_cropland)*Regions(reg).gwp100_region_mean_rcg_farm_em_kg_co2eq_per_ton_dm*10^-3;
                        
                    elseif strcmp(Farm_em(i).crop_name,'Switchgrass')
                        binary_swi_and_Iordan_data_ac = binary_isSwithcgrass_ac & Farm_em(i).gwp100_5arcmin > 0;
                        binary_swi_and_no_Iordan_data_ac = binary_isSwithcgrass_ac & Farm_em(i).gwp100_5arcmin <= 0;
                        binary_swi_and_Iordan_data_cropland = binary_isSwitchgrass_cropland & Farm_em(i).gwp100_5arcmin > 0;
                        binary_swi_and_no_Iordan_data_cropland = binary_isSwitchgrass_cropland & Farm_em(i).gwp100_5arcmin <= 0;
                        
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_ac(binary_swi_and_Iordan_data_ac) = Regions(reg).Bioenergy_rf_h(scens).dm_ac(binary_swi_and_Iordan_data_ac).*Farm_em(i).gwp100_5arcmin(binary_swi_and_Iordan_data_ac);
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_ac(binary_swi_and_no_Iordan_data_ac) = Regions(reg).Bioenergy_rf_h(scens).dm_ac(binary_swi_and_no_Iordan_data_ac)*Regions(reg).gwp100_region_mean_switchgrass_farm_em_kg_co2eq_per_ton_dm;
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland(binary_swi_and_Iordan_data_cropland) = Regions(reg).Bioenergy_rf_h(scens).dm_cropland(binary_swi_and_Iordan_data_cropland).*Farm_em(i).gwp100_5arcmin(binary_swi_and_Iordan_data_cropland);
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland(binary_swi_and_no_Iordan_data_cropland) = Regions(reg).Bioenergy_rf_h(scens).dm_cropland(binary_swi_and_no_Iordan_data_cropland)*Regions(reg).gwp100_region_mean_switchgrass_farm_em_kg_co2eq_per_ton_dm*10^-3;
                        
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_4(binary_swi_and_Iordan_data_cropland) = Regions(reg).Bioenergy_rf_h(scens).dm_cropland_ilswe_4(binary_swi_and_Iordan_data_cropland).*Farm_em(i).gwp100_5arcmin(binary_swi_and_Iordan_data_cropland);
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_4(binary_swi_and_no_Iordan_data_cropland) = Regions(reg).Bioenergy_rf_h(scens).dm_cropland_ilswe_4(binary_swi_and_no_Iordan_data_cropland)*Regions(reg).gwp100_region_mean_switchgrass_farm_em_kg_co2eq_per_ton_dm*10^-3;
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_5(binary_swi_and_Iordan_data_cropland) = Regions(reg).Bioenergy_rf_h(scens).dm_cropland_ilswe_5(binary_swi_and_Iordan_data_cropland).*Farm_em(i).gwp100_5arcmin(binary_swi_and_Iordan_data_cropland);
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_5(binary_swi_and_no_Iordan_data_cropland) = Regions(reg).Bioenergy_rf_h(scens).dm_cropland_ilswe_5(binary_swi_and_no_Iordan_data_cropland)*Regions(reg).gwp100_region_mean_switchgrass_farm_em_kg_co2eq_per_ton_dm*10^-3;
                        
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_se_5(binary_swi_and_Iordan_data_cropland) = Regions(reg).Bioenergy_rf_h(scens).dm_cropland_se5(binary_swi_and_Iordan_data_cropland).*Farm_em(i).gwp100_5arcmin(binary_swi_and_Iordan_data_cropland);
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_se_5(binary_swi_and_no_Iordan_data_cropland) = Regions(reg).Bioenergy_rf_h(scens).dm_cropland_se5(binary_swi_and_no_Iordan_data_cropland)*Regions(reg).gwp100_region_mean_switchgrass_farm_em_kg_co2eq_per_ton_dm*10^-3;
                        
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_se_10(binary_swi_and_Iordan_data_cropland) = Regions(reg).Bioenergy_rf_h(scens).dm_cropland_se10(binary_swi_and_Iordan_data_cropland).*Farm_em(i).gwp100_5arcmin(binary_swi_and_Iordan_data_cropland);
                        Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_se_10(binary_swi_and_no_Iordan_data_cropland) = Regions(reg).Bioenergy_rf_h(scens).dm_cropland_se10(binary_swi_and_no_Iordan_data_cropland)*Regions(reg).gwp100_region_mean_switchgrass_farm_em_kg_co2eq_per_ton_dm*10^-3;
                        
                    end
                end
            end
            %binary_ilswe_4 = Regions(reg).cropland_ilswe_4_hectare > 0;
            %sum(sum(binary_ilswe_4 & Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_4 <= 0))
        end
        
        
    end
    
    
    
    for reg = 1:length(Regions)
        if strcmp(Regions(reg).region_name, 'Nordic_region')
            tot_gwp_rcg = 0;
            tot_gwp_swi = 0;
            tot_land = 0;
            for scens = 1:length(Regions(reg).Bioenergy_rf_h)
                Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_ac(:,:) = 0;
                Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland(:,:) = 0;
                Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_4(:,:) = 0;
                Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_5(:,:) = 0;
                Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_se_5(:,:) = 0;
                Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_se_10(:,:) = 0;
            end
            for reg2 = 1:length(Regions)
                if  reg2 == reg
                    continue
                end
                tot_gwp_swi = tot_gwp_swi+sum(sum(Regions(reg2).gwp100_region_mean_switchgrass_farm_em_kg_co2eq_per_ton_dm.*(Regions(reg2).abandoned_cropland_hectare+Regions(reg2).cropland_hectare)));
                tot_gwp_rcg = tot_gwp_rcg+sum(sum(Regions(reg2).gwp100_region_mean_rcg_farm_em_kg_co2eq_per_ton_dm.*(Regions(reg2).abandoned_cropland_hectare+Regions(reg2).cropland_hectare)));
                tot_land = sum(sum(Regions(reg2).abandoned_cropland_hectare+Regions(reg2).cropland_hectare))+tot_land;
                
                for scens = 1:length(Regions(reg).Bioenergy_rf_h)
                    Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_ac = Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_ac+Regions(reg2).Bioenergy_rf_h(scens).farm_emissions_gwp100_ac;
                    Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland = Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland+Regions(reg2).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland;
                    
                    Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_4 = Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_4+Regions(reg2).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_4;
                    Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_5 = Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_5+Regions(reg2).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_5;
                    Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_se_5 = Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_se_5+Regions(reg2).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_se_5;
                    Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_se_10 = Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_se_10+Regions(reg2).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_se_10;
                end
            end
            Regions(reg).gwp100_region_mean_rcg_farm_em_kg_co2eq_per_ton_dm = tot_gwp_rcg/tot_land;
            Regions(reg).gwp100_region_mean_switchgrass_farm_em_kg_co2eq_per_ton_dm = tot_gwp_swi/tot_land;
            
            
        end
    end
    
    %% Calc mitigiation
    fprintf('Calculating mitigation over (years): ');
    
    n_years=20;
    fprintf(num2str(n_years));
    fprintf('\n');
    
    carbon_to_co2 = (12+32)/12;
    
    for reg = 1:length(Regions)
        fprintf(Regions(reg).region_name);
        fprintf('.. \n');
        for scens = 1:length(Regions(reg).Bioenergy_rf_h)
            
            for refs = 1:length(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows)
                Ref = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).Biorefinery;
                
                %Substitution_factor_ft_this
                substitution_factor_ft_this_kgCO2eq_per_MJ = (Inputs.gwp100_diesel_kgCO2eq_per_MJ*Ref.share_ft_to_diesel) + (Inputs.gwp100_petrol_kgCO2eq_per_MJ*Ref.share_ft_to_gasoline);
                
                %Aboveground carbon
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).fe_aboveground_carbon_clearing = Regions(reg).Bioenergy_rf_h(scens).pe_aboveground_carbon_clearing*Ref.energy_efficiency;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).ethanol_fe_aboveground_carbon_clearing = Regions(reg).Bioenergy_rf_h(scens).pe_aboveground_carbon_clearing*Ref.ethanol_efficiency;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).ft_fe_aboveground_carbon_clearing = Inputs.share_of_aboveground_carbon_harvested_for_bioenergy*Regions(reg).Bioenergy_rf_h(scens).pe_aboveground_carbon_clearing*Ref.fischer_tropsch_efficiency;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).electricity_fe_aboveground_carbon_clearing = Inputs.share_of_aboveground_carbon_harvested_for_bioenergy*Regions(reg).Bioenergy_rf_h(scens).pe_aboveground_carbon_clearing*Ref.electricity_efficiency;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_fuel_aboveground_carbon_clearing = Inputs.share_of_aboveground_carbon_harvested_for_bioenergy*Regions(reg).Bioenergy_rf_h(scens).carbon_aboveground_carbon_clearing*Ref.fraction_biomass_C_in_fuel;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_emitted_at_refinery_aboveground_carbon_clearing = Inputs.share_of_aboveground_carbon_harvested_for_bioenergy*Regions(reg).Bioenergy_rf_h(scens).carbon_aboveground_carbon_clearing*Ref.fraction_biomass_C_emitted_at_refinery;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_ccs_or_char_aboveground_carbon_clearing = Inputs.share_of_aboveground_carbon_harvested_for_bioenergy*Regions(reg).Bioenergy_rf_h(scens).carbon_aboveground_carbon_clearing*Ref.fraction_biomass_C_sequestered_through_CCS_or_char;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).tco2eq_fossil_fuel_substitution_1to1_abc_clearing_ft = - Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).ft_fe_aboveground_carbon_clearing*substitution_factor_ft_this_kgCO2eq_per_MJ;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).tco2eq_fossil_fuel_substitution_1to1_abc_clearing_ethanol = - Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).ethanol_fe_aboveground_carbon_clearing*Inputs.gwp100_petrol_kgCO2eq_per_MJ;
                
                %size(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).tco2eq_fossil_fuel_substitution_1to1_abc_clearing_ft);
                
                %Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).tco2eq_electricity_substitution_1to1_abc_clearing = - Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).electricity_fe_aboveground_carbon_clearing*Inputs.gwp100_petrol_kgCO2eq_per_MJ*n_years;
                
                %% Abandoned cropland
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac = Mitigation;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.contains_aboveground_carbon = 1;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_farm_production = Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_ac*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_farm2ref_transport = Regions(reg).Bioenergy_rf_h(scens).diesel_biomass_transport_emissions_ac*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_emitted_at_refinery = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_emitted_at_refinery_ac*carbon_to_co2*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_ccs_or_char = -Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_ccs_or_char_abandoned_cropland*carbon_to_co2*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_fuel_combustion = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_fuel_ac*carbon_to_co2*n_years;
                
                
                
                %SOC
                crop_id_willow = 5;
                ac_willow_ha = zeros(length(Regions(reg).lon), length(Regions(reg).lat));
                ac_willow_ha(Regions(reg).Bioenergy_rf_h(scens).crop_allocation_ac == crop_id_willow) = Regions(reg).abandoned_cropland_hectare(Regions(reg).Bioenergy_rf_h(scens).crop_allocation_ac == crop_id_willow);
                ac_perennial_ha = Regions(reg).abandoned_cropland_hectare-ac_willow_ha;
                ac_productive_willow_ha = ac_willow_ha.*(Regions(reg).Bioenergy_rf_h(scens).dm_yield_ac > 0);
                ac_productive_perennial_ha = ac_perennial_ha.*(Regions(reg).Bioenergy_rf_h(scens).dm_yield_ac > 0);
                
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_soc_change = -SOC_change.soc_stock_change_fallow_2_bioenergy_grass.*ac_productive_willow_ha*carbon_to_co2;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_soc_change(SOC_change.soc_stock_change_fallow_2_bioenergy_grass <= 0) = 0;
                temp = SOC_change.soc_stock_change_fallow_2_agroforestry.*ac_productive_perennial_ha*carbon_to_co2;
                temp(temp <= 0) = 0;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_soc_change = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_soc_change-temp;
                
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_ff_subsitution_ft = -Regions(reg).Bioenergy_rf_h(scens).pe_ac*Ref.fischer_tropsch_efficiency*substitution_factor_ft_this_kgCO2eq_per_MJ*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_ff_subsitution_ethanol = -Regions(reg).Bioenergy_rf_h(scens).pe_ac*Ref.ethanol_efficiency*Inputs.gwp100_petrol_kgCO2eq_per_MJ*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_crop_sequestration = -Regions(reg).Bioenergy_rf_h(scens).carbon_ac*carbon_to_co2*n_years;
                
                %ABC clearing
                dm_abc_clearing_tot = Inputs.share_of_aboveground_carbon_harvested_for_bioenergy*sum(sum(Regions(reg).Bioenergy_rf_h(scens).carbon_aboveground_carbon_clearing/ABC.carbon_content_of_dry_mass)); %Assume carbon content of nat veg 50%.
                dm_abc_clearing = Inputs.share_of_aboveground_carbon_harvested_for_bioenergy*Regions(reg).Bioenergy_rf_h(scens).carbon_aboveground_carbon_clearing/ABC.carbon_content_of_dry_mass;
                
                
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_abc_clearing_burned_at_field = carbon_to_co2*(1-Inputs.share_of_aboveground_carbon_harvested_for_bioenergy)*Regions(reg).Bioenergy_rf_h(scens).carbon_aboveground_carbon_clearing;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_abc_clearing_emitted_at_refinery = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_emitted_at_refinery_aboveground_carbon_clearing*carbon_to_co2;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_abc_clearing_ccs_or_char = -Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_ccs_or_char_aboveground_carbon_clearing*carbon_to_co2;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_abc_clearing_fuel_combustion = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_fuel_aboveground_carbon_clearing*carbon_to_co2;
                
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_abc_clearing_burned_at_field_tot = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_abc_clearing_burned_at_field));
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_abc_clearing_emitted_at_refinery_tot = carbon_to_co2*sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_emitted_at_refinery_aboveground_carbon_clearing));
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_abc_clearing_ccs_or_char_tot = -carbon_to_co2*sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_ccs_or_char_aboveground_carbon_clearing));
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_abc_clearing_fuel_combustion_tot = carbon_to_co2*sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_fuel_aboveground_carbon_clearing));
                
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_abc_clearing_harvest = dm_abc_clearing.*Inputs.gwp100_aboveground_carbon_clearing_kgCO2eq_per_ton*10^-3;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_abc_clearing_harvest_tot = dm_abc_clearing_tot*Inputs.gwp100_aboveground_carbon_clearing_kgCO2eq_per_ton*10^-3;
                %Assume 200km dry mass transport.
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_abc_clearing_transport = 10^-3*200*dm_abc_clearing*Inputs.diesel_biomass_transport_energy_use_MJ_per_tkm*Inputs.gwp100_diesel_kgCO2eq_per_MJ;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_abc_clearing_transport_tot = 10^-3*200*dm_abc_clearing_tot*Inputs.diesel_biomass_transport_energy_use_MJ_per_tkm*Inputs.gwp100_diesel_kgCO2eq_per_MJ;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_abc_clearing_ff_subsitution_ft_tot = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).tco2eq_fossil_fuel_substitution_1to1_abc_clearing_ft));
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_abc_clearing_ff_subsitution_ethanol_tot = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).tco2eq_fossil_fuel_substitution_1to1_abc_clearing_ethanol));
                
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_abc_clearing_ff_substitution_ft = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).tco2eq_fossil_fuel_substitution_1to1_abc_clearing_ft;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_abc_clearing_ff_substitution_ethanol = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).tco2eq_fossil_fuel_substitution_1to1_abc_clearing_ethanol;
                
                
                
                
                %Calc totals
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.calc_tots_from_gridded();
                
                %% Cropland perennials vs woody crops distribution, SOC
                cropland_perennials_binary = zeros(length(Regions(reg).lon), length(Regions(reg).lat));
                cropland_woody_binary = zeros(length(Regions(reg).lon), length(Regions(reg).lat));
                cropland_woody_binary(Regions(reg).Bioenergy_rf_h(scens).crop_allocation_cropland == willow_ID) = 1;
                cropland_perennials_binary(cropland_woody_binary == 0) = 1;
                cropland_perennials_binary(Regions(reg).Bioenergy_rf_h(scens).crop_allocation_cropland == 0) = 0;
                
                
                %% Cropland
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland = Mitigation;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_accumulated_farm_production = Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_accumulated_farm2ref_transport = Regions(reg).Bioenergy_rf_h(scens).diesel_biomass_transport_emissions_cropland*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_accumulated_emitted_at_refinery = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_emitted_at_refinery_cropland*carbon_to_co2*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_accumulated_ccs_or_char = -Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_ccs_or_char_cropland*carbon_to_co2*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_accumulated_fuel_combustion = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_fuel_cropland*carbon_to_co2*n_years;
                %SOC
                land_perennial = Regions(reg).cropland_hectare.*cropland_perennials_binary;
                land_woody = Regions(reg).cropland_hectare.*cropland_woody_binary;
                land_productive_perennial = land_perennial.*(Regions(reg).Bioenergy_rf_h(scens).dm_yield_cropland > 0);
                land_productive_woody = land_woody.*(Regions(reg).Bioenergy_rf_h(scens).dm_yield_cropland > 0);
                soc_change_perennial = SOC_change.soc_stock_change_annual_crop_2_bioenergy_grass.*land_productive_perennial;
                soc_change_woody = SOC_change.soc_stock_change_annual_crop_2_agroforestry.*land_productive_woody;
                soc_change_perennial(SOC_change.soc_stock_change_annual_crop_2_bioenergy_grass <= 0) = 0;
                soc_change_woody(SOC_change.soc_stock_change_annual_crop_2_agroforestry <= 0) = 0;
                soc_tot = soc_change_perennial+soc_change_woody;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_accumulated_soc_change = -soc_tot*carbon_to_co2;
                
                
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_accumulated_ff_subsitution_ft = -Regions(reg).Bioenergy_rf_h(scens).pe_cropland*Ref.fischer_tropsch_efficiency*substitution_factor_ft_this_kgCO2eq_per_MJ*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_accumulated_ff_subsitution_ethanol = -Regions(reg).Bioenergy_rf_h(scens).pe_cropland*Ref.ethanol_efficiency*Inputs.gwp100_petrol_kgCO2eq_per_MJ*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_crop_sequestration = -Regions(reg).Bioenergy_rf_h(scens).carbon_cropland*carbon_to_co2*n_years;
                %Calc totals
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.calc_tots_from_gridded();
                
                %% Cropland ilswe 4
                
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4 = Mitigation;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_accumulated_farm_production = Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_4*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_accumulated_farm2ref_transport = Regions(reg).Bioenergy_rf_h(scens).diesel_biomass_transport_emissions_cropland_ilswe_4*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_accumulated_emitted_at_refinery = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_emitted_at_refinery_cropland_ilswe_4*carbon_to_co2*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_accumulated_ccs_or_char = -Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_ccs_or_char_cropland_ilswe_4*carbon_to_co2*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_accumulated_fuel_combustion = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_fuel_cropland_ilswe_4*carbon_to_co2*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_accumulated_ff_subsitution_ft = -Regions(reg).Bioenergy_rf_h(scens).pe_cropland_ilswe_4*Ref.fischer_tropsch_efficiency*substitution_factor_ft_this_kgCO2eq_per_MJ*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_accumulated_ff_subsitution_ethanol = -Regions(reg).Bioenergy_rf_h(scens).pe_cropland_ilswe_4*Ref.ethanol_efficiency*Inputs.gwp100_petrol_kgCO2eq_per_MJ*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_crop_sequestration = -Regions(reg).Bioenergy_rf_h(scens).carbon_cropland_ilswe_4*carbon_to_co2*n_years;
                
                %SOC
                land_perennial = Regions(reg).cropland_ilswe_4_hectare.*cropland_perennials_binary;
                land_woody = Regions(reg).cropland_ilswe_4_hectare.*cropland_woody_binary;
                land_productive_perennial = land_perennial.*(Regions(reg).Bioenergy_rf_h(scens).dm_yield_cropland > 0);
                land_productive_woody = land_woody.*(Regions(reg).Bioenergy_rf_h(scens).dm_yield_cropland > 0);
                
                soc_change_perennial = SOC_change.soc_stock_change_annual_crop_2_bioenergy_grass.*land_productive_perennial;
                soc_change_woody = SOC_change.soc_stock_change_annual_crop_2_agroforestry.*land_productive_woody;
                soc_change_perennial(SOC_change.soc_stock_change_annual_crop_2_bioenergy_grass <= 0) = 0;
                soc_change_woody(SOC_change.soc_stock_change_annual_crop_2_agroforestry <= 0) = 0;
                soc_tot = soc_change_perennial+soc_change_woody;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_accumulated_soc_change = -soc_tot*carbon_to_co2;
                
                %Calc totals
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.calc_tots_from_gridded();
                
                %% Cropland ilswe 5
                
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5 = Mitigation;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_accumulated_farm_production = Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_ilswe_5*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_accumulated_farm2ref_transport = Regions(reg).Bioenergy_rf_h(scens).diesel_biomass_transport_emissions_cropland_ilswe_5*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_accumulated_emitted_at_refinery = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_emitted_at_refinery_cropland_ilswe_5*carbon_to_co2*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_accumulated_ccs_or_char = -Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_ccs_or_char_cropland_ilswe_5*carbon_to_co2*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_accumulated_fuel_combustion = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_fuel_cropland_ilswe_5*carbon_to_co2*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_accumulated_ff_subsitution_ft = -Regions(reg).Bioenergy_rf_h(scens).pe_cropland_ilswe_5*Ref.fischer_tropsch_efficiency*substitution_factor_ft_this_kgCO2eq_per_MJ*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_accumulated_ff_subsitution_ethanol = -Regions(reg).Bioenergy_rf_h(scens).pe_cropland_ilswe_5*Ref.ethanol_efficiency*Inputs.gwp100_petrol_kgCO2eq_per_MJ*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_crop_sequestration = -Regions(reg).Bioenergy_rf_h(scens).carbon_cropland_ilswe_5*carbon_to_co2*n_years;
                
                %SOC
                land_perennial = Regions(reg).cropland_ilswe_5_hectare.*cropland_perennials_binary;
                land_woody = Regions(reg).cropland_ilswe_5_hectare.*cropland_woody_binary;
                land_productive_perennial = land_perennial.*(Regions(reg).Bioenergy_rf_h(scens).dm_yield_cropland > 0);
                land_productive_woody = land_woody.*(Regions(reg).Bioenergy_rf_h(scens).dm_yield_cropland > 0);
                
                soc_change_perennial = SOC_change.soc_stock_change_annual_crop_2_bioenergy_grass.*land_productive_perennial;
                soc_change_woody = SOC_change.soc_stock_change_annual_crop_2_agroforestry.*land_productive_woody;
                soc_change_perennial(SOC_change.soc_stock_change_annual_crop_2_bioenergy_grass <= 0) = 0;
                soc_change_woody(SOC_change.soc_stock_change_annual_crop_2_agroforestry <= 0) = 0;
                soc_tot = soc_change_perennial+soc_change_woody;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_accumulated_soc_change = -soc_tot*carbon_to_co2;
                
                %Calc totals
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.calc_tots_from_gridded();
                
                %% Get mitigation with both wind and water erosion
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5 = Mitigation;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5 + Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.multiply_grids_with_hadamar_product_of_matrix(Regions(reg).share_of_cropland_ilswe_also_under_se);
                
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.calc_tots_from_gridded();
                %Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5
                
                
                
                %% Cropland se 5
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5 = Mitigation;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_accumulated_farm_production = Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_se_5*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_accumulated_farm2ref_transport = Regions(reg).Bioenergy_rf_h(scens).diesel_biomass_transport_emissions_cropland_se5*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_accumulated_emitted_at_refinery = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_emitted_at_refinery_cropland_se5*carbon_to_co2*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_accumulated_ccs_or_char = -Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_ccs_or_char_cropland_se5*carbon_to_co2*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_accumulated_fuel_combustion = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_fuel_cropland_se5*carbon_to_co2*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_accumulated_ff_subsitution_ft = -Regions(reg).Bioenergy_rf_h(scens).pe_cropland_se5*Ref.fischer_tropsch_efficiency*substitution_factor_ft_this_kgCO2eq_per_MJ*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_accumulated_ff_subsitution_ethanol = -Regions(reg).Bioenergy_rf_h(scens).pe_cropland_se5*Ref.ethanol_efficiency*Inputs.gwp100_petrol_kgCO2eq_per_MJ*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_crop_sequestration = -Regions(reg).Bioenergy_rf_h(scens).carbon_cropland_se5*carbon_to_co2*n_years;
                
                %SOC
                land_perennial = Regions(reg).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare.*cropland_perennials_binary;
                land_woody = Regions(reg).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare.*cropland_woody_binary;
                land_productive_perennial = land_perennial.*(Regions(reg).Bioenergy_rf_h(scens).dm_yield_cropland > 0);
                land_productive_woody = land_woody.*(Regions(reg).Bioenergy_rf_h(scens).dm_yield_cropland > 0);
                
                soc_change_perennial = SOC_change.soc_stock_change_annual_crop_2_bioenergy_grass.*land_productive_perennial;
                soc_change_woody = SOC_change.soc_stock_change_annual_crop_2_agroforestry.*land_productive_woody;
                soc_change_perennial(SOC_change.soc_stock_change_annual_crop_2_bioenergy_grass <= 0) = 0;
                soc_change_woody(SOC_change.soc_stock_change_annual_crop_2_agroforestry <= 0) = 0;
                soc_tot = soc_change_perennial+soc_change_woody;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_accumulated_soc_change = -soc_tot*carbon_to_co2;
                
                %Calc totals
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.calc_tots_from_gridded();
                
                %% Cropland se 10
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10 = Mitigation;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_accumulated_farm_production = Regions(reg).Bioenergy_rf_h(scens).farm_emissions_gwp100_cropland_se_10*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_accumulated_farm2ref_transport = Regions(reg).Bioenergy_rf_h(scens).diesel_biomass_transport_emissions_cropland_se10*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_accumulated_emitted_at_refinery = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_emitted_at_refinery_cropland_se10*carbon_to_co2*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_accumulated_ccs_or_char = -Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_ccs_or_char_cropland_se10*carbon_to_co2*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_accumulated_fuel_combustion = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).carbon_fuel_cropland_se10*carbon_to_co2*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_accumulated_soc_change = -SOC_change.soc_stock_change_fallow_2_bioenergy_grass.*Regions(reg).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare*carbon_to_co2;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_accumulated_soc_change(SOC_change.soc_stock_change_fallow_2_bioenergy_grass <= 0) = 0;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_accumulated_ff_subsitution_ft = -Regions(reg).Bioenergy_rf_h(scens).pe_cropland_se10*Ref.fischer_tropsch_efficiency*substitution_factor_ft_this_kgCO2eq_per_MJ*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_accumulated_ff_subsitution_ethanol = -Regions(reg).Bioenergy_rf_h(scens).pe_cropland_se10*Ref.ethanol_efficiency*Inputs.gwp100_petrol_kgCO2eq_per_MJ*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_crop_sequestration = -Regions(reg).Bioenergy_rf_h(scens).carbon_cropland_se10*carbon_to_co2*n_years;
                
                %SOC
                land_perennial = Regions(reg).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare.*cropland_perennials_binary;
                land_woody = Regions(reg).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare.*cropland_woody_binary;
                land_productive_perennial = land_perennial.*(Regions(reg).Bioenergy_rf_h(scens).dm_yield_cropland > 0);
                land_productive_woody = land_woody.*(Regions(reg).Bioenergy_rf_h(scens).dm_yield_cropland > 0);
                
                soc_change_perennial = SOC_change.soc_stock_change_annual_crop_2_bioenergy_grass.*land_productive_perennial;
                soc_change_woody = SOC_change.soc_stock_change_annual_crop_2_agroforestry.*land_productive_woody;
                soc_change_perennial(SOC_change.soc_stock_change_annual_crop_2_bioenergy_grass <= 0) = 0;
                soc_change_woody(SOC_change.soc_stock_change_annual_crop_2_agroforestry <= 0) = 0;
                soc_tot = soc_change_perennial+soc_change_woody;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_accumulated_soc_change = -soc_tot*carbon_to_co2;
                
                Regions(reg) = Regions(reg).get_mean_soc_rate(Biome);
                
                %Calc totals
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.calc_tots_from_gridded();
                
                %% Cropland se 5 to 10
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10 = Mitigation;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_accumulated_farm_production = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_accumulated_farm_production-Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_accumulated_farm_production;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_accumulated_farm2ref_transport = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_accumulated_farm2ref_transport-Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_accumulated_farm2ref_transport;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_accumulated_emitted_at_refinery = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_accumulated_emitted_at_refinery-Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_accumulated_emitted_at_refinery;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_accumulated_ccs_or_char = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_accumulated_ccs_or_char-Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_accumulated_ccs_or_char;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_accumulated_fuel_combustion = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_accumulated_fuel_combustion-Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_accumulated_fuel_combustion;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_accumulated_soc_change = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_accumulated_soc_change-Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_accumulated_soc_change;
                %Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_accumulated_soc_change(SOC_change.soc_stock_change_fallow_2_bioenergy_grass <= 0) = 0;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_accumulated_ff_subsitution_ft = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_accumulated_ff_subsitution_ft-Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_accumulated_ff_subsitution_ft;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_accumulated_ff_subsitution_ethanol = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_accumulated_ff_subsitution_ethanol-Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_accumulated_ff_subsitution_ethanol;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_crop_sequestration = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_crop_sequestration-Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_crop_sequestration;
                %Calc totals
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.calc_tots_from_gridded();
                
                % Remove gridded data from RAM, GWP100 calcs
                remove_gridded_data_from_mem = 1;
                remove_wb_scen_data = 1;
                remove_eo_scen_data = 0;
                if Inputs.remove_gridded_data_from_mem == 1
                    skip_this = 0;
                    if Regions(reg).Bioenergy_rf_h(scens).is_wb_scenario == 1
                        if Inputs.remove_wb_scen_data == 0
                            skip_this = 1;
                        elseif Inputs.remove_wb_scen_data == 1
                            skip_this = 0;
                        end
                    end
                    if Regions(reg).Bioenergy_rf_h(scens).is_energy_optimization == 1
                        if Inputs.remove_eo_scen_data == 0
                            skip_this = 1;
                        elseif Inputs.remove_eo_scen_data == 1
                            skip_this = 0;
                        end
                    end
                    
                    if skip_this == 0
                        Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.remove_gridded_data_from_RAM();
                        Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.remove_gridded_data_from_RAM();
                        Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.remove_gridded_data_from_RAM();
                        Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.remove_gridded_data_from_RAM();
                        Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.remove_gridded_data_from_RAM();
                        Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.remove_gridded_data_from_RAM();
                        Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.remove_gridded_data_from_RAM();
                        Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.remove_gridded_data_from_RAM();
                    end
                end
                %Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac
            end
        end
    end
    
    fprintf('Calculating electricity use/substitution.. \n');
    %Electricity
    for reg = 1:length(Regions)
        if strcmp(Regions(reg).region_name, 'Norway')
            gwp100_el_this_tCO2eq_per_GJ = 10^-3*5.6205;
        elseif strcmp(Regions(reg).region_name, 'Sweden')
            gwp100_el_this_tCO2eq_per_GJ = 10^-3*13.5825;
        elseif strcmp(Regions(reg).region_name, 'Denmark')
            gwp100_el_this_tCO2eq_per_GJ = 10^-3*89.0997;
        elseif strcmp(Regions(reg).region_name, 'Finland')
            gwp100_el_this_tCO2eq_per_GJ = 10^-3*66.8327;
        else
            continue
        end
        for scens = 1:length(Regions(reg).Bioenergy_rf_h)
            for refs = 1:length(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows)
                Ref = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).Biorefinery;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_electricity_substitution = -Regions(reg).Bioenergy_rf_h(scens).pe_ac*Ref.electricity_efficiency*gwp100_el_this_tCO2eq_per_GJ*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_electricity_substitution_tot = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_electricity_substitution));
                
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).tco2eq_electricity_substitution_1to1_abc_clearing = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).electricity_fe_aboveground_carbon_clearing*gwp100_el_this_tCO2eq_per_GJ; %1year/instant emission.
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_abc_clearing_electricity_substitution_tot = sum(sum(-Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).tco2eq_electricity_substitution_1to1_abc_clearing));
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_accumulated_abc_clearing_electricity_substitution = -Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).tco2eq_electricity_substitution_1to1_abc_clearing;
                
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_accumulated_electricity_substitution = -Regions(reg).Bioenergy_rf_h(scens).pe_cropland*Ref.electricity_efficiency*gwp100_el_this_tCO2eq_per_GJ*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_accumulated_electricity_substitution_tot = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_accumulated_electricity_substitution));
                
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_accumulated_electricity_substitution = -Regions(reg).Bioenergy_rf_h(scens).pe_cropland_ilswe_4*Ref.electricity_efficiency*gwp100_el_this_tCO2eq_per_GJ*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_accumulated_electricity_substitution_tot = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_accumulated_electricity_substitution));
                
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_accumulated_electricity_substitution = -Regions(reg).Bioenergy_rf_h(scens).pe_cropland_ilswe_5*Ref.electricity_efficiency*gwp100_el_this_tCO2eq_per_GJ*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_accumulated_electricity_substitution_tot = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_accumulated_electricity_substitution));
                
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.tco2eq_accumulated_electricity_substitution = Regions(reg).share_of_cropland_ilswe_also_under_se.*(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_accumulated_electricity_substitution+Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_accumulated_electricity_substitution);
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.tco2eq_accumulated_electricity_substitution_tot = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.tco2eq_accumulated_electricity_substitution));
                
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_accumulated_electricity_substitution = -Regions(reg).Bioenergy_rf_h(scens).pe_cropland_se5*Ref.electricity_efficiency*gwp100_el_this_tCO2eq_per_GJ*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_accumulated_electricity_substitution_tot = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_accumulated_electricity_substitution));
                
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_accumulated_electricity_substitution = -Regions(reg).Bioenergy_rf_h(scens).pe_cropland_se10*Ref.electricity_efficiency*gwp100_el_this_tCO2eq_per_GJ*n_years;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_accumulated_electricity_substitution_tot = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_accumulated_electricity_substitution));
                
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_accumulated_electricity_substitution = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_accumulated_electricity_substitution-Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_accumulated_electricity_substitution;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_accumulated_electricity_substitution_tot = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_accumulated_electricity_substitution));
            end
        end
    end
    
    fprintf('Calculating Nordic region mitigation.. \n');
    for reg = 1:length(Regions)
        if strcmp(Regions(reg).region_name, 'Nordic_region')
            for scens = 1:length(Regions(reg).Bioenergy_rf_h)
                
                for refs = 1:length(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows)
                    Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac = Mitigation;
                    Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland = Mitigation;
                    Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4 = Mitigation;
                    Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5 = Mitigation;
                    Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5 = Mitigation;
                    Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10 = Mitigation;
                    Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10 = Mitigation;
                    
                    Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.set_to_zeros_1d();
                    Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.set_to_zeros_1d();
                    Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.set_to_zeros_1d();
                    Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.set_to_zeros_1d();
                    Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.set_to_zeros_1d();
                    Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.set_to_zeros_1d();
                    Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.set_to_zeros_1d();
                    Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.set_to_zeros_1d();
                    
                    
                    for reg2 = 1:length(Regions)
                        if ~strcmp(Regions(reg2).region_name, 'Nordic_region')
                            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac+Regions(reg2).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac;
                            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland+Regions(reg2).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland;
                            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4+Regions(reg2).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4;
                            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5+Regions(reg2).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5;
                            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5+Regions(reg2).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5;
                            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5+Regions(reg2).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5;
                            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10+Regions(reg2).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10;
                            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10+Regions(reg2).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10;
                        end
                        
                    end
                end
            end
        end
    end
    
    for reg = 1:length(Regions)
        for scens = 1:length(Regions(reg).Bioenergy_rf_h)
            for refs = 1:length(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows)
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.calc_tot_from_tots;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.calc_tot_from_tots;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.calc_tot_from_tots;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.calc_tot_from_tots;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.calc_tot_from_tots;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.calc_tot_from_tots;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.calc_tot_from_tots;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.calc_tot_from_tots;
                
                temp = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4+Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5-Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5;
                temp = temp.multiply_object_with_factor(Inputs.share_of_cropland_under_wind_erosion_for_bioenergy);
                temp = temp +Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5;
                Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy = temp;
                clear('temp');
            end
        end
    end
    
    
    %% GET GRIDDED MITIGATION NUMBERS, TARGETTED NORDIC WB Scenario
    for reg = 1:length(Regions)
        if reg > 1
            continue
        end
        
        for refs = 1:length(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows)
            scens = 7; %HARDCODE
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.calc_gridded_nets(Regions(reg).abandoned_cropland_hectare, ['Output/' Regions(reg).region_name '_' Regions(1).Bioenergy_rf_h(7).Biorefinery_energy_carbon_flows(1).Biorefinery.description '_ac.nc']);
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.calc_gridded_nets(Regions(reg).cropland_hectare);
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.calc_gridded_nets(Regions(reg).cropland_ilswe_4_hectare);
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.calc_gridded_nets(Regions(reg).cropland_ilswe_5_hectare);
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.calc_gridded_nets(Regions(reg).cropland_both_ilswe_4_5_se_5);
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.calc_gridded_nets(Regions(reg).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare);
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.calc_gridded_nets(Regions(reg).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare-Regions(reg).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare);
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.calc_gridded_nets(Regions(reg).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare);
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.calc_gridded_nets(Regions(reg).cropland_under_soil_erosion_mod_high_4bioenergy_hectare, ['Output/' Regions(reg).region_name '_' Regions(1).Bioenergy_rf_h(7).Biorefinery_energy_carbon_flows(1).Biorefinery.description '_cropland_se.nc']);
            
            %Get annual mitigation
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_per_ha_year_gridded_net_mitigation_annual = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_per_year_gridded_net_mitigation_annual./Regions(reg).abandoned_cropland_hectare;
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_per_ha_year_gridded_net_mitigation_annual(isnan(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_per_ha_year_gridded_net_mitigation_annual)) = 0;
            
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_per_ha_year_gridded_net_mitigation_annual = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_per_year_gridded_net_mitigation_annual./Regions(reg).cropland_hectare;
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_per_ha_year_gridded_net_mitigation_annual(isnan(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_per_ha_year_gridded_net_mitigation_annual)) = 0;
            
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_per_ha_year_gridded_net_mitigation_annual = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_per_year_gridded_net_mitigation_annual./Regions(reg).cropland_ilswe_4_hectare;
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_per_ha_year_gridded_net_mitigation_annual(isnan(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_per_ha_year_gridded_net_mitigation_annual)) = 0;
            
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_per_ha_year_gridded_net_mitigation_annual = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_per_year_gridded_net_mitigation_annual./Regions(reg).cropland_ilswe_5_hectare;
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_per_ha_year_gridded_net_mitigation_annual(isnan(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_per_ha_year_gridded_net_mitigation_annual)) = 0;
            
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.tco2eq_per_ha_year_gridded_net_mitigation_annual = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.tco2eq_per_year_gridded_net_mitigation_annual./Regions(reg).cropland_both_ilswe_4_5_se_5;
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.tco2eq_per_ha_year_gridded_net_mitigation_annual(isnan(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.tco2eq_per_ha_year_gridded_net_mitigation_annual)) = 0;
            
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_per_ha_year_gridded_net_mitigation_annual = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_per_year_gridded_net_mitigation_annual./Regions(reg).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare;
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_per_ha_year_gridded_net_mitigation_annual(isnan(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_per_ha_year_gridded_net_mitigation_annual)) = 0;
            
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_per_ha_year_gridded_net_mitigation_annual = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_per_year_gridded_net_mitigation_annual./Regions(reg).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare;
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_per_ha_year_gridded_net_mitigation_annual(isnan(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_per_ha_year_gridded_net_mitigation_annual)) = 0;
            
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_per_ha_year_gridded_net_mitigation_annual = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_per_year_gridded_net_mitigation_annual./(Regions(reg).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare-Regions(reg).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare);
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_per_ha_year_gridded_net_mitigation_annual(isnan(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_per_ha_year_gridded_net_mitigation_annual)) = 0;
            
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.tco2eq_per_ha_year_gridded_net_mitigation_annual = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.tco2eq_per_year_gridded_net_mitigation_annual./(Regions(reg).cropland_under_soil_erosion_mod_high_4bioenergy_hectare);
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.tco2eq_per_ha_year_gridded_net_mitigation_annual(isnan(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.tco2eq_per_ha_year_gridded_net_mitigation_annual)) = 0;
            
            
            %Get annual mean mitigation per hectare
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.tco2eq_per_year_gridded_net_mitigation_annual))/sum(sum(Regions(reg).abandoned_cropland_hectare(Regions(reg).Bioenergy_rf_h(scens).pe_ac > 0)));
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.tco2eq_per_year_gridded_net_mitigation_annual))/sum(sum(Regions(reg).cropland_hectare(Regions(reg).Bioenergy_rf_h(scens).pe_cropland > 0)));
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.tco2eq_per_year_gridded_net_mitigation_annual))/sum(sum(Regions(reg).cropland_ilswe_4_hectare(Regions(reg).Bioenergy_rf_h(scens).pe_cropland_ilswe_4 > 0)));
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.tco2eq_per_year_gridded_net_mitigation_annual))/sum(sum(Regions(reg).cropland_ilswe_5_hectare(Regions(reg).Bioenergy_rf_h(scens).pe_cropland_ilswe_5 > 0)));
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.tco2eq_per_year_gridded_net_mitigation_annual))/sum(sum(Regions(reg).cropland_both_ilswe_4_5_se_5(Regions(reg).Bioenergy_rf_h(scens).pe_cropland_both_se5_and_ilswe_4_5 > 0)));
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.tco2eq_per_year_gridded_net_mitigation_annual))/sum(sum(Regions(reg).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare(Regions(reg).Bioenergy_rf_h(scens).pe_cropland_se5 > 0)));
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.tco2eq_per_year_gridded_net_mitigation_annual))/sum(sum(Regions(reg).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare(Regions(reg).Bioenergy_rf_h(scens).pe_cropland_se10 > 0)));
            temp = (Regions(reg).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare-Regions(reg).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare);
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.tco2eq_per_year_gridded_net_mitigation_annual))/sum(sum(temp(temp > 0)));
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean = sum(sum(Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.tco2eq_per_year_gridded_net_mitigation_annual))/sum(sum(Regions(reg).cropland_under_soil_erosion_mod_high_4bioenergy_hectare(Regions(reg).Bioenergy_rf_h(scens).pe_cropland_se_wat_wind_4bioenergy > 0)));
            
            %Calc standard deviations
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.calc_standard_deviation(Regions(reg).abandoned_cropland_hectare);
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland.calc_standard_deviation(Regions(reg).cropland_hectare);
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4.calc_standard_deviation(Regions(reg).cropland_ilswe_4_hectare);
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5.calc_standard_deviation(Regions(reg).cropland_ilswe_5_hectare);
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5.calc_standard_deviation(Regions(reg).cropland_both_ilswe_4_5_se_5);
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5.calc_standard_deviation(Regions(reg).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare);
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10.calc_standard_deviation(Regions(reg).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare);
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10 = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10.calc_standard_deviation(Regions(reg).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare-Regions(reg).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare);
            Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy = Regions(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.calc_standard_deviation(Regions(reg).cropland_under_soil_erosion_mod_high_4bioenergy_hectare);
        end
    end
    
    %% PLOTS
    if plot_stuff == 1
        plot_fig1d(Regions(2:end));
        generate_fig3(Regions, BiorefineryArray);
        plot_final_energy(Regions(1:end));
        plot_aboveground_carbon_stock_ac(Regions);
        
        for reg = 1:length(Regions)
            
            Regions(reg).plot_ac_distribution_after_abandonment( ABC );
            
            
            for scens = 1:length(Regions(reg).Bioenergy_rf_h)
                
                if reg == 4 && scens == 1
                    continue
                end
                Regions(reg).plot_mitigation(scens, Inputs, Natural_regrowth);
            end
        end
        
        export_src_data_fig1( Regions(1) )
        export_src_data_fig2( Regions(1) )
        export_key_results_2mat(Regions)
        
    end
    
    % else
    %
    % end
end

toc