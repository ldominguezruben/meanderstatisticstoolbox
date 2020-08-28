function [nReachPoints, xResample, yResample, sResample, cResample] =...
    mStat_getxyResampled(x,y,B,AdvancedSet)
%Dominguez Ruben 8/1/2017

fakeRMax = 10;       %  will work well with this number.

inLineCoords = [x y];
transParam = [AdvancedSet.nTimesToSmooth AdvancedSet.polyOrder...
    AdvancedSet.nPointsInWindow AdvancedSet.nReachPoints fakeRMax];

%      Calling Leigleiter Function.
[snOut,ClSpline,centerlineOut,xyOut,iMiss,iTrans] = ...
xy2sn(inLineCoords,inLineCoords,transParam);
   
inLineCoords1 = [centerlineOut(:,1) centerlineOut(:,2)];
[clCurveSeries, clSpline] = curvature(inLineCoords1, transParam);
 reachLength =  clCurveSeries(end,1);
 dS = diff(clCurveSeries(:,1));  %Spacing of s-coordinates
 aveDs = mean(dS); %Average point spacing
 dN = 100;  %Number of points that will be added or subtracted to reduce error
 error = (aveDs-B)/B; %Error of spacing
 nReachPoints = floor(reachLength/B);
 %Checks if error is within desired limit and resamples points until the
 %error is reduced to the desired amount
 while abs(error) > 0.01
      if aveDs-B < 0 
         signD = -1;
      else
         signD = 1;
      end 
   nReachPoints =  nReachPoints+dN*signD;
    
   transParam = [AdvancedSet.nTimesToSmooth AdvancedSet.polyOrder...
    AdvancedSet.nPointsInWindow nReachPoints fakeRMax];

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
 if mod(nReachPoints,1) < 1
     nReachPoints = nReachPoints-mod(nReachPoints,1);
 else
     nReachPoints = nReachPoints+1-mod(nReachPoints,1);
 end
 %Call Leigleiter final time. Transfora a coordenadas locales
 transParam = [AdvancedSet.nTimesToSmooth AdvancedSet.polyOrder...
    AdvancedSet.nPointsInWindow nReachPoints fakeRMax];

 [snOut,ClSpline,centerlineOut,xyOut,iMiss,iTrans] = ...
     xy2sn(inLineCoords,inLineCoords,transParam);
 equallySpacedX = centerlineOut(:,1);
 inLineCoords1 = [centerlineOut(:,1) centerlineOut(:,2)];
 [clCurveSeries, clSpline] = curvature(inLineCoords1, transParam);

 dS1 = diff(clCurveSeries(:,1));%check average segmentation
 aveDs1 = mean(dS1);% average segmentation
% figure(5)
% plot(dS,'-k')
% hold on
% plot(dS1,'-r')

 %Defining variables to pass
 xResample = centerlineOut(:,1);
 yResample = centerlineOut(:,2);
 difx=diff(xResample);
 dify=diff(yResample);
 
 for u=1:length(dify)
     sResample1(u)=sqrt(difx(u)^2+dify(u)^2);
 end
 sResample= [0;cumsum(sResample1)'];
 %sResample = clCurveSeries(:,1);
 cResample = clCurveSeries(:,2);
    