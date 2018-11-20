function [clCurveSeries,ClSpline]  =   curvature(inCenterlinePt,transParam)
% Fit cubic spline to centerline coordinates and compute curvature values
%
%% curvature.m: 
%   Fits cubic splines to digitized points along a channel centerline, 
%   calculates the arc length along the line defined by the sequence of 
%   splines, creates a set of equally spaced points along the splined 
%   centerline, recalculates the spline in terms of distance downstream,
%   and computes the curvature at each point along the new centerline
%
%% SYNTAX:
%   [clCurveSeries,ClSpline]  =   curvature(inCenterlinePt,transParam)
%
%% INPUTS:
%   inCenterlinePt  =   2 X nCenterlineNode matrix of (x,y) coordinates for 
%                       points digitized along a channel centerline
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
%                           nDiscr: number of segments used to discretize the 
%                                   centerline in the resampled spline; 
%                                   determines the distance interval between 
%                                   spline segment end points, which is also 
%                                   the interval at which the curvature values
%                                   are calculated; note that the number of 
%                                   vertices used to discretize the centerline 
%                                   will be one greater than the number of 
%                                   segments
%                           rMax:   not used by this function (see xy2sn.m)
%   
%% OUTPUTS:
%   clCurveSeries   =   nDiscr X 2 matrix containing cumulative downstream
%                       distances (s coordinates) and centerline curvature
%                       values for the splined centerline: 
%                           [cumDistance clCurvature] 
%   ClSpline        =   structure array containing the coefficients for the
%                       calculated spline segments along the centerline; see
%                       ppval, unmkpp, and spline in the MATLAB help
%
%% NOTES:
%   For a discussion of the calculations and an example application, see 
%   Fagherazzi, S., Gabet, E. J., & Furbish, D. J. (2004). The effect of 
%   bidirectional flow on tidal channel planforms. Earth Surface Processes 
%   and Landforms, 29, 295-309.  For more on the calcualtion of arc lengths
%   and curvatures, see the Calculus book by Larson, Hostetler, and Edwards
%   (section 12.5).  For long sequences of points and/or large nDsicr, the 
%   function can be slow.  Note that the spline is based entirely on the 
%   initial digitized points, even if it is resampled to output curvature 
%   values at a smaller, regular spacing.  Code is well commented.  Fixed
%   parameters that the user might wish to modify are listed at the
%   beginning of the code.  
%
%% FUNCTION SUMMARY:
%   [curvatureOut,cumDistance,ClSpline]  =  curvature(inCenterlinePt,filtParam,nDiscr)

%% VERSION HISTORY:
%  July 30, 2004
%  Modified 10-31-2005 to allow for variable spacing (i.e, replace the 1's
%  in the arclength and derivative calculations with the spacing input
%  argument) and to include another round of splining to improve the arc
%  length calculation.  NOTE: output is still not exactly regularly spaced
%  in terms of arclength along the centerline
%%%%%
%   Modified again 11-3-2005 to implement a fixed number of discretization
%   points rather than a regular distance spacing, which wasn't working.
%   Also worked on evaluation of derivatives and bench-marked using a unit
%   circle
%%%%%
%   Cleaned up 11-28-2005
%%%%%
%   Verified functionality and cleaned up comments on 12-23-2005
%%%%%
% Reformatted inputs and outputs to ensure compatibility with other
% functions on 1-31-2007
% C:\Carl\RiverSpace\SNZgeostats\riverKrige\curvature.m

%% AUTHOR:
%   Code developed by Dr. Carl J. Legleiter (c), 10/25/2009.  
%   Last updated 01/31/2007.
%   The author makes this code available to interested users free of charge and 
%   with limited documentation (included in this m-file).  The author takes NO 
%   responsibility for inappropriate or erroneous applications of the code.  
%   Users of the code take FULL responsibility for the use of the code and 
%   should cite the author (and MATLAB) appropriately.  The code may be modified 
%   as desired to suit other applications.

%% OFFICIAL LICENSE AGREEMENT
%
%   Copyright (c) 2009, Dr. Carl J. Legleiter, All rights reserved. 
%   Last modified 01/31/2007.
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


