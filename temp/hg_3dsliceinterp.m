% top = imread('C:\Users\gabrysh\Desktop\Coding\temp\pic1.png');
% bottom = imread('C:\Users\gabrysh\Desktop\Coding\temp\pic2.png');
% top = ~im2bw(top);
% bottom = ~im2bw(bottom);

im1 = ~im2bw(imread('C:\Users\gabrysh\Desktop\Coding\temp\pic_b1.png'));
im2 = ~im2bw(imread('C:\Users\gabrysh\Desktop\Coding\temp\pic_b2.png'));
im3 = ~im2bw(imread('C:\Users\gabrysh\Desktop\Coding\temp\pic_b3.png'));
% figure;
% imshow(top);
% figure;
% imshow(bottom);
 %% Schenk method

% 
% figure;
% imshow(bwperim(top));
% 
% figure;
% imshow(bwdist(bwperim(top)));


% bwperim(BW) returns a binary image that contains only the perimeter pixels...
%   of objects in the input image BW.
% bwdist(BW) computes the Euclidean distance transform of the binary image BW. ...
%   For each pixel in BW, the distance transform assigns a number that is ...
%   the distance between that pixel and the nearest nonzero pixel of BW.
imdist = @(x) -bwdist(bwperim(x)).*~x + bwdist(bwperim(x)).*x;


im1 = imdist(im1);
im2 = imdist(im2);
im3 = imdist(im3);

%num = 20;

r = size(im1,1);
c = size(im1,2);
%t = num+2;

[x y z] = ndgrid(1:r,1:c,1:3); % existing data
[xi yi zi] = ndgrid(1:r,1:c,1:0.1:3); % including new slice

out = interpn(x,y,z,cat(3,im1,im2,im3),xi,yi,zi);
%out = out(:,:,2:end-1)>=0;
out = out(:,:,1:end)>=0;

% figure;
% imshow(abs(im2), [0, max(im2(:))]);


%% print
for i=1:size(out,3)
figure;
imshow(out(:,:,i));
end

%% simple method <- it won't do!
num = 10;
r = size(top,1);
c = size(top,2);
t = num+2;

[x y z] = ndgrid(1:r,1:c,[1 t]); % existing data
[xi yi zi] = ndgrid(1:r,1:c,1:t); % including new slice

bottom = bottom+0;
top = top+0;
out = interpn(x,y,z,cat(3,bottom,top),xi,yi,zi,'cubic');
%out = out(:,:,2:end-1)>=0;
%out = out(:,:,1:end)>=0.5;