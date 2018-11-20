function mStat_kml(name,latlon1,latlon2,latlon3)
%makes a kml file for use in google earth
%input:  name of track, one matrix containing latitude and longitude
%usage:  pwr_kml('track5',latlon)

header=['<kml xmlns="http://earth.google.com/kml/2.0"><Placemark><description>"' name '"</description><LineString><tessellate>1</tessellate><coordinates>'];
footer='</coordinates></LineString></Placemark></kml>';

fid = fopen([name '_Centerline.kml'], 'wt');
d=flipud(rot90(fliplr(latlon1)));
fprintf(fid, '%s \n',header);
fprintf(fid, '%.6f,%.6f,0.0 \n', d);
fprintf(fid, '%s', footer);
fclose(fid);

clear d

fid = fopen([name '_MeanCenterLine.kml'], 'wt');
d=flipud(rot90(fliplr(latlon2)));
fprintf(fid, '%s \n',header);
fprintf(fid, '%.6f,%.6f,0.0 \n', d);
fprintf(fid, '%s', footer);
fclose(fid);

clear d

fid = fopen([name '_InflectionPointsLine.kml'], 'wt');
d=flipud(rot90(fliplr(latlon3)));
fprintf(fid, '%s \n',header);
fprintf(fid, '%.6f,%.6f,0.0 \n', d);
fprintf(fid, '%s', footer);
fclose(fid);