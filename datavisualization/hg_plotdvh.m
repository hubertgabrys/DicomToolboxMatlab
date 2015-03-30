function hg_plotdvh( args, vals, linecolor, str, ax )

plot(ax, args, vals, 'LineWidth', 2, 'Color', linecolor, 'LineStyle', ':');
xlabel(ax, {'Dose [Gy]'});
ylabel(ax, {'Relative Volume [%]'});
title(ax, str);
axis(ax, [0 70 0 100]);
hold on;

end