function[amplitudeOfBends] = mStat_amplitude(inflectionX, inflectionY,...
    nBends, maxCurvX, maxCurvY, newInflectionPts,numMaxPts)

%      Last Modified:  November 2014 by Kristin Dauer.
%      Last Modified:  April 2016 by Lucas Dominguez.
%
%      This function takes the x,y coordinates of the peaks and troughs 
%      of a given river reach and calculates the planimetric amplitude 
%      of each bend.  Note:  the planimetric amplitude is defined as the
%      distance between the point of maximum curvature and the line between
%      the limiting inflection points of each bend.  In this function, the
%      amplitude is found using the vector distance formula and the
%      "createLine" and "projPointOnLine" functions from the MATLAB file
%      exchange.
%      
%      INPUTS:
%      
%      inflectionX = the X-coordinates of each inflection point defined
%      along the river reach.  
%      inflectionY = the Y-coordinates of each inflection point defined
%      along the river reach. 
%      nBends = the number of bends in the river reach of interest.   
%      maxCurvX = the x-coordinates of the peaks and troughs along the
%      river reach.  
%      maxCurvY = the y-coordinates of the peaks and troughs along the
%      river reach.
%      numMaxPts = an array, where each row represents a bend, and the
%      number in that row tells how many points of maximum curvature are in
%      that bend.
%
%      OUTPUTS:
%      amplitudeOfBends = a structure that contains the planarmetric 
%      amplitude of each river bend in order from upstream to downstream.  

%--------------------------------------------------------------------------

%      The x,y coordinates of the peaks/troughs of each bend are known
%      already as maxCurvX and maxCurvY.  Make a matrix to
%      contain all of these maximum curvature points.  

maxCurvXY = [maxCurvX maxCurvY];

%      Thus, the first step in the calculation is to estimate a point along
%      the line between the limiting inflection points that can serve as 
%      the other end of the amplitude distance.  This point is found below
%      by projecting the point of maximum curvature onto the constructed 
%      line between the two limiting inflection points. 

%      Construct lines between the two limiting inflection points of each
%      bend.  Store these lines in the matrix called "lineC".  

%lineC = createLine((newInflectionPts(1,:)), newInflectionPts(2,:));
for i = 1:nBends
lineC(i,:) = createLine((newInflectionPts(i,:)), newInflectionPts(i+1,:));
end

%      Now, we can find the amplitude of each bend using the distance
%      formula between the peaks/troughs and the projected points. 
%      If there are more than one points of maximum curvature in a bend,
%      then the amplitude is calculated at each of the points of maximum
%      curvature in that bend, and the largest value is assigned as the
%      amplitude of the bend. 
sizeMax = max(numMaxPts);   
p = 0;
amplitudeOfBends = zeros(nBends,1);
for i = 1:length(numMaxPts)
    %If there are multiple points of maximum curvature in a bend, enter this loop
if numMaxPts(i)> 1
    k=1; 
    amplitudeOfBend = zeros(sizeMax,1);
    for j = i+p:i+p+numMaxPts(i)-1
        maxCurvXYPt = maxCurvXY(j,:);
        lineCPt = lineC(i,:);
        projection = projPointOnLine(maxCurvXYPt, lineCPt);
        amplitudeOfBend(k,1)= sqrt((maxCurvXY(j,1)-projection(1,1)).^(2) +...
            (maxCurvXY(j,2)-projection(1,2)).^(2));
        k = k+1;
    end
    maxAmplitudeOfBend=max(amplitudeOfBend);
    amplitudeOfBends(i,1)= maxAmplitudeOfBend;
    p2 = numMaxPts(i)-1;
    p = p2+p;
    %If only one point of maximum curvature in bend
elseif numMaxPts(i) ==0
    p = p-1;
else
    if i==length(numMaxPts)
    else
    maxCurvXYPt = maxCurvXY(i+p,:);
        lineCPt = lineC(i,:);
        projection = projPointOnLine(maxCurvXYPt, lineCPt);
        amplitudeOfBends(i,1) = sqrt((maxCurvXY(i+p,1)-projection(1,1)).^(2) +...
    (maxCurvXY(i+p,2)-projection(1,2)).^(2));

    end
end
end