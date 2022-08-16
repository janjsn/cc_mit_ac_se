function plot_fig1d( Region_array )
%PLOT_FIG1D Summary of this function goes here
%   Detailed explanation goes here

length(Region_array)

matrix = zeros(length(Region_array),6);

x_labels = cell(1,length(Region_array));

for i = 1:length(Region_array)
   matrix(i,1) = sum(sum(Region_array(i).abandoned_cropland_hectare));
   
   se_5 = Region_array(i).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare-Region_array(i).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare;
   se_5 = se_5-(Region_array(i).cropland_both_ilswe_4_5_se_5); %Whole cell to bioenergy
   se_5(se_5 < 0) = 0;
   matrix(i,2) = sum(sum(se_5));
   
   se_10 = Region_array(i).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare-(Region_array(i).cropland_both_ilswe_4_5_se_5);%whole cell to bioenergy
   se_10(se_10 < 0) = 0; %This is ok since se data resolution is 0.25deg.
   matrix(i,3) = sum(sum(se_10));
   matrix(i,4) = sum(sum(Region_array(i).cropland_ilswe_4_hectare.*(1-Region_array(i).share_of_cropland_ilswe_also_under_se)))/3; %1/3 to bioenergy
   matrix(i,5) = sum(sum(Region_array(i).cropland_ilswe_5_hectare.*(1-Region_array(i).share_of_cropland_ilswe_also_under_se)))/3; %1/3 to bioenergy
   matrix(i,6) = sum(sum(Region_array(i).cropland_both_ilswe_4_5_se_5)); %whole cell to bioenergy
   
%    matrix(i,2) = sum(sum((Region_array(i).cropland_under_pressure == 1).*Region_array(i).cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare));
%    matrix(i,3) = sum(sum((Region_array(i).cropland_under_pressure == 2).*Region_array(i).cropland_soil_erosion_above_10_ton_perHa_perYear_unit_hectare));
%    
%    
%    matrix(i,4) = sum(sum((Region_array(i).cropland_under_pressure == 3).*Region_array(i).cropland_ilswe_4_hectare.*(1-Region_array(i).share_of_cropland_ilswe_also_under_se)))/3;
%    matrix(i,5) = sum(sum((Region_array(i).cropland_under_pressure == 4).*Region_array(i).cropland_ilswe_5_hectare.*(1-Region_array(i).share_of_cropland_ilswe_also_under_se)))/3;
%    matrix(i,6) = sum(sum((Region_array(i).cropland_under_pressure == 6).*Region_array(i).cropland_both_ilswe_4_5_se_5))/3; 
   
   
   

% matrix(i,3) = Region_array(i).total_available_area_SE_threshold_10_hectare
% matrix(i,2) = Region_array(i).total_available_area_SE_threshold_5_hectare-matrix(i,3);
% matrix(i,4) = sum(sum(Region_array(i).cropland_ilswe_4_hectare));
% matrix(i,5) = sum(sum(Region_array(i).cropland_ilswe_5_hectare));
   
   x_labels{i} = Region_array(i).region_name;
end

size(matrix)

figure
p = bar(matrix*10^-3, 'stacked');
hold on


ylabel('kha')
legend(string({'Abandoned cropland', 'Moderate water erosion', 'High water erosion', 'Moderate wind erosion', 'High wind erosion', 'Multiple impacts'}), 'Location', 'northwest');

xticklabels(x_labels);
%colors = {	'm', [1 1 0], [1 0 0], [0 1 1],[0 0 1], [0 0 0]};
colors = {	'#77AC30', 'y', 'r', 'c','b', 'm'};

for i=1:length(colors)
   p(i).FaceColor =colors{i};
end

filename = 'Output/fig1d_land.pdf';
print('-painters','-dpdf', '-r1000', filename)

save('Output/src_data_1d', 'matrix');

end

