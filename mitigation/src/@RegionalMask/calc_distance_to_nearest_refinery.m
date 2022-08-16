function obj = calc_distance_to_nearest_refinery( obj, Ref_array )
%CALC_DISTANCE_TO_NEAREST_REFINERY Summary of this function goes here
%   Detailed explanation goes here

distance_to_ref = zeros(length(obj.lon),length(obj.lat));
nearest_ref_id = zeros(length(obj.lon), length(obj.lat));

binary_contains_region = obj.fraction_of_cell_is_region > 0;

radius_ref = zeros(1,length(Ref_array));
for refs = 1:length(radius_ref)
    radius_ref(refs) = calc_earth_geocentric_radius_at_latitude( Ref_array(refs).lat ) ;
end

for lons = 1:length(obj.lon)
    for lats = 1:length(obj.lat)
        if binary_contains_region(lons,lats)
            this_distance = zeros(1,length(Ref_array));
            
            for refs = 1:length(this_distance)
                
                mean_r = (obj.geocentric_radius_at_lat_km(lats)+radius_ref(refs))/2;
                
                this_distance(refs) = calc_distance_between_two_points_on_sphere(mean_r, obj.lat(lats), obj.lon(lons), Ref_array(refs).lat, Ref_array(refs).lon);
                
            end
            
            [distance_to_ref(lons,lats),idx] = min(this_distance);
            nearest_ref_id(lons,lats) = Ref_array(idx).ID;
        end
    end
end

obj.distance_from_nearest_refinery_km = distance_to_ref;
obj.nearest_refinery_ID = nearest_ref_id;

end

