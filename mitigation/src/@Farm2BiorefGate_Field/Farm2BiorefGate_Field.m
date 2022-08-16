classdef Farm2BiorefGate_Field
    %FARM2BIOREFGATE_FIELD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        a = 350.38;
        b = -0.63;
        equation = 'y = ax^(-b)';
        crop_id
        dm_yield
        lhv
        gwp100_kgCO2e_per_ton_dm
        gwp100_kgCO2e_per_MJ_primary_energy
        
    end
    
    methods
        function obj = Farm2BiorefGate_Field(GAEZ_variant)
            
            obj.crop_id = GAEZ_variant.crop_ID;
            obj.lhv = GAEZ_variant.crop_ID;
            obj.gwp100_kgCO2e_per_ton_dm = obj.a.*(GAEZ_variant.dm_yield.^(obj.b));
            obj.gwp100_kgCO2e_per_MJ_primary_energy = obj.gwp100_kgCO2e_per_ton_dm/obj.lhv;
            
        end
        
        
    end
    
end

