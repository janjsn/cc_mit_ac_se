function plot_pixel_comparisons_yields_be_af( obj )
%PLOT_PIXEL_COMPARISONS_YIELDS_BE_AF Summary of this function goes here
%   Detailed explanation goes here
acs_nr_cropland = obj.acs_nr_rate_cropland;
carbon_yield_be = obj.Bioenergy_rf_h(7).carbon_yield_cropland;


binary_productive = carbon_yield_be > 0;

carbon_yield_be_vec = carbon_yield_be(binary_productive);
acs_nr_vec = acs_nr_cropland(binary_productive);

plot(acs_nr_vec, carbon_yield_be_vec);
print(

end

