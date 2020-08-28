function ArMigra=mStat_MigrationArea(geovar)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Define are bends
%by Dominguez Ruben
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Determinate the intersection points
robust=0;

[ArMigra.xint_area,ArMigra.yint_area,~,~]=intersections(geovar{1}.equallySpacedX,geovar{1}.equallySpacedY,...
    geovar{2}.equallySpacedX,geovar{2}.equallySpacedY,robust);

%Determinate area
%quit the first and end value
linet0=[geovar{1}.equallySpacedX,geovar{1}.equallySpacedY];
linet1=[geovar{2}.equallySpacedX,geovar{2}.equallySpacedY];

%Calculate the area between lines

t0area=trapz(geovar{1}.equallySpacedX,geovar{1}.equallySpacedY);
t1area=trapz(geovar{2}.equallySpacedX,geovar{2}.equallySpacedY);

ArMigra.TotalA=abs(t1area-t0area);

%figure(3)
plot(geovar{1}.equallySpacedX,geovar{1}.equallySpacedY,'-r')
hold on
plot(geovar{2}.equallySpacedX,geovar{2}.equallySpacedY,'-b')
fill(linet0,linet1,'g')






