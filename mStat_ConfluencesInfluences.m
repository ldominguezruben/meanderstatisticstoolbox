function [Conf]=mStat_ConfluencesInfluences(geovar,handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%MStaT 
%This function estimates the influence of the tributary channel on the main
%channel
%input
% - geovar
% - handles
%output
% - confluences parameters
%by Dominguez Ruben UNL, Argentina.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%start code

%Read data
x=geovar{1}.equallySpacedX;%Main channel xCoordinate
y=geovar{1}.equallySpacedY;%Main channel yCoordinate

for t=1:length(geovar)-1
    %If exist intersection betwen tributary and main channel, this function find the intersection
    robust=0;
    [Conf.XINT{t},Conf.YINT{t},Conf.IOUT{t},Conf.JOUT{t}] =...
        intersections(geovar{1}.equallySpacedX,geovar{1}.equallySpacedY,...
        geovar{t+1}.equallySpacedX,geovar{t+1}.equallySpacedY,robust);
    
    if isnan(Conf.XINT{t})%or find the point closest to main channel
        
        Aini{t}=[geovar{t+1}.equallySpacedX(1) geovar{t+1}.equallySpacedY(1)];
        Aend{t}=[geovar{t+1}.equallySpacedX(end) geovar{t+1}.equallySpacedY(end)];

        B=[x y];
                
        %compute Euclidean distances:
        distancesini{t} = sqrt(sum(bsxfun(@minus, B, Aini{t}).^2,2));
        %find the smallest distance and use that as an index into B:
        closestini{t} = find(distancesini{t}==min(distancesini{t}));
        
        %compute Euclidean distances:
        distancesend{t} = sqrt(sum(bsxfun(@minus, B, Aend{t}).^2,2));
        %find the smallest distance and use that as an index into B:
        closestend{t} = find(distancesend{t}==min(distancesend{t}));


        if min(distancesini{t})<min(distancesend{t})
           Conf.indexinter{t}=closestini{t};
        else
           Conf.indexinter{t}=closestend{t};
        end

        Conf.XINT{t}=geovar{1}.equallySpacedX(Conf.indexinter{t},1);%intersection point X
        Conf.YINT{t}=geovar{1}.equallySpacedY(Conf.indexinter{t},1);%intersection point Y
    else
       [~,Conf.indexinter{t}]=min(abs(x-Conf.XINT{t}));
    end 

end

%% CONFLUENCE ANGLE
% This part of code calculate the angle in the confluence Conf.angle
for t=1:length(geovar)-1
    u1 = geovar{1}.equallySpacedX(Conf.indexinter{t},1)-geovar{1}.equallySpacedX(Conf.indexinter{t}-1,1); 
    v1 = geovar{1}.equallySpacedY(Conf.indexinter{t},1)-geovar{1}.equallySpacedY(Conf.indexinter{t}-1,1);
    u2 = geovar{1+t}.equallySpacedX(end,1)-geovar{1+t}.equallySpacedX(end-1,1);
    v2 = geovar{1+t}.equallySpacedY(end,1)-geovar{1+t}.equallySpacedY(end-1,1);
    a =[u1 v1 0];
    b =[u2 v2 0];
    Conf.angle{t} = atan2d(norm(cross(a,b)), dot(a,b));
end

%% PERTURBATION DISTANCE
%Determinate the distance of view the first area of countor graph and
%calcule the default influence distance for each confluences
%Plotting
SIGLVL=0.95;
sel=1;%Toolbox inflection points method by defect
axest=[handles.wavel_axes];
Tools=3;%Confluence Analyzer
filter='calmain';%this calculate main or tributary
vars=Conf;%vars inputs

%Determinate distance of main channel
mStat_plotWavel(geovar{1},sel,SIGLVL,filter,axest,Tools,vars)
%take the data
Conf.inter  = getappdata(0, 'inter');
Conf.rm  = getappdata(0, 'rmmin');
Conf.rmt  = getappdata(0, 'rmtmin');
Conf.rmlocation = getappdata(0, 'rmlocation');
Conf.rmtlocation = getappdata(0, 'rmtlocation');

% 
filter='caltributary';%this calculate main or tributary
%Determinate distnace tributary channels
for i=2:length(geovar)
    mStat_plotWavel(geovar{i},sel,SIGLVL,filter,axest,Tools,vars)
    Conf.rt{i-1} = getappdata(0, 'rtmin');
    Conf.rtlocation{i-1} = getappdata(0, 'rtlocation');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT Wavelets graphs
%Wavelet main channel
%Plotting
SIGLVL=0.95;
sel=1;%Toolbox inflection points method by default
filter='graphmain';
axest=[handles.wavel_axes];
Tools=3;%Confluence Module
vars=Conf;
%plot wavelet of main channel
mStat_plotWavel(geovar{1},sel,SIGLVL,filter,axest,Tools,vars)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Wavelet tributary channel
%Plotting
SIGLVL=0.95;
sel=1;%Toolbox inflection points method by default
filter='graphtributary';
axest=[handles.tributary_axes];
Tools=3;%Confluence Module
Conf.tribuselected = handles.confluenceselected;%rename the tributary selected
vars=Conf;
%by default plot wavelet of first confluence
mStat_plotWavel(geovar{1+Conf.tribuselected},sel,SIGLVL,filter,axest,Tools,vars)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot equallySpaced points
axes(handles.pictureReach)
plot(geovar{1}.equallySpacedX,geovar{1}.equallySpacedY,'-k')%Main
hold on 

for t=1:length(geovar)-1
    plot(geovar{1+t}.equallySpacedX,geovar{1+t}.equallySpacedY)%tributary channel
    txt = [ num2str(t) ];
    text(Conf.XINT{t}+100,Conf.YINT{t}+100,txt,'FontSize',12,'Color', 'r')
    Conf.confdata(t,1) = {t};
    Conf.confdata(t,2:5) = [round(Conf.angle{t}/1,1) num2cell(round((Conf.rt{t}/1000),3))...
        num2cell(round((Conf.rm{t}/1000),3)) num2cell(round((Conf.rmt{t}/1000),3))];%
end

grid on
lgd=legend(handles.tableData(:,1),...
    'Location','Best');
lgd.FontSize = 7;
xlabel('X');ylabel('Y')
axis equal
hold off

