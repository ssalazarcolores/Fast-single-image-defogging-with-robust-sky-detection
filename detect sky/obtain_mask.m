function [f_mask2] = obtain_mask(img_norm,edges,filt_std,edges_f)
%% Parameters
u_m=3;
tolerance = 0;
m=0.9;
%%
str2=strel('square',15);
entropia=entropyfilt(edges,str2.Neighborhood);  % calculo entropia

str1=strel('square',8);
t1_dc=imerode(max(img_norm,[],3),str1);%The dark channel


% mask_trans=(entropia<u_m).*(1-filt_std).*t1_dc>m;
mask_trans=(entropia<u_m).*t1_dc>m;
mask_trans=bwareaopen(mask_trans,50);   

f_mask=zeros(size(edges_f));
str2=strel('square',3);
edges_f=imclose(edges_f,str2);

if sum(sum(mask_trans))>2  
    mask_p=bwmorph(bwmorph(mask_trans,'skel',Inf),'branchpoints');
    [row, column] = find(mask_p == 1);
    a(:,1)=row;
    a(:,2)=column;
    for i=1:size(a,1)
        if f_mask(a(i,1), a(i,2))==0
            f_mask = f_mask+grayconnected(edges_f,a(i,1), a(i,2),tolerance);
        end
    end
    f_mask2=1-bwareaopen(1-(f_mask>0),5000);
  else
    f_mask2=mask_trans;
    a(1,1)=1;
    a(1,2)=1;
end
% 
% figure('Name','Detecting sky process...')
% h(1)=axes('pos',[0.01 0.66 0.3 0.3]);
% imagesc(img_norm);axis off;title('Original image')
% h(2)=axes('pos',[0.33 0.66 0.3 0.3]);
% imagesc(edges);axis off;title('Edges')
% h(3)=axes('pos',[0.66 0.66 0.3 0.3]);
% imagesc(filt_std);axis off;title('Standard deviation > 0.05')
% h(4)=axes('pos',[0.01 0.33 0.3 0.3]);
% imshowpair(img_norm,1-filt_std);axis off;title('Standard deviation <0.05 filtered')
% h(5)=axes('pos',[0.33 0.33 0.3 0.3]);
% imagesc(entropia);axis off;title('Entropia')
% h(6)=axes('pos',[0.66 0.33 0.3 0.3]);
% imshowpair(img_norm,(entropia<u_m));axis off;title('Entropia > 4')
% h(7)=axes('pos',[0.01 0.01 0.3 0.3]);
% imagesc(t1_dc);axis off;title('DC transmission')
% h(8)=axes('pos',[0.33 0.01 0.3 0.3]);
% imshowpair(img_norm,(t1_dc>m));axis off;title('DC transmission < 0.5')
% h(9)=axes('pos',[0.66 0.01 0.3 0.3]);
% imshowpair(img_norm,mask_trans);axis off;title('Initial Sky...')
% expandAxes(h)
% 
% figure('Name','Segmentation sky process...')
% h(1)=axes('pos',[0.01 0.66 0.3 0.3]);
% imshowpair(img_norm,mask_trans);axis off;title('Initial sky...')
% h(2)=axes('pos',[0.33 0.66 0.3 0.3]);
% imagesc(edges);axis off;title('Initial edges');
% h(3)=axes('pos',[0.66 0.66 0.3 0.3]);
% imagesc(filt_std);axis off;title('mask filter');
% h(4)=axes('pos',[0.01 0.33 0.3 0.3]);
% imagesc(edges_f);axis off;title('Filtered edges');
% h(5)=axes('pos',[0.33 0.33 0.3 0.3]);
% imagesc(edges_f);hold on;plot(a(:,2),a(:,1),'.r','MarkerSize',15);axis off;title('Guide edges with seeds')
% h(6)=axes('pos',[0.66 0.33 0.3 0.3]);
% imagesc(img_norm);hold on;plot(a(:,2),a(:,1),'.r','MarkerSize',20);axis off;title('Sky with seeds...')
% h(7)=axes('pos',[0.01 0.01 0.3 0.3]);
% imshowpair(img_norm,f_mask);axis off;title('Segmented sky...')
% h(8)=axes('pos',[0.33 0.01 0.3 0.3]);
% imshowpair(img_norm,f_mask2);axis off;title('Segmented sky without noise...')
% 
% 
% expandAxes(h)
end

