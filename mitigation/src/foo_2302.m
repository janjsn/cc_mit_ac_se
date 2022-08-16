idx = 7;
n_years = 20;

for reg = 1:5
    fprintf([Regions(reg).region_name '\n']);
for ref = 1:3
    fprintf([Regions(reg).Bioenergy_rf_h(idx).Biorefinery_energy_carbon_flows(ref).Biorefinery.description '\n']);
    fprintf('ac mitigation: ' )
    ac_mit = 10^-6*Regions(reg).Bioenergy_rf_h(idx).Biorefinery_energy_carbon_flows(ref).GWP100_ac.tco2eq_total_mitigation_with_abc/n_years;
   fprintf(num2str(ac_mit));
   fprintf('\n');
   fprintf('se mitigation: ')
   se_mit = 10^-6*Regions(reg).Bioenergy_rf_h(idx).Biorefinery_energy_carbon_flows(ref).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy.tco2eq_total_mitigation_with_abc/n_years;
    fprintf(num2str(se_mit));
    fprintf('\n');
   fprintf('total mitigation: ')
   fprintf(num2str(se_mit+ac_mit));
   fprintf('\n');
   
    
    
end
end