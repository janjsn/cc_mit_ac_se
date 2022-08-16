function plot_wheat_production_losses_after_yield_gains( obj )
%PLOT_WHEAT_PRODUCTION_LOSSES_AFTER_YIELD_GAINS Summary of this function goes here
%   Detailed explanation goes here

figure
loss_se5_to_10 = 10^-3*obj.wheat_production_change_after_mean_yield_gain_se5_to_se10;
loss_se10 = 10^-3*obj.wheat_production_change_after_mean_yield_gain_se10;

subplot(2,2,1)
plot(100*obj.yield_gain_vec, loss_se5_to_10)
xlabel('Mean yield increase (%)');
ylabel('Change in food production (kton dm yr-1)');
subplot(2,2,2)
plot(100*obj.yield_gain_vec, loss_se10);
xlabel('Mean yield increase (%)');
ylabel('Change in food production (kton dm yr-1)');

filename = 'Output/wheat_production_loss.pdf';
if exist(filename, 'file')
   delete(filename) 
end
print('-painters','-dpdf', '-r1000', filename)
end

