function [maxCurvS, maxCurvXY] = mStat_assignMaxCurv(dimlessCurvature, delta, sResample, equallySpaced)

%This function found the maximum curvature using the peakdet function
%Dominguez Ruben L. UNL

%       Use the peakdet function to get an index of the peaks and troughs
[maxtab, mintab]=peakdet(dimlessCurvature, delta, sResample);
%       Create index
index1 = zeros(length(maxtab(:,1)),1);
index2 = zeros(length(mintab(:,1)),1);

for i = 1:length(maxtab(:,1))
index1(i) = find(sResample == maxtab(i,1));
end

for i= 1:length(mintab(:,1))
index2(i) = find(sResample == mintab(i,1));
end

index = [index1; index2];
index = sort(index);

%peakS = handles.sResample(index1);%        s-ordinates of peaks.
%troughS = handles.sResample(index2);%      s-ordinates of troughs.
% maxCurvX = handles.equallySpacedX(index);% x-ordinates of peaks and troughs.
% maxCurvY = handles.equallySpacedY(index);% y-ordinates of peaks and troughs.
maxCurvS = sResample(index); %     s-ordinates of peaks and troughs.
maxCurvXY(:,1) =  equallySpaced(index,1);   %matrix with x,y coordinates of points of max curvature
maxCurvXY(:,2) =  equallySpaced(index,2);

%Bend to bend analize the distance that the point to line
