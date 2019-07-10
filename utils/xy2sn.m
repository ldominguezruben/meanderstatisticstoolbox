function [snOut,ClSpline,centerlineOut,xyOut,iMiss,iTrans] = ...
            xy2sn(inCenterlinePt,xyDataPt,transParam)
% Create spline centerline, compute curvature, and convert xy to sn coordinates
%
%% DESCRIPTION: xy2sn.m
%     Given digitized points along the centerline and in-channel data points,
%     creates a spline centerline, calculates the streamwise
%     distance along the centerline, computes the curvature, and
%     returns streamwise and normal (s,n) coordinates for the
%     in-channel data points
%
%% SYNTAX:
%   [snOut,ClSpline,centerlineOut,xyOut,iMiss,iTrans]  =   ...
%        xy2sn(inCenterlinePt,xyDataPt,transParam)
%
%% INPUTS:
%   inCenterlinePt  =   x,y coordinates of points (vertices) digitized
%                       along the channel centerline, used to fit a cubic 
%                       spline for defining a continuous centerline
%   xyDataPt        =   x,y coordinates of in-channel data points, which
%                       will be converted to their corresponding (s,n)
%                       coordinates based on the channel centerline
%   transParam      =   5 X 1 vector of transformation parameters for 
%                       filtering the input coordinates with a 
%                       Savitzky-Golay filter, creating a specified number
%                       of discretization points along the output
%                       centerline, and searching laterally for points to
%                       transform:
%                       [nFilt order window nDiscr rMax]
%                           nFilt:  number of times smoothing filter will
%                                   be applied to the coordinates
%                           order:  order of the polynomial used to perform
%                                   the filtering
%                           window: number of points included in the filter
%                                   window
%                           nDiscr: number of points used to discretize the 
%                                   centerline in the resampled spline; 
%                                   determines the distance interval between 
%                                   spline segment end points, which is also 
%                                   the interval at which the curvature values
%                                   are calculated
%                           rMax:   maximum distance from channel centerline 
%                                   that will be used to obtain n coordinates; 
%                                   should be set slightly larger than the 
%                                   greatest plausible channel width
%
%% OUTPUTS:
%   snOut           =   2-column matrix of coordinates [s n], where ...
%                   s:  streamwise coordinate (distance downstream,
%                       increasing in the downstream direction);
%                   n:  normal (transverse) coordiante; perpendicular
%                       distance from data point to channel centerline,
%                       positive if left of centerline, negative if right;
%                       NOTE: untransformed points given NaN coordinates
%   ClSpline        =   structure array containing the coefficients for the
%                       calculated spline segments along the centerline; see
%                       ppval, unmkpp, and spline in the MATLAB help
%   centerlineOut   =   nPoint X 4 matrix containing information on the 
%                       spline-generated continuous channel centerline:
%                       [xCoordOut yCoordOut cumDist curveOut]
%                           xCoordOut:  x coordinates of vertices along
%                                       the output centerline
%                           yCoordOut:  y coordinates of vertices along
%                                       the output centerline
%                           cumDist:    cumulative length along the channel 
%                                       centerline from the origin at the 
%                                       upstream end of the reach
%                           curveOut:   curvature values calculated at each
%                                       vertex of the spline centerline
%   xyOut           =   original x,y coordinates corresponding to the computed
%                       s,n; untransformed points given NaN coordinates
%   iMiss           =   vector of indices of xy data points that were NOT
%                       transformed and have been assigned NaN coordinates
%                       in s,n, and xyOut; these points were either outside
%                       the range of the digitized centerline or beyond the
%                       specified rMax
%   iTrans          =   vector of indices of xy data points that WERE
%                       transformed and have valid s,n, and xyOut
%                       coordinates
%
%% NOTES:
%  *  Calls curvature.m and its helper integrand.m
%  *  Follows the sign convention of Smith and McLean (1984), which ensures a
%     right-handed coordinate system with s oriented downstream, n positive to
%     the left of the centerline, and z positive vertically upward; note that
%     the curvature convention adopted here is also that of Smith and McLean
%     (1984), which is opposite that of Fagherazzi et al. (2004) and Merwade
%     (2004)
%  *  The initial channel centerline can be digitized from an image using 
%     getline; data points can be created using ginput;
%  *  The assignment of an algebraic sign to the n-coordinate is based on the
%     unit normal vector, which is assumed to point to the left of the
%     centerline - that is, in the direction of positive n, which will be
%     the case if the centerline is digitized from upstream to downstream
%  *  The input centerline coordinates are filtered using a Savitzky-Golay 
%     filter suggested by Fagherazzi et al. (2004); see curvature.m
%  *  Note that some points might be missed and not transformed; these
%     missing points are assigned NaN coordinates in s,n, and xyOut
%     and the vectors of indices iMiss and iTrans can be used to identify
%     and select which points have not and have been transformed,
%     respectively, for plotting and further analysis
%
%% FUNCTION SUMMARY:
%   [snOut,ClSpline,centerlineOut,xyOut,iMiss,iTrans]  =   ...
%        xy2sn(inCenterlinePt,xyDataPt,transParam)

