function  generate_fig3( Regions_array, Bioenergy_refinery_array )
%GENERATE_FIG3 Summary of this function goes here
%   Detailed explanation goes here


share_windbreak_willow = (1/3);

share_bc_se = 1;

matrix = zeros(6,length(Regions_array));


pos_eo = 5;
pos_wb = 6;

legends = cell(1,length(Regions_array)-1);

c=1;
for  i = 1:length(Regions_array)
    if strcmp(Regions_array(i).region_name, 'Nordic_region')
        continue
    end
    %Abandoned cropland
    matrix(1,c) = Regions_array(i).Bioenergy_rf_h(pos_eo).pe_ac_tot;
    %     matrix(3,i) = Regions_array(i).Bioenergy_rf_h(pos_eo).pe_cropland_se10_tot;
    %     matrix(2,i) = Regions_array(i).Bioenergy_rf_h(pos_eo).pe_cropland_se5_tot-matrix(3,i);
    %     matrix(5,i) = Regions_array(i).Bioenergy_rf_h(pos_wb).pe_cropland_ilswe_5_tot*share_windbreak_willow;
    %     matrix(4,i) = Regions_array(i).Bioenergy_rf_h(pos_wb).pe_cropland_ilswe_4_tot*share_windbreak_willow;
    
    pe_se5_10 = Regions_array(i).Bioenergy_rf_h(pos_eo).pe_cropland_se5 - Regions_array(i).Bioenergy_rf_h(pos_eo).pe_cropland_se10;
    pe_se5_10 = pe_se5_10- Regions_array(i).Bioenergy_rf_h(pos_eo).pe_cropland_both_se5_and_ilswe_4_5;
    pe_se5_10(pe_se5_10 < 0) = 0;
    matrix(2,c) = sum(sum(pe_se5_10));
    
    pe_se10 = Regions_array(i).Bioenergy_rf_h(pos_eo).pe_cropland_se10-Regions_array(i).Bioenergy_rf_h(pos_eo).pe_cropland_both_se5_and_ilswe_4_5;
    pe_se10(pe_se10 < 0) = 0;
    matrix(3,c) = sum(sum(pe_se10));
    
    matrix(4,c) = sum(sum(Regions_array(i).Bioenergy_rf_h(pos_wb).pe_cropland_ilswe_4.*(1-Regions_array(i).share_of_cropland_ilswe_also_under_se)))*share_windbreak_willow;
    matrix(5,c) = sum(sum(Regions_array(i).Bioenergy_rf_h(pos_wb).pe_cropland_ilswe_5.*(1-Regions_array(i).share_of_cropland_ilswe_also_under_se)))*share_windbreak_willow;
    matrix(6,c) = Regions_array(i).Bioenergy_rf_h(pos_wb).pe_cropland_both_se5_and_ilswe_4_5_tot;
    
    legends{c} = Regions_array(i).region_name;
    c=c+1;
end
x_labels = {'Abandoned cropland', 'Moderate water erosion', 'High water erosion', 'Moderate wind erosion', 'High wind erosion', 'Multiple impacts'};



bar(matrix*10^-6, 'stacked');
ylabel('PJ yr-1')
xticklabels(x_labels);

legend(string(legends), 'Location', 'northwest')

filename = 'Output/fig_pe.pdf';
print('-painters','-dpdf', '-r1000', filename)

save('src_data_fig_pe.mat', 'matrix');

% %Try inverse plot
% figure
% matrix2 = matrix';
%
% bar(matrix2*10^-6, 'stacked');
% ylabel('PJ yr-1');
% xticklabels(legends);
% legend(string({'Abandoned cropland', 'Moderate erosion by water', 'High erosion by water', 'Moderate erosion by wind', 'High erosion by wind'}), 'Location', 'northwest');
%

%% Final energy
n_refs = length(Bioenergy_refinery_array);

matrix_fe = zeros(n_refs,length(Regions_array));

c=1;
for i = 1:length(Regions_array)
    if strcmp(Regions_array(i).region_name, 'Nordic_region')
        continue
    end
    for j = 1:n_refs
        matrix_fe(j,c) = sum(matrix(:,c))*Bioenergy_refinery_array(j).energy_efficiency;
    end
    c=c+1;
end

figure
bar(matrix_fe*10^-6, 'stacked');

legend(string(legends), 'Location', 'northwest')
ylabel('PJ yr-1');
xticklabels({'Current biorefinery', 'Future biorefinery', 'Future BECCS refinery'});
xtickangle(45)
%legend({''})

filename = 'Output/fig3_fe.pdf';
print('-painters','-dpdf', '-r1000', filename)

save('src_data_fig_fe.mat', 'matrix_fe');

end



