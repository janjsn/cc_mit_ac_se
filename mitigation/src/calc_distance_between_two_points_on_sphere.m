function distance = calc_distance_between_two_points_on_sphere(radius, lat1_deg, lon1_deg, lat2_deg, lon2_deg)
%Calculates the distance between two points on a sphere (e.g. Earth).
%Uses Haversine formula - https://en.wikipedia.org/wiki/Haversine_formula

lat1_rad = lat1_deg*(pi/180);
lon1_rad = lon1_deg*(pi/180);
lat2_rad = lat2_deg*(pi/180);
lon2_rad = lon2_deg*(pi/180);

distance = 2*radius*asin(sqrt((sin((lat2_rad-lat1_rad)/2))^2+(cos(lat1_rad)*cos(lat2_rad)*((sin((lon2_rad-lon1_rad)/2))^2))));



end