%% Parse inputs
filtParam   =   transParam(1:3);
nDiscr      =   transParam(4);

%% Filter the input centerline coordinates with a Savitzky-Golay filter
% Filter these coordinates following Fagherazzi et al., 2004 and using the
% sgolayfilt function from the signal processing toolbox with the specified
% polynomial order and window size
nFilt   =   filtParam(1);
order   =   filtParam(2);
window  =   filtParam(3);
tmp     =   inCenterlinePt;
for iFilt=1:nFilt;
    tmp =   sgolayfilt(tmp,order,window);
end    
inCenterlineFilt    =   tmp;
clear tmp*
% The coordinates need to be in row vectors for the spline functions
if size(inCenterlineFilt,1)~=2    
    inCenterlineFilt    =   inCenterlineFilt';
end
    
%% Create the first round of the spline, with an integer parameter
% Get the parametric form of an interpolating spline for centerline points
% To start at the origin of the centerline, start with the arbitrary
% parameter t at 0, with integer steps up to one less than the number of
% input centerline ponts
t   =   0:length(inCenterlineFilt)'-1;  
    % t is the parameter tracing out the plane curve and doesn't really mean 
    % anything, just a way of indexing the segments between points
pp  =   spline(t,inCenterlineFilt);   
    % pp is a structure array containing functional form of cubic polynomials
[b,c,l,k,d] =   unmkpp(pp);
    % b is breaks (endpoints) of spline
    % c is coefficients, alternating rows of x (odd) and y (even)
    % l is the number of segments, and is one less than number of nodes
    % k is the order of the polynomial, 4 for a cubic spline
    % d is the dimension, which will be 2 if x and y are done together
% Loop over the l segments and compute the arclength of the segment
ix  =   1;      
    % initialize index for x coordinate coefficients (odd rows)
iy  =   2;      
    % initialize index for y coordinate coefficients (even rows)
% Now loop over the segments; each one has different x and y spline functions
for i = 1:l     
    % note that for each spline segment, the parametric functions are
    % bounded between 0, at the upstream end of the segment, and 1 at
    % the downstream end of the segment because the parameter t is just
    % a series of integers up to one less than the length of the vector 
    % of input coordinates 
    dx          =   polyder(c(ix,:));   
        % first derivative of parametric equation describing x coordinate
    dy          =   polyder(c(iy,:));   
        % first derivative of parametric equation describing y coordinate
    arclen(i)   =   simpson(@integrand,0,1,dx,dy);   
        % Call helper function to perform integration for arc length
        % formula; limits of integration are zero to one for all
        % segments since it is an integer-valued parameter
    % increment indices into matrix of alternating x and y coefficients
    if i<l
        ix  =   ix+2;   
        iy  =   iy+2;
    end % if                         
end % for loop over the segments of the spline
% Compute the cumulative arc length (i.e., downstream distance) as the sum
% of the arc lengths above each node along the centerline
cumlen      =   cumsum(arclen);
    % The length of the cumsum vector is one less than the number of input
    % nodes and the first entry is the distance from the origin to the
    % second vertex so we will need to prepend a zero (i.e., the first node 
    % should have a downstream distance of 0 since it is the origin)
   
%% Create a second spline with regularly spaced points
% Evaluate the first spline at regularly spaced points, scaled to
% span the range of the initial parameter t with the specified number of
% discretization segments (the number of discretization points is one
% greater)

% So now we want to create the arc length parameter (see pg. 819 of LHE
% Calculus) by dividing by the total length of the line; this basically
% rescales the value of the parameter t at each point along the
% original spline to a fraction of the total length of the line (but
% note that we have to multiply by the length or all the nodes would be
% in the first segment; just think of it as a relative cumulative arc
% length, scaled by the length of the parameter vector)
tNew    =   [0 cumsum(arclen/cumlen(end))*(length(t)-1)];
% Evaluate the current spline at these new points, specified as a
% fraction of the total length of the line
xyNew   =   ppval(tNew,pp);
    % So this result is still in units of the original parameter, but the
    % nodes should be spaced proportional to the fraction of the total arc
    % length occupied by each segment
    
