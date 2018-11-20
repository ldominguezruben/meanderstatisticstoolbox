%   This function was created on May 20, 2013 by Brian W. Hone.  It plots 
%   the user inputs of equally spaced data, inflection points of the river 
%   mean centerline, points of maximum curvature, the wavelet filter 
%   centerline, and the intersection points of the wavelet filter 
%   centerline and the equally spaced data.  All outputs are plotted to 
%   the mStat_ver_1_copy2 graphical user interface in the "pictureReach" axes. 
%
%   Last updated:  9/28/2013 by Brian W. Hone 

%--------------------------------------------------------------------------

function [equalPlot, inflectionCplot, intPoints1, maxCurv, wavelet]...
    = guiPlots(equallySpacedX, equallySpacedY, newInflectionPts, x0,... 
    y0, x_sim, maxCurvX, maxCurvY, pictureReach)

%      Change the current axes to "pictureReach".
axes(pictureReach);
% axis xy; 
% axis on;
% axis equal
set(gca, 'Color', 'none')
xlim([min(equallySpacedX)-10000 max(equallySpacedX)+10000])
ylim([min(equallySpacedY)-10000 max(equallySpacedY)+10000])
% axis tight;


%   Plot of equally spaced data (blue line).  
equalPlot = line(equallySpacedX, equallySpacedY, 'color', 'k','LineWidth',2.5);%, 'marker','+');
hold on;

% %   Plot of all inflection points (green stars).
inflectionCplot = line(newInflectionPts(:,1), newInflectionPts(:,2), ...
    'color', 'b', 'linewidth',1.5,'marker','d','MarkerSize',8,    'MarkerEdgeColor','b',...
    'MarkerFaceColor','c');
hold on;

%   Plot of intersection points of the wavelet filter centerline
%   and the equally spaced data (along the given, blue centerline).  These
%   intersection points are shown as a circle colored "cyan".  
intPoints1 = plot(x0, y0,'ok',    'MarkerSize',8,...
    'MarkerEdgeColor','r','MarkerFaceColor','y');
hold on;

%   Plot of points of maximum curvature (peaks and troughs) as black squares.
maxCurv = plot(maxCurvX, maxCurvY, 'sk','MarkerSize',9);
hold on;

%   Plot of valley filter centerline (red-dashed line).  
wavelet = plot(x_sim(:,1),'--r','LineWidth',1.5); 
hold on;



% exag=10;
% set(gca,...
%     'DataAspectRatio',   [exag 1 1],...
%     'PlotBoxAspectRatio',[exag 1 1]...
%     ...'FontSize',          14)
%     )

%--------------------------------------------------------------------------