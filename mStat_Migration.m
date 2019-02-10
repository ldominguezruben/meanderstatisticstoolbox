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

        %Determinate the times 
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
        [xline1_int{t}(:,o),yline1_int{t}(:,o),~,~] = intersections(X11{t}(:,o),Y22{t}(:,o),Migra.linet1X{t}.line,Migra.linet1Y{t}.line,robust);

        xline2_int{t}(:,o)=xx(o,:);%start point t0 Coordinate X
        yline2_int{t}(:,o)=yy(o,:);%start point t0 Coordinate Y       
        
        
        if isnan(xline1_int{t}(:,o)) | length(Migra.linet0X{t}.line)<3 | Migra.distancet1{t}<0.6*Migra.distancet0{t}
            Migra.BendCutOff(l) = t;
            Migra.NumberOfCut = l;
            l=l+1;
            
            %Delete all data bend
            xline1_int{t}(:,:)=nan;%delete area t1
            yline1_int{t}(:,:)=nan;%delete area t1
            xline2_int{t}(:,:)=nan;%delete area t0
            yline2_int{t}(:,:)=nan;%delete area t0
            MigrationSignal{t}(:,:)=nan;
            Direction{t}(:,:)=nan;
            
            %No calcula migration cuando hay un cutoff
            break
        else
            MigrationSignal{t}(o,1)=((xline1_int{t}(o)-xline2_int{t}(o))^2+...
                (yline1_int{t}(o)-yline2_int{t}(o))^2)^0.5;

            u = xline1_int{t}(o)-xline2_int{t}(o);
            w = yline1_int{t}(o)-yline2_int{t}(o);
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
end
    
%%
% Resize the array to determinate a continuos signal
e=1;
for t=1:length(Migra.Distance)
    for o=3:length(Migra.Distance{t}.DistanceSignal)
        if t==1 & o==3%first point
            Migra.MigrationDistance(e,1) = Migra.Distance{t}.DistanceSignal(1,o-1) + Migra.Distance{t}.DistanceSignal(1,o-1);
            if isnan(MigrationSignal{t})
                Migra.MigrationSignal(e,1) = nan;
                Migra.Direction(e,1) = nan;
                Migra.xline1_int(e) = nan;
                Migra.yline1_int(e) = nan;
                Migra.xline2_int(e) = nan;
                Migra.yline2_int(e) = nan; 
                e=e+1;
            else
                Migra.MigrationSignal(e,1) = MigrationSignal{t}(o-1,1);
                Migra.Direction(e,1) = Direction{t}(o-1,1);
                Migra.xline1_int(e) = xline1_int{t}(:,o-1);
                Migra.yline1_int(e) = yline1_int{t}(:,o-1);
                Migra.xline2_int(e) = xline2_int{t}(:,o-1);
                Migra.yline2_int(e) = yline2_int{t}(:,o-1);   
                e=e+1;
            end
        else
            Migra.MigrationDistance(e,1) = Migra.Distance{t}.DistanceSignal(1,o-1) + Migra.MigrationDistance(e-1,1);
            if isnan(MigrationSignal{t})              
                Migra.MigrationSignal(e,1) = nan;
                Migra.Direction(e,1) = nan;
                Migra.xline1_int(e) = nan;
                Migra.yline1_int(e) = nan;
                Migra.xline2_int(e) = nan;
                Migra.yline2_int(e) = nan; 
                e=e+1;
            else
                 Migra.MigrationSignal(e,1) = MigrationSignal{t}(o-1,1);
                 Migra.Direction(e,1) = Direction{t}(o-1,1);
                 Migra.xline1_int(e) = xline1_int{t}(:,o-1);
                 Migra.yline1_int(e) = yline1_int{t}(:,o-1);
                 Migra.xline2_int(e) = xline2_int{t}(:,o-1);
                 Migra.yline2_int(e) = yline2_int{t}(:,o-1);
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

Migra.deltat=handles.year(2)-handles.year(1);%Delta time

mStat_plotWavel(geovar{1},sel,SIGLVL,filter,axest,Tools,Migra)

