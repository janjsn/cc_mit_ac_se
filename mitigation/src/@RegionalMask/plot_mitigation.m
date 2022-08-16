function plot_mitigation( obj, idx_bioenergy_rf_h, Inputs, Nat_reg )
%PLOT_MITIGATION Summary of this function goes here
%   Detailed explanation goes here

output_folder = 'Output/plots/';

C_to_CO2 = 3.67;

scens = idx_bioenergy_rf_h;

src_data_ac = cell(1,length(obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows));

figure

ymin = 0;

initial_penalty_vec = zeros(1,length(obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows));
for refs = 1:length(obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows)
    GWP_ac = obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac;
    
    yearly_mitigation_ac = GWP_ac.tco2eq_total_mitigation/GWP_ac.time_period_years;
    initial_penalty = sum(sum(GWP_ac.tco2eq_total_mitigation_with_abc))-GWP_ac.tco2eq_total_mitigation;
    initial_penalty = initial_penalty*10^-6;
    initial_penalty_vec(refs) = initial_penalty;
    x_vec = [0:1:15];
    y_vec = (x_vec*yearly_mitigation_ac)+initial_penalty;
    y_vec = -10^-6*y_vec;
    
    src_data_ac{refs} = y_vec;
    
    plot(x_vec, -y_vec);
    
    if min(y_vec) < ymin
        ymin = min(y_vec);
    end
    
    hold on
end

ymax = max(y_vec);
ymax = ceil(ymax/10)*10;




ymin = floor(ymin/10)*10;

%Continued regrowth
soil_carbon_accumulation_tonC_per_ha_year =obj.mean_soil_carbon_seq_rate_of_nat_regrowth_tonC_per_ha_year;
y_vec_ac_nat_reg = 10^-6*x_vec*(obj.mean_natural_regrowth_ac_tonC_per_ha_year+soil_carbon_accumulation_tonC_per_ha_year)*3.67*sum(sum(obj.abandoned_cropland_hectare));
%y_vec
plot(x_vec,-y_vec_ac_nat_reg);
hold on

filename = 'mitigation_abandoned_cropland.pdf';

if obj.Bioenergy_rf_h(scens).is_wb_scenario == 1
    scen_description ='wb_scen';
elseif obj.Bioenergy_rf_h(scens).is_energy_optimization == 1
    scen_description ='eo_scen';
elseif obj.Bioenergy_rf_h(scens).is_carbon_optimization == 1
    scen_description ='co_scen';
elseif obj.Bioenergy_rf_h(scens).is_single_crop == 1
    
    scen_description =obj.Bioenergy_rf_h(scens).crop_names;
end

filename_src = [ output_folder 'src_data_' obj.region_name '_' scen_description '_' filename(1:end-4) '.mat'];

filename = [output_folder obj.region_name '_' scen_description '_' filename];
ylabel('MtCO2-eq');
xlabel('years');



ylim([-ymax -ymin ]);

legend('Current refinery', 'Future refinery', 'Future BECCS refinery', 'Continued natural regrowth', 'location', 'Southwest');
print('-painters','-dpdf', '-r1000', filename)

save(filename_src, 'src_data_ac', 'y_vec_ac_nat_reg', 'x_vec' )

%%

figure

GWP_cropland_under_pressure_array(1:length(obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows)) = Mitigation;

src_data_cse = cell(1,length(obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows));

for refs = 1:length(obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows)
    GWP100_cropland_ilswe_4 = obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_4;
    GWP100_cropland_ilswe_5 = obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_ilswe_5;
    GWP100_cropland_se10 = obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se10;
    GWP100_cropland_se5 = obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5;
    GWP100_cropland_se5to10 = obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_se5to10;
    GWP100_cropland_both_ilswe_4_5_se_5 = obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_both_ilswe_4_5_se_5;
    
    GWP100_cropland_ilswe_4_5 = GWP100_cropland_ilswe_4+GWP100_cropland_ilswe_5;
    GWP100_cropland_ilswe_4_5_not_SE5 = GWP100_cropland_ilswe_4_5-GWP100_cropland_both_ilswe_4_5_se_5;
    GWP100_cropland_ilswe_4_5_not_SE5_deployed_for_bioenergy = GWP100_cropland_ilswe_4_5_not_SE5.multiply_object_with_factor(Inputs.share_of_cropland_under_wind_erosion_for_bioenergy);
    
    GWP_cropland_under_pressure = GWP100_cropland_ilswe_4_5_not_SE5_deployed_for_bioenergy+GWP100_cropland_se5;
    
    
    x_vec = [0:1:15];
    
    y_vec = -10^-6*x_vec*GWP_cropland_under_pressure.tco2eq_total_mitigation/GWP_cropland_under_pressure.time_period_years;

    plot(x_vec,-y_vec);
    hold on
    GWP_cropland_under_pressure_array(refs) = GWP_cropland_under_pressure;
    
    src_data_cse{refs} = y_vec;