%% VERSION HISTORY:
% Carl J. Legleiter
% February 9, 2005
% October 31, 2005
% November 9, 2005
% December 23, 2005
% January 30, 2007
% March 19, 2008:   fixed bug in the handling of untransformed points and
%                   cleaned up the code a bit
% C:\Carl\RiverSpace\SNZgeostats\riverKrige\xy2sn.m


%% AUTHOR:
%   Code developed by Dr. Carl J. Legleiter (c), 10/25/2009.  
%   Last updated 03/19/2008.
%   The author makes this code available to interested users free of charge and 
%   with limited documentation (included in this m-file).  The author takes NO 
%   responsibility for inappropriate or erroneous applications of the code.  
%   Users of the code take FULL responsibility for the use of the code and 
%   should cite the author (and MATLAB) appropriately.  The code may be modified 
%   as desired to suit other applications.
%
%% OFFICIAL LICENSE AGREEMENT
%
%   Copyright (c) 2009, Dr. Carl J. Legleiter, All rights reserved. 
%   Last modified 03/19/2008.
%
%   Redistribution and use, with or without modification, are permitted provided 
%   that the following conditions are satisfied:
%
%   1)  Redistributions of source code must retain the above copyright notice, 
%       this list of conditions %and the following disclaimer. 
%   2)  Neither name of Carl J. Legleiterr nor the names of other contributors 
%       may be used to endorse or promote products derived from this software 
%       without specific prior written permission.
%
%   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER "AS IS" AND ANY EXPRESS OR
%   IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
%   MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO 
%   EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
%   INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
%   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, 
%   OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
%   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
%   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
%   EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
    

%% Fixed parameter
NDISCR  =   100;
% Number of nodes used to discretize each centerline segment in computing s,n 
% coordinates; fixed for now, could be adjusted based on curvature, with more 
% discretization points used in areas of higher curvature

%% Parse the transParam input
filtParam   =   transParam(1:3);
nDiscr      =   transParam(4);
rMax        =   transParam(5);

%% Call the curvature function to generate a spline for the centerline    
[clCurveSeries,ClSpline] =   curvature(inCenterlinePt,transParam);
cumDistance =   clCurveSeries(:,1);

%% Reproduce smooth centerline by evaluating the spline at its breakpoints    
centerlineOut  =   ppval(ClSpline,ClSpline.breaks);
%   hold on; plot(centerlineOut(1,:),centerlineOut(2,:),'k-x'); axis equal
       
