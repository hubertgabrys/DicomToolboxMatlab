function hg_plot3Ddosedensity( cube, xVec, yVec, zVec, ax )

[V, x1gv, x2gv, x3gv] = hg_cropcube(cube, xVec, yVec, zVec, 'zero');

[ Vi, x1gvi, x2gvi, x3gvi ] = hg_interpcube( V, x1gv, x2gv, x3gv, 1, 'linear');

maxdim = max(size(Vi));
xpad = round((maxdim-length(x1gvi))/2);
ypad = round((maxdim-length(x2gvi))/2);
zpad = round((maxdim-length(x3gvi))/2);
Vpi = padarray(Vi,[xpad,ypad,zpad]);
if mod(maxdim,2)
    for i=1:3
        if ~mod(size(Vpi,i),2)
            if i==1
                Vpi(end,:,:) = [];
            elseif i==2
                Vpi(:,end,:) = [];
            else
                Vpi(:,:,end) = [];
            end
        end
    end
else
    for i=1:3
        if mod(size(Vpi,i),2)
            if i==1
                Vpi(end,:,:) = [];
            elseif i==2
                Vpi(:,end,:) = [];
            else
                Vpi(:,:,end) = [];
            end
        end
    end
end

%% plot single axis plots
% 1d
x = x1gv;
y = squeeze(sum(sum(V,3),2));
figure;
plot(x,y);
title('1d: anterior -> posterior');
% x = x1gvi;
% y = sum(sum(Vpi,3),2);
% plot(x,y); hold off;

% 2d
x = x2gv;
y = squeeze(sum(sum(V,3),1));
figure;
plot(x,y);
title('2d: right -> left');

% 3d
x = x3gv;
y = squeeze(sum(sum(V,1),2));
figure;
plot(x,y);
title('3d: inferior -> superior');

%% plot 3d density
[X,Y,Z] = meshgrid(1:size(Vpi,1),1:size(Vpi,2),1:size(Vpi,3));
smoothing = 'direct';

figure;
%set(gcf,'renderer','opengl')
mini = min(Vpi(Vpi(:)>0));
maxi = max(Vpi(Vpi(:)>0));
pcolor3(X,Y,Z,Vpi, 'alphalim', [0,maxi], 'alpha', 0.05, 'edgealpha', 0.01, smoothing);
colormap(ax, jet)
view(-30,30)
xlabel('2d: right -> left');
ylabel('1d: posterior <- anterior');
zlabel('z: inferior -> superior')
colorbar('location','eastoutside');

figure;
%set(gcf,'renderer','opengl')
mini = min(Vpi(Vpi(:)>0));
maxi = max(Vpi(Vpi(:)>0));
pcolor3(X,Y,Z,Vpi, 'alphalim', [0,maxi], 'alpha', 0.05, 'edgealpha', 0.01, smoothing);
colormap(ax, jet)
view(-90,0)
xlabel('2d: right -> left');
ylabel('1d: posterior <- anterior');
zlabel('z: inferior -> superior')
colorbar('location','eastoutside');

figure;
%set(gcf,'renderer','opengl')
mini = min(Vpi(Vpi(:)>0));
maxi = max(Vpi(Vpi(:)>0));
pcolor3(X,Y,Z,Vpi, 'alphalim', [0,maxi], 'alpha', 0.05, 'edgealpha', 0.01, smoothing);
colormap(ax, jet)
view(90,0)
xlabel('2d: right -> left');
ylabel('1d: posterior <- anterior');
zlabel('3d: inferior -> superior')
colorbar('location','eastoutside');

figure;
%set(gcf,'renderer','opengl')
mini = min(Vpi(Vpi(:)>0));
maxi = max(Vpi(Vpi(:)>0));
pcolor3(X,Y,Z,Vpi, 'alphalim', [0,maxi], 'alpha', 0.05, 'edgealpha', 0.01, smoothing);
colormap(ax, jet)
view(0,0)
xlabel('2d: right -> left');
ylabel('1d: posterior <- anterior');
zlabel('3d: inferior -> superior')
colorbar('location','eastoutside');

figure;
%set(gcf,'renderer','opengl')
mini = min(Vpi(Vpi(:)>0));
maxi = max(Vpi(Vpi(:)>0));
pcolor3(X,Y,Z,Vpi, 'alphalim', [0,maxi], 'alpha', 0.05, 'edgealpha', 0.01, smoothing);
colormap(ax, jet)
view(180,0)
xlabel('2d: right -> left');
ylabel('1d: posterior <- anterior');
zlabel('3d: inferior -> superior')
colorbar('location','eastoutside');

end