function [GAEZ_array, Wheat] = getGAEZ_v4( CropType_array )
%GETGAEZ_V4 Summary of this function goes here
%   Detailed explanation goes here


misc_file = 'Input/GAEZ_v4/misc200b_yld_NorESM-M_RCP45_2011_2040_hi_rf.nc';
swi_file = 'Input/GAEZ_v4/swgr200b_yld_NorESM-M_RCP45_2011_2040_hi_rf.nc';
rcg_file = 'Input/GAEZ_v4/rcgr200b_yld_NorESM-M_RCP45_2011_2040_hi_rf.nc';
wheat_file = 'Input/GAEZ_v4/whea200b_yld_NorESM-M_RCP45_2011_2040_hi_rf.nc';

GAEZ_array(1:3) = GAEZ_data;
Wheat = GAEZ_data;
c=1;
%Miscanthus
ncid = netcdf.open(misc_file);
GAEZ_array(c).lat = netcdf.getVar(ncid,0);
GAEZ_array(c).lon = netcdf.getVar(ncid,1);
GAEZ_array(c).dm_yield = netcdf.getVar(ncid,2);
GAEZ_array(c).crop_ID = 1;
GAEZ_array(c).year = 2020;
GAEZ_array(c).crop_name = 'Miscanthus';
GAEZ_array(c).climate_scenario_ID = 2;
GAEZ_array(c).climate_scenario_name = 'RCP45';
GAEZ_array(c).climate_model = 'NorESM-M';
GAEZ_array(c).agricultural_management_intensity = 3;
GAEZ_array(c).irrigation_is_assumed = 0;
GAEZ_array(c).agricultural_management_intensity_name = 'High';

Crop_this = CropType_array([CropType_array.ID] == GAEZ_array(c).crop_ID);
GAEZ_array(c).bioenergy_yield = GAEZ_array(c).dm_yield*Crop_this.lowerHeatingValue_vectorizedAfterCropPart_MJperKg;
netcdf.close(ncid);
%Switchgrass
c=c+1;
ncid = netcdf.open(swi_file);
GAEZ_array(c).lat = netcdf.getVar(ncid,0);
GAEZ_array(c).lon = netcdf.getVar(ncid,1);
GAEZ_array(c).dm_yield = netcdf.getVar(ncid,2);
GAEZ_array(c).year = 2020;
GAEZ_array(c).crop_ID = 3;
GAEZ_array(c).crop_name = 'Switchgrass';
GAEZ_array(c).climate_scenario_ID = 2;
GAEZ_array(c).climate_scenario_name = 'RCP45';
GAEZ_array(c).climate_model = 'NorESM-M';
GAEZ_array(c).agricultural_management_intensity = 3;
GAEZ_array(c).irrigation_is_assumed = 0;
GAEZ_array(c).agricultural_management_intensity_name = 'High';

Crop_this = CropType_array([CropType_array.ID] == GAEZ_array(c).crop_ID);
GAEZ_array(c).bioenergy_yield = GAEZ_array(c).dm_yield*Crop_this.lowerHeatingValue_vectorizedAfterCropPart_MJperKg;
netcdf.close(ncid);
%Reed canary grass
c=c+1;
ncid = netcdf.open(rcg_file);
GAEZ_array(c).lat = netcdf.getVar(ncid,0);
GAEZ_array(c).lon = netcdf.getVar(ncid,1);
GAEZ_array(c).dm_yield = netcdf.getVar(ncid,2);
GAEZ_array(c).crop_ID = 2;
GAEZ_array(c).year = 2020;
GAEZ_array(c).crop_name = 'Reed Canary Grass';
GAEZ_array(c).climate_scenario_ID = 2;
GAEZ_array(c).climate_scenario_name = 'RCP45';
GAEZ_array(c).climate_model = 'NorESM-M';
GAEZ_array(c).agricultural_management_intensity = 3;
GAEZ_array(c).irrigation_is_assumed = 0;
GAEZ_array(c).agricultural_management_intensity_name = 'High';

Crop_this = CropType_array([CropType_array.ID] == GAEZ_array(c).crop_ID);
GAEZ_array(c).bioenergy_yield = GAEZ_array(c).dm_yield*Crop_this.lowerHeatingValue_vectorizedAfterCropPart_MJperKg;
netcdf.close(ncid);

%%WHEAT
ncid = netcdf.open(wheat_file);
Wheat.lat = netcdf.getVar(ncid,0);
Wheat.lon = netcdf.getVar(ncid,1);
Wheat.dm_yield = netcdf.getVar(ncid,2);
Wheat.crop_ID = 100;
Wheat.year = 2020;
Wheat.crop_name = 'Wheat';
Wheat.climate_scenario_ID = 2;
Wheat.climate_scenario_name = 'RCP45';
Wheat.climate_model = 'NorESM-M';
Wheat.agricultural_management_intensity = 3;
Wheat.irrigation_is_assumed = 0;
Wheat.agricultural_management_intensity_name = 'High';


Wheat.bioenergy_yield = 0;
netcdf.close(ncid);

end

