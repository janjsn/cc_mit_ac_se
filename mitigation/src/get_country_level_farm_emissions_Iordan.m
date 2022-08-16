function Output = get_country_level_farm_emissions_Iordan(  )
%GET_COUNTRY_LEVEL_FARM_EMISSIONS_IORDAN Summary of this function goes here
%   Detailed explanation goes here

filenames = {'Input/lca impacts/DK_impact_per_kgDM_reed canarygrass_rainfed.nc',...
    'Input/lca impacts/DK_impact_per_kgDM_switchgrass_rainfed.nc',...
    'Input/lca impacts/FI_impact_per_kgDM_reed canarygrass_rainfed.nc',...
    'Input/lca impacts/FI_impact_per_kgDM_switchgrass_rainfed.nc',...
    'Input/lca impacts/NO_impact_per_kgDM_reed canarygrass_rainfed.nc',...
    'Input/lca impacts/NO_impact_per_kgDM_switchgrass_rainfed.nc',...
    'Input/lca impacts/SE_impact_per_kgDM_reed canarygrass_rainfed.nc',...
    'Input/lca impacts/SE_impact_per_kgDM_switchgrass_rainfed.nc',...
    };

crop_ids = [2 3 2 3 2 3 2 3];
crop_names = {'Reed Canary Grass', 'Switchgrass', 'Reed Canary Grass', 'Switchgrass', 'Reed Canary Grass', 'Switchgrass', 'Reed Canary Grass', 'Switchgrass'};
countries = {'Denmark', 'Denmark', 'Finland', 'Finland', 'Norway', 'Norway', 'Sweden', 'Sweden'};

Output(1:length(filenames)) = Country_level_farm_emissions;

for files = 1:length(filenames)
    ncid = netcdf.open(filenames{files});
    Output(files).lat = netcdf.getVar(ncid,0);
    Output(files).lon = netcdf.getVar(ncid,1);
    Output(files).crop_name = crop_names{files};
    Output(files).crop_ID = crop_ids(files);
    Output(files).gwp100 = netcdf.getVar(ncid,5);
    Output(files).country_name = countries{files};
    harvest_potential = netcdf.getVar(ncid,3);
    land = netcdf.getVar(ncid,2);
    
    test1 = unique(Output(files).gwp100./land);
    
    %Get 5arcmin data
    gwp100_5arcmin = zeros(4320,2160);
    
    idx_lat = zeros(1,length(Output(files).lat));
    idx_lon = zeros(1,length(Output(files).lon));
    for lats = 1:length(Output(files).lat)
        [~,idx_lat(lats)] = min(abs(Output(files).lat(lats)-Output(files).lat_5arcmin));
    end
    for lons = 1:length(Output(files).lon)
        [~,idx_lon(lons)] = min(abs(Output(files).lon(lons)-Output(files).lon_5arcmin));
    end
    
    for lons = 1:length(idx_lon)
        for lats = 1:length(idx_lat)
            gwp100_5arcmin(idx_lon(lons),idx_lat(lats)) = Output(files).gwp100(lons,lats);
        end
    end
   Output(files).gwp100_5arcmin = gwp100_5arcmin; 
end



end

