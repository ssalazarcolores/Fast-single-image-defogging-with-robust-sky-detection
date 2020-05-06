function [t_ref] = compute_transmission(image,dc,r,eps,s)
    t_dc=1-dc;
    t_ref=fastguidedfilter_color(image,t_dc, r, eps, s); 
end
