function [sky_mask,new_airlight] = detect_sky(image_norm)
%% Compute and filter edges based on a standard deviation filter
[a,b,c]=size(image_norm);
image_norm=imresize(image_norm,[600 400]);% scale image

image_norm_lab=rgb2lab(image_norm); % Change image to spacecolor Lab

str1=strel('square',15);
dc=imerode(min(image_norm,[],3),str1);% Compute dark channel


[gx,gy] = imgradientxy(image_norm_lab(:,:,1));

edges_lab=mat2gray(sqrt(gx.^2+gy.^2));% Compute local standard deviation in L channel


edges_filt=edges_lab>0.05;
mask_m_dc=dc>0.85;% Threshold dc
edges_filt_dc=edges_filt.*(1-mask_m_dc);
%% Compute max dark channel

%% Compute local entropy
str2=strel('square',15);
entropy=entropyfilt(edges_filt,str2.Neighborhood);

%% Compute and fusion preliminary sky region detection
mask_entropy=1-(entropy>0);
mask_m_dc=dc>0.85;
mask_trans=mask_entropy.*mask_m_dc;

%% Filter preliminary sky region
f_mask=zeros(size(edges_filt_dc));
str3=strel('square',5);
edges_filt_dc=imclose(edges_filt_dc,str3);
%% Final segmentation of sky region
row=0;
column=0;
if sum(sum(mask_trans))>0
    mask_p=bwmorph(bwmorph(mask_trans,'skel',Inf),'branch')+bwmorph(bwmorph(mask_trans,'skel',Inf),'endpoint'); % Compute skeleton and endpoints
% 	mask_p=bwmorph(bwmorph(mask_trans,'skel',Inf),'endpoint'); % Compute skeleton and endpoints
    [row, column] = find(mask_p == 1);
    for i=1:size(row,1)
        if f_mask(row(i), column(i))==0
            f_mask = (f_mask+grayconnected(edges_filt_dc,row(i),column(i),0))>0; % region growing of seeds
        end
    end
    f_mask2=1-bwareaopen(1-(f_mask>0),5000); % Area opening
else
    f_mask2=mask_trans;
end

sky_mask=imresize(f_mask2,[a b]);
new_airlight=compute_new_airlight(image_norm,f_mask2);

end