%% Evaluate derivatives wrt s and determine tangent and normal vectors
% See code in curvature.m for further explanation of the spline and unmkpp
[b,c,l,k,d] =   unmkpp(ClSpline);
% Loop over the l segments of the centerline and compute the derivatives; note
% that the coefficients in the matrix c alternate between the x and y
% coordinates, with x coefficients on the odd-numbered rows and y coefficients
% on the even-numbered rows
ix  =   1;
iy  =   2;
% Pre-allocate arrays
xTangent    =   zeros(l,1);
yTangent    =   zeros(l,1);
xNormal     =   zeros(l,1);
yNormal     =   zeros(l,1);
for i = 1:l
   dx =  polyder(c(ix,:));
   dy =  polyder(c(iy,:));
   % Using results from Mathworld
   % Note that the derivatives are evaluated at the segment start points
   xTangent(i) =  polyval(dx,0)/sqrt(polyval(dx,0)^2+polyval(dy,0)^2);
   yTangent(i) =  polyval(dy,0)/sqrt(polyval(dy,0)^2+polyval(dx,0)^2);
   xNormal(i)  =  -1*polyval(dy,0)/sqrt(polyval(dy,0)^2+polyval(dx,0)^2);
   yNormal(i)  =  polyval(dx,0)/sqrt(polyval(dy,0)^2+polyval(dx,0)^2);
   % Now increment the indices into the coefficient matrix
   if i<l; ix  =   ix+2;   iy  =   iy+2;   end
end
% Now repeat this one last time for the final segment, only evaluate it at
% the downstream end point of the segment; the indices ix and iy should
% already be at their end point values
   dx =  polyder(c(ix,:));
   dy =  polyder(c(iy,:));
   % Using results from Mathworld
   % Note that the derivatives are evaluated at the segment end point,
   % which depends on the spacing of the output centerline vertices
   spacing       =  cumDistance(end)/nDiscr;
   xTangent(i+1) =  polyval(dx,spacing)/sqrt(polyval(dx,spacing)^2+polyval(dy,spacing)^2);
   yTangent(i+1) =  polyval(dy,spacing)/sqrt(polyval(dy,spacing)^2+polyval(dx,spacing)^2);
   xNormal(i+1)  =  -1*polyval(dy,spacing)/sqrt(polyval(dy,spacing)^2+polyval(dx,spacing)^2);
   yNormal(i+1)  =  polyval(dx,spacing)/sqrt(polyval(dy,spacing)^2+polyval(dx,spacing)^2);

   
%% Get the (x,y) coordinates of the data points and splined centerline nodes
    xCoord   =  xyDataPt(:,1);
    yCoord   =  xyDataPt(:,2);
    % Get vector of centerline coordiantes
    xCenter  =  centerlineOut(1,:);
    yCenter  =  centerlineOut(2,:);
    % % Plot the tangent and normal vectors on the plot with the centerline; note that
    % % this might be necessary to verify that the normal vector points to the left of
    % % the centerline, facing downstream
    % hold on;
    % plot([xCenter+xTangent],[yCenter+yTangent],'bo')
    % plot([xCenter+xNormal],[yCenter+yNormal],'gd')
   
%% Assign s,n coordinates using polygons defined by the normal vectors
% The basic algorithm here consists of three steps:
% 1)  For each pair of successive nodes along the centerline, define a polygon
%     with vertices along the centerline between these nodes and at two points 
%     a distance rMax from the centerline in a direction defined by the unit 
%     normal vector
% 2)  Find all in-channel data points within this polygon
% 3)  Discretize the centerline segment and compute the distances from each of
%     the interpolated centerline nodes to each of the in-channel points within
%     the polygon
% 4)  The minimum centerline-data point distance defines the n coordinate, and
%     the index of the centerline node at which this minimum occurs is used to
%     refine the s coordinate; note that n will be positive for points within
%     polygons on the left side of the channel
% 5)  Repeat the previous four steps a second time, but now orient the polygons
%     in the directon opposite the unit normal vector - that is, to the right of
%     the channel; the points in these polygons will have negative n coordinates
%
% This sign convention matches that of Smith and McLean (1984) and ensures a
% right-hand coordinate system with s positive downstream, n positive to the
% left of the centerline, and z positive upward.  Note that the assignment of
% the algebraic sign of n in this algorithm requires that the unit normal vector
% is oriented toward the left of the centerline.  This has been the case in
% every example I have tried so far, but could break down in some cases,
% especially if the centerline nodes are digitized in an upstream direction

% Pre-allocate outputs
xOut    =   zeros(1,length(xCoord));
yOut    =   zeros(1,length(xCoord));
s       =   zeros(1,length(xCoord));
n       =   zeros(1,length(xCoord));