% Now create a new parameter with a regular spacing from 0 to the
% total length of the centerline, in real units, with the specified
% level of discretization.  This will be the actual arc length
s       =   linspace(0,cumlen(end),nDiscr+1);
spacing =   cumlen(end)/nDiscr;
% But first we need to rescale this new parameter to span the range of
% the original parameter, or at least its values at the nodes
sScaled =   linspace(min(tNew),max(tNew),length(s));
% Now create a new spline and evaluate it at the (scaled) regularly
% spaced points
xyReg   =   spline(tNew,xyNew,sScaled);
% Now create a new spline based on the xy coordinates of these points,
% which should be regularly spaced, and parameterize it in terms of the
% actual arc length
ppReg  =   spline(s,xyReg);

% % Create a new parameter with a regular spacing from 0 to the
% % total length of the centerline, in real units, with the specified
% % level of discretization; this will become the actual arc length
% s       =   linspace(0,cumlen(end),nDiscr+1);
% % NOTE: Not clear why the nDiscr+1 is needed here, but if you just use
% % nDiscr, the coordinate transformation is subject to a shift, with the
% % transformation error increasing with distance downstream
% spacing =   cumlen(end)/nDiscr;
% % But first we need to rescale this new parameter to span the range of
% % the original parameter, or at least its values at the nodes
% sScaled =   linspace(0,length(t),length(s));
% % Evaluate the initial spline at these (scaled) regularly spaced points
% xyReg   =   ppval(pp,sScaled);
% % Now create a new spline based on the xy coordinates of these points,
% % which should be approximately regularly spaced, and parameterize it in terms 
% % of the actual arc length
% ppReg  =   spline(s,xyReg);

%% Now proceed with arc length and curvature calculations, in terms of s
[b,c,l,k,d] =   unmkpp(ppReg);  % See above for explanation
    %% This works, but the interpolated centerline nodes are still not
    %% regularly spaced. This isn't necessarily a big problem, but could
    %% cause the coordinate transformation to be uneven.  The basic problem
    %% is that a linearly spaced parameter won't produce linearly spaced
    %% centerline nodes because of the longer distance along the centerline
    %% due to curvature
% Loop over the l segments and compute the arclength of the segment and its
% curvature, see explanation in the initial loop above
clear cumlen arclen curve
ix  =   1;
iy  =   2;
for i = 1:l
    dx          =   polyder(c(ix,:));
    dy          =   polyder(c(iy,:));
    arclen(i)   =   simpson(@integrand,0,spacing,dx,dy);
    % These are just the second derivatives of the parametric equations
    % describing the x and y coordinates for each segment
    dx2         =   polyder(dx);
    dy2         =   polyder(dy);
    % Evaluate the curvature at the downstream end point of each
    % segment, which is approximately equal to the spacing between
    % centerline vertices
    curve(i)    =   (polyval(dx,spacing)*polyval(dy2,spacing) - polyval(dy,spacing)*polyval(dx2,spacing))/...
                    ((polyval(dx,spacing))^2 + (polyval(dy,spacing))^2)^1.5;
    if i<l; ix  =   ix+2;   iy  =   iy+2;   end
end
cumlen      =   cumsum(arclen);

%% Output the results    
% Prepend a zero so that the vector of cumulative downstream distances
% starts with zero at the origin of the centerline; this will also
% ensure that the number of elements in this vector is the same as the
% number of breaks in the spline output
cumDistance =   [0 cumlen];
% Evaluate the curvature at the origin of the centerline
ix  =   1;
iy  =   2;
dx          =   polyder(c(ix,:));
dy          =   polyder(c(iy,:));
dx2         =   polyder(dx);
dy2         =   polyder(dy);
curve0      =   (polyval(dx,0)*polyval(dy2,0) - polyval(dy,0)*polyval(dx2,0))/...
                ((polyval(dx,0))^2 + (polyval(dy,0))^2)^1.5;
curvatureOut=   [curve0 curve];
ClSpline    =   ppReg;

clCurveSeries   =   [cumDistance' curvatureOut'];