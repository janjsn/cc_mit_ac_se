function radius_km = calc_earth_geocentric_radius_at_latitude( latitude_deg )
%Calculates geocentric radius at given latitude in degrees.
%https://en.wikipedia.org/wiki/Earth_radius
polar_radius = 6357;
equatorial_radius = 6378;

lat_rad = latitude_deg*pi/180;

cos_lat =cos(lat_rad);
sin_lat = sin(lat_rad);

radius_km = sqrt(((equatorial_radius^2*cos_lat)^2+(polar_radius^2*sin_lat)^2)/((equatorial_radius*cos_lat)^2+(polar_radius*sin_lat)^2));



end

