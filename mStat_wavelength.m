function [wavelengthOfBends] = wavelength(newInflectionPts, nBends)

%      Last Modified:  30/12/2016 by Dominguez Ruben L.  
%
%      This function takes the x,y coordinates of the inflection points
%      defining a bend on a given river centerline (blue) and finds the 
%      wavelength of the bends.  Note: the planarmetric 
%      wavelength is defined as the distance between the two inflection 
%      points along a constructed line between them.  In this function, the
%      distance is found with the vector distance formula.     
%      
%      INPUTS:
%      inflectionX = the X-coordinates of each inflection point defined
%      along the river reach.  
%      inflectionY = the Y-coordinates of each inflection point defined
%      along the river reach. 
%
%      OUTPUTS:
%      wavelengthOfBends = a structure that contains the wavelength of each
%      river bend in order from upstream to downstream.  

wavelengthOfBends = zeros(nBends,1);
j = 1;
for i = 2:(nBends+1)
    wavelengthOfBends(j) = sqrt((newInflectionPts(i,1)-newInflectionPts(i-1,1)).^(2) +...
    (newInflectionPts(i,2)-newInflectionPts(i-1,2)).^(2));
j = j+1;
end
%--------------------------------------------------------------------------
