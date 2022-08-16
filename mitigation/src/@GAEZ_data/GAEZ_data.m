classdef GAEZ_data
    %GAEZ_DATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        lat
        lon        
        description
        year
        crop_name
        crop_ID
        lhv
        ref_lhv
        climate_scenario_ID
        climate_scenario_name
        climate_model
        agricultural_management_intensity
        agricultural_management_intensity_name
        irrigation_is_assumed
        dm_yield
        ref_dm_yield
        bioenergy_yield
        water_use
        ref_water_deficit
        Farm_2_biorefinery_emissions_Field
        
        
        
    end
    
    methods
        %Constructor
        function obj = GAEZ_data(filename)
            %Check if filename is provided
            if nargin > 0
                %Open file
               ncid = netcdf.open(filename); 
               
               %Get fieldnames which are equal to file variable names
               varnames = fieldnames(obj);
               %Find number of vars
               [~,n_vars,~,~] = netcdf.inq(ncid);
               
               for vars = 1:n_vars
                   %Get varname
                   varname_this = netcdf.inqVar(ncid,vars-1);
                   %Check for match
                   for names = 1:length(varnames)
                      if strcmp(varname_this, varnames{names})
                          %Get variable
                          var = netcdf.getVar(ncid,vars-1);
                          %Check if variable is char
                          if ischar(var)
                              %Transpose
                             var = var'; 
                          end
                          %Save to object
                          obj.(varname_this) = var;
                      end
                   end
               end   
               obj = get_farm2biorefGate_emissions_Field( obj );
            end        
        end %End constructor
        
        obj = get_farm2biorefGate_emissions_Field( obj )
    end
    
end

