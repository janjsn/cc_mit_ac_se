function Out_biomes = get_biomes_from_terrestrial_ecoregions_outdated( filename )

Out_biomes = Biomes;

ncid = netcdf.open(filename);

Out_biomes.lat = netcdf.getVar(ncid,0);
Out_biomes.lon = netcdf.getVar(ncid,1);

lat = Out_biomes.lat;
lon = Out_biomes.lon;

data = netcdf.getVar(ncid,2);

water_ID = 255;
tundra_ID = [160:1:190];
temperate_broadleaf_forest_ID = [33 125];
boreal_forest_ID = [61];
temperate_coniferous_forest_ID = [9999];


lat_northern_border_temperate_broadleaf_Denmark = 57.8;
lat_northern_border_temperate_broadleaf_SweFin = 61.1;
lat_northern_border_temperate_coniferous = 69.8;
lon_eastern_border_temperate_coniferous_SN = 6.4;

data_new = zeros(4320,2160);
data_new(data == water_ID) = -999;
for i = 1:length(tundra_ID)
data_new(data == tundra_ID(i)) = 1;
end
for i = 1:length(temperate_broadleaf_forest_ID)
data_new(data == temperate_broadleaf_forest_ID(i)) = 2;
end
for i = 1:length(temperate_coniferous_forest_ID)
data_new(data == temperate_coniferous_forest_ID(i)) = 3;
end
data_new(data == boreal_forest_ID) = 4;

for lons = 1:4320
    for lats = 1:2160
        if data_new(lons,lats) ~= 0
            continue
        end
        
        if lat(lats) <= lat_northern_border_temperate_broadleaf_Denmark
            data_new(lons, lats) = 2; %temperate_broadleaf_fores
        elseif lon(lons) < lon_eastern_border_temperate_coniferous_SN
            if lat(lats) <= lat_northern_border_temperate_coniferous
                %Check for Trøndelag boreal band
                if 63.5 < lat(lats) && lat(lats) <= 64.7
                %Trøndelag boreal band
                data_new(lons,lats) = 4;
                else
                %Not boreal band    
                data_new(lons,lats) = 3; % temperate_coniferous_forest
                end
                
                
            else 
                %North of Tromsø, tundra
                data_new(lons, lats) = 1;
            end
        else 
            if lat(lats) <= lat_northern_border_temperate_broadleaf_SweFin
                data_new(lons, lats) = 2;
            %Norwegian west coast
            elseif lat(lats) > 59 && lat(lats) < 63.5
                if lon(lons) < 8
                    %Western Norway coniferous band
                    data_new(lons,lats) = 3; % temperate_coniferous_forest
                elseif lat(lats) > 61 && lon(lons) < 9.9
                    data_new(lons,lats) = 3;
                else
                    data_new(lons,lats) = 4;
                end
                %Nordland
            elseif lat(lats) > 64.7 && lat(lats) <= 67.0
                if lon(lons) < 12.7
                   data_new(lons,lats) = 3;
                elseif lon(lons) < 13.5
                    data_new(lons,lats) = 4;
                elseif lon(lons) < 14.7
                    data_new(lons,lats) = 1;
                else
                    data_new(lons,lats) = 4;
                end
            elseif lat(lats) > 67 && lat(lats) <  lat_northern_border_temperate_coniferous
                if lon(lons) < 19.3
                   data_new(lons,lats)=3; 
                elseif lon(lons) < 22.3
                    data_new(lons,lats) = 1;
                else
                    data_new(lons,lats) = 4;
                end
                
            elseif lat(lats) < 69.7
                data_new(lons,lats) = 4;
            else
                data_new(lons,lats) = 1;
                
            end
        end
        
       
    end
end

%% Clean up discrepancies
for lons = 1:4320
    for lats = 1:2160
        if lat(lats) <= lat_northern_border_temperate_broadleaf_Denmark
            if data_new(lons,lats) == 1
                data_new(lons, lats) = 2; %temperate_broadleaf_fores
            end
        end
        
        if lat(lats) > 60 && lat(lats) <= 62.3
            if lon(lons) > 8.5 && lon(lons) <= 11
                if data_new(lons,lats) == 3
                   data_new(lons,lats) = 1; 
                end
            end
        end
        
        if lat(lats) > 60.5 && lon(lons) < 12.4
           if data_new(lons,lats) == 2
               data_new(lons,lats) = 4;
           end
        end
        
        if lat(lats) < 68 && lon(lons) > 17.6 && lat(lats) > 64
           if data_new(lons,lats) == 3
               data_new(lons,lats) = 4;
           end
        end
        
        if lat(lats) > lat_northern_border_temperate_broadleaf_SweFin && lat(lats) < 66.5
           if lon(lons) > 16.3
               if data_new(lons,lats) == 1
                  data_new(lons,lats) = 4; 
               end
           end
        end
        
        if lat(lats) < lat_northern_border_temperate_broadleaf_SweFin && lon(lons) > 9.8
            if data_new(lons,lats) == 1
                data_new(lons,lats) =2;
            end
        end
    end
    
end

makeNcFile_latlon('test.nc', data_new, lat, lon);

%% IDs temperate broadleaf forests
%ID_sarmatic_mixed_forests_palearctic_temperate_broadleaf_mixed = 33;
%ID_European_Atlantic_mixed_forests = 125;
%ID_Baltic_mixed_forests = 153;

end

