function [mask] = detect_sky(image_norm)
    %% Parameters
    u_m=3;
    tolerance = 0;
    m=0.9;
    min_s=400;
    %%
    edges=sum(stdfilt(image_norm),3);  
    std_dv=mat2gray(edges);
    filt_std=1-bwareaopen(std_dv<0.05,min_s);   
    edges_f=edges.*filt_std;       



    %%
    str2=strel('square',15);
    entropia=entropyfilt(edges,str2.Neighborhood);  % calculo entropia

    str1=strel('square',8);
    t1_dc=imerode(max(image_norm,[],3),str1);%The dark channel


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
    mask=f_mask2;
end




    