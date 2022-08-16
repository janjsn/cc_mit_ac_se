ac_carbon_yield = Regions(1).Bioenergy_rf_h(7).carbon_yield_ac;
se_carbon_yield = Regions(1).Bioenergy_rf_h(7).carbon_yield_cropland;
binary_productive_se = Regions(1).Bioenergy_rf_h(7).pe_cropland_se_wat_wind_4bioenergy > 0;
se_carbon_yield(binary_productive_se == 0) = -999;

ac_nat_reg_carbon_yield = Regions(1).acs_nr_rate_abandoned_cropland;
se_nat_reg_carbon_yield = Regions(1).acs_nr_cropland;
se_nat_reg_carbon_yield(binary_productive_se == 0) = -999;


