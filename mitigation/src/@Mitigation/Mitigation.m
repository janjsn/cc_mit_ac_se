classdef Mitigation
    %MITIGATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        time_period_years = 20;
        unit_tco2eq = 'ton CO2 equivalents per year'
        contains_aboveground_carbon = 0;
        
        tco2eq_crop_sequestration= 0;
        tco2eq_accumulated_farm_production= 0;
        tco2eq_accumulated_farm2ref_transport= 0;
        tco2eq_accumulated_emitted_at_refinery= 0;
        tco2eq_accumulated_ccs_or_char= 0;
        tco2eq_accumulated_fuel_combustion= 0;
        tco2eq_accumulated_ff_subsitution_ft = 0;
        tco2eq_accumulated_ff_subsitution_ethanol = 0;
        tco2eq_accumulated_electricity_substitution = 0;
        
        
        tco2eq_accumulated_soc_change= 0;
        tco2eq_accumulated_abc_clearing_burned_at_field = 0;
        tco2eq_accumulated_abc_clearing_harvest= 0;
        tco2eq_accumulated_abc_clearing_transport= 0;
        tco2eq_accumulated_abc_clearing_emitted_at_refinery= 0;
        tco2eq_accumulated_abc_clearing_ccs_or_char= 0;
        tco2eq_accumulated_abc_clearing_fuel_combustion= 0;
        tco2eq_accumulated_abc_clearing_ff_substitution_ft = 0;
        tco2eq_accumulated_abc_clearing_ff_substitution_ethanol = 0;
        tco2eq_accumulated_abc_clearing_electricity_substitution = 0;
        
        tco2eq_crop_sequestration_tot = 0;
        tco2eq_accumulated_farm_production_tot = 0;
        tco2eq_accumulated_farm2ref_transport_tot = 0;
        tco2eq_accumulated_emitted_at_refinery_tot = 0;
        tco2eq_accumulated_ccs_or_char_tot = 0;
        
        tco2eq_accumulated_fuel_combustion_tot = 0;
        tco2eq_accumulated_ff_subsitution_ft_tot = 0;
        tco2eq_accumulated_ff_subsitution_ethanol_tot = 0;
        tco2eq_accumulated_electricity_substitution_tot = 0;
        
        tco2eq_accumulated_soc_change_tot = 0;
        tco2eq_accumulated_abc_clearing_burned_at_field_tot = 0;
        tco2eq_accumulated_abc_clearing_harvest_tot = 0;
        tco2eq_accumulated_abc_clearing_transport_tot = 0;
        tco2eq_accumulated_abc_clearing_emitted_at_refinery_tot = 0;
        tco2eq_accumulated_abc_clearing_ccs_or_char_tot = 0;
        tco2eq_accumulated_abc_clearing_fuel_combustion_tot = 0;
        tco2eq_accumulated_abc_clearing_ff_subsitution_ft_tot = 0;
        tco2eq_accumulated_abc_clearing_ff_subsitution_ethanol_tot = 0;
        tco2eq_accumulated_abc_clearing_electricity_substitution_tot = 0;
        
        tco2eq_total_mitigation = 0;
        tco2eq_total_mitigation_with_abc = 0;
        tco2eq_total_mitigation_per_year_no_abc_mean = 0;
        tco2eq_total_mitigation_per_year_with_abc_mean = 0;
        tco2eq_total_mitigation_per_ha_year_no_abc_mean = 0;
        tco2eq_total_mitigation_per_ha_year_with_abc_mean = 0;
        
        tco2eq_gridded_net_mitigation = 0;
        tco2eq_per_year_gridded_net_mitigation_annual= 0;
        tco2eq_per_ha_year_gridded_net_mitigation_annual= 0;
        tco2eq_per_ha_year_gridded_net_mitigation_annual_mean= 0;
        tco2eq_per_ha_year_gridded_net_mitigation_annual_mean_std_dev= 0;
        
        gridded_nets_computed = 0;
        standard_deviation_computed = 0;
        
        tco2eq_mitigation_per_year = 0;
        tco2eq_mitigation_per_ha_year = 0;
        std_mitigation_per_year = 0;
        std_mitigation_per_ha_year = 0;
        
        
    end
    
    methods
        
        function [best_mitigation_strategy] = write_gridded_mitigation_to_netcdf(obj, filename, lat, lon, nat_reg_co2_accumulation_rates, nat_reg_co2_accumulation)
            if exist(filename, 'file')
                delete(filename);
            end
            
            nccreate(filename,'lat','Dimensions',{'lat' length(lat)});
            ncwriteatt(filename, 'lat', 'standard_name', 'latitude');
            ncwriteatt(filename, 'lat', 'long_name', 'latitude');
            ncwriteatt(filename, 'lat', 'units', 'degrees_north');
            ncwriteatt(filename, 'lat', '_CoordinateAxisType', 'Lat');
            ncwriteatt(filename, 'lat', 'axis', 'Y');
            
            nccreate(filename,'lon','Dimensions',{'lon' length(lon)});
            ncwriteatt(filename, 'lon', 'standard_name', 'longitude');
            ncwriteatt(filename, 'lon', 'long_name', 'longitude');
            ncwriteatt(filename, 'lon', 'units', 'degrees_east');
            ncwriteatt(filename, 'lon', '_CoordinateAxisType', 'Lon');
            ncwriteatt(filename, 'lon', 'axis', 'X');
            
            nccreate(filename, 'net_mitigation', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'net_mitigation', 'standard_name', 'net_mitigation');
            ncwriteatt(filename, 'net_mitigation', 'long_name', 'net_mitigation');
            ncwriteatt(filename, 'net_mitigation', 'units', 'tCO2eq yr-1');
            ncwriteatt(filename, 'net_mitigation', 'missing_value', '-999');
            
            nccreate(filename, 'net_mitigation_intensity', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'net_mitigation_intensity', 'standard_name', 'net_mitigation_intensity');
            ncwriteatt(filename, 'net_mitigation_intensity', 'long_name', 'net_mitigation_intensity');
            ncwriteatt(filename, 'net_mitigation_intensity', 'units', 'tCO2eq ha-1 yr-1');
            ncwriteatt(filename, 'net_mitigation_intensity', 'missing_value', '-999');
            
            nccreate(filename, 'average_of_number_of_years', 'Datatype', 'double')
            ncwriteatt(filename, 'average_of_number_of_years', 'standard_name', 'average_of_number_of_years')
            ncwriteatt(filename, 'average_of_number_of_years', 'long_name', 'average_of_number_of_years')
            ncwriteatt(filename, 'average_of_number_of_years', 'units', 'year');
            
            nccreate(filename, 'net_mitigation_intensity_mean', 'Datatype', 'double')
            ncwriteatt(filename, 'net_mitigation_intensity_mean', 'standard_name', 'net_mitigation_intensity_mean')
            ncwriteatt(filename, 'net_mitigation_intensity_mean', 'long_name', 'net_mitigation_intensity_mean')
            ncwriteatt(filename, 'net_mitigation_intensity_mean', 'units', 'tCO2eq ha-1 yr-1');
            
            nccreate(filename, 'net_mitigation_intensity_mean_standard_deviation', 'Datatype', 'double')
            ncwriteatt(filename, 'net_mitigation_intensity_mean_standard_deviation', 'standard_name', 'net_mitigation_intensity_mean_standard_deviation')
            ncwriteatt(filename, 'net_mitigation_intensity_mean_standard_deviation', 'long_name', 'net_mitigation_intensity_mean_standard_deviation')
            ncwriteatt(filename, 'net_mitigation_intensity_mean_standard_deviation', 'units', 'tCO2eq ha-1 yr-1');
            
            ncwrite(filename, 'lat', lat);
            ncwrite(filename, 'lon', lon);
            ncwrite(filename, 'net_mitigation', obj.tco2eq_per_year_gridded_net_mitigation_annual);
            
            net_mit_intensity= obj.tco2eq_per_ha_year_gridded_net_mitigation_annual;
            net_mit_intensity(net_mit_intensity == 0) = -999;
            
            ncwrite(filename, 'net_mitigation_intensity', net_mit_intensity);
            ncwrite(filename, 'average_of_number_of_years', obj.time_period_years);
            ncwrite(filename, 'net_mitigation_intensity_mean', obj.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean);
            ncwrite(filename, 'net_mitigation_intensity_mean_standard_deviation', obj.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean_std_dev);
            
            if exist('nat_reg_co2_accumulation_rates', 'var')
                nccreate(filename, 'net_mitigation_natural_regrowth', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
                ncwriteatt(filename, 'net_mitigation_natural_regrowth', 'standard_name', 'net_mitigation_natural_regrowth');
                ncwriteatt(filename, 'net_mitigation_natural_regrowth', 'long_name', 'net_mitigation_natural_regrowth');
                ncwriteatt(filename, 'net_mitigation_natural_regrowth', 'units', 'tCO2eq yr-1');
                ncwriteatt(filename, 'net_mitigation_natural_regrowth', 'missing_value', '-999');
                
                nccreate(filename, 'net_mitigation_intensity_natural_regrowth', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
                ncwriteatt(filename, 'net_mitigation_intensity_natural_regrowth', 'standard_name', 'net_mitigation_intensity_natural_regrowth');
                ncwriteatt(filename, 'net_mitigation_intensity_natural_regrowth', 'long_name', 'net_mitigation_intensity_natural_regrowth');
                ncwriteatt(filename, 'net_mitigation_intensity_natural_regrowth', 'units', 'tCO2eq ha-1 yr-1');
                ncwriteatt(filename, 'net_mitigation_intensity_natural_regrowth', 'missing_value', '-999');
                
                nccreate(filename, 'best_mitigation_stratgy_over_time_period', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
                ncwriteatt(filename, 'best_mitigation_stratgy_over_time_period', 'standard_name', 'best_mitigation_stratgy_over_time_period');
                ncwriteatt(filename, 'best_mitigation_stratgy_over_time_period', 'long_name', 'best_mitigation_stratgy_over_time_period. Bioenergy = 1, Natural regrowth = 2');
                ncwriteatt(filename, 'best_mitigation_stratgy_over_time_period', 'units', 'tCO2eq yr-1');
                ncwriteatt(filename, 'best_mitigation_stratgy_over_time_period', 'missing_value', '-999');
                
                
                
                
                best_mitigation_strategy = zeros(length(lon), length(lat));
                binary_productive_bioenergy = obj.tco2eq_per_ha_year_gridded_net_mitigation_annual <0;
                best_mitigation_strategy(binary_productive_bioenergy) = 1;
                binary_nat_reg = obj.tco2eq_per_ha_year_gridded_net_mitigation_annual > nat_reg_co2_accumulation_rates;
                best_mitigation_strategy(binary_nat_reg) = 2;
                best_mitigation_strategy(binary_productive_bioenergy == 0) = -999;
                
                nat_reg_co2_accumulation_rates(~binary_productive_bioenergy) =-999;
                ncwrite(filename, 'net_mitigation_intensity_natural_regrowth', nat_reg_co2_accumulation_rates)
                ncwrite(filename, 'net_mitigation_natural_regrowth', nat_reg_co2_accumulation);
                ncwrite(filename, 'best_mitigation_stratgy_over_time_period', best_mitigation_strategy);
                
            end
            
        end
        
        function plot_mitigation_per_ha_with_std(obj, filename_src)
            tco2eq_mitigation_per_ha_year = obj.tco2eq_mitigation_per_ha_year;
            tco2eq_mitigation_per_year = obj.tco2eq_mitigation_per_year;
            std_mitigation_per_ha_year = obj.std_mitigation_per_ha_year;
            
            save(filename_src, 'tco2eq_mitigation_per_ha_year', 'tco2eq_mitigation_per_year', 'std_mitigation_per_ha_year')
            
        end
        
        function obj = calc_gridded_nets(obj, land_ha, filename)
            obj.tco2eq_gridded_net_mitigation = obj.tco2eq_accumulated_farm_production+obj.tco2eq_accumulated_farm2ref_transport+obj.tco2eq_accumulated_ccs_or_char ...
                + obj.tco2eq_accumulated_ff_subsitution_ft + obj.tco2eq_accumulated_ff_subsitution_ethanol + obj.tco2eq_accumulated_electricity_substitution + obj.tco2eq_accumulated_soc_change;
            
            annual_mitigation_bp = obj.tco2eq_gridded_net_mitigation./obj.time_period_years;
            mSize = size(annual_mitigation_bp);
            insant_penalty_abc_clearing = zeros(mSize(1), mSize(2));
            
            if obj.contains_aboveground_carbon == 1
                
                obj.tco2eq_gridded_net_mitigation = obj.tco2eq_gridded_net_mitigation + obj.tco2eq_accumulated_abc_clearing_burned_at_field+obj.tco2eq_accumulated_abc_clearing_harvest + obj.tco2eq_accumulated_abc_clearing_transport ...
                    + obj.tco2eq_accumulated_abc_clearing_emitted_at_refinery + obj.tco2eq_accumulated_abc_clearing_fuel_combustion + obj.tco2eq_accumulated_abc_clearing_ff_substitution_ft...
                    + obj.tco2eq_accumulated_abc_clearing_ff_substitution_ethanol + obj.tco2eq_accumulated_abc_clearing_electricity_substitution;
                
                
                insant_penalty_abc_clearing = obj.tco2eq_accumulated_abc_clearing_burned_at_field+obj.tco2eq_accumulated_abc_clearing_harvest + obj.tco2eq_accumulated_abc_clearing_transport ...
                    + obj.tco2eq_accumulated_abc_clearing_emitted_at_refinery + obj.tco2eq_accumulated_abc_clearing_fuel_combustion + obj.tco2eq_accumulated_abc_clearing_ff_substitution_ft...
                    + obj.tco2eq_accumulated_abc_clearing_ff_substitution_ethanol + obj.tco2eq_accumulated_abc_clearing_electricity_substitution;
            end
            
            obj.tco2eq_per_year_gridded_net_mitigation_annual = obj.tco2eq_gridded_net_mitigation./obj.time_period_years;
            obj.gridded_nets_computed = 1;
            
            soc_bio_change_yearly = obj.tco2eq_accumulated_soc_change./obj.time_period_years;
            
            
            x_vec = [0:1:30];
            x_vec_rem_soc  = zeros(1,length(x_vec));
            %x_vec_rem_soc(17:end) = 1:1:15;
            x_vec_rem_soc(22:end) = 1:1:10;
            mitigation_gridded_yearly_tco2eq_a = zeros(mSize(1),mSize(2),length(x_vec));
            mit_per_ha_vec = zeros(1,length(x_vec));
            mit_vec = zeros(1,length(x_vec));
            std_mit_vec_per_ha_vec = zeros(1,length(x_vec));
            binary = obj.tco2eq_crop_sequestration < 0;
            for i = 1:length(x_vec)
                mitigation_gridded_yearly_tco2eq_a(:,:,i) = insant_penalty_abc_clearing+ x_vec(i)*annual_mitigation_bp;
                mitigation_gridded_yearly_tco2eq_a(:,:,i) = mitigation_gridded_yearly_tco2eq_a(:,:,i) - (soc_bio_change_yearly*x_vec_rem_soc(i));
                mit = mitigation_gridded_yearly_tco2eq_a(:,:,i);
                mit_vec(i) = sum(sum(mit(binary)));
                mit_per_ha_vec(i) = sum(sum(mit(binary)))/sum(sum(land_ha(binary)));
                mit_per_ha = mitigation_gridded_yearly_tco2eq_a(:,:,i)./land_ha;
                mit_per_ha(isnan(mit_per_ha)) = 0;
                mit_per_ha(binary == 0) = 0;
                %std_mit_vec = std(mit_vec
                std_mit_vec_per_ha_vec(i) = std(mit_per_ha(binary), land_ha(binary));
            end
            
            obj.tco2eq_mitigation_per_year = mit_vec;
            obj.tco2eq_mitigation_per_ha_year = mit_per_ha_vec;
            obj.std_mitigation_per_ha_year = std_mit_vec_per_ha_vec;
            %nargin
            if nargin == 3
                
                if exist(filename, 'file')
                   delete(filename); 
                end
                
                lat_step = 180/2160;
                lat = [90-lat_step/2:-lat_step:-90+lat_step/2];
                lon_step = 360/4320;
                lon = [-180+lon_step/2:lon_step:180-lon_step/2];
                nccreate(filename,'lat','Dimensions',{'lat' length(lat)});
                ncwriteatt(filename, 'lat', 'standard_name', 'latitude');
                ncwriteatt(filename, 'lat', 'long_name', 'latitude');
                ncwriteatt(filename, 'lat', 'units', 'degrees_north');
                ncwriteatt(filename, 'lat', '_CoordinateAxisType', 'Lat');
                ncwriteatt(filename, 'lat', 'axis', 'Y');
                
                nccreate(filename,'lon','Dimensions',{'lon' length(lon)});
                ncwriteatt(filename, 'lon', 'standard_name', 'longitude');
                ncwriteatt(filename, 'lon', 'long_name', 'longitude');
                ncwriteatt(filename, 'lon', 'units', 'degrees_east');
                ncwriteatt(filename, 'lon', '_CoordinateAxisType', 'Lon');
                ncwriteatt(filename, 'lon', 'axis', 'X');
                
                nccreate(filename,'time','Dimensions',{'time' length(x_vec)});
                ncwriteatt(filename, 'time', 'standard_name', 'latitude');
                ncwriteatt(filename, 'time', 'long_name', 'latitude');
                ncwriteatt(filename, 'time', 'units', 'year');
                
                
                nccreate(filename, 'mitigation_gridded_yearly_tco2eq_a', 'Dimensions', {'lon' length(lon) 'lat' length(lat) 'time' length(x_vec)}, 'DeflateLevel', 4);
                ncwriteatt(filename, 'mitigation_gridded_yearly_tco2eq_a', 'standard_name', 'mitigation_gridded_yearly_tco2eq_a');
                ncwriteatt(filename, 'mitigation_gridded_yearly_tco2eq_a', 'long_name', 'mitigation_gridded_yearly_tco2eq_a');
                ncwriteatt(filename, 'mitigation_gridded_yearly_tco2eq_a', 'units', 'tCO2eq yr-1');
                ncwriteatt(filename, 'mitigation_gridded_yearly_tco2eq_a', 'missing_value', 'NaN');
                

                
                ncwrite(filename, 'lat', lat);
                ncwrite(filename, 'lon', lon);
                ncwrite(filename, 'time', x_vec);
                ncwrite(filename, 'mitigation_gridded_yearly_tco2eq_a', mitigation_gridded_yearly_tco2eq_a);
            end
            
            
        end
        
        function obj = calc_standard_deviation(obj, land_ha)
            binary = obj.tco2eq_crop_sequestration < 0;
            obj.tco2eq_per_ha_year_gridded_net_mitigation_annual_mean_std_dev = std(obj.tco2eq_per_ha_year_gridded_net_mitigation_annual(binary), land_ha(binary));
            obj.standard_deviation_computed = 1;
            
            %Also add means for controle
            obj.tco2eq_total_mitigation_per_year_no_abc_mean = obj.tco2eq_total_mitigation/obj.time_period_years;
            obj.tco2eq_total_mitigation_per_year_with_abc_mean = obj.tco2eq_total_mitigation_with_abc/obj.time_period_years;
            obj.tco2eq_total_mitigation_per_ha_year_no_abc_mean = obj.tco2eq_total_mitigation_per_year_no_abc_mean/sum(sum(land_ha(binary)));
            obj.tco2eq_total_mitigation_per_ha_year_with_abc_mean = obj.tco2eq_total_mitigation_per_year_with_abc_mean/sum(sum(land_ha(binary)));
        end
        
        function obj = calc_tots_from_gridded(obj)
            obj.tco2eq_accumulated_farm_production_tot = sum(sum(obj.tco2eq_accumulated_farm_production));
            obj.tco2eq_accumulated_farm2ref_transport_tot = sum(sum(obj.tco2eq_accumulated_farm2ref_transport));
            obj.tco2eq_accumulated_emitted_at_refinery_tot = sum(sum(obj.tco2eq_accumulated_emitted_at_refinery));
            obj.tco2eq_accumulated_ccs_or_char_tot = sum(sum(obj.tco2eq_accumulated_ccs_or_char));
            obj.tco2eq_accumulated_fuel_combustion_tot = sum(sum(obj.tco2eq_accumulated_fuel_combustion));
            obj.tco2eq_accumulated_ff_subsitution_ft_tot = sum(sum(obj.tco2eq_accumulated_ff_subsitution_ft));
            obj.tco2eq_accumulated_ff_subsitution_ethanol_tot = sum(sum(obj.tco2eq_accumulated_ff_subsitution_ethanol));
            obj.tco2eq_accumulated_electricity_substitution_tot = sum(sum(obj.tco2eq_accumulated_electricity_substitution));
            obj.tco2eq_accumulated_soc_change_tot = sum(sum(obj.tco2eq_accumulated_soc_change));
            obj.tco2eq_crop_sequestration_tot = sum(sum(obj.tco2eq_crop_sequestration));
            
            %obj.tco2eq_total_mitigation = obj.tco2eq_accumulated_farm_production_tot+obj.tco2eq_accumulated_farm2ref_transport_tot+obj.tco2eq_accumulated_emitted_at_refinery_tot+obj.tco2eq_accumulated_ccs_or_char_tot+obj.tco2eq_accumulated_fuel_combustion_tot+obj.tco2eq_accumulated_ff_subsitution_ft_tot+obj.tco2eq_accumulated_ff_subsitution_ethanol_tot+obj.tco2eq_accumulated_soc_change_tot+obj.tco2eq_crop_sequestration_tot;
            obj.tco2eq_total_mitigation = obj.tco2eq_accumulated_farm_production_tot+obj.tco2eq_accumulated_farm2ref_transport_tot+obj.tco2eq_accumulated_ccs_or_char_tot+obj.tco2eq_accumulated_ff_subsitution_ft_tot+obj.tco2eq_accumulated_ff_subsitution_ethanol_tot+obj.tco2eq_accumulated_electricity_substitution_tot+obj.tco2eq_accumulated_soc_change_tot;
            
        end
        
        function obj = calc_tot_from_tots(obj)
            %             obj.tco2eq_total_mitigation = obj.tco2eq_accumulated_electricity_substitution_tot+obj.tco2eq_accumulated_farm_production_tot+obj.tco2eq_accumulated_farm2ref_transport_tot+obj.tco2eq_accumulated_emitted_at_refinery_tot...
            %                 +obj.tco2eq_accumulated_ccs_or_char_tot+obj.tco2eq_accumulated_fuel_combustion_tot+obj.tco2eq_accumulated_ff_subsitution_ft_tot+obj.tco2eq_accumulated_ff_subsitution_ethanol_tot+obj.tco2eq_accumulated_soc_change_tot...
            %                 +obj.tco2eq_crop_sequestration_tot;
            %             %add abc
            %             obj.tco2eq_total_mitigation_with_abc = obj.tco2eq_total_mitigation+obj.tco2eq_accumulated_abc_clearing_harvest_tot+obj.tco2eq_accumulated_abc_clearing_transport_tot+obj.tco2eq_accumulated_abc_clearing_emitted_at_refinery_tot ...
            %                 + obj.tco2eq_accumulated_abc_clearing_ccs_or_char_tot + obj.tco2eq_accumulated_abc_clearing_fuel_combustion_tot + obj.tco2eq_accumulated_abc_clearing_ff_subsitution_ft_tot + obj.tco2eq_accumulated_abc_clearing_ff_subsitution_ethanol_tot...
            %                 + obj.tco2eq_accumulated_abc_clearing_electricity_substitution_tot;
            
            obj.tco2eq_total_mitigation = obj.tco2eq_accumulated_electricity_substitution_tot+obj.tco2eq_accumulated_farm_production_tot+obj.tco2eq_accumulated_farm2ref_transport_tot...
                +obj.tco2eq_accumulated_ccs_or_char_tot+obj.tco2eq_accumulated_ff_subsitution_ft_tot+obj.tco2eq_accumulated_ff_subsitution_ethanol_tot+obj.tco2eq_accumulated_soc_change_tot...
                ;
            %add abc
            obj.tco2eq_total_mitigation_with_abc = obj.tco2eq_total_mitigation+obj.tco2eq_accumulated_abc_clearing_burned_at_field_tot+obj.tco2eq_accumulated_abc_clearing_harvest_tot+obj.tco2eq_accumulated_abc_clearing_transport_tot+obj.tco2eq_accumulated_abc_clearing_emitted_at_refinery_tot ...
                + obj.tco2eq_accumulated_abc_clearing_fuel_combustion_tot + obj.tco2eq_accumulated_abc_clearing_ff_subsitution_ft_tot + obj.tco2eq_accumulated_abc_clearing_ff_subsitution_ethanol_tot...
                + obj.tco2eq_accumulated_abc_clearing_electricity_substitution_tot;
        end
        
        function obj = set_to_zeros_5arcmin(obj)
            obj.tco2eq_crop_sequestration = zeros(4320,2160);
            obj.tco2eq_accumulated_farm_production = zeros(4320,2160);
            obj.tco2eq_accumulated_farm2ref_transport = zeros(4320,2160);
            obj.tco2eq_accumulated_emitted_at_refinery = zeros(4320,2160);
            obj.tco2eq_accumulated_ccs_or_char = zeros(4320,2160);
            obj.tco2eq_accumulated_fuel_combustion = zeros(4320,2160);
            obj.tco2eq_accumulated_ff_subsitution_ft = zeros(4320,2160);
            obj.tco2eq_accumulated_ff_subsitution_ethanol = zeros(4320,2160);
            obj.tco2eq_accumulated_electricity_substitution = zeros(4320,2160);
            
            
            obj.tco2eq_accumulated_soc_change = zeros(4320,2160);
            
            obj.tco2eq_accumulated_abc_clearing_harvest = zeros(4320,2160);
            obj.tco2eq_accumulated_abc_clearing_transport = zeros(4320,2160);
            obj.tco2eq_accumulated_abc_clearing_emitted_at_refinery = zeros(4320,2160);
            obj.tco2eq_accumulated_abc_clearing_ccs_or_char = zeros(4320,2160);
            obj.tco2eq_accumulated_abc_clearing_fuel_combustion = zeros(4320,2160);
            obj.tco2eq_accumulated_abc_clearing_burned_at_field = zeros(4320,2160);
            
            
        end
        
        function obj = set_to_zeros_1d(obj)
            obj.tco2eq_crop_sequestration = 0;
            obj.tco2eq_accumulated_farm_production = 0;
            obj.tco2eq_accumulated_farm2ref_transport = 0;
            obj.tco2eq_accumulated_emitted_at_refinery = 0;
            obj.tco2eq_accumulated_ccs_or_char = 0;
            obj.tco2eq_accumulated_fuel_combustion = 0;
            obj.tco2eq_accumulated_ff_subsitution_ft = 0;
            obj.tco2eq_accumulated_ff_subsitution_ethanol = 0;
            obj.tco2eq_accumulated_electricity_substitution = 0;
            
            
            obj.tco2eq_accumulated_soc_change =0;
            
            obj.tco2eq_accumulated_abc_clearing_harvest =0;
            obj.tco2eq_accumulated_abc_clearing_transport = 0;
            obj.tco2eq_accumulated_abc_clearing_emitted_at_refinery = 0;
            obj.tco2eq_accumulated_abc_clearing_ccs_or_char = 0;
            obj.tco2eq_accumulated_abc_clearing_fuel_combustion = 0;
            
            obj.tco2eq_crop_sequestration_tot = 0;
            obj.tco2eq_accumulated_farm_production_tot = 0;
            obj.tco2eq_accumulated_farm2ref_transport_tot = 0;
            obj.tco2eq_accumulated_emitted_at_refinery_tot = 0;
            obj.tco2eq_accumulated_ccs_or_char_tot = 0;
            
            obj.tco2eq_accumulated_fuel_combustion_tot = 0;
            obj.tco2eq_accumulated_ff_subsitution_ft_tot = 0;
            obj.tco2eq_accumulated_ff_subsitution_ethanol_tot = 0;
            obj.tco2eq_accumulated_electricity_substitution_tot = 0;
            
            obj.tco2eq_accumulated_soc_change_tot = 0;
            obj.tco2eq_accumulated_abc_clearing_harvest_tot = 0;
            obj.tco2eq_accumulated_abc_clearing_transport_tot = 0;
            obj.tco2eq_accumulated_abc_clearing_emitted_at_refinery_tot = 0;
            obj.tco2eq_accumulated_abc_clearing_ccs_or_char_tot = 0;
            obj.tco2eq_accumulated_abc_clearing_fuel_combustion_tot = 0;
            obj.tco2eq_accumulated_abc_clearing_ff_subsitution_ft_tot = 0;
            obj.tco2eq_accumulated_abc_clearing_ff_subsitution_ethanol_tot = 0;
            obj.tco2eq_accumulated_abc_clearing_electricity_substitution_tot = 0;
            obj.tco2eq_accumulated_abc_clearing_burned_at_field_tot = 0;
            
            obj.tco2eq_total_mitigation = 0;
            
            
        end
        
        function obj = multiply_grids_with_hadamar_product_of_matrix(obj, matrix)
            sum(sum(isnan(matrix)));
            obj.tco2eq_crop_sequestration = obj.tco2eq_crop_sequestration.*matrix;
            sum(sum(isnan(obj.tco2eq_crop_sequestration)));
            obj.tco2eq_accumulated_farm_production = obj.tco2eq_accumulated_farm_production.*matrix;
            obj.tco2eq_accumulated_farm2ref_transport = obj.tco2eq_accumulated_farm2ref_transport.*matrix;
            obj.tco2eq_accumulated_emitted_at_refinery = obj.tco2eq_accumulated_emitted_at_refinery.*matrix;
            obj.tco2eq_accumulated_ccs_or_char = obj.tco2eq_accumulated_ccs_or_char.*matrix;
            obj.tco2eq_accumulated_fuel_combustion = obj.tco2eq_accumulated_fuel_combustion.*matrix;
            obj.tco2eq_accumulated_ff_subsitution_ft = obj.tco2eq_accumulated_ff_subsitution_ft.*matrix;
            obj.tco2eq_accumulated_ff_subsitution_ethanol = obj.tco2eq_accumulated_ff_subsitution_ethanol.*matrix;
            mSize = size(obj.tco2eq_accumulated_electricity_substitution);
            if mSize(1) == 4320
                obj.tco2eq_accumulated_electricity_substitution = obj.tco2eq_accumulated_electricity_substitution.*matrix;
            end
            obj.tco2eq_accumulated_soc_change = obj.tco2eq_accumulated_soc_change.*matrix;
        end
        
        function obj = multiply_object_with_factor(obj, factor)
            obj.tco2eq_crop_sequestration = obj.tco2eq_crop_sequestration*factor;
            obj.tco2eq_accumulated_farm_production = obj.tco2eq_accumulated_farm_production*factor;
            obj.tco2eq_accumulated_farm2ref_transport = obj.tco2eq_accumulated_farm2ref_transport*factor;
            obj.tco2eq_accumulated_emitted_at_refinery=  obj.tco2eq_accumulated_emitted_at_refinery*factor;
            obj.tco2eq_accumulated_ccs_or_char = obj.tco2eq_accumulated_ccs_or_char*factor;
            obj.tco2eq_accumulated_fuel_combustion = obj.tco2eq_accumulated_fuel_combustion*factor;
            obj.tco2eq_accumulated_ff_subsitution_ft = obj.tco2eq_accumulated_ff_subsitution_ft*factor;
            obj.tco2eq_accumulated_ff_subsitution_ethanol = obj.tco2eq_accumulated_ff_subsitution_ethanol*factor;
            obj.tco2eq_accumulated_electricity_substitution = obj.tco2eq_accumulated_electricity_substitution*factor;
            
            
            obj.tco2eq_accumulated_soc_change =  obj.tco2eq_accumulated_soc_change*factor;
            
            obj.tco2eq_accumulated_abc_clearing_harvest = obj.tco2eq_accumulated_abc_clearing_harvest*factor;
            obj.tco2eq_accumulated_abc_clearing_transport = obj.tco2eq_accumulated_abc_clearing_transport*factor;
            obj.tco2eq_accumulated_abc_clearing_emitted_at_refinery = obj.tco2eq_accumulated_abc_clearing_emitted_at_refinery*factor;
            obj.tco2eq_accumulated_abc_clearing_ccs_or_char = obj.tco2eq_accumulated_abc_clearing_ccs_or_char*factor;
            obj.tco2eq_accumulated_abc_clearing_fuel_combustion = obj.tco2eq_accumulated_abc_clearing_fuel_combustion*factor;
            obj.tco2eq_accumulated_abc_clearing_burned_at_field = obj.tco2eq_accumulated_abc_clearing_burned_at_field*factor;
            
            obj.tco2eq_crop_sequestration_tot = obj.tco2eq_crop_sequestration_tot*factor;
            obj.tco2eq_accumulated_farm_production_tot = obj.tco2eq_accumulated_farm_production_tot*factor;
            obj.tco2eq_accumulated_farm2ref_transport_tot = obj.tco2eq_accumulated_farm2ref_transport_tot*factor;
            obj.tco2eq_accumulated_emitted_at_refinery_tot = obj.tco2eq_accumulated_emitted_at_refinery_tot*factor;
            obj.tco2eq_accumulated_ccs_or_char_tot = obj.tco2eq_accumulated_ccs_or_char_tot*factor;
            
            obj.tco2eq_accumulated_fuel_combustion_tot = obj.tco2eq_accumulated_fuel_combustion_tot*factor;
            obj.tco2eq_accumulated_ff_subsitution_ft_tot = obj.tco2eq_accumulated_ff_subsitution_ft_tot*factor;
            obj.tco2eq_accumulated_ff_subsitution_ethanol_tot = obj.tco2eq_accumulated_ff_subsitution_ethanol_tot*factor;
            obj.tco2eq_accumulated_electricity_substitution_tot = obj.tco2eq_accumulated_electricity_substitution_tot*factor;
            
            obj.tco2eq_accumulated_soc_change_tot = obj.tco2eq_accumulated_soc_change_tot*factor;
            obj.tco2eq_accumulated_abc_clearing_harvest_tot = obj.tco2eq_accumulated_abc_clearing_harvest_tot*factor;
            obj.tco2eq_accumulated_abc_clearing_transport_tot = obj.tco2eq_accumulated_abc_clearing_transport_tot*factor;
            obj.tco2eq_accumulated_abc_clearing_emitted_at_refinery_tot = obj.tco2eq_accumulated_abc_clearing_emitted_at_refinery_tot*factor;
            obj.tco2eq_accumulated_abc_clearing_ccs_or_char_tot = obj.tco2eq_accumulated_abc_clearing_ccs_or_char_tot*factor;
            obj.tco2eq_accumulated_abc_clearing_fuel_combustion_tot = obj.tco2eq_accumulated_abc_clearing_fuel_combustion_tot*factor;
            obj.tco2eq_accumulated_abc_clearing_ff_subsitution_ft_tot = obj.tco2eq_accumulated_abc_clearing_ff_subsitution_ft_tot*factor;
            obj.tco2eq_accumulated_abc_clearing_ff_subsitution_ethanol_tot = obj.tco2eq_accumulated_abc_clearing_ff_subsitution_ethanol_tot*factor;
            obj.tco2eq_accumulated_abc_clearing_electricity_substitution_tot = obj.tco2eq_accumulated_abc_clearing_electricity_substitution_tot*factor;
            obj.tco2eq_accumulated_abc_clearing_burned_at_field_tot = obj.tco2eq_accumulated_abc_clearing_burned_at_field_tot*factor;
            
            obj = calc_tot_from_tots(obj);
        end
        
        function Added_objects = plus(obj1,obj2)
            
            Added_objects = Mitigation;
            
            if obj1.time_period_years == obj2.time_period_years
                Added_objects.time_period_years = obj1.time_period_years;
            else
                error('Incompatible time periods for adding objects.');
            end
            
            Added_objects.tco2eq_crop_sequestration = obj1.tco2eq_crop_sequestration + obj2.tco2eq_crop_sequestration;
            
            Added_objects.tco2eq_accumulated_farm_production = obj1.tco2eq_accumulated_farm_production + obj2.tco2eq_accumulated_farm_production;
            Added_objects.tco2eq_accumulated_farm2ref_transport = obj1.tco2eq_accumulated_farm2ref_transport + obj2.tco2eq_accumulated_farm2ref_transport;
            Added_objects.tco2eq_accumulated_emitted_at_refinery = obj1.tco2eq_accumulated_emitted_at_refinery + obj2.tco2eq_accumulated_emitted_at_refinery;
            Added_objects.tco2eq_accumulated_ccs_or_char = obj1.tco2eq_accumulated_ccs_or_char + obj2.tco2eq_accumulated_ccs_or_char;
            Added_objects.tco2eq_accumulated_fuel_combustion = obj1.tco2eq_accumulated_fuel_combustion + obj2.tco2eq_accumulated_fuel_combustion;
            Added_objects.tco2eq_accumulated_ff_subsitution_ft = obj1.tco2eq_accumulated_ff_subsitution_ft + obj2.tco2eq_accumulated_ff_subsitution_ft;
            Added_objects.tco2eq_accumulated_ff_subsitution_ethanol = obj1.tco2eq_accumulated_ff_subsitution_ethanol + obj2.tco2eq_accumulated_ff_subsitution_ethanol;
            Added_objects.tco2eq_accumulated_electricity_substitution = obj1.tco2eq_accumulated_electricity_substitution + obj2.tco2eq_accumulated_electricity_substitution;
            
            Added_objects.tco2eq_accumulated_soc_change = obj1.tco2eq_accumulated_soc_change + obj2.tco2eq_accumulated_soc_change;
            
            Added_objects.tco2eq_accumulated_abc_clearing_harvest = obj1.tco2eq_accumulated_abc_clearing_harvest + obj2.tco2eq_accumulated_abc_clearing_harvest;
            Added_objects.tco2eq_accumulated_abc_clearing_transport = obj1.tco2eq_accumulated_abc_clearing_transport + obj2.tco2eq_accumulated_abc_clearing_transport;
            Added_objects.tco2eq_accumulated_abc_clearing_emitted_at_refinery = obj1.tco2eq_accumulated_abc_clearing_emitted_at_refinery + obj2.tco2eq_accumulated_abc_clearing_emitted_at_refinery;
            Added_objects.tco2eq_accumulated_abc_clearing_ccs_or_char = obj1.tco2eq_accumulated_abc_clearing_ccs_or_char + obj2.tco2eq_accumulated_abc_clearing_ccs_or_char;
            Added_objects.tco2eq_accumulated_abc_clearing_fuel_combustion = obj1.tco2eq_accumulated_abc_clearing_fuel_combustion + obj2.tco2eq_accumulated_abc_clearing_fuel_combustion;
            Added_objects.tco2eq_accumulated_abc_clearing_burned_at_field = obj1.tco2eq_accumulated_abc_clearing_burned_at_field + obj2.tco2eq_accumulated_abc_clearing_burned_at_field;
            
            Added_objects.tco2eq_accumulated_ff_subsitution_ft = obj1.tco2eq_accumulated_ff_subsitution_ft+obj2.tco2eq_accumulated_ff_subsitution_ft;
            Added_objects.tco2eq_accumulated_ff_subsitution_ethanol = obj1.tco2eq_accumulated_ff_subsitution_ethanol+obj2.tco2eq_accumulated_ff_subsitution_ethanol;
            Added_objects.tco2eq_accumulated_electricity_substitution= obj1.tco2eq_accumulated_electricity_substitution+obj2.tco2eq_accumulated_electricity_substitution;
            if obj1.contains_aboveground_carbon == 1 ...
                    || obj2.contains_aboveground_carbon == 1
                Added_objects.contains_aboveground_carbon = 1;
                Added_objects.tco2eq_accumulated_abc_clearing_ff_substitution_ft = obj1.tco2eq_accumulated_abc_clearing_ff_substitution_ft+obj2.tco2eq_accumulated_abc_clearing_ff_substitution_ft;
                Added_objects.tco2eq_accumulated_abc_clearing_ff_substitution_ethanol = obj1.tco2eq_accumulated_abc_clearing_ff_substitution_ethanol+obj2.tco2eq_accumulated_abc_clearing_ff_substitution_ethanol;
                Added_objects.tco2eq_accumulated_abc_clearing_electricity_substitution = obj1.tco2eq_accumulated_abc_clearing_electricity_substitution+obj2.tco2eq_accumulated_abc_clearing_electricity_substitution;
                
            end
            
            Added_objects.tco2eq_crop_sequestration_tot = obj1.tco2eq_crop_sequestration_tot + obj2.tco2eq_crop_sequestration_tot;
            
            Added_objects.tco2eq_accumulated_farm_production_tot = obj1.tco2eq_accumulated_farm_production_tot + obj2.tco2eq_accumulated_farm_production_tot;
            Added_objects.tco2eq_accumulated_farm2ref_transport_tot = obj1.tco2eq_accumulated_farm2ref_transport_tot + obj2.tco2eq_accumulated_farm2ref_transport_tot;
            Added_objects.tco2eq_accumulated_emitted_at_refinery_tot = obj1.tco2eq_accumulated_emitted_at_refinery_tot + obj2.tco2eq_accumulated_emitted_at_refinery_tot;
            Added_objects.tco2eq_accumulated_ccs_or_char_tot = obj1.tco2eq_accumulated_ccs_or_char_tot + obj2.tco2eq_accumulated_ccs_or_char_tot;
            
            Added_objects.tco2eq_accumulated_fuel_combustion_tot = obj1.tco2eq_accumulated_fuel_combustion_tot + obj2.tco2eq_accumulated_fuel_combustion_tot;
            Added_objects.tco2eq_accumulated_ff_subsitution_ft_tot = obj1.tco2eq_accumulated_ff_subsitution_ft_tot + obj2.tco2eq_accumulated_ff_subsitution_ft_tot;
            Added_objects.tco2eq_accumulated_ff_subsitution_ethanol_tot = obj1.tco2eq_accumulated_ff_subsitution_ethanol_tot + obj2.tco2eq_accumulated_ff_subsitution_ethanol_tot;
            Added_objects.tco2eq_accumulated_electricity_substitution_tot = obj1.tco2eq_accumulated_electricity_substitution_tot + obj2.tco2eq_accumulated_electricity_substitution_tot;
            
            Added_objects.tco2eq_accumulated_soc_change_tot = obj1.tco2eq_accumulated_soc_change_tot + obj2.tco2eq_accumulated_soc_change_tot;
            Added_objects.tco2eq_accumulated_abc_clearing_harvest_tot = obj1.tco2eq_accumulated_abc_clearing_harvest_tot + obj2.tco2eq_accumulated_abc_clearing_harvest_tot;
            Added_objects.tco2eq_accumulated_abc_clearing_transport_tot = obj1.tco2eq_accumulated_abc_clearing_transport_tot + obj2.tco2eq_accumulated_abc_clearing_transport_tot;
            Added_objects.tco2eq_accumulated_abc_clearing_emitted_at_refinery_tot = obj1.tco2eq_accumulated_abc_clearing_emitted_at_refinery_tot + obj2.tco2eq_accumulated_abc_clearing_emitted_at_refinery_tot;
            Added_objects.tco2eq_accumulated_abc_clearing_ccs_or_char_tot = obj1.tco2eq_accumulated_abc_clearing_ccs_or_char_tot + obj2.tco2eq_accumulated_abc_clearing_ccs_or_char_tot;
            Added_objects.tco2eq_accumulated_abc_clearing_fuel_combustion_tot = obj1.tco2eq_accumulated_abc_clearing_fuel_combustion_tot + obj2.tco2eq_accumulated_abc_clearing_fuel_combustion_tot;
            Added_objects.tco2eq_accumulated_abc_clearing_burned_at_field_tot = obj1.tco2eq_accumulated_abc_clearing_burned_at_field_tot + obj2.tco2eq_accumulated_abc_clearing_burned_at_field_tot;
            
            Added_objects.tco2eq_accumulated_abc_clearing_ff_subsitution_ft_tot = obj1.tco2eq_accumulated_abc_clearing_ff_subsitution_ft_tot + obj2.tco2eq_accumulated_abc_clearing_ff_subsitution_ft_tot;
            Added_objects.tco2eq_accumulated_abc_clearing_ff_subsitution_ethanol_tot = obj1.tco2eq_accumulated_abc_clearing_ff_subsitution_ethanol_tot + obj2.tco2eq_accumulated_abc_clearing_ff_subsitution_ethanol_tot;
            Added_objects.tco2eq_accumulated_abc_clearing_electricity_substitution_tot = obj1.tco2eq_accumulated_abc_clearing_electricity_substitution_tot + obj2.tco2eq_accumulated_abc_clearing_electricity_substitution_tot;
            
            
            msize1 = size(obj1.tco2eq_gridded_net_mitigation);
            
            msize2 = size(obj2.tco2eq_gridded_net_mitigation);
            
            if msize1 ~= msize2
                obj1
                obj2
            end
            
            Added_objects.tco2eq_gridded_net_mitigation = obj1.tco2eq_gridded_net_mitigation+obj2.tco2eq_gridded_net_mitigation;
            Added_objects.tco2eq_per_year_gridded_net_mitigation_annual = obj1.tco2eq_per_year_gridded_net_mitigation_annual+obj2.tco2eq_per_year_gridded_net_mitigation_annual;
            
            Added_objects = Added_objects.calc_tot_from_tots;
            
            
            %Added_objects = Added_objects.calc_tots_from_gridded();
            %Added_objects.tco2eq_accumulated_electricity_substitution_tot = sum(sum(Added_objects.tco2eq_accumulated_electricity_substitution));
            
        end
        
        function Subtracted_objects = minus(obj1,obj2)
            
            Subtracted_objects = Mitigation;
            
            if obj1.time_period_years == obj2.time_period_years
                Subtracted_objects.time_period_years = obj1.time_period_years;
            else
                error('Incompatible time periods for adding objects.');
            end
            
            Subtracted_objects.tco2eq_crop_sequestration = obj1.tco2eq_crop_sequestration + obj2.tco2eq_crop_sequestration;
            
            Subtracted_objects.tco2eq_accumulated_farm_production = obj1.tco2eq_accumulated_farm_production - obj2.tco2eq_accumulated_farm_production;
            Subtracted_objects.tco2eq_accumulated_farm2ref_transport = obj1.tco2eq_accumulated_farm2ref_transport - obj2.tco2eq_accumulated_farm2ref_transport;
            Subtracted_objects.tco2eq_accumulated_emitted_at_refinery = obj1.tco2eq_accumulated_emitted_at_refinery - obj2.tco2eq_accumulated_emitted_at_refinery;
            Subtracted_objects.tco2eq_accumulated_ccs_or_char = obj1.tco2eq_accumulated_ccs_or_char - obj2.tco2eq_accumulated_ccs_or_char;
            Subtracted_objects.tco2eq_accumulated_fuel_combustion = obj1.tco2eq_accumulated_fuel_combustion - obj2.tco2eq_accumulated_fuel_combustion;
            Subtracted_objects.tco2eq_accumulated_ff_subsitution_ft = obj1.tco2eq_accumulated_ff_subsitution_ft - obj2.tco2eq_accumulated_ff_subsitution_ft;
            Subtracted_objects.tco2eq_accumulated_ff_subsitution_ethanol = obj1.tco2eq_accumulated_ff_subsitution_ethanol - obj2.tco2eq_accumulated_ff_subsitution_ethanol;
            Subtracted_objects.tco2eq_accumulated_electricity_substitution = obj1.tco2eq_accumulated_electricity_substitution - obj2.tco2eq_accumulated_electricity_substitution;
            
            Subtracted_objects.tco2eq_accumulated_soc_change = obj1.tco2eq_accumulated_soc_change - obj2.tco2eq_accumulated_soc_change;
            
            Subtracted_objects.tco2eq_accumulated_abc_clearing_harvest = obj1.tco2eq_accumulated_abc_clearing_harvest - obj2.tco2eq_accumulated_abc_clearing_harvest;
            Subtracted_objects.tco2eq_accumulated_abc_clearing_transport = obj1.tco2eq_accumulated_abc_clearing_transport - obj2.tco2eq_accumulated_abc_clearing_transport;
            Subtracted_objects.tco2eq_accumulated_abc_clearing_emitted_at_refinery = obj1.tco2eq_accumulated_abc_clearing_emitted_at_refinery - obj2.tco2eq_accumulated_abc_clearing_emitted_at_refinery;
            Subtracted_objects.tco2eq_accumulated_abc_clearing_ccs_or_char = obj1.tco2eq_accumulated_abc_clearing_ccs_or_char - obj2.tco2eq_accumulated_abc_clearing_ccs_or_char;
            Subtracted_objects.tco2eq_accumulated_abc_clearing_fuel_combustion = obj1.tco2eq_accumulated_abc_clearing_fuel_combustion - obj2.tco2eq_accumulated_abc_clearing_fuel_combustion;
            Subtracted_objects.tco2eq_accumulated_abc_clearing_burned_at_field = obj1.tco2eq_accumulated_abc_clearing_burned_at_field - obj2.tco2eq_accumulated_abc_clearing_burned_at_field;
            
            Subtracted_objects.tco2eq_crop_sequestration_tot = obj1.tco2eq_crop_sequestration_tot - obj2.tco2eq_crop_sequestration_tot;
            
            Subtracted_objects.tco2eq_accumulated_farm_production_tot = obj1.tco2eq_accumulated_farm_production_tot - obj2.tco2eq_accumulated_farm_production_tot;
            Subtracted_objects.tco2eq_accumulated_farm2ref_transport_tot = obj1.tco2eq_accumulated_farm2ref_transport_tot - obj2.tco2eq_accumulated_farm2ref_transport_tot;
            Subtracted_objects.tco2eq_accumulated_emitted_at_refinery_tot = obj1.tco2eq_accumulated_emitted_at_refinery_tot - obj2.tco2eq_accumulated_emitted_at_refinery_tot;
            Subtracted_objects.tco2eq_accumulated_ccs_or_char_tot = obj1.tco2eq_accumulated_ccs_or_char_tot - obj2.tco2eq_accumulated_ccs_or_char_tot;
            
            Subtracted_objects.tco2eq_accumulated_fuel_combustion_tot = obj1.tco2eq_accumulated_fuel_combustion_tot - obj2.tco2eq_accumulated_fuel_combustion_tot;
            Subtracted_objects.tco2eq_accumulated_ff_subsitution_ft_tot = obj1.tco2eq_accumulated_ff_subsitution_ft_tot - obj2.tco2eq_accumulated_ff_subsitution_ft_tot;
            Subtracted_objects.tco2eq_accumulated_ff_subsitution_ethanol_tot = obj1.tco2eq_accumulated_ff_subsitution_ethanol_tot - obj2.tco2eq_accumulated_ff_subsitution_ethanol_tot;
            Subtracted_objects.tco2eq_accumulated_electricity_substitution_tot = obj1.tco2eq_accumulated_electricity_substitution_tot - obj2.tco2eq_accumulated_electricity_substitution_tot;
            
            Subtracted_objects.tco2eq_accumulated_soc_change_tot = obj1.tco2eq_accumulated_soc_change_tot - obj2.tco2eq_accumulated_soc_change_tot;
            Subtracted_objects.tco2eq_accumulated_abc_clearing_harvest_tot = obj1.tco2eq_accumulated_abc_clearing_harvest_tot - obj2.tco2eq_accumulated_abc_clearing_harvest_tot;
            Subtracted_objects.tco2eq_accumulated_abc_clearing_transport_tot = obj1.tco2eq_accumulated_abc_clearing_transport_tot - obj2.tco2eq_accumulated_abc_clearing_transport_tot;
            Subtracted_objects.tco2eq_accumulated_abc_clearing_emitted_at_refinery_tot = obj1.tco2eq_accumulated_abc_clearing_emitted_at_refinery_tot - obj2.tco2eq_accumulated_abc_clearing_emitted_at_refinery_tot;
            Subtracted_objects.tco2eq_accumulated_abc_clearing_ccs_or_char_tot = obj1.tco2eq_accumulated_abc_clearing_ccs_or_char_tot - obj2.tco2eq_accumulated_abc_clearing_ccs_or_char_tot;
            Subtracted_objects.tco2eq_accumulated_abc_clearing_fuel_combustion_tot = obj1.tco2eq_accumulated_abc_clearing_fuel_combustion_tot - obj2.tco2eq_accumulated_abc_clearing_fuel_combustion_tot;
            Subtracted_objects.tco2eq_accumulated_abc_clearing_burned_at_field = obj1.tco2eq_accumulated_abc_clearing_burned_at_field - obj2.tco2eq_accumulated_abc_clearing_burned_at_field_tot;
            
            Subtracted_objects.tco2eq_accumulated_abc_clearing_ff_subsitution_ft_tot = obj1.tco2eq_accumulated_abc_clearing_ff_subsitution_ft_tot - obj2.tco2eq_accumulated_abc_clearing_ff_subsitution_ft_tot;
            Subtracted_objects.tco2eq_accumulated_abc_clearing_ff_subsitution_ethanol_tot = obj1.tco2eq_accumulated_abc_clearing_ff_subsitution_ethanol_tot - obj2.tco2eq_accumulated_abc_clearing_ff_subsitution_ethanol_tot;
            Subtracted_objects.tco2eq_accumulated_abc_clearing_electricity_substitution_tot = obj1.tco2eq_accumulated_abc_clearing_electricity_substitution_tot - obj2.tco2eq_accumulated_abc_clearing_electricity_substitution_tot;
            
            Subtracted_objects.tco2eq_accumulated_abc_clearing_ff_substitution_ft = obj1.tco2eq_accumulated_abc_clearing_ff_substitution_ft - obj2.tco2eq_accumulated_abc_clearing_ff_substitution_ft;
            Subtracted_objects.tco2eq_accumulated_abc_clearing_ff_substitution_ethanol = obj1.tco2eq_accumulated_abc_clearing_ff_substitution_ethanol - obj2.tco2eq_accumulated_abc_clearing_ff_substitution_ethanol;
            Subtracted_objects.tco2eq_accumulated_abc_clearing_electricity_substitution = obj1.tco2eq_accumulated_abc_clearing_electricity_substitution - obj2.tco2eq_accumulated_abc_clearing_electricity_substitution;
            
            Subtracted_objects = Subtracted_objects.calc_tot_from_tots;
            
            
            %Added_objects = Added_objects.calc_tots_from_gridded();
            %Added_objects.tco2eq_accumulated_electricity_substitution_tot = sum(sum(Added_objects.tco2eq_accumulated_electricity_substitution));
            
        end
        
        
        function obj = remove_gridded_data_from_RAM(obj)
            obj.tco2eq_crop_sequestration = 0;
            obj.tco2eq_accumulated_farm_production = 0;
            obj.tco2eq_accumulated_farm2ref_transport = 0;
            obj.tco2eq_accumulated_emitted_at_refinery = 0;
            obj.tco2eq_accumulated_ccs_or_char = 0;
            obj.tco2eq_accumulated_fuel_combustion = 0;
            obj.tco2eq_accumulated_ff_subsitution_ft = 0;
            obj.tco2eq_accumulated_ff_subsitution_ethanol = 0;
            obj.tco2eq_accumulated_electricity_substitution = 0;
            
            obj.tco2eq_accumulated_soc_change = 0;
            obj.tco2eq_accumulated_abc_clearing_harvest = 0;
            obj.tco2eq_accumulated_abc_clearing_transport = 0;
            obj.tco2eq_accumulated_abc_clearing_emitted_at_refinery = 0;
            obj.tco2eq_accumulated_abc_clearing_ccs_or_char = 0;
            obj.tco2eq_accumulated_abc_clearing_fuel_combustion = 0;
            obj.tco2eq_accumulated_abc_clearing_burned_at_field = 0;
        end
        
        
    end
    
end