end

%Continued regrowth
soil_carbon_accumulation_tonC_per_ha_year =obj.mean_soil_carbon_seq_rate_cropland_se5_ilswe_45;
y_vec_cropland_se_nat_reg = 10^-6*x_vec*(obj.mean_natural_regrowth_cropland_se5_ilswe_45_tonC_per_ha_year+soil_carbon_accumulation_tonC_per_ha_year)*3.67*sum(sum(obj.cropland_under_soil_erosion_mod_high_4bioenergy_hectare));
%y_vec
hold on
plot(x_vec,-y_vec_cropland_se_nat_reg);
hold on

filename = 'mitigation_cropland_under_soil_erosion_pressure.pdf';
filename_src = [ output_folder 'src_data_' obj.region_name '_' scen_description '_' filename(1:end-4) '.mat'];
filename = [output_folder obj.region_name '_' scen_description  '_' filename];
ylabel('MtCO2-eq');
xlabel('years');
ymax = max(y_vec);
ymax = ceil(ymax/10)*10;

ylim([-ymax 0]);
legend('Current refinery', 'Future refinery', 'Future BECCS refinery', 'Natural regrowth', 'location', 'Southwest');
print('-painters','-dpdf', '-r1000', filename)

save(filename_src, 'src_data_cse', 'y_vec_cropland_se_nat_reg', 'x_vec' )

%% 

%% STACKED BAR CHART
plotMatrix = zeros(length(obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows)*2+2,5);
n_refs = length(obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows);
%ac_tot = sum(sum(obj.abandoned_cropland_hectare));
%cropland_se_tot = (sum(sum(obj.cropland_ilswe_4_hectare+obj.cropland_ilswe_5_hectare))*Inputs.share_of_cropland_under_wind_erosion_for_bioenergy)+sum(sum(obj.cropland_soil_erosion_above_5_ton_perHa_perYear_unit_hectare))-sum(sum(obj.cropland_both_ilswe_4_5_se_5*(Inputs.share_of_cropland_under_wind_erosion_for_bioenergy)));

ac_productive_tot = obj.Bioenergy_rf_h(scens).productive_land_ac_tot;
cropland_se5_productive = obj.Bioenergy_rf_h(scens).productive_land_cropland_se5_tot + obj.Bioenergy_rf_h(scens).productive_land_cropland_se5_tot;
cropland_ilswe_deployed_productive = (obj.Bioenergy_rf_h(scens).productive_land_cropland_ilswe_4_tot+obj.Bioenergy_rf_h(scens).productive_land_cropland_ilswe_5_tot)*Inputs.share_of_cropland_under_wind_erosion_for_bioenergy;
overlap = sum(sum(obj.Bioenergy_rf_h(scens).productive_land_cropland_both_ilswe_4_5_se_5*Inputs.share_of_cropland_under_wind_erosion_for_bioenergy));
cropland_se_productive_tot = cropland_se5_productive+cropland_ilswe_deployed_productive-overlap;

net_vec = zeros(1,length(obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows)*2+2);
errlow = zeros(1,length(obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows)*2+2);
errhigh = zeros(1,length(obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows)*2+2);
err = errlow;

%std_dev_vec = zeros(1,length(obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows)*2+2);

