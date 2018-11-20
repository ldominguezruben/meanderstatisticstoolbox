function zoomcenter(varargin)
%ZOOMCENTER Zoom in and out of a specifeid point on a 2-D plot.
% ZOOMCENTER(X,Y) zooms the current axis on the point (X,Y) by a
%factor of 2.5.
% ZOOMCENTER(X,Y,FACTOR) zooms the current axis on the point (X,Y) by
%FACTOR.
%
% ZOOMCENTER(AX,...) zooms on the specified axis
%
% Example:
% line
% zoomcenter(.5, .5, 10)
%
%line
%zoomcenter(.7, .3, .5)

nin = nargin;
if nin==0
 error('ZOOMCENTER requires at least 2 inputs');
end
if ishandle(varargin{1})
 ax = varargin{1};
 varargin = varargin(2:end);
 nin = nin-1;
else
 ax = gca;
end
if nin<2
 error('ZOOMCENTER requires specifying both X and Y');
else
 x = varargin{1};
 y = varargin{2};
end
if nin==3
 factor = varargin{3};
else
 factor = 2.5;
end

cax = axis(ax);
daxX = (cax(2)-cax(1))/factor(1)/2;
daxY = (cax(4)-cax(3))/factor(end)/2;
axis(ax,[x+[-1 1]*daxX y+[-1 1]*daxY]);