% Begin loop
for iCenter  =  1:length(xCenter)-1;
   % Convert the unit normal vector to polar coordinates so that the angle
   % (orientation) can be preserved and the radius (magnitude) can be easily
   % adjusted to be the user-specified maximum rMax; note that rho will be one,
   % by the definition of the unit normal vector, so it is not output
   theta1   =  cart2pol(xNormal(iCenter),yNormal(iCenter));
   theta2   =  cart2pol(xNormal(iCenter+1),yNormal(iCenter+1));
   
   % Now use these angles and the user-specified rMax to create new Cartesian 
   % coordinates for the vertices of a polygon; note that the vertices defined
   % using the unit normal vectors will need to be offset by the coordinates of
   % the corresponding centerline node (i.e., the origin of the vector must be
   % shifted)
   [xVertex1,yVertex1]  =  pol2cart(theta1,rMax);
   xVertex1             =  xVertex1 + xCenter(iCenter);
   yVertex1             =  yVertex1 + yCenter(iCenter);
   [xVertex2,yVertex2]  =  pol2cart(theta2,rMax);
   xVertex2             =  xVertex2 + xCenter(iCenter+1);
   yVertex2             =  yVertex2 + yCenter(iCenter+1);
   % Now create some discretized points along the centerline to become the
   % curved inside (i.e., centerline) of the "polygon"; note that if you
   % just use the original centerline vertices without "filling in" the
   % curve, you risk missing points that are very close to the centerline
   % in a tightly curved segment (this is a pathological case but it is
   % conceptually and computationally easy to avoid)
   sCoordDiscr    =  linspace(ClSpline.breaks(iCenter),...
                              ClSpline.breaks(iCenter+1),NDISCR);
   segmentDiscr   =  ppval(ClSpline,sCoordDiscr);
   segmentDiscrX  =  segmentDiscr(1,:);
   segmentDiscrY  =  segmentDiscr(2,:);   
   % Create the vector of vertices; must be a closed loop
   xVertices=  [xVertex1 segmentDiscrX xVertex2 xVertex1];
   yVertices=  [yVertex1 segmentDiscrY yVertex2 yVertex1];
      
   % Now check for data points inside (or on) this polygon
   [inPoly,onPoly]   =  inpolygon(xCoord,yCoord,xVertices,yVertices);
   % Get the indices of these points; the likelihood of a point lying on a
   % polygon boundary is low, so the on-polygon case is not addressed (for now)
   pointInPoly       =  find(inPoly);
   pointOnPoly       =  find(onPoly, 1);
   %if ~isempty(pointOnPoly)
