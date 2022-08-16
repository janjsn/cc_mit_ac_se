function  plot_dm_yield_vs_soc_bio( obj, SOC_change )
%PLOT_DM_YIELD_VS_SOC_BIO Summary of this function goes here
%   Detailed explanation goes here

output_folder = 'Output/';
carbon_yield_wb_scen_ac = obj.Bioenergy_rf_h(7).carbon_yield_ac;
carbon_yield_wb_scen_cropland = obj.Bioenergy_rf_h(7).carbon_yield_cropland;

productive_ac = obj.Bioenergy_rf_h(7).pe_ac > 0;
productive_cropland = obj.Bioenergy_rf_h(7).pe_cropland_se_wat_wind_4bioenergy > 0;

soc_carbon_yield_ac = SOC_change.soc_stock_change_fallow_2_bioenergy_grass/20;
soc_carbon_yield_se = SOC_change.soc_stock_change_annual_crop_2_bioenergy_grass/20;

x_vec_ac = carbon_yield_wb_scen_ac(productive_ac);
x_vec_cropland = carbon_yield_wb_scen_cropland(productive_cropland);
y_vec_ac = soc_carbon_yield_ac(productive_ac);
y_vec_cropland = soc_carbon_yield_se(productive_cropland);



x_vec = [x_vec_ac
 x_vec_cropland];
y_vec = [y_vec_ac
y_vec_cropland];
sum(y_vec > 0)
sum(y_vec < 0)
sum(y_vec == 0)
max(y_vec)
min(y_vec)

binary_positive = y_vec > 0; %Clean data
x_vec = x_vec(binary_positive);
y_vec = y_vec(binary_positive);
sum(x_vec)/sum(y_vec)

R = corrcoef(x_vec, y_vec)

figure
scatter(x_vec, y_vec);
hold on
plot([0:1:12],[0:1:12]);
ylabel('ton C ha^{-1} yr^{-1}');
xlabel('ton C ha^{-1} yr^{-1}');
legend('datapoints', '1:1 line')

box on
filename = [output_folder obj.region_name '_carbon_yield_comparison_aboveground_and_belowground_bioenergy.pdf'];
if exist(filename, 'file')
   delete(filename); 
end
print('-painters','-dpdf', '-r1000', filename)

save('src_aboveground_vs_belowground_yields.mat', 'x_vec', 'y_vec');
end

