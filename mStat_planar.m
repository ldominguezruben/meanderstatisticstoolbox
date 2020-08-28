function [geovar]=mStat_planar(xCoord,yCoord,width,FileName,sel,...
   Module,level,AdvancedSet)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%MStaT
%This function calculate diferents methods of determination of bends
%by Dominguez Ruben, UNL, Argentina 01/20/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%start code
str=['Analyzing ' FileName];
hwait = waitbar(0,str,'Name','MStaT',...
         'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
setappdata(hwait,'canceling',0)

nFiles=1;
%--------------------------------------------------------------------------
% Begin geometric section.

% First, resample data to get equally spaced points (call the
% getxyResampled function).  These resampled points represent the 
% given (blue) centerline of the river reach. 

[nReachPoints, equallySpacedX, equallySpacedY, ...
    sResample, cResample] =...
    mStat_getxyResampled(xCoord,yCoord,width,AdvancedSet);
    
% Second, found the angle variations of the resampled line 
[angle]= mStat_angledes(equallySpacedX,equallySpacedY);

% Waitbar shows the the user the status
    waitbar(10/100,hwait);

% Now, utilize the PCA-Wavelet filter to obtain valley centerline.
% The level below will have to be user input until a better approach
% has been found (4 works well for Ucayali).

wname = 'db10';  
npc = 'nodet'; 
theXYCenterScatter = complex(equallySpacedX,equallySpacedY);
[x_sim, qual, npc] = wmspca(theXYCenterScatter, level, wname, npc);

% Waitbar shows the the user the status
waitbar(30/100,hwait);

meanCenter{nFiles}.XYOriginal = [real(x_sim(:,1)),imag(x_sim(:,1))]; 
%(These are the meanCenter XY original coordinates).
meanCenter{nFiles}.XYOriginalNPoints = length(real(x_sim(:,1)));
%(These are the meanCenter XY original coordinates number of points).
xValleyCenter = real(x_sim(:,1));
yValleyCenter = imag(x_sim(:,1));

% Waitbar shows the the user the status
waitbar(50/100,hwait);

dimlessCurvature = cResample*width;%dimlees curvature with width C*=CBave
equallySpaced = [equallySpacedX, equallySpacedY];

% Now, get the indices for the different intersection points.
% index1 identifies the maximum points (peaks) of the bends.
% index2 identifies the minimum points (troughs) of the bends.
% "index" combines index1 and index2 into one vector
delta = 0.01;
[maxCurvS, maxCurvXY] = ...
    mStat_assignMaxCurv(dimlessCurvature, delta, sResample, equallySpaced);

waitbar(60/100,hwait);


%%
% Now, find the Geometric Inflection Points.
%
% Call the crossing function and initialize handles structures for the
% geometric inflection points.  
% Note: geometric inflection points are dimensionless.  Therefore, the
% "index" output of the crossing function below has no units.  
% Note:  level2 can be changed to find curvature other than zero
% crossings.
% Note: choose default linear interpolation method with imeth.  
level2 = 0; 
imeth = 'linear'; 
[ind] = crossing(dimlessCurvature, sResample, level2, imeth);
ind = ind';

for i=1:length(ind)
    inflectionX(i) = equallySpacedX(ind(i));
    inflectionY(i) = equallySpacedY(ind(i));
    inflectionS(i) = sResample(ind(i));     
end

inflectionX = inflectionX';
inflectionY = inflectionY';
inflectionPts = [inflectionX, inflectionY];

if sel==2 %Mean center method
        geovar.methodIntersection='Intersection Mean Center';

        % Now, get the intersection points of the equally spaced data and
        % valley centerline by calling the "intersections" function and initializing
        % a handles structure for dimlessCurvature.
        % Note: may make more sense to initialize robust as zero.
        robust = 0;
        active.ac = 0;
        setappdata(0, 'active', active);
        [x0, y0, iout, jout] = intersections(equallySpacedX,...
            equallySpacedY, xValleyCenter, yValleyCenter,robust);
        
        waitbar(70/100,hwait);
        
elseif sel==1 %inflection points method
        
        geovar.methodIntersection='Intersection Inflection Points';
        % Now, get the intersection points of the equally spaced data and
        % inflection points by calling the "intersections" function and initializing
        % a handles structure for dimlessCurvature.
        % Note: may make more sense to initialize robust as zero.

        active.ac = 0;       
        setappdata(0, 'active', active);
        
%         robust = 0;
%         [x0, y0, iout, jout] = intersections(equallySpacedX,...
%             equallySpacedY, inflectionX, inflectionY,robust);
        x0=inflectionX;
        y0=inflectionY;
        iout=ind;
        jout=(1:1:length(ind))';

        waitbar(70/100,hwait);
end

%      End geometric section.  

%--------------------------------------------------------------------------
%      Begin bends section.

%      Call the bends function.  
[intS, nBends, bendID, bend, newInflectionPts,...
    dStreamIndex, uStreamIndex, symmetricIndex, ...
    cmpdIndex, newMaxCurvX, newMaxCurvY,...
    newMaxCurvS, numMaxPts, ~] = ...
    mStat_bends(maxCurvS, maxCurvXY, x0, y0,...
    sResample, iout, jout, inflectionX', inflectionY',...
    inflectionPts,equallySpacedX, equallySpacedY);
%     
%     

% Waitbar shows the the user the status
    waitbar(80/100,hwait);

% End bends section.  

%--------------------------------------------------------------------------
% Begin statistics section.  

% Find the sinuosity, straight length, and curved length of each bend
% by calling the "sinuosity" function.

[sinuosityOfBends, lengthStraight, lengthCurved] =...
    mStat_sinuosity(intS, nBends, newInflectionPts);

% Find the wavelength of each bend by calling on the "wavelength"
% function.  
[wavelengthOfBends] = mStat_wavelength(newInflectionPts, nBends);

% Find the amplitude of each bend by calling on the "amplitude"
% function.  
[amplitudeOfBends] = mStat_amplitude(inflectionX', inflectionY',...
nBends, newMaxCurvX, newMaxCurvY, newInflectionPts, numMaxPts);

lengthAmplitudeOfBends = length(amplitudeOfBends);

% End statistics section.

%------------------------------------------------------------------------------------
% Calculate array Condition 'DS.Downstream length, 'US. Upstream length', 'C' and 'S'
Condition=[dStreamIndex uStreamIndex cmpdIndex symmetricIndex];
dStreamIndex1=dStreamIndex';
uStreamIndex1=uStreamIndex';
cmpdIndex1=cmpdIndex';
symmetricIndex1=symmetricIndex';

[ns,ms]=size(Condition);
bends1=[1:1:ms];
bends1=bends1';
bends1(dStreamIndex1)=12;
bends1(uStreamIndex1)=13;
bends1(cmpdIndex1)=14;
if symmetricIndex(1) ~= 0
    bends1(symmetricIndex1)=15;
end

% Array conditions
for ii=1:ms-1
    if bends1(ii,1)==12
        condition(ii,1)={'DS'};
    elseif bends1(ii,1)==13
        condition(ii,1)={'US'};
    elseif bends1(ii,1)==14
        condition(ii,1)={'C'};
    elseif bends1(ii,1)==15
        condition(ii,1)={'S'};
    end
end

[na,ma]=size(newMaxCurvS);

s11='C';

for i=2:nBends+1
    for j=1:na
        if j==1
           if newMaxCurvS(j)<intS(i) && newMaxCurvS(j+1)> intS(i) 
               newMaxCurvS1(i-1)=newMaxCurvS(j);
           else
           end
        end
        if j>1
            if newMaxCurvS(j)>intS(i-1) && newMaxCurvS(j-1)< intS(i-1)
                newMaxCurvS1(i-1)=newMaxCurvS(j);
            else
            end
        end
    end
end

newMaxCurvS1=newMaxCurvS1';

j = 1;
for i = 2:nBends+1
    if strcmp(s11,condition(j)) ~=1 && amplitudeOfBends(j)~=0
        downstreamSlength(j) = intS(i)-newMaxCurvS1(j) ;
    else
        downstreamSlength(j)=nan;
    end
    j=j+1;
end

% 
j = 1;
for i = 2:nBends+1
    if strcmp(s11,condition(j)) ~=1 && amplitudeOfBends(j)~=0
        upstreamSlength(j) = (intS(i)-intS(i-1))-downstreamSlength(j);
    else
        upstreamSlength(j)=nan;
    end
    j=j+1;
end

downstreamSlength(upstreamSlength<1)=nan;
upstreamSlength(upstreamSlength<1)=nan;
upstreamSlength(downstreamSlength<1)=nan;
downstreamSlength(downstreamSlength<1)=nan;

%end calculate
waitbar(90/100,hwait);

%--------------------------------------------------------------------------

%Store all the planar data calculated
geovar.angle = angle;
geovar.xValleyCenter = xValleyCenter;
geovar.yValleyCenter = yValleyCenter;
geovar.x0 = x0;
geovar.y0 = y0;
geovar.inflectionX = inflectionX;
geovar.inflectionY = inflectionY;
geovar.inflectionPts = inflectionPts;
geovar.x_sim = x_sim;
geovar.intS = intS;
geovar.nBends = nBends;
geovar.bend = bend;
geovar.newInflectionPts = newInflectionPts;
geovar.newMaxCurvX = newMaxCurvX;
geovar.newMaxCurvY = newMaxCurvY;
geovar.newMaxCurvS = newMaxCurvS;
geovar.equallySpacedX = equallySpacedX;
geovar.equallySpacedY = equallySpacedY;
geovar.sResample = sResample;
geovar.cResample = cResample;

geovar.bendID1 = bendID';
geovar.sinuosityOfBends = sinuosityOfBends;
geovar.lengthStraight = lengthStraight;
geovar.lengthCurved = lengthCurved;
geovar.wavelengthOfBends = wavelengthOfBends;
geovar.amplitudeOfBends = amplitudeOfBends;
geovar.downstreamSlength = downstreamSlength;
geovar.upstreamSlength = upstreamSlength;
geovar.condition = condition;
geovar.width = width;

mStat_transformatevar(geovar)

waitbar(1,hwait)
delete(hwait)
