function plot_mitigation_per_ha_with_std_30y( obj, Inputs )
%PLOT_MITIGATION_PER_HA_WITH_STD_30Y Summary of this function goes here
%   Detailed explanation goes here
output_folder = 'Output/plots/';


for scens = 1:length(obj.Bioenergy_rf_h)
    if scens ~= 7
       continue 
    end
    
    if obj.Bioenergy_rf_h(scens).is_wb_scenario == 1
        scen_description ='wb_scen_20ySOC';
    elseif obj.Bioenergy_rf_h(scens).is_energy_optimization == 1
        scen_description ='eo_scen_20ySOC';
    elseif obj.Bioenergy_rf_h(scens).is_carbon_optimization == 1
        scen_description ='co_scen_20ySOC';
    elseif obj.Bioenergy_rf_h(scens).is_single_crop == 1
        
        scen_description =obj.Bioenergy_rf_h(scens).crop_names;
    end
    
    if Inputs.share_of_aboveground_carbon_harvested_for_bioenergy == 0
        scen_description = [scen_description '_burned_abc'];
    end
    
    
    for refs = 1:length(obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows)
        
        if refs == 1
            desc_ref = 'current_ref';
        elseif refs == 2
            desc_ref = 'future_ref';
        elseif refs == 3 
            desc_ref = 'beccs';
        end
        filename = 'mitigation_per_hectare_30y_abandoned_cropland.pdf';
        filename_src = [ output_folder 'src/src_data_' obj.region_name '_' scen_description '_' desc_ref '_' filename(1:end-4) '.mat'];
        filename = [output_folder obj.region_name '_' scen_description '_' filename];
        
        obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac.plot_mitigation_per_ha_with_std( filename_src)
        
        filename = 'mitigation_per_hectare_30y_cropland_soil_erosion.pdf';
        filename_src = [ output_folder 'src/src_data_' obj.region_name '_' scen_description '_' desc_ref '_' filename(1:end-4) '.mat'];
        filename = [output_folder obj.region_name '_' scen_description '_' filename];
        
        obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.plot_mitigation_per_ha_with_std( filename_src)
    end
end
end

