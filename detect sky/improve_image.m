function [radiance2,transmission2,new_airlight] = improve_image(image,rep_atmosphere,omega)
    [m,n,~]=size(image);
    img_norm=image./rep_atmosphere;
    [mask,new_airlight]=detect_sky(img_norm);
	rep_new_airlight = repmat(reshape(new_airlight, [1, 1, 3]), m, n);
    str1=strel('square',15);
	dc=imerode(min(image./rep_new_airlight,[],3),str1);%The dark channel

    new_dc=(dc.*(1-mask))+((1-dc).*mask); 
    trans2=1-omega.*new_dc;

	transmission2=fastguidedfilter(rgb2gray(image),trans2, 64, 0.01, 8);%321e-6

    radiance2 = get_radiance(image, transmission2, rep_new_airlight);
end