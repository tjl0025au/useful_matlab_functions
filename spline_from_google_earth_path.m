function [splined_lla] = spline_from_google_earth_path(path_filename,n)

lla = kml2struct(path_filename);

lla = flip(lla,1);
lat = lla.Lat;
lon = lla.Lon;

i = 1;
count = 1;
while i<= length(lat) && count <= length(lat)-1
    [spline(i).lat,spline(i).lon,spline(i).alt] = google_earth_spline(lat(count:count+1),lon(count:count+1),n);
    i = i+1;
    count = count + 1;
end


i = 1;
while i <= length(spline(1,:))
    if i == 1
        lat_ = spline(i).lat';
        lon_ = spline(i).lon';
        alt_ = spline(i).alt';
    else
        lat_1 = spline(i).lat';
        lon_1 = spline(i).lon';
        alt_1 = spline(i).lat';
        lat_ = [lat_ lat_1];
        lon_ = [lon_ lon_1];
        alt_ = [alt_ alt_1];
    end
    i = i+1;
end


% geoplot(lat_,lon_)
% geobasemap satellite

splined_lla = [lat_',lon_',alt_'];