function [intS, nBends, bendID, bend, newInflectionPts, dStreamIndex, ...
    uStreamIndex, symmetricIndex, cmpdIndex, nMaxCurvX, nMaxCurvY, nMaxCurvS,...
    numMaxPts, simpleIndex] = mStat_bends(maxCurvS, maxCurvXY, x0, y0, ...
    sResample, I, J, xCenter, yCenter, inflectionPts, equallySpacedX, equallySpacedY)

%      This function finds and classifies bends for the given river planimetry.    
%      Last Modified: 5/10/2017 by Dominguez Ruben L

%--------------------------------------------------------------------------
%      Obtain a a vector with the s-coordinate (along the river centerline) of intersection points.
%      (This centerline pertains only to the equally spaced (sResample) data.)  

intS = zeros(length(x0),1);
counter(:,1) = 1:numel(I);
intersectionSortIndex = sortrows([I, counter], 1); 
I = intersectionSortIndex(:,1); %I = sort(I); 
for i = 1:length(x0)
    fraction = I(i)-floor(I(i));
    intS(i) = fraction*(sResample(ceil(I(i)))-sResample(floor(I(i))))+sResample(floor(I(i)));
end
int = length(intS);

%%
I = intersectionSortIndex(:,2);
x0(1:int,1) = x0(I(1:int),1);
y0(1:int,1) = y0(I(1:int),1);
newInflectionPts = [x0 y0];
%[index,cv] = searchclosest(equallySpacedX,x0);
%-----------------------------------------------
%     Find the number of bends in the river ("nBends").  
%nBends = (length(newInflectionPts(:,1)) - 1);
nBends = length(intS)-1;    

%     Assign bend ID numbers, which are used in the
%     bendSelect list box.  

bendID = zeros(nBends,1);
for i = 1:nBends
    bendID(i) = i;
end

%--------------------------------------------------------------------------
%     Now, trim vector to remove peaks/troughs that are at beginning or 
%     end of the river planimetry (not actually part of a bend) in
%     S,c-coordinates.

%     Trim peaks/troughs before the first intersection point.
i = 1;
j = 1;
if maxCurvS(j) < intS(i)
    while maxCurvS(j) < intS(i)
        j = j+1;
    end
    nMaxS = maxCurvS(j:length(maxCurvS));
    %nMaxN = maxCurvC(j:length(maxCurvC));
else
    nMaxS = maxCurvS;
    %nMaxN = maxCurvN;
end
startTrim = j;
%     Trim peaks/troughs after the last intersection point.
 j = length(intS);
 i = length(nMaxS);
    while nMaxS(i) > intS(j)
        i = i-1;
    end
    endTrim = i;
nMaxCurvS = nMaxS(1:i);
var1011425a = length(maxCurvXY);
nMaxCurvX = maxCurvXY(startTrim:(endTrim+startTrim-1), 1);
nMaxCurvY = maxCurvXY(startTrim:(endTrim+startTrim-1), 2);
nMaxCurvXY = [nMaxCurvX, nMaxCurvY];

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% %     Now, get some of the bend statistics.
% 
% %     This loop creates a matrix of bend data called "bend".  Each row of the 
% %     matrix contains the starting point of the bend, one or more points of 
% %     maximum curvature, and the ending point of each bend.  This matrix is  
% %     also used to call up the secondary window and display individual bend
% %     statistics.  
j = 1;
p = 1;
bend = zeros(nBends,10);
for i = 1:2:nBends
    m = 2;
    %     Add first intersection point to matrix of bend data.
    bend(i,1) = intS(i);
    %     Add points of maximum curvature to matrix of bend data.
    if j <= length(nMaxCurvS)
        bend(i,m) = nMaxCurvS(j);
    else
    end
    j = j+1;
    while (j+1)<= length(nMaxCurvS) && (i+1) <= length(intS) && nMaxCurvS(j) < intS(i+1)
        m = m+1;
        bend(i,m) = nMaxCurvS(j);
        j = j+1;
    end
    %     Add points of maximum curvature from adjacent bend to matrix.
    k = i+2;
    if k <= length(intS)
        n = 2;
        while p <= length(nMaxCurvS) && j <= length(nMaxCurvS) && nMaxCurvS(j) < intS(i+2)
            bend(i+1,n) = nMaxCurvS(j); 
            j = j+1;
            n = n+1;
        end   
    else
    end
    %     Add last point of inflection of current bend to matrix of bend data.
    bend(i,m+1) = intS(i+1);
    bend(i+1,1) = intS(i+1); 
%     Add last inflection point of adjacent bend to matrix of bend data.
    if i+2 <= length(intS)
        bend(i+1, n) = intS(i+2);
    else
    end
end

%    Classify Bends by orientation and type.  

%    Sort into simple and compound.
j = 1;
k = 1;
m = 1;
n = 1;
p = 1;
cmpdIndex = 1;
symmetricIndex = 0; 
dStreamIndex=0;
uStreamIndex=0;
simpleIndex=0;

for i = 1:nBends
    %Determines if Simple bends are u/s or d/s oriented
    if (bend(i,4)-bend(i,1)) < 0     
        simpleIndex(j) = i;
        if (bend(i,2)-bend(i,1)) > (bend(i,3)-bend(i,1))/2
            dStreamIndex(m) = i; %Downstream oriented bends
            m = m+1;
        elseif (bend(i,2)-bend(i,1)) < (bend(i,3)-bend(i,1))/2
            uStreamIndex(n) = i; %Upstream oriented bends
            n = n+1;
        elseif (bend(i,2)-bend(i,1)) == (bend(i,3)-bend(i,1))/2
            symmetricIndex(p) = i; %Symmetric bends
            p = p+1; 
        end
        j = j+1;
    else %Compound bends
        cmpdIndex(k) = i;
        k = k+1;
    end
    numMaxPts(i,1) = find(bend(i,:),1, 'last')-2;
end

% 
% 
if uStreamIndex==0
    uStreamIndex=1;
else
end

if dStreamIndex==0
    dStreamIndex=1;
else
end

if simpleIndex==0
    simpleIndex=1;
else
end


%--------------------------------------------------------------------------

