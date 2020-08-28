%   This function was created on May 20, 2013 by Brian W. Hone.  It plots 
%   the user inputs of equally spaced data, inflection points of the river 
%   mean centerline, points of maximum curvature, the wavelet filter 
%   centerline, and the intersection points of the wavelet filter 
%   centerline and the equally spaced data.  All outputs are plotted to 
%   the mStat_ver_1_copy2 graphical user interface in the "pictureReach" axes. 
%
%   Last updated:  9/28/2013 by Brian W. Hone 

%--------------------------------------------------------------------------

function [equalPlot, inflectionCplot, intPoints1, maxCurv, wavelet,upstream]...
    = guiPlots(equallySpacedX, equallySpacedY, newInflectionPts, x0,... 
    y0, x_sim, maxCurvX, maxCurvY, pictureReach,sel)

%      Change the current axes to "pictureReach".
axes(pictureReach);
axis equal
 extended=0;
 dtx=abs(max(equallySpacedX)-min(equallySpacedX))+extended;
 dty=abs(max(equallySpacedY)-min(equallySpacedY))+extended;
 if dtx>dty
     xlim([min(equallySpacedX)-extended max(equallySpacedX)+extended])
     ylim([min(equallySpacedY)-(dtx/2) max(equallySpacedY)+(dtx/2)])
 elseif dtx<dty
     xlim([min(equallySpacedX)-(dty/2) max(equallySpacedX)+(dty/2)])
     ylim([min(equallySpacedY)-extended max(equallySpacedY)+extended])
 end
 axis fill

%   Plot of equally spaced data (blue line).  
equalPlot = line(equallySpacedX, equallySpacedY, 'color', 'k','LineWidth',2.5);%, 'marker','+');
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


%plot upstream point
upstream = plot(equallySpacedX(1,1), equallySpacedY(1,1),'*',    'MarkerSize',14,...
    'MarkerEdgeColor','b','MarkerFaceColor','b');
hold on;


if sel==1
    % %   Plot of all inflection points (green stars).
    inflectionCplot = line(newInflectionPts(:,1), newInflectionPts(:,2), ...
        'color', 'b', 'linewidth',1.5);%,'marker','d','MarkerSize',8,    'MarkerEdgeColor','b',...
       % 'MarkerFaceColor','c');
    hold on;
    wavelet =0;%default value
        %-------------------------------------------------------------------------
    % Add a resizable legend to the main GUI axes.  
    axes(pictureReach)
    hLegend = legend([equalPlot, inflectionCplot, ...
        intPoints1, maxCurv,upstream], ...
      'Equally Spaced Data'         , ...
      'Inflection Line'           , ...
      'Intersection Points'         , ...
      'Maximum Curvature Points'    , ...
      'Upstream'                    , ...
      'location', 'Best' );

elseif sel==2
    %   Plot of valley filter centerline (red-dashed line).  
    wavelet = plot(x_sim(:,1),'--r','LineWidth',1.5); 
    hold on;
    inflectionCplot =0;%default value
        %-------------------------------------------------------------------------
    % Add a resizable legend to the main GUI axes.  
    axes(pictureReach)
    hLegend = legend([equalPlot, wavelet, ...
        intPoints1, maxCurv,upstream], ...
      'Equally Spaced Data'         , ...
      'Mean Center Line'            , ...
      'Intersection Points'         , ...
      'Maximum Curvature Points'    , ...
      'Upstream'                    , ...
      'location', 'Best' );
end





%  scalebar

% exag=10;
% set(gca,...
%     'DataAspectRatio',   [exag 1 1],...
%     'PlotBoxAspectRatio',[exag 1 1]...
%     ...'FontSize',          14)
%     )

%--------------------------------------------------------------------------