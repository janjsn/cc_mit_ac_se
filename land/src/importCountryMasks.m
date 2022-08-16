function [ CountryMask ] = importCountryMasks(  )
%IMPORTCOUNTRYMASKS Summary of this function goes here
%   Detailed explanation goes here
filename_country_masks = 'Input/gpw-v4-national-identifier-grid-rev11_30_sec_tif/gpw_v4_national_identifier_grid_rev11_30_sec.tif';

[countryMasks_30arcsec, GeoInfo_countryMask] = getCountryMasks_gpw(filename_country_masks);
countryMasks_30arcsec = countryMasks_30arcsec';

CountryArray = getCountryMaskIDs( 'Input/gpw-v4-national-identifier-grid-rev11_30_sec_tif/gpw-v4-country-level-summary-rev11.xlsx', 'GPWv4 Rev11 Summary' );
   
CountryMask = GPW_v4_nig(CountryArray, countryMasks_30arcsec, GeoInfo_countryMask);


end