%       disp('Whoa, we got one on the poly.')
%    end
   
   % Now loop over the points inside this particular polygon and determine their
   % s,n coordinates by discretizing the centerline segment and computing the
   % distances from each discretized centerline node to each data point; the
   % minumum distance defines the n coordinate and the index of the minimum is
   % used to refine the s coordinate
   for iPoint  =  1:length(pointInPoly)
      % Get the x,y coordinates of the points in the polygon
      xCoordTmp      =  xCoord(pointInPoly(iPoint));
      yCoordTmp      =  yCoord(pointInPoly(iPoint));      
      % Now compute the distance from each discretized centerline point to the
      % data point in question
      pt2lineDist    =  sqrt((xCoordTmp-segmentDiscr(1,:)).^2 + ...
                             (yCoordTmp-segmentDiscr(2,:)).^2);
      % Get the minimum of these distances, and its index
      [minDist,iMinDist]   =  min(pt2lineDist);
      % The s-coordinate becomes the s of the upstream node plus the spacing
      % times the fraction of the discretized nodes to the next point
      sCoordTmp     =   cumDistance(iCenter)+iMinDist/NDISCR*(cumDistance(iCenter+1)-cumDistance(iCenter));
      % For this case, with the polygon on the left of the centerline, the
      % algebraic sign of the n coordinate is positive
      nCoordTmp      =  minDist;
      % Associate these with the proper data point vectors
      s(pointInPoly(iPoint))  =  sCoordTmp;
      n(pointInPoly(iPoint))  =  nCoordTmp;
      % Output the original x and y coordinates for convenience
      xOut(pointInPoly(iPoint))  =  xCoordTmp;
      yOut(pointInPoly(iPoint))  =  yCoordTmp;
   end
  
   % Repeat the whole process a second time using polygons on the right side of
   % the channel; the corresponding n coordinates will be negative
   % Now use these to create new Cartesian coordinates for the vertices
   [xVertex1,yVertex1]  =  pol2cart(theta1,-1*rMax);
   xVertex1             =  xVertex1 + xCenter(iCenter);
   yVertex1             =  yVertex1 + yCenter(iCenter);
   [xVertex2,yVertex2]  =  pol2cart(theta2,-1*rMax);
   xVertex2             =  xVertex2 + xCenter(iCenter+1);
   yVertex2             =  yVertex2 + yCenter(iCenter+1);
   % Create a vector of vertices; must be a closed loop
   % Use the same discretized centerline vertices from before
   xVertices=  [xVertex1 segmentDiscrX xVertex2 xVertex1];
   yVertices=  [yVertex1 segmentDiscrY yVertex2 yVertex1];
   
   % Now check for data points inside (or on) this polygon
   [inPoly,onPoly]   =  inpolygon(xCoord,yCoord,xVertices,yVertices);
   % Get the indices of these points
   pointInPoly       =  find(inPoly);
   pointOnPoly       =  find(onPoly, 1);
   if ~isempty(pointOnPoly)
      %disp('Whoa, we got one on the poly.')   Kristin commented this out
      %11/29/12
   end
   
   % Begin a loop over the points in the polygon
   for iPoint  =  1:length(pointInPoly)
      xCoordTmp      =  xCoord(pointInPoly(iPoint));
      yCoordTmp      =  yCoord(pointInPoly(iPoint));
      % Now compute the distance from each discretized centerline point to the
      % data point in question
      pt2lineDist    =  sqrt((xCoordTmp-segmentDiscr(1,:)).^2 + ...
                             (yCoordTmp-segmentDiscr(2,:)).^2);
      [minDist,iMinDist]   =  min(pt2lineDist);
      % The s-coordinate becomes the s of the upstream node plus the spacing
      % times the fraction of the discretized nodes to the next point
      sCoordTmp     =   cumDistance(iCenter)+iMinDist/NDISCR*(cumDistance(iCenter+1)-cumDistance(iCenter));
      % For this case, with the polygon on the right of the centerline, the
      % algenbraic sign of the n coordinate is negative
      nCoordTmp      =  -1*minDist;
      % Associate these with the proper data point vectors
      s(pointInPoly(iPoint))  =  sCoordTmp;
      n(pointInPoly(iPoint))  =  nCoordTmp;
      % Output the original x and y coordinates for convenience
      xOut(pointInPoly(iPoint))  =  xCoordTmp;
      yOut(pointInPoly(iPoint))  =  yCoordTmp;
   end
end

%% Account for the xy data points that aren't transformed and get s,n of 0,0
% For xy data points that lie outside the range of the digitized centerline
% or outside the specifed rMax, the s,n coordinates default to zero.  Not
% clear why this is
iMiss       =   find(s == 0 & n == 0);
s(iMiss)    =   NaN;
n(iMiss)    =   NaN;
xOut(iMiss) =   NaN;
yOut(iMiss) =   NaN;
% iTrans      =   find(s ~= 0 & n ~= 0);
iTrans      =   find(~(isnan(s)) & ~(isnan(n)));

% if ~isempty(iMiss);
    % Create a warning for points that were not transformed
%     disp('******************************')
%     disp('******************************')
%     disp('Some of the input x,y coordinates were not transformed to s,n coordinates.')
%     disp([num2str(length(iMiss)) ' points were not transformed.'])
%     disp(['The untransformed points are: ' num2str(iMiss)])
%     disp('******************************')
%     disp('******************************')
% end
    
%% Convert all outputs to column vectors
snOut           =   [s' n'];
centerlineOut   =   [centerlineOut' clCurveSeries];
xyOut           =   [xOut' yOut'];
iMiss           =   iMiss';
iTrans          =   iTrans';