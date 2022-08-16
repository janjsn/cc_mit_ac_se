ncid = netcdf.open('Input/Willow/willow_dm_yields_Mola_Yudego.nc');
willow_high = netcdf.getVar(ncid,4);

ncid_land = netcdf.open('Nordic region_bienergy_crop_land_availability43200x21600.nc');

lat = netcdf.getVar(ncid_land,0);
lon = netcdf.getVar(ncid_land,1);
region = netcdf.getVar(ncid_land,3)';
ac = netcdf.getVar(ncid_land,5);
cropland = netcdf.getVar(ncid_land,7);
cropland_se5 = netcdf.getVar(ncid_land,9);
cropland_se10 = netcdf.getVar(ncid_land,11);
cropland_ilswe1 = netcdf.getVar(ncid_land,29);
cropland_ilswe2 = netcdf.getVar(ncid_land,30);
cropland_ilswe3 = netcdf.getVar(ncid_land,31);
cropland_ilswe4 = netcdf.getVar(ncid_land,32);
cropland_ilswe5 = netcdf.getVar(ncid_land,33);
cropland_floods = netcdf.getVar(ncid_land,34);
