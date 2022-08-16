function Existing_refineries = get_existing_oil_refineries_Kramel(xls_filename)
%GET_EXISTING_OIL_REFINERIES_KRAMEL Summary of this function goes here
%   Detailed explanation goes here

[~,~ ,raw] = xlsread(xls_filename);
mSize = size(raw);

n_refs = mSize(1)-1;

nameCol = 1;
capacity_barrel_per_day_col = 2;
capacity_million_ton_per_year_col = 3;
country_col = 4;
region_col = 5;
lat_col = 6;
lon_col = 7;
ownership_col = 8;
owner_about_col = 9;
shareholder_about_col = 10;
production_col = 11;
activity_since_col = 12;

%% Get data
Existing_refineries(1:n_refs) = Actual_refinery;

for i = 1:mSize(1)-1
    Existing_refineries(i).lat = raw{i+1,lat_col};
    Existing_refineries(i).lon = raw{i+1,lon_col};
    Existing_refineries(i).country = raw{i+1,country_col};
    Existing_refineries(i).region = raw{i+1,region_col};
    Existing_refineries(i).name = raw{i+1,nameCol};
    Existing_refineries(i).ownership = raw{i+1, ownership_col};
    Existing_refineries(i).owner_about = raw{i+1,owner_about_col};
    Existing_refineries(i).shareholder_about = raw{i+1,shareholder_about_col};
    Existing_refineries(i).production = raw{i+1,production_col};
    Existing_refineries(i).capacity_barrel_per_day_bbday = raw{i+1,capacity_barrel_per_day_col};
    Existing_refineries(i).capacity_million_ton_year = raw{i+1,capacity_million_ton_per_year_col};
    Existing_refineries(i).activity_since = raw{i+1,activity_since_col};
    Existing_refineries(i).ID = i;
end


end

