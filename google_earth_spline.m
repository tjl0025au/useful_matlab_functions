function [spline_lat,spline_lon,spline_alt] = google_earth_spline(lat,lon,n)

lat_xx = linspace(lat(1),lat(end),n);

lon_xx = spline(lat,lon,lat_xx);

% geoplot(lat_xx,lon_xx)
% geobasemap satellite

spline_lat = lat_xx';
spline_lon = lon_xx';
spline_alt = repelem(600,length(lat_xx))';