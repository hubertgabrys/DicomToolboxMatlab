function hg_plotdvh( args, vals, linecolor, varargin )

if ~isempty(varargin)
    str = varargin{1};
    ax = varargin{2};
    plot(ax, args, vals, 'LineWidth', 2, 'Color', linecolor, 'LineStyle', '--');
    xlabel(ax, {'Dose [Gy]'});
    ylabel(ax, {'Relative Volume [%]'});
    title(ax, str);
    axis(ax, [0 70 0 100]);
    hold on;
else
    plot(args, vals, 'LineWidth', 2, 'Color', linecolor, 'LineStyle', '--');
    xlabel({'Dose [Gy]'});
    ylabel({'Relative Volume [%]'});
    axis([0 70 0 100]);
end

end