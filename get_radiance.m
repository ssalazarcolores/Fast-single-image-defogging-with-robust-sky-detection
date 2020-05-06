function radiance = get_radiance(image, transmission, rep_atmosphere)
max_transmission = repmat(max(transmission, 0.1), [1, 1, 3]);
radiance = ((image - rep_atmosphere) ./ max_transmission) + rep_atmosphere;
end