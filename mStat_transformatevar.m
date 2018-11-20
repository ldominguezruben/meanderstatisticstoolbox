function mStat_transformatevar(geovar)

%this function stor the vaiables
bendID = num2str(geovar.bendID1);
setappdata(0, 'bendID', bendID);
intS = num2str(geovar.intS);
setappdata(0, 'intS', intS);
sResample = num2str(geovar.sResample);
setappdata(0, 'sResample', sResample);
sinuosityOfBends = num2str(geovar.sinuosityOfBends);
setappdata(0, 'sinuosityOfBends', sinuosityOfBends);
lengthStraight = num2str(geovar.lengthStraight);
setappdata(0, 'lengthStraight', lengthStraight);
lengthCurved = num2str(geovar.lengthCurved);
setappdata(0, 'lengthCurved', lengthCurved);
wavelengthOfBends = num2str(geovar.wavelengthOfBends);
setappdata(0, 'wavelengthOfBends', wavelengthOfBends);
amplitudeOfBends = num2str(geovar.amplitudeOfBends);
setappdata(0, 'amplitudeOfBends', amplitudeOfBends);
downstreamSlength = num2str(geovar.downstreamSlength);
setappdata(0, 'downstreamSlength',downstreamSlength);
upstreamSlength = num2str(geovar.upstreamSlength);
setappdata(0, 'upstreamSlength', upstreamSlength);
equallySpacedX = num2str(geovar.equallySpacedX);
setappdata(0, 'equallySpacedX',equallySpacedX);
equallySpacedY = num2str(geovar.equallySpacedY);
setappdata(0, 'equallySpacedY',equallySpacedY);
newInflectionPts= num2str(geovar.newInflectionPts);
setappdata(0, 'newInflectionPts',newInflectionPts);


