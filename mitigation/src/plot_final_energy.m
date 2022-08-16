function plot_final_energy( Region_array )
%PLOT_FINAL_ENERGY Summary of this function goes here
%   Detailed explanation goes here
output_folder = 'Output/plots/';
description = 'final_energy';

n_regs = length(Region_array);
n_refs = length(Region_array(1).Bioenergy_rf_h(1).Biorefinery_energy_carbon_flows);


x_labels = cell(1,n_regs-1);

%% Country contributions per technology

for scens = 1:length(Region_array(1).Bioenergy_rf_h)
    plot_matrix = zeros(3,4);
    for i = 1:n_regs
        if strcmp('Nordic_region', Region_array(i).region_name) 
            continue
        end
        
        for refs = 1:length(Region_array(i).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows)
            plot_matrix(refs,i-1) = Region_array(i).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).fe_cropland_all_se_wb_tot;
        end
        
        if Region_array(i).Bioenergy_rf_h(scens).is_wb_scenario == 1
            scen_description ='wb_scen';
        elseif Region_array(i).Bioenergy_rf_h(scens).is_energy_optimization == 1
            scen_description ='eo_scen';
        elseif Region_array(i).Bioenergy_rf_h(scens).is_carbon_optimization == 1
            scen_description ='co_scen';
        elseif Region_array(i).Bioenergy_rf_h(scens).is_single_crop == 1
            
            scen_description =Region_array(i).Bioenergy_rf_h(scens).crop_names;
        end
        
        
    end
    
    
    plot_matrix = plot_matrix*10^-6;
    
    figure
    bar(plot_matrix,'stacked')
    ylabel('PJ yr-1')
    
    xticklabels({'Current refinery', 'Future refinery', 'Future BECCS refinery'});
    
    legend('Norway', 'Sweden', 'Finland', 'Denmark', 'location', 'Northwest')
    
    
    filename = [output_folder 'Nordic_' description '_' scen_description '.pdf' ];
    
    
    
    print('-painters','-dpdf', '-r1000', filename)
end


%% Final energy per land use



for scens = 1:length(Region_array(1).Bioenergy_rf_h)
    plotMatrix = zeros(n_refs*(n_regs-1),6);
    for reg = 1:n_regs
        if strcmp('Nordic_region', Region_array(reg).region_name) 
            continue
        end
        for refs = 1:length(Region_array(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows)
            idx1 = (reg-2)*n_refs+refs;
            
            plotMatrix(idx1, 1) = Region_array(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).fe_ac_tot;
            
            fe_ilswe_4_tot = (1/3)*sum(sum(Region_array(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).fe_cropland_ilswe_4.*(1-Region_array(reg).share_of_cropland_ilswe_also_under_se)));
            fe_ilswe_5_tot = (1/3)*sum(sum(Region_array(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).fe_cropland_ilswe_5.*(1-Region_array(reg).share_of_cropland_ilswe_also_under_se)));
            fe_se5_to_10 =  Region_array(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).fe_cropland_se5 -  Region_array(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).fe_cropland_se10;
            
            multiple_impacts_deployed = Region_array(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).fe_cropland_both_se5_and_ilswe_4_5;
            
            fe_se5_to_10(fe_se5_to_10 > 0) = fe_se5_to_10(fe_se5_to_10 > 0)-multiple_impacts_deployed(fe_se5_to_10 > 0);
            fe_se5_to_10_tot = sum(sum(fe_se5_to_10));
            fe_se10 = Region_array(reg).Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).fe_cropland_se10;
            fe_se10(fe_se10 > 0) = fe_se10(fe_se10 > 0)-multiple_impacts_deployed(fe_se10 > 0);
            fe_se10_tot = sum(sum(fe_se10));
            
            fe_multiple_impacts_tot = sum(sum(multiple_impacts_deployed));
            
            plotMatrix(idx1, 2) = fe_ilswe_4_tot;
            plotMatrix(idx1, 3) = fe_ilswe_5_tot;
            plotMatrix(idx1,4) = fe_se5_to_10_tot;
            plotMatrix(idx1, 5) = fe_se10_tot;
            plotMatrix(idx1, 6) = fe_multiple_impacts_tot;
            
        end
    end
    
    if Region_array(reg).Bioenergy_rf_h(scens).is_wb_scenario == 1
        scen_description ='wb_scen';
    elseif Region_array(reg).Bioenergy_rf_h(scens).is_energy_optimization == 1
        scen_description ='eo_scen';
    elseif Region_array(reg).Bioenergy_rf_h(scens).is_carbon_optimization == 1
        scen_description ='co_scen';
    elseif Region_array(reg).Bioenergy_rf_h(scens).is_single_crop == 1
        
        scen_description =Region_array(i).Bioenergy_rf_h(scens).crop_names;
    end
    plotMatrix = plotMatrix*10^-6;
    figure
    bar(plotMatrix,'stacked')
    ylabel('PJ yr-1')
    
    legend('Abandoned cropland', 'Moderate wind erosion', 'High wind erosion', 'Moderate water erosion', 'High water erosion', 'Multiple impacts', 'Location', 'Northwest')
    
    description = 'final_energy_per_country_lu';
    filename = [output_folder 'Nordic_' description '_' scen_description '.pdf' ];
        
    print('-painters','-dpdf', '-r1000', filename)
    
    filename = [output_folder 'src_data_Nordic_' description '_' scen_description '.mat' ];
    save(filename, 'plotMatrix');
end






end

