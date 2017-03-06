function plot_dvh( struct_cube, linecolor, varargin )

dose_domain = (0:0.1:100)';
struct_dc2 = struct_cube(struct_cube ~= 0);
noVox = nnz(struct_dc2);
volume_relative = zeros(length(dose_domain),1);
for k=1:length(dose_domain)
    volume_relative(k) = nnz(struct_dc2 >= dose_domain(k))*100/nnz(struct_dc2);
    if volume_relative(k) > 100
        disp('what!?');
        disp(volume_relative(k));
    end
end

args = dose_domain;
vals = volume_relative;

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