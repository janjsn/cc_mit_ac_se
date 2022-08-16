function GAEZ_array = getGAEZ_v3()

%NAMELIST input filenames
dirlist = dir('Input/GAEZ/');

n_candidates = length(dirlist);

filenames = {dirlist.name};

binary_use = false(1,n_candidates);
for i = 1:n_candidates
    this = filenames{i};
    if length(this) > 2
        if strcmp(this(end-2:end), '.nc')
            binary_use(i) = true;
        end
    end
end


filenames = filenames(binary_use);


GAEZ_array(1:length(filenames)) = GAEZ_data;
for i = 1:length(filenames)
    GAEZ_array(i) = GAEZ_data(['Input/GAEZ/' filenames{i}]);    
end



end

