classdef Emission_factors
    %EMISSION_FACTORS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        emissions_combustion_fe_gasoline_gco2eq_perMj
        emissions_combustion_fe_diesel_gco2eq_perMj
        emissions_eu_mix_electricity_supply_high_voltage_gco2eq_perMj
        emissions_ng_electricty_generation_gco2eq_perMj
        lce_gasoline_gco2eq_perMj
        lce_diesel_gco2_eq_perMj
        lce_ng_electricity_gco2_eq_perMj
        refs
        
    end
    
    methods
        function obj = Emission_factors()
            %Set emission factors of fossil fuel/el
            obj.emissions_combustion_fe_gasoline_gco2eq_perMj = 73.4;
            obj.emissions_combustion_fe_diesel_gco2eq_perMj = 73.2;
            obj.emissions_eu_mix_electricity_supply_high_voltage_gco2eq_perMj = 126.8;
            %NG, Gibon (2017)
            obj.emissions_ng_electricty_generation_gco2eq_perMj = 530*0.70/3.6;
            
            obj.lce_gasoline_gco2eq_perMj = 95.3;
            obj.lce_diesel_gco2_eq_perMj = 95.1;
            obj.lce_ng_electricity_gco2_eq_perMj = 530/3.6;
            
            
            obj.refs = {'Edwards, R. et al. (2017). Definition of input data to assess GHG default emissions from biofuels in EU legislation. Version 1c–July.',...
                'NG: Gibon 2017'};

        end
        
        
        
    end
    
end