for refs = 1:length(obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows)
    GWP_ac
    %AC
    GWP_ac = obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_ac;
    plotVec_ac = zeros(1,5);
    plotVec_ac(2) = GWP_ac.tco2eq_accumulated_soc_change_tot;
    plotVec_ac(3) = GWP_ac.tco2eq_accumulated_farm_production_tot+GWP_ac.tco2eq_accumulated_farm2ref_transport_tot+GWP_ac.tco2eq_accumulated_abc_clearing_harvest_tot+GWP_ac.tco2eq_accumulated_abc_clearing_transport_tot;
    plotVec_ac(4) = GWP_ac.tco2eq_accumulated_ccs_or_char_tot+GWP_ac.tco2eq_accumulated_abc_clearing_ccs_or_char_tot;
    plotVec_ac(5) = GWP_ac.tco2eq_accumulated_ff_subsitution_ft_tot+GWP_ac.tco2eq_accumulated_ff_subsitution_ethanol_tot+GWP_ac.tco2eq_accumulated_electricity_substitution_tot;
    plotVec_ac(5) = plotVec_ac(5)+GWP_ac.tco2eq_accumulated_abc_clearing_ff_subsitution_ft_tot+GWP_ac.tco2eq_accumulated_abc_clearing_ff_subsitution_ethanol_tot+GWP_ac.tco2eq_accumulated_abc_clearing_electricity_substitution_tot;
    plotVec_ac(1) = sum(sum(obj.Bioenergy_rf_h(scens).carbon_aboveground_carbon_clearing*3.67));
    %plotVec_ac(5) = (initial_penalty_vec(refs));
    

    
    %C-SE
    GWP_cropland_under_pressure_array(refs) = obj.Bioenergy_rf_h(scens).Biorefinery_energy_carbon_flows(refs).GWP100_cropland_under_soil_erosion_mod_high_4bioenergy;
    plotVec_cropland_erosion = zeros(1,5);
    %plotVec_cropland_erosion(1) = GWP_cropland_under_pressure_array(refs).tco2eq_crop_sequestration_tot;
    plotVec_cropland_erosion(2) = GWP_cropland_under_pressure_array(refs).tco2eq_accumulated_soc_change_tot;
    plotVec_cropland_erosion(3) = GWP_cropland_under_pressure_array(refs).tco2eq_accumulated_farm_production_tot+GWP_cropland_under_pressure_array(refs).tco2eq_accumulated_farm2ref_transport_tot;
    %plotVec_cropland_erosion(4) = GWP_cropland_under_pressure_array(refs).tco2eq_accumulated_emitted_at_refinery_tot;
    plotVec_cropland_erosion(4) = GWP_cropland_under_pressure_array(refs).tco2eq_accumulated_ccs_or_char_tot;
    %plotVec_cropland_erosion(6) = GWP_cropland_under_pressure_array(refs).tco2eq_accumulated_fuel_combustion_tot;
    plotVec_cropland_erosion(5) = GWP_cropland_under_pressure_array(refs).tco2eq_accumulated_ff_subsitution_ft_tot+GWP_cropland_under_pressure_array(refs).tco2eq_accumulated_ff_subsitution_ethanol_tot+GWP_cropland_under_pressure_array(refs).tco2eq_accumulated_electricity_substitution_tot;
    
    %Get per ha
    plotMatrix(refs,:) = -plotVec_ac/ac_productive_tot;
    plotMatrix(n_refs+refs+1,:) = -plotVec_cropland_erosion/cropland_se_productive_tot;
    
    if GWP_ac.standard_deviation_computed == 1
        %errlow(refs) = -sum(plotMatrix(refs,:))-GWP_ac.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean_std_dev;
        %errhigh(refs) = -sum(plotMatrix(refs,:))+GWP_ac.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean_std_dev;
        err(refs) = GWP_ac.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean_std_dev;
    end
    if ~isempty(GWP_cropland_under_pressure_array(refs).tco2eq_per_ha_year_gridded_net_mitigation_annual_mean_std_dev)
        %errlow(n_refs+refs+1) = -sum(plotMatrix(n_refs+refs+1,:))-GWP_cropland_under_pressure_array(refs).tco2eq_per_ha_year_gridded_net_mitigation_annual_mean_std_dev;
        %errhigh(n_refs+refs+1) = -sum(plotMatrix(n_refs+refs+1,:))+GWP_cropland_under_pressure_array(refs).tco2eq_per_ha_year_gridded_net_mitigation_annual_mean_std_dev;
        err(n_refs+refs+1) = GWP_cropland_under_pressure_array(refs).tco2eq_per_ha_year_gridded_net_mitigation_annual_mean_std_dev;
    end
    %     net_vec(refs) = sum(plotMatrix(refs,:));
    %     net_vec(n_refs+refs) = sum(plotMatrix(n_refs+refs,:));
end

%Annual means
plotMatrix = plotMatrix/(GWP_ac.time_period_years);

