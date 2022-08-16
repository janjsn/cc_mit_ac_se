function print_bioenergy_yields(Region)

cropland = Region.cropland_hectare;
ac = Region.abandoned_cropland_hectare;

land = cropland+ac;

for i = 1:length(Region.Bioenergy_rf_h)
    
    if Region.Bioenergy_rf_h(i).is_single_crop == 1
        fprintf(['Printing for crop ID: ' num2str(Region.Bioenergy_rf_h(i).crop_id_vector) '\n']);
    elseif Region.Bioenergy_rf_h(i).is_energy_optimization == 1
        fprintf('Printing for energy optimization. \n')
    elseif Region.Bioenergy_rf_h(i).is_carbon_optimization == 1
        fprintf('Printing for carbon optimization. \n');
    end
    
    
    productive_land = sum(sum(land(Region.Bioenergy_rf_h(i).bioenergy_yield > 0)));
    
    production = sum(sum(Region.Bioenergy_rf_h(i).pe_cropland + Region.Bioenergy_rf_h(i).pe_ac));
    
    mean_yield = production/productive_land;
    
    fprintf('Mean bioenergy yield on productive land:');
    fprintf(num2str(mean_yield));
    fprintf('GJ ha-1 yr-1 \n');
    
end




end