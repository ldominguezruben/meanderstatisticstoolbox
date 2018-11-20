function mStat_plotplanar(equallySpacedX, equallySpacedY,inflectionPts, x0, y0, x_sim,...
newMaxCurvX, newMaxCurvY,pictureReach)


%Function create the initial panel graph
%Dominguez Ruben 11/2017
%--------------------------------------------------------------------------
% This creates the 'background' axes.
 
ha = axes('units','normalized', ...
'position',[0 0 1 1]);
% Move the background axes to the bottom
uistack(ha,'bottom');
% Turn the handlevisibility off so that we don't inadvertently selectData
% into the axes again.  Also, make the background axes invisible.
set(ha,'handlevisibility','off','visible','off')
axes(pictureReach);
set(gca, 'Color', 'w')
axis equal;

% Call plotting function and selectData necessary data in the pictureReach.  
[equalPlot, inflectionCplot, intPoints1, maxCurv, wavelet] = ...
guiPlots(equallySpacedX, equallySpacedY,... 
inflectionPts, x0, y0, x_sim(:,1), ...
newMaxCurvX, newMaxCurvY, pictureReach);
xsim=x_sim(:,1);
hold on; 

% % Selectdata of inflection points.
axes(pictureReach); 
set(gca, 'Color', 'w')
hold on;
%handles.inflectionCplot = inflectionCplot;
hold on; 

% Selectdata of equally spaced data and blue centerline.
axes(pictureReach); 
set(gca, 'Color', 'w')
axis tight;
%handles.equalPlot = equalPlot;
hold on;

% Selectdata of intersection points of the wavelet filter centerline
% and the equally spaced data.
axes(pictureReach); 
set(gca, 'Color', 'w')
%handles.intPoints1 = intPoints1;
hold on;

% Selectdata of points of maximum curvature (peaks and troughs).  
axes(pictureReach); 
set(gca, 'Color', 'w')
%handles.maxCurv = maxCurv;
hold on;

% Selectdata of wavelet filter centerline.
axes(pictureReach); 
set(gca, 'Color', 'w')
handles.wavelet = wavelet;
hold on;

%-------------------------------------------------------------------------

% Add a resizable legend to the main GUI axes.  
axes(pictureReach)
hLegend = legend([equalPlot, inflectionCplot, wavelet, ...
    intPoints1, maxCurv], ...
  'Equally Spaced Data'         , ...
  'Inflection Points'           , ...
  'Valley Centerline'           , ...
  'Intersection Points'         , ...
  'Maximum Curvature Points'    , ...
  'location', 'Best' );


% End plotting section. 
