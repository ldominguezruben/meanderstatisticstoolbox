function [sinuosityOfBends, lengthStraight, lengthCurved] = ...
       mStat_sinuosity(intS, nBends, newInflectionPts)
%      This function finds the sinuosity of each individual bend in the
%      graphical output plot (i.e. the length along the given centerline
%      divided by the length of the chord centerline between the inflection
%      points).  It outputs the sinuosity of each curve as a vector
%      called "sinuosityOfBends" and also outputs the curved legnth of the
%      bends in "lengthCurved" and the chord length of the bends in
%      "lengthStraight".
%
%      Last Modifed:  October, 2017 by Dominguez Ruben L.
%--------------------------------------------------------------------------

%      First, find the curved length between the limit points following the 
%      given (blue) centerline.  
%
%      Note:  The starting and ending limits for the individual bend are
%      already computed in the main code and are given by the 
%      inflection points along the resampled data centerline (blue).  
%      These limit points are stored as S-ordintates in the "inflectionS" 
%      structure.   

%      This process loops through inflectionS and calculates the 
%      distance along the blue centerline between the limit 
%      points of each individual bend.  Then, it displays the resulting,
%      curved lengths in the secondary window. 
j = 1;
for i = 2:nBends+1
    lengthCurved(j) = intS(i) - intS(i-1);
    j=j+1;
end


%--------------------------------------------------------------------------

%      Next, the distance between the inflection points of the individual 
%      bends along a constructed chord are found.      
%
%      Note:  in order to find the straight distance along the chord,
%      centerline, the x,y coordinates of the inflection points
%      for each bend must be known.  These x,y coordinates are contained 
%      in the "newInflectionPts" structure from the main code. 
%
%      This process circulates through the river data and calculates the 
%      distance between the limiting inflection points of each individual 
%      bend.  These are the chord lengths of each bend.     
j = 1;
lengthStraight = zeros(length(nBends)); 
for i = 2:nBends+1 
    lengthStraight(j) = sqrt((newInflectionPts(i,1) - newInflectionPts(i-1,1)).^(2)...
    + (newInflectionPts(i,2) - newInflectionPts(i-1,2)).^(2));
j = j+1;
end
%--------------------------------------------------------------------------

%      Finally, the sinuosity of each individual bend can be calculated as
%      the curved length divided by the length along the wavelet filter
%      centerline.  The sinuosity values for each bend are stored in the
%      structure "sinuosityOfBends".  

for j = 1:nBends
    sinuosityOfBends(j) = lengthCurved(j) / lengthStraight(j);
end
sinuosityOfBends = sinuosityOfBends.';
%--------------------------------------------------------------------------
