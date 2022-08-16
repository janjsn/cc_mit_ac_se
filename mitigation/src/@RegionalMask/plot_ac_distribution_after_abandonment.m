function plot_ac_distribution_after_abandonment( obj, ABC )
%PLOT_AC_DISTRIBUTION_AFTER_ABANDONMENT Summary of this function goes here
%   Detailed explanation goes here

ac = obj.abandoned_cropland_hectare;

time = ABC.time;
ac_hectare_after_change = ABC.ac_hectare_after_change;

bnds = [1992 2000 2005 2010
    1999 2004 2009 2017];

dims = size(bnds);

binary_region = ac > 0;

hectares_vec = zeros(1,dims(2));

for t = 1:length(time)
   %find idx
   idx = 0;
   for bars = 1:dims(2)
      if time(t) >= bnds(1,bars)
          if time(t) <= bnds(2,bars)
              idx = bars;
          end
      end
       
   end
    if idx == 0
        continue
    end
    
    ac_this_year = ac_hectare_after_change(:,:,t);
    ac_this_year(binary_region == 0) = 0;
    
    hectares_vec(idx) = hectares_vec(idx) + sum(sum(ac_this_year));
    
    
end

hectares_tot = sum(sum(hectares_vec));
share_vec = hectares_vec/hectares_tot;

hectares_to_plot = share_vec*sum(sum(ac));
hectares_to_plot = 10^-3*hectares_to_plot;

figure
bar(hectares_to_plot);

x_labels = cell(1,dims(2));
for i = 1:dims(2)
x_labels{i} = [num2str(bnds(1,i)) '-' num2str(bnds(2,i))];
end

xticklabels(x_labels);
ylabel('kha')
xlabel('year')


filename = ['Output/plots/' obj.region_name '_AC_distribution_after_abandonment.pdf'];
print('-painters','-dpdf', '-r1000', filename)
filename_src = ['Output/plots/' obj.region_name '_src_data_AC_distribution_after_abandonment.mat'];
save(filename_src, 'hectares_to_plot', 'bnds' )



end

