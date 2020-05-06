function [a] = compute_new_airlight(image,mask)
a(1)=(mean(nonzeros(image(:,:,1).*mask)));
a(2)=(mean(nonzeros(image(:,:,2).*mask)));
a(3)=(mean(nonzeros(image(:,:,3).*mask)));
if isnan(a(1)),a(1)=1;end;
if isnan(a(2)),a(2)=1;end;  
if isnan(a(3)),a(3)=1;end;
end

