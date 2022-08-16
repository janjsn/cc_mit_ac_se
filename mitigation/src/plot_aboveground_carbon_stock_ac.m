function  plot_aboveground_carbon_stock_ac( Regions_array )
%PLOT_ABOVEGROUND_CARBON_STOCK_AC Summary of this function goes here
%   Detailed explanation goes here


c = 1;
x_labels = cell(1,4);

for i = 1:length(Regions_array)
    if strcmp(Regions_array(i).region_name, 'Nordic_region')
       continue 
    end
    carbon_stock(c) = 10^-6*sum(sum(Regions_array(i).aboveground_carbon_on_abandoned_cropland_ton_C));
    
    x_labels{c} = Regions_array(i).region_name;
    
    c=c+1;
end

figure
bar(carbon_stock);

xticklabels(x_labels);
ylabel('MtC');
filename = 'Output/plots/Aboveground_carbon_stock.pdf';
print('-painters','-dpdf', '-r1000', filename)

filename_src = 'Output/plots/src_data_aboveground_carbon_stock.pdf';
save(filename_src, 'carbon_stock', 'x_labels' )
end

