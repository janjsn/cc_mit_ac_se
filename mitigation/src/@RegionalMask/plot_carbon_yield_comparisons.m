function plot_carbon_yield_comparisons( obj )
%PLOT_CARBON_YIELD_COMPARISONS Summary of this function goes here
%   Detailed explanation goes here

output_folder = 'Output/';

nr_carbon_yield_ac = obj.acs_nr_rate_abandoned_cropland;
nr_carbon_yield_cropland = obj.acs_nr_rate_cropland;

carbon_yield_wb_scen_ac = obj.Bioenergy_rf_h(7).carbon_yield_ac;
carbon_yield_wb_scen_cropland = obj.Bioenergy_rf_h(7).carbon_yield_cropland;

productive_ac = obj.Bioenergy_rf_h(7).pe_ac > 0;
productive_cropland = obj.Bioenergy_rf_h(7).pe_cropland_se_wat_wind_4bioenergy > 0;

x_vec_ac = nr_carbon_yield_ac(productive_ac);
y_vec_ac = carbon_yield_wb_scen_ac(productive_ac);

figure
scatter(x_vec_ac, y_vec_ac);
hold on
plot([0:1:10],[0:1:10]);
ylabel('ton C ha^{-1} yr^{-1}');
xlabel('ton C ha^{-1} yr^{-1}');

filename = [output_folder obj.region_name '_carbon_yield_comparison_bioenergy_natural_regrowth_ac.pdf'];
if exist(filename, 'file')
   delete(filename); 
end
print('-painters','-dpdf', '-r1000', filename)

x_vec_cropland = nr_carbon_yield_cropland(productive_cropland);
y_vec_cropland = carbon_yield_wb_scen_cropland(productive_cropland);

figure
scatter(x_vec_cropland, y_vec_cropland);
hold on
plot([0:1:10],[0:1:10]);
ylabel('ton C ha^{-1} yr^{-1}');
xlabel('ton C ha^{-1} yr^{-1}');

filename = [output_folder obj.region_name '_carbon_yield_comparison_bioenergy_natural_regrowth_cropland_se.pdf'];
if exist(filename, 'file')
   delete(filename); 
end
print('-painters','-dpdf', '-r1000', filename)

x_vec = [x_vec_ac
 x_vec_cropland];
y_vec = [y_vec_ac
 y_vec_cropland];

sum(y_vec(x_vec > 0))/sum(x_vec(x_vec > 0))

figure
scatter(x_vec, y_vec);
hold on
plot([0:1:10],[0:1:10]);
ylabel('ton C ha^{-1} yr^{-1}');
xlabel('ton C ha^{-1} yr^{-1}');

box on
filename = [output_folder obj.region_name '_carbon_yield_comparison_bioenergy_natural_regrowth_all_considered_land.pdf'];
if exist(filename, 'file')
   delete(filename); 
end
print('-painters','-dpdf', '-r1000', filename)

end

