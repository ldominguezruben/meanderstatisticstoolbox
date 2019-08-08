function [Migra,ArMigra]=mStat_Migration(geovar,handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MIGRATION DETERMINATE 
% Dominguez Ruben L. UNL
% This function calculate the migration between two centerline of a delta
% time t0 and t1. Define 4 normal lines from centerline t0 and calculate the
% distance from t0 to t1 centerline. This is the punctual migration. Also
% calculate the migration determinating the Migration Area between the length
%
    init=1;%initial time
    ended=2;%final time
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Intersection lines both centerlines and the determination of area and
%the length to calculate Migration=Area/length
robust=0;
active.ac=0;%deactivate close point
setappdata(0, 'active', active);
Migra.deltat=handles.year(2)-handles.year(1);%Delta time

% Verify the order of difitalization 
[ArMigra.xint_areat0,ArMigra.yint_areat0,iout0,jout0]=intersections...
    (geovar{1}.equallySpacedX,geovar{1}.equallySpacedY,...
    geovar{2}.equallySpacedX,geovar{2}.equallySpacedY,robust);

    %Initial data
    xstart=geovar{init}.equallySpacedX;
    ystart=geovar{init}.equallySpacedY;
    
if iout0(1,1)<iout0(end,1)
    %Finally data
    xend=geovar{ended}.equallySpacedX;
    yend=geovar{ended}.equallySpacedY;
else%Modify the order 
    %Finally data
    xend=flipud(geovar{ended}.equallySpacedX);
    yend=flipud(geovar{ended}.equallySpacedY);
end

    [ArMigra.xint_areat0,ArMigra.yint_areat0,iout0,jout0]=intersections...
        (xstart,ystart,xend,yend,robust);

    [ArMigra.xint_areat1,ArMigra.yint_areat1,iout1,jout1]=intersections...
        (xend,yend,xstart,ystart,robust);


%Determinate perimeter of migration area for line t0 (Doesn cosider the
%first reach with open area
for t=1:length(ArMigra.xint_areat0)-1
    m=1;
    for r=1:length(xstart)
        if r<jout1(t) & jout1(t)<r+1 %first point of Migration area
            linex(m)=ArMigra.xint_areat0(t);
            liney(m)=ArMigra.yint_areat0(t);
            distance(m)=0;
            indexP(m)=r;
            m=m+1;
        elseif jout1(t)<r & jout1(t+1)>r %intern point of Migration area
            linex(m)=xstart(r);
            liney(m)=ystart(r);
            distance(m)=((linex(m)-linex(m-1))^2+(liney(m)-liney(m-1))^2)^0.5;
            indexP(m)=r;
            m=m+1;
        elseif r>jout1(t+1) % last point of Migration area
            linex(m)=ArMigra.xint_areat0(t+1);
            liney(m)=ArMigra.yint_areat0(t+1);
            indexP(m)=r;
            distance(m)=((linex(m)-linex(m-1))^2+(liney(m)-liney(m-1))^2)^0.5;
            m=m+1;
            break
        end
    end
    Migra.linet0X{t}.line = linex;
    Migra.linet0Y{t}.line = liney;
    Migra.Indext0{t}.ind = indexP;
    Migra.Distance{t}.DistanceSignal = distance;
    Migra.distancet0{t} = nansum(distance);
    
%     figure(3)
%     plot(linex,liney,'-r','Linewidth',2)
%     hold on
%     plot(xstart,ystart,'-b')%start
%     plot(xend,yend,'-k')
%     plot(ArMigra.xint_areat0,ArMigra.yint_areat0,'or')

    clear m linex liney distance indexP
end

% %line t1
for t=1:length(ArMigra.xint_areat1)-1%number of Migration areas found
    m=1;
    for r=1:length(xend)
        if r<jout0(t) & jout0(t)<r+1%first point
            linex(m)=ArMigra.xint_areat1(t);
            liney(m)=ArMigra.yint_areat1(t);
            distance(m)=0;
            indexP(m)=r;
            m=m+1;
        elseif jout0(t)<r & jout0(t+1)>r%between points area
            linex(m)=xend(r);
            liney(m)=yend(r);
            distance(m)=((linex(m)-linex(m-1))^2+(liney(m)-liney(m-1))^2)^0.5;
            indexP(m)=r;
            m=m+1;
        elseif r>jout0(t+1)%the last point of migration area
            linex(m)=ArMigra.xint_areat1(t+1);
            liney(m)=ArMigra.yint_areat1(t+1);
            distance(m)=((linex(m)-linex(m-1))^2+(liney(m)-liney(m-1))^2)^0.5;
            indexP(m)=r;
            break
        end
    end
    Migra.linet1X{t}.line=linex;
    Migra.linet1Y{t}.line=liney;
    Migra.Indext1{t}.ind=indexP;
    Migra.distancet1{t}=nansum(distance);
    
%     figure(3)
%     plot(linex,liney,'-r','Linewidth',2)
%     hold on
%     plot(xstart,ystart,'-b')%start
%     plot(xend,yend,'-k')
%     plot(ArMigra.xint_areat0,ArMigra.yint_areat0,'or')
    clear m liney linex distance indexP
end    

%Calculate Migration areas
for t=1:length(ArMigra.xint_areat1)-1
	Migra.areat0(t)=trapz(Migra.linet0X{t}.line,Migra.linet0Y{t}.line);
	Migra.areat1(t)=trapz(Migra.linet1X{t}.line,Migra.linet1Y{t}.line);
	Migra.areat0_t1(t)=abs(Migra.areat0(t)-Migra.areat1(t));
end

%Average Migration (Julien 2002)
for t=1:length(ArMigra.xint_areat1)-1
	Migra.AreaTot(t)=Migra.areat0_t1(t)/(Migra.distancet0{t}+Migra.distancet1{t});
    Migra.MigrationAveArea(t)=(Migra.areat0_t1(t)/(Migra.distancet0{t}+Migra.distancet1{t}))/Migra.deltat;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Migration estimated
robust=0;
active.ac=1;
setappdata(0, 'active', active);%activate Migration correction
l=1;%number of cut off count
Migra.NumberOfCut = 0;

for t=1:length(ArMigra.xint_areat1)-1%each bend from second area first and final is open!!
    
    for o=2:length(Migra.linet0X{t}.line)-1
        
        startpoint(o,:)=[Migra.linet0X{t}.line(1,o) Migra.linet0Y{t}.line(1,o)];
        endpoint(o,:)=[Migra.linet0X{t}.line(1,o+1) Migra.linet0Y{t}.line(1,o+1)];
        v(o,:)=endpoint(o,:)-startpoint(o,:);

        %space=0.5;%Space between subreach
        Migra.porcenVector=0;%0:space:1-space;%percentage of spacing between width reach

        xx(o,:)=Migra.linet0X{t}.line(1,o)+Migra.porcenVector*v(o,1);%

        yy(o,:)=Migra.linet0Y{t}.line(1,o)+Migra.porcenVector*v(o,2);%

        %Determinate the times of extended 
        times=10;%(nanmin(geovar{2}.wavelengthOfBends)/geovar{1}.width)+5;%reduce the minimum wavelength and width ¿Como calculamos un valor correcto?

        mag=geovar{2}.width*times;%times of amplitude of migration 
        v(o,:)=mag*v(o,:)/norm(v(o,:));

        xstart_line1(o,:)=xx(o,:)+v(o,2);%extended line start
        xend_line1(o,:)=xx(o,:)-v(o,2);%extended line end
        ystart_line1(o,:)=yy(o,:)-v(o,1); 
        yend_line1(o,:)=yy(o,:)+v(o,1);
        
        %Intersection withorthogonal with t1
        X11{t}(:,o)=[xstart_line1(o,1);xend_line1(o,1)];
        Y22{t}(:,o)=[ystart_line1(o,1);yend_line1(o,1)];

        %Find the intersection
        [xlinet1_int{t}(:,o),ylinet1_int{t}(:,o),~,~] = intersections(X11{t}(:,o),Y22{t}(:,o),Migra.linet1X{t}.line,Migra.linet1Y{t}.line,robust);

        xlinet0_int{t}(:,o)=xx(o,:);%start point t0 Coordinate X
        ylinet0_int{t}(:,o)=yy(o,:);%start point t0 Coordinate Y       
        
        
        if isnan(xlinet1_int{t}(:,o)) |  Migra.distancet1{t}<0.6*Migra.distancet0{t} %| length(Migra.linet0X{t}.line)<3  | length(Migra.linet1X{t}.line)<3
            if  length(Migra.linet0X{t}.line)<3  | length(Migra.linet1X{t}.line)<3
               %Delete all data bend
                xlinet1_int{t}(:,:)=nan;%delete area t1
                ylinet1_int{t}(:,:)=nan;%delete area t1
                xlinet0_int{t}(:,:)=nan;%delete area t0
                ylinet0_int{t}(:,:)=nan;%delete area t0
                MigrationSignal{t}(:,:)=nan;
                Direction{t}(:,:)=nan;
                
            else
                %%Define cut off
                Migra.BendCutOff(l) = t;
                Migra.NumberOfCut = l;
                l=l+1;

                %Delete all data bend
                xlinet1_int{t}(:,:)=nan;%delete area t1
                ylinet1_int{t}(:,:)=nan;%delete area t1
                xlinet0_int{t}(:,:)=nan;%delete area t0
                ylinet0_int{t}(:,:)=nan;%delete area t0
                MigrationSignal{t}(:,:)=nan;
                Direction{t}(:,:)=nan;

                %No calcula migration cuando hay un cutoff
            break
            
            end
        else
            MigrationSignal{t}(o,1)=((xlinet1_int{t}(o)-xlinet0_int{t}(o))^2+...
                (ylinet1_int{t}(o)-ylinet0_int{t}(o))^2)^0.5;
            
            
    
            u = xlinet1_int{t}(o)-xlinet0_int{t}(o);
            w = ylinet1_int{t}(o)-ylinet0_int{t}(o);
            anglq = atan2d(u,w);                                    % Angle Corrected For Quadrant
            Angles360 = @(a) rem(360+a, 360);                       % For ‘atan2d’
            Direction{t}(o,1)= Angles360(anglq);
        end
    
%         figure(3)
%         hold on
%         axis equal
%         plot(Migra.linet0X{t}.line,Migra.linet0Y{t}.line,'-r');%t0
%         plot(Migra.linet1X{t}.line,Migra.linet1Y{t}.line,'-b');%t1        
%         line([xstart_line1(o,1) xend_line1(o,1)],[ystart_line1(o,1) yend_line1(o,1)])
        
        clear  xx yy u v w xstart_line1 xend_line1 ystart_line1 yend_line1 ...
            startpoint endpoint
    end
    
    if isempty(o)
        Migra.MigrationAve(t)=nan;
    else
        % Mean migration
        Migra.MigrationAve(t)=nanmean(MigrationSignal{t}(2:end,1))./Migra.deltat;
    end
end
    
Migra.seg.xlinet1_int=xlinet1_int;
Migra.seg.ylinet1_int=ylinet1_int;
%%
%Determinate distance

Migra.MigrationDistance=cumsum(diff(geovar{1}.sResample(floor(iout0(1))+1:floor(iout0(end))+1)));

% Resize the array to determinate a continuos signal
e=1;
for t=1:length(Migra.Distance)

    
    for o=3:length(Migra.Distance{t}.DistanceSignal)
        if t==1 & o==2%first point
          %  Migra.MigrationDistance(e,1) = Migra.Distance{t}.DistanceSignal(1,o-1) + Migra.Distance{t}.DistanceSignal(1,o-1);
            if isnan(MigrationSignal{t})
                Migra.MigrationSignal(e,1) = nan;
                Migra.Direction(e,1) = nan;
                Migra.xlinet1_int(e) = nan;%t1
                Migra.ylinet1_int(e) = nan;%t1
                Migra.xlinet0_int(e) = nan;%t0
                Migra.ylinet0_int(e) = nan; %t0
                e=e+1;
            else
                Migra.MigrationSignal(e,1) = MigrationSignal{t}(o-1,1);
                Migra.Direction(e,1) = Direction{t}(o-1,1);
                Migra.xlinet1_int(e) = xlinet1_int{t}(:,o-1);
                Migra.ylinet1_int(e) = ylinet1_int{t}(:,o-1);
                Migra.xlinet0_int(e) = xlinet0_int{t}(:,o-1);
                Migra.ylinet0_int(e) = ylinet0_int{t}(:,o-1);   
                e=e+1;
            end
        else
           % Migra.MigrationDistance(e,1) = Migra.Distance{t}.DistanceSignal(1,o-1) + Migra.MigrationDistance(e-1,1);
            if isnan(MigrationSignal{t})              
                Migra.MigrationSignal(e,1) = nan;
                Migra.Direction(e,1) = nan;
                Migra.xlinet1_int(e) = nan;
                Migra.ylinet1_int(e) = nan;
                Migra.xlinet0_int(e) = nan;
                Migra.ylinet0_int(e) = nan; 
                e=e+1;
            else
                 Migra.MigrationSignal(e,1) = MigrationSignal{t}(o-1,1);
                 Migra.Direction(e,1) = Direction{t}(o-1,1);
                 Migra.xlinet1_int(e) = xlinet1_int{t}(:,o-1);
                 Migra.ylinet1_int(e) = ylinet1_int{t}(:,o-1);
                 Migra.xlinet0_int(e) = xlinet0_int{t}(:,o-1);
                 Migra.ylinet0_int(e) = ylinet0_int{t}(:,o-1);
                 e=e+1;
            end
        end
    end
end       
%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Go to wavelet analyzer to plot
SIGLVL=0.95;
sel=2;%inflection Method
filter=0;%No filter option
axest=[handles.wavel_axes];%axes of determination
Tools=2;%Migration tools

mStat_plotWavel(geovar{1},sel,SIGLVL,filter,axest,Tools,Migra)

%%%Plot
axes(handles.pictureReach)

plot(xstart,ystart,'-b')%start
hold on
plot(xend,yend,'-r')%ended
plot(ArMigra.xint_areat0,ArMigra.yint_areat0,'ok')
plot(xstart(1),ystart(1),'or',    'MarkerSize',4,...
    'MarkerEdgeColor','r','MarkerFaceColor','y');%start
legend('t0','t1','Intersection','Init Data','Location','Best')   
grid on
axis equal
% for t=2:length(Migra.xlinet1_int)
%     %line([xstart(t,1) xline1_int(1,t)],[ystart(t,1) ylinet1_int(1,t)])
%     %line([xstart_line1(t) xend_line1(t)],[ystart_line1(t) yend_line1(t)])
%     %line([xlinet0_int(t) xline1_int(t)],[ylinet0_int(t) ylinet1_int(t)])
% 
%     % figure(3)
%     D=[Migra.xlinet1_int(t) Migra.ylinet1_int(t)]-[Migra.xlinet0_int(t) Migra.ylinet0_int(t)];
%     quiver(Migra.xlinet0_int(t),Migra.ylinet0_int(t),D(1),D(2),0,'filled','color','k','MarkerSize',10)
%     % plot(xline1_int{u}(1,i),ylinet1_int{u}(1,i),'or')
%     % hold on
%     % plot(xstart,ystart,'-r')
%     % plot(xend,yend,'-g')
%     % axis equal
% 
%     % waitbar(((t/length(Migra.xline1_int))/50)/100,hwait); 
% end

% 
xlabel('X [m]');ylabel('Y [m]')
hold off

%Plot maximum migration
axes(handles.pictureReach)
hold on

%Found maximum migration
Controlmax=Migra.MigrationSignal;
[~,pos]=nanmax(Controlmax);

%Control maximum migration
r=1;
while(Controlmax(pos)- Controlmax(pos-1))/Controlmax(pos)>0.5
    Controlmax(pos)=[];
    [~,pos]=nanmax(Controlmax);
    r=r+1;
end

ee=text(Migra.xlinet1_int(pos),Migra.ylinet1_int(pos),'Maximum Migration');
set(ee,'Clipping','on')
    
hold off

% waitbar(50/100,hwait);  
    
% figure(3)
% hold on
% plot(Migra.MigrationDistance,Migra.MigrationSignal/Migra.deltat,'-r');
% xlabel('Intrinsic Channel Lengths [m]','Fontsize',10);
% ylabel('Migration/year [m/yr]','Fontsize',10) 

%%
% Plot migration signal
% Define limits
FileBed_dataMX=Migra.MigrationDistance;
xmin=0;     
DeltaCentS=FileBed_dataMX(1,1);  %units. 
n=length((Migra.MigrationSignal/Migra.deltat)');
xlim = [xmin,(n-1)*DeltaCentS+xmin];  % plotting range
Abscise = [1:length(FileBed_dataMX)] + xmin;

axes(handles.signalvariation);
dimlessx=Abscise*DeltaCentS;
[hAx,hLine1,hLine2] = plotyy(dimlessx,Migra.MigrationSignal/Migra.deltat,dimlessx,Migra.Direction,'plot');
hold on
xlabel('Intrinsic Channel Lengths [m]','Fontsize',10);
ylabel('Migration/year [m/yr]','Fontsize',10) % left y-axis
set(hAx(1),'XLim',xlim(:));
set(hAx(2),'XLim',xlim(:));
set(hAx(1),'XGrid','on');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%grid on
ylabel(hAx(1),'Migration/year [m/yr]','Fontsize',10) % left y-axis ylabel('Migration/year [m/yr]','Fontsize',10) % left y-axis
ylabel(hAx(2),'Direction [º]','Fontsize',10) % right y-axis
%set(hAx(1),'YLim',[0 nanmax(Migra.MigrationSignal/Migra.deltat)],'YTick',[0 nanmax(Migra.MigrationSignal/Migra.deltat)/2  nanmax(Migra.MigrationSignal/Migra.deltat)])
set(hAx(2),'YLim',[0 360],'YTick',[0 90 180 270 360])
hold off

hLine1.LineStyle = '-';
hLine2.LineStyle = '-.';
