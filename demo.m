clear 
close all hidden
warning ('off','all');
addpath('./detect sky/')
%% Load image
[File_Name,Path] = uigetfile(fullfile('H:/data/dehazing/various/natural images/','*.tif;*.jpg;*.png;*.gif*'),'Image Selector');    
image = double(imread(fullfile(Path, File_Name)))./255; % input image
%% Define parameters
omega=0.95;
r = 64;   % radio gf
eps = 0.01; %regularization gf
s = 4;   % $scale gf
patch_size_dc1=16;
%% Dehazing algorithm
tic 
    [radiance2,transmission2]=dehaze(image,omega,r,eps,s);
    toc
    
    figure('Name','Dehaze...')
    h(1)=axes('pos',[0.01 0.2 0.3 0.6]);
    imagesc(image);axis off;title('Original image')

    h(2)=axes('pos',[0.33 0.2 0.3 0.6]);
    imagesc(transmission2,[0 1]);axis off;title('Transmission map')

    h(3)=axes('pos',[0.66 0.2 0.3 0.6]);
    imagesc(radiance2);axis off;title('Dehazed image')
    expandAxes(h)
toc

