function hg_plotdvh( args, vals, linecolor, varargin )

if ~isempty(varargin)
    str = varargin{1};
    ax = varargin{2};
    plot(ax, args, vals, 'LineWidth', 2, 'Color', linecolor, 'LineStyle', ':');
    xlabel(ax, {'Dose [Gy]'}, 'FontSize', 14);
    ylabel(ax, {'Relative Volume [%]'}, 'FontSize', 14);
    title(ax, str);
    axis(ax, [0 80 0 100]);
    %hold on;
else
    plot(args, vals, 'LineWidth', 2, 'Color', linecolor, 'LineStyle', ':');
    xlabel({'Dose [Gy]'}, 'FontSize', 14);
    ylabel({'Relative Volume [%]'}, 'FontSize', 14);
    axis([0 80 0 100]);
end

end