function hg_plotdvh( args, vals, linecolor, str )

plot(args, vals, 'LineWidth', 2, 'Color', linecolor, 'LineStyle', ':');
xlabel({'Dose [Gy]'});
ylabel({'Relative Volume [%]'});
title(str);
axis([0 70 0 100]);
hold on;

end