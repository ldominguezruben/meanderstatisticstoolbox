function [highlightX, highlightY,indi]= userSelectBend(intS, selectedBend,equallySpacedX,...
    equallySpacedY,newInflectionPts,sResample)

%     This function allows the user to click on a spot in the "bendSelect" 
%     listbox, selects the individual river bend that is chosen, and 
%     creates a matrix containing the equally spaced points closeset to the
%     limit points of the chosen bend.  The selected bend can then be
%     passed to a child window along with it's respective statistics.  
%
%     Last Modified:  October, 2013 by Brian W. Hone 
%
%     INPUTS:  
%     sResample = the vector containing the points defining the given, blue 
%     centerline in S,n coordintates.
%     nBends = the number of bends in the given river planimetry.
%     intS = the vector containing the intersection points along the given,
%     blue centerline.  
%     selectedBend = the bend that the user picked from the main window listbox. 
%     equallySpacedX, equallySpacedY = coordinates of the blue centerline
%     that outline the selected bend. 
%
%     OUTPUTS:
%     indexOfIntersectionPoints = a matrix containing the indices of the
%     points closest to the bend limit points from intS.  
%     highlightX = the x-coordinates of the equallly spaced points on the
%     highlighted bend.  
%     highlightY = the y-coordinates of the equallly spaced points on the
%     highlighted bend.

%       Use "searchclosest" to get an index of the points nearest to the
%       bend limit points (the index with respect to sResample of the 
%       closest point).

i = 1;  
for i = 1:length(intS)
     v = intS(i);
     [index,cv] = searchclosest(sResample, v); %  find(sResample==intS(i));
     
     if isnan(index)
     else
     indexOfIntersectionPoints(i) = index; 
     end
end

%--------------------------------------------------------------------------

%     This section assigns indices to the bend intersection points and
%     highlights the bend selected by the user in terms of x,y coordinates.   

%     Pull the index number of the first intersection point in the bend.
start = indexOfIntersectionPoints(selectedBend);

%     Pull the index number of the second intersection point in the bend.
stop = indexOfIntersectionPoints(selectedBend+1);

%     Assign a matrix with the x,y coordinates of the section of the blue 
%     centerline that we want to highlight. 

i=1;
k=1;
indi(1,1:2)=[start stop];
for k = start:stop
    highlightX(i) = equallySpacedX(k);
    highlightY(i) = equallySpacedY(k);
    i = i+1;
end 

if highlightX(1)~=newInflectionPts(selectedBend,1) 
     highlightX(1)=newInflectionPts(selectedBend,1);
end
if highlightX(end)~=newInflectionPts(selectedBend+1,1)
        highlightX(end)=newInflectionPts(selectedBend+1,1);
end
if highlightY(1)~=newInflectionPts(selectedBend,2)
            highlightY(1)=newInflectionPts(selectedBend,2);
end
if highlightY(end)~=newInflectionPts(selectedBend+1,2)
                highlightY(end)=newInflectionPts(selectedBend+1,2);
end
