function [radiance2,transmission2] = dehaze(image,omega,r,eps,s)
addpath('./detect sky/')

patch_size_dc1=16;
%% Dehazing algorithm
[m,n,~]=size(image);

str1=strel('square',patch_size_dc1);
dc1=imerode(min(image,[],3),str1);%The dark channel
atmosphere=compute_airlight(image, dc1); %Such as He
rep_atmosphere = repmat(reshape(atmosphere, [1, 1, 3]), m, n);

[radiance2, transmission2] = improve_image(image,rep_atmosphere,omega);
end