%add natural regrowth, allready annual mean
plotMatrix(n_refs+1,1) = obj.mean_natural_regrowth_ac_tonC_per_ha_year*C_to_CO2;
plotMatrix(2*n_refs+2,1) = obj.mean_natural_regrowth_cropland_se5_ilswe_45_tonC_per_ha_year*C_to_CO2;

plotMatrix(n_refs+1,2) = obj.mean_soil_carbon_seq_rate_of_nat_regrowth_tonC_per_ha_year*C_to_CO2;
plotMatrix(2*n_refs+2,2) = obj.mean_soil_carbon_seq_rate_cropland_se5_ilswe_45*C_to_CO2;

% %Switch position SOC and abc clearing
% temp = plotMatrix(:,1);
% plotMatrix(:,1) = plotMatrix(:,5);
% plotMatrix(:,5) = temp;


%Get nets.
dims = size(plotMatrix);
for i = 1:dims(1)
    net_vec(i) = -sum(plotMatrix(i,:));
end




%plot
figure
barh(-plotMatrix, 'stacked');
hold on
x_labels = cell(1,2);
x_labels{1} = 'Abandoned cropland - current refinery';
x_labels{2} = 'Abandoned cropland - future refinery';
x_labels{3} = 'Abandoned cropland - future BECCS refinery';
x_labels{4} = 'Abandoned cropland - continued regrowth';

x_labels{5} = 'Cropland under erosion - current refinery';
x_labels{6} = 'Cropland under erosion - future refinery';
x_labels{7} = 'Cropland under erosion - future BECCS refinery';
x_labels{8} = 'Cropland under erosion - new regrowth';

yticklabels(x_labels);
xlabel('tCO2-eq. ha-1 year-1')
%legend('Aboveground carbon', 'Soil carbon sequestration', 'Supply chain emissions', 'Carbon emitted at refinery', 'CCS', 'Carbon emitted at combustion', 'Energy substitution', 'location', 'Southoutside');


scatter(net_vec, [1:1:2*n_refs+2], 'd', 'k');
hold on

binary = Nat_reg.aboveground_carbon_sequestration_rate_ac_ton_per_ha > 0;
soc_ac_rate = obj.gridded_soil_carbon_seq_rate_nat_regrowth_tonC_per_ha_year;

err(n_refs+1) = std((Nat_reg.aboveground_carbon_sequestration_rate_ac_ton_per_ha(binary)+soc_ac_rate(binary))*3.67, obj.abandoned_cropland_hectare(binary));
binary = Nat_reg.aboveground_carbon_sequestration_rate_cropland_ton_per_ha >0;
soc_c_rate = obj.gridded_soil_carbon_seq_rate_nat_regrowth_tonC_per_ha_year;
err(2*n_refs+2) = std((Nat_reg.aboveground_carbon_sequestration_rate_cropland_ton_per_ha(binary)+soc_c_rate(binary))*3.67, obj.cropland_under_soil_erosion_mod_high_4bioenergy_hectare(binary));


%for later export
%nat_reg_rate_soc_abc_ac = (Nat_reg.soc_ac_rate + Nat_reg.aboveground_carbon_sequestration_rate_ac_ton_per_ha)*3.67;
%nat_reg_rate_soc_abc_cropland_se = (Nat_reg.soc_c_rate + Nat_reg.aboveground_carbon_sequestration_rate_cropland_ton_per_ha)*3.67;


if GWP_ac.standard_deviation_computed == 1
    net_vec
    err = err;
    h = errorbar(net_vec,[1:1:2*n_refs+2],err, 'horizontal');
    h.Color = [0 0 0];
%     er.LineStyle = 'none';
  set(h,'linestyle','none')
end


% ymax = max(y_vec);
% ymax = ceil(ymax/10)*10;

ymax = 40;
xlim([-ymax 10]);

filename = 'annual_mitigation.pdf';
filename_src = [ output_folder 'src_data_' obj.region_name '_' scen_description '_' filename(1:end-4) '.mat'];
filename = [output_folder obj.region_name '_' scen_description '_'  filename];
legend('Aboveground carbon','Soil carbon', 'Supply chain emissions', 'CCS', 'Energy substitution' , 'Net', 'Standard deviation', 'location', 'Southoutside');

%legend('Current refinery', 'Future refinery', 'Future BECCS refinery', 'location', 'Northwest');
print('-painters','-dpdf', '-r1000', filename)

save(filename_src, 'plotMatrix', 'net_vec', 'err' )




end %function
