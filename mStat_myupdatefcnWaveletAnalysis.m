function txt = mStat_myupdatefcn(obj,event_obj)
% 

%Read input variables
geovar= getappdata(0, 'geovar');

%data window
pos = get(event_obj,'Position');
clickX=round(pos(1)*10000)/10000;
clickY=round(pos(2)*10000)/10000;

%create vector
cursorX=nan(length(geovar.bendID1),500);
cursorY=nan(length(geovar.bendID1),500);

for hf=1:length(geovar.bendID1)
 [highlightX, highlightY] = userSelectBend(geovar.intS, geovar.bendID1 (hf),...
    geovar.equallySpacedX,geovar.equallySpacedY,geovar.newInflectionPts,...
    geovar.sResample);
% highlightPlot = line(highlightX(1,:), highlightY(1,:), 'color', 'y'); 
 len=length(highlightX);
 cursorX(hf,1:len)=highlightX;
 cursorY(hf,1:len)=highlightY;
 
end


%find equal
[row1,pos]= find(clickX==round(geovar.equallySpacedX*10000)/10000);

figure(2)
DeltaCentS=geovar.sResample(2,1)-geovar.sResample(1,1);
xmin=min(geovar.sResample(:,1));
n = length(geovar.sResample);
xlim = [xmin,(n-1)*DeltaCentS+xmin];
dt=1;
Abscise = [1:length(geovar.cResample)]*dt + xmin ;

dimlessx=Abscise*DeltaCentS./geovar.width;
dimlessy=geovar.cResample.*geovar.width;
plot(dimlessx,dimlessy,'black -','linewidth',1.0);
hold on
plot(dimlessx(row1),dimlessy(row1),'or');
set(gca,'XLim',xlim(:)./geovar.width);
xlabel('S*','fontsize',10);
ylabel('C*','fontsize',10);
title('Signature of the channel curvature','fontsize',13);
grid on;
hold off;

waitbar(25/100,hwait);


%find equal
[row,~]= find(clickX==cursorX);


pos = get(event_obj,'Position');
txt = {['BendID: ',num2str(row)],['Sinuosity: ',num2str(round(sinuosityOfBends(row),2))],...
    ['Arc Wavelength [m]: ',num2str(round(lengthCurved(row),1))],...
    ['Wavelength [m]: ',num2str(round(wavelengthOfBends(row),1))],...
    ['Amplitude [m]: ',num2str(round(amplitudeOfBends(row),1))],...
    ['Upstream length [m]: ',num2str(round(upstreamSlength(row),1))],...
    ['Downstream length [m]: ',num2str(round(downstreamSlength(row),1))]};
set(0,'userdata',pos);

end
