function txt = mStat_myupdatefcn(obj,event_obj)
% 

%Read input variables
bendID= getappdata(0, 'bendID');
bendID = str2num(bendID);
sinuosityOfBends = getappdata(0, 'sinuosityOfBends');
sinuosityOfBends = str2num(sinuosityOfBends);
lengthCurved = getappdata(0, 'lengthCurved');
lengthCurved = str2num(lengthCurved);
wavelengthOfBends = getappdata(0, 'wavelengthOfBends');
wavelengthOfBends = str2num(wavelengthOfBends);
amplitudeOfBends = getappdata(0, 'amplitudeOfBends');
amplitudeOfBends = str2num(amplitudeOfBends);
intS = getappdata(0, 'intS');
intS = str2num(intS);
downstreamSlength = getappdata(0, 'downstreamSlength');
downstreamSlength = str2num(downstreamSlength);
upstreamSlength = getappdata(0, 'upstreamSlength');
upstreamSlength = str2num(upstreamSlength);
sResample = getappdata(0, 'sResample');
sResample = str2num(sResample);
equallySpacedX= getappdata(0, 'equallySpacedX');
equallySpacedX = str2num(equallySpacedX);
equallySpacedY = getappdata(0, 'equallySpacedY');
equallySpacedY = str2num(equallySpacedY);
newInflectionPts = getappdata(0, 'newInflectionPts');
newInflectionPts = str2num(newInflectionPts);




%data window
pos = get(event_obj,'Position');
clickX=round(pos(1)*10000)/10000;
clickY=round(pos(2)*10000)/10000;

%create vector
cursorX=nan(length(bendID),500);
cursorY=nan(length(bendID),500);

for hf=1:length(bendID)
 [highlightX, highlightY] = userSelectBend(intS, bendID (hf),...
    equallySpacedX,equallySpacedY,newInflectionPts,...
    sResample);
 len=length(highlightX);
 cursorX(hf,1:len)=highlightX;
 cursorY(hf,1:len)=highlightY;
end

%find equal
[row,col]= find(clickX==cursorX);


pos = get(event_obj,'Position');
txt = {['BendID: ',num2str(row)],['Sinuosity: ',num2str(sinuosityOfBends(row))],...
    ['Arc Wavelength [m]: ',num2str(lengthCurved(row))],...
    ['Wavelength [m]: ',num2str(wavelengthOfBends(row))],...
    ['Amplitude [m]: ',num2str(amplitudeOfBends(row))],...
    ['Upstream length [m]: ',num2str(upstreamSlength(row))],...
    ['Downstream length [m]: ',num2str(downstreamSlength(row))]};
set(0,'userdata',pos);

end
