function plot_dosemovies(V)
% cube dimensions = (anterior->posterior, right->left, inferior->superior)

maxdim = max(size(V));
scale = round(400/maxdim);

% Frontal view
figure;
for i=1:size(V,1)
    imshow(imresize(squeeze(V(i,:,:)),scale), 'DisplayRange', [0, max(V(:))],...
        'Colormap', jet);
    F(i) = getframe;
end
figure;
title('Frontal view');
xlabel('Inferior -> Superior');
ylabel('Left <- Right');
movie(F, 10, 10);

% Sagital view
figure;
clear F;
for i=1:size(V,2)
    imshow(imresize(squeeze(V(:,i,:)),scale), 'DisplayRange', [0, max(V(:))],...
        'Colormap', jet);
    F(i) = getframe;
end
figure;
title('Sagital view');
xlabel('Inferior -> Superior');
ylabel('Posterior <- Anterior');
movie(F, 20, 5);

% Transverse view
figure;
clear F;
for i=1:size(V,3)
    %imshow(mat2gray(imresize(squeeze(V(:,:,i)),scale), [0, max(V(:))]), jet);
    imshow(imresize(squeeze(V(:,:,i)),scale), 'DisplayRange', [0, max(V(:))],...
        'Colormap', jet);
    F(i) = getframe;
end
figure;
title('Transverse view');
xlabel('Right -> Left');
ylabel('Posterior <- Anterior');
movie(F, 20, 5);

end