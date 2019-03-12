function [nReachPoints, xResample, yResample, sResample, cResample] = mStat_getxyResampled(x,y,B)
%Dominguez Ruben 8/1/2017

%      General parameters to get equally spaced data.
nTimesToSmooth = 3;  %  equivalent to "nFilt" in "curvature" function. 
polyOrder =2;        %  equivalent to "order" in "curvature" function.
nPointsInWindow = 7; %  equivalent to "window" in "curvature" function.
nReachPoints = 1500; %  equivalent to "nDiscr" in "curvature" function 
                     %  in the banks: 1500 works well in most of the cases.
fakeRMax = 10;       %  will work well with this number.
inLineCoords = [x y];
transParam = [nTimesToSmooth polyOrder nPointsInWindow nReachPoints fakeRMax];

%      Calling Leigleiter Function.
[snOut,ClSpline,centerlineOut,xyOut,iMiss,iTrans] = ...
xy2sn(inLineCoords,inLineCoords,transParam);
   
inLineCoords1 = [centerlineOut(:,1) centerlineOut(:,2)];
[clCurveSeries, clSpline] = curvature(inLineCoords1, transParam);
 reachLength =  clCurveSeries(end,1);
 dS = diff(clCurveSeries(:,1));  %Spacing of s-coordinates
 aveDs = mean(dS); %Average point spacing
 dN = 50;  %Number of points that will be added or subtracted to reduce error
 error = (aveDs-B)/B; %Error of spacing
 nReachPoints = floor(reachLength/B);
 %Checks if error is within desired limit and resamples points until the
 %error is reduced to the desired amount
 while abs(error) > 0.50
      if aveDs-B < 0 
          signD = -1;
      else
         signD = 1;
      end 
   nReachPoints =  nReachPoints+dN*signD;
%    if nReachPoints<0
%        dN = 1;
%        nReachPoints =  floor(reachLength/B)+dN*signD;
%        transParam = [nTimesToSmooth polyOrder nPointsInWindow nReachPoints fakeRMax];
%    else
   transParam = [nTimesToSmooth polyOrder nPointsInWindow nReachPoints fakeRMax];
%    end
   
   [snOut,ClSpline,centerlineOut,xyOut,iMiss,iTrans] = ...
       xy2sn(inLineCoords,inLineCoords,transParam);
   equallySpacedX = centerlineOut(:,1);
  [clCurveSeries, clSpline] = curvature(inLineCoords1, transParam);
   reachLength =  clCurveSeries(end,1);
   dS = diff(clCurveSeries(:,1));  %Spacing of s-coordinates
   aveDs = mean(dS);  %Average point spacing
   dN = 100;  %Number of points that will be added or subtracted to reduce error
   error = (aveDs-B)/B; %Error of spacing    
 end
 %Round number of points
 if mod(nReachPoints,50) < 25
     nReachPoints = nReachPoints-mod(nReachPoints,50);
 else
     nReachPoints = nReachPoints+50-mod(nReachPoints,50);
 end
 %Call Leigleiter final time. Transfora a coordenadas locales
 transParam = [nTimesToSmooth polyOrder nPointsInWindow nReachPoints fakeRMax];
 [snOut,ClSpline,centerlineOut,xyOut,iMiss,iTrans] = ...
     xy2sn(inLineCoords,inLineCoords,transParam);
 equallySpacedX = centerlineOut(:,1);
 inLineCoords1 = [centerlineOut(:,1) centerlineOut(:,2)];
 [clCurveSeries, clSpline] = curvature(inLineCoords1, transParam);
 %disp(['Number of points after resampling: ', num2str(nReachPoints)]);
 %Defining variables to pass
 xResample = centerlineOut(:,1);
 yResample = centerlineOut(:,2);
 sResample = clCurveSeries(:,1);
 cResample = clCurveSeries(:,2);
    