%%%Plot
hwait = waitbar(0,'Plotting...','Name','MStaT ',...
         'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
setappdata(hwait,'canceling',0)

axes(handles.pictureReach)

plot(xstart,ystart,'-b')%start
hold on
plot(xend,yend,'-k')
%plot(Migra.xline2_int,Migra.yline2_int,'ob')
plot(ArMigra.xint_areat0,ArMigra.yint_areat0,'or')
legend('t0','t1','Intersection','Location','Best')
grid on
axis equal
for t=2:length(Migra.xline1_int)
    %line([xstart(t,1) xline1_int(1,t)],[ystart(t,1) yline1_int(1,t)])
    %line([xstart_line1(t) xend_line1(t)],[ystart_line1(t) yend_line1(t)])
    %line([xline2_int(t) xline1_int(t)],[yline2_int(t) yline1_int(t)])

    % figure(3)
    D=[Migra.xline1_int(t) Migra.yline1_int(t)]-[Migra.xline2_int(t) Migra.yline2_int(t)];
    quiver(Migra.xline2_int(t),Migra.yline2_int(t),D(1),D(2),0,'filled','color','k','MarkerSize',10)
    % plot(xline1_int{u}(1,i),yline1_int{u}(1,i),'or')
    % hold on
    % plot(xstart,ystart,'-r')
    % plot(xend,yend,'-g')
    % axis equal

    %waitbar(((t/length(xline1_int))/50)/100,hwait); 
end
% 
xlabel('X [m]');ylabel('Y [m]')
hold off

waitbar(50/100,hwait);  
    
% figure(3)
% hold on
% plot(Migra.MigrationDistance,Migra.MigrationSignal/Migra.deltat,'-r');
% xlabel('Intrinsic Channel Lengths [m]','Fontsize',10);
% ylabel('Migration/year [m/yr]','Fontsize',10) 

%Plot migration
axes(handles.signalvariation);
[hAx,hLine1,hLine2] = plotyy(Migra.MigrationDistance,Migra.MigrationSignal/Migra.deltat,Migra.MigrationDistance,Migra.Direction,'plot');
hold on

xlabel('Intrinsic Channel Lengths [m]','Fontsize',10);
ylabel('Migration/year [m/yr]','Fontsize',10) % left y-axis

% Define limits
 FileBed_dataMX=Migra.MigrationDistance;
% xmin=min(FileBed_dataMX);     
% DeltaCentS=FileBed_dataMX(2,1)-FileBed_dataMX(1,1);  %units. 
% n=length((Migra.MigrationSignal/Migra.deltat)');
% xlim = [xmin,(n-1)*DeltaCentS+xmin];  % plotting range
xlim = [FileBed_dataMX(1,1),FileBed_dataMX(end,1)];
set(hAx(1),'XLim',xlim(:));
set(hAx(2),'XLim',xlim(:));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%grid on
ylabel(hAx(1),'Migration/year [m/yr]','Fontsize',10) % left y-axis ylabel('Migration/year [m/yr]','Fontsize',10) % left y-axis
ylabel(hAx(2),'Direction [º]','Fontsize',10) % right y-axis
%set(hAx(1),'YLim',[0 nanmax(Migra.MigrationSignal/Migra.deltat)],'YTick',[0 nanmax(Migra.MigrationSignal/Migra.deltat)/2  nanmax(Migra.MigrationSignal/Migra.deltat)])
set(hAx(2),'YLim',[0 360],'YTick',[0 90 180 270 360])
hold off

hLine1.LineStyle = '-';
hLine2.LineStyle = '-.';

waitbar(100/100,hwait);
delete(hwait)


% 
% for i=1:size(xstart,1)-1
%     startpoint(i,:)=[xstart(i,1) ystart(i,1)];
%     endpoint(i,:)=[xstart(i+1,1) ystart(i+1,1)];
%     v(i,:)=endpoint(i,:)-startpoint(i,:);
%     
%     space=0.5;%Space between subreach
%     Migra.porcenVector=0.5;%0:space:1-space;%percentage of spacing between width reach
%     
%     xx(i,:)=xstart(i,1)+Migra.porcenVector*v(i,1);%
% 
%     yy(i,:)=ystart(i,1)+Migra.porcenVector*v(i,2);%
% 
%     %Determinate the times 
%     times=(nanmin(geovar{2}.wavelengthOfBends)/geovar{1}.width)+2.5;%reduce the minimum wavelength and width ¿Como calculamos un valor correcto?
%     
%     mag=geovar{2}.width*times;%times of amplitude of migration 
%     v(i,:)=mag*v(i,:)/norm(v(i,:));
%     
%     xstart_line1(i,:)=xx(i,:)+v(i,2);%extended line start
% 	xend_line1(i,:)=xx(i,:)-v(i,2);%extended line end
% 	ystart_line1(i,:)=yy(i,:)-v(i,1); 
% 	yend_line1(i,:)=yy(i,:)+v(i,1);
% end
% 
%  clear startpoint endpoint
% 
% %  figure(3)
% %     plot(xstart,ystart,'-b')%start
% %     	hold on
% %     plot(xend,yend,'-k')
% %   for i=1:length(xend_line1)-1
% %   hold on
% %      line([xx(i,1)+v(i,2), xx(i,1)-v(i,2)],[yy(i,1)-v(i,1),yy(i,1)+v(i,1)])
% %  end
% % %  plot(xend_line1,yend_line1,'-k')
% % 
% % %  quiver(xstart,ystart,-dy,dx)
% %   axis equal
% 
% robust=0;
% active.ac=1;
% setappdata(0, 'active', active);%if dont found intersection
% %Intersection betwen extended normal line(t0) to centerline t1
% %t1
% for u=1:length(Migra.porcenVector)
%     xline1_int{u}=zeros(2,length(xstart_line1)-1);
%     yline1_int{u}=zeros(2,length(xstart_line1)-1);
% end
% 
% for i=1:length(xstart_line1)-1
%     for u=1:length(Migra.porcenVector)
%         if isnan(xstart_line1(i,u)) | isnan(xend_line1(i,u)) | isnan(ystart_line1(i,u)) | isnan(yend_line1(i,u)) 
%             xline1_int{u}(:,i)=nan;
%             yline1_int{u}(:,i)=nan;
%         else
%             X11{u}(:,i)=[xstart_line1(i,u);xend_line1(i,u)];
%             Y22{u}(:,i)=[ystart_line1(i,u);yend_line1(i,u)];
%             %Find the intersection
%             [xline1_int{u}(:,i),yline1_int{u}(:,i),~,~] = intersections(X11{u}(:,i),Y22{u}(:,i),xend,yend,robust);
%         end
% %     figure(3)
% %     plot(xline1_int{u}(1,i),yline1_int{u}(1,i),'or')
% %     hold on
% %     plot(xstart,ystart,'-r')
% %     plot(xend,yend,'-g')
%     end
% end             
% clear X11 Y22
% 
% 
% %t0
% for i=1:length(xstart_line1)-1
%     for u=1:length(Migra.porcenVector)
%     if isnan(xstart_line1(i,u)) | isnan(xend_line1(i,u)) | isnan(ystart_line1(i,u)) | isnan(yend_line1(i,u)) 
%         xline1_int{u}(:,i)=nan;
%         yline1_int{u}(:,i)=nan;
%     else
%         X11{u}(:,i)=[xstart_line1(i,u);xend_line1(i,u)];
%         Y22{u}(:,i)=[ystart_line1(i,u);yend_line1(i,u)];
%     [xline2_int{u}(:,i),yline2_int{u}(:,i),~,~] = intersections(X11{u}(:,i),Y22{u}(:,i),xstart,ystart,robust);
%     %Modify
%     xline2_int{u}(:,i)=xx(i);
%     yline2_int{u}(:,i)=yy(i);
%     end
%     end
% end
% clear X11 Y22



%Calculate the distance

% for i=1:length(xline1_int{1})
%     
%     for n=1:length(Migra.porcenVector)
%         MigrationSignal{n}(i,1)=((xline1_int{n}(i)-xline2_int{n}(i))^2+(yline1_int{n}(i)-yline2_int{n}(i))^2)^0.5;
% 
%         u = xline1_int{n}(i)-xline2_int{n}(i);
%         v = yline1_int{n}(i)-yline2_int{n}(i);
%         anglq = atan2d(u,v);                                    % Angle Corrected For Quadrant
%         Angles360 = @(a) rem(360+a, 360);                       % For ‘atan2d’
%         Direction{n}(i,1)= Angles360(anglq);
%         clear u v
%         
%     end
% end
