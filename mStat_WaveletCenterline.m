%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MStaT
%Wavelet Analysis Function
%This function plot the wavelet analisys, need initial data
%last modified 04/17 by Dominguez Ruben L. UNL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%start code
function [period,power,sig95M,scale_avg,scaleavg_signif] = mStat_WaveletCenterline(JProfile,jnodes,DeltaCentS,sst,OptSaveFig,FileBaseW,...
    xmin,dt,dj,Lower_Scale,Upper_Scale,SIGLVL,equallySpacedX,equallySpacedY,angle,width, sel1,filter,axest,Module,vars)

if Module==2 | Module==3 
else
hwait = waitbar(0,'Creating Wavelet Plot...','Name','MStaT v1.1',...
         'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
setappdata(hwait,'canceling',0)
end

% ------------------------------START EVALUATION ---------------------------
ssto = sst;
sstoav = num2str(ssto);
setappdata(0, 'sstoav', sstoav);

variance = nanstd(sst)^2;
sst = (sst - nanmean(sst))/sqrt(variance) ;
 
% Computation of the Lag1 coefficient for the Red Noise Power Spectrum Eq. 16        
[c,lags] = xcorr(sst,10,'coeff'); % for 10 Lag values (-10 to 10)  
Index_Lag1 = find(lags==1);
lag1 = c(Index_Lag1);  
lag1av = num2str(lag1);
setappdata(0, 'lag1av', lag1av);
n = length(sst); 
nAbscise = 1:n;
%  lag1 = input('assumed/computed Lag1 0 <= Lag1 < 1.0: ');
Abscise = [1:length(sst)]*dt + xmin ;  % construct Abscise array

xlim = [xmin,(n-1)*DeltaCentS+xmin];  % plotting range

% Parameter to control the sig95 (0: To not modify, 1: Modify by cone of influence)
sig95Mod = 1;

pad = 1;      % pad the time series with zeroes (recommended)
% dj = 0.25;    % this will do 4 sub-octaves per octave
s0 = 2*dt;    % this says start at a scale of 6 months
j1 = fix(log2(n*dt/s0))/dj; %J1 = (LOG2(N dx/S0))/DJ
%  j1 = 7/dj;    % this says do 7 powers-of-two with dj sub-octaves each
% lag1 = 0.97;  % lag-1 autocorrelation for red noise background
mother = 'Morlet';

% Wavelet transform:
[f,wave,period,scale,coi] = wavelet(sst,dt,pad,dj,s0,j1,mother);
periodav = num2str(period);
setappdata(0, 'periodav', periodav);
coiav = num2str(coi);
setappdata(0, 'coiav', coiav);

power = (abs(wave)).^2 ;                % compute wavelet power spectrum (number period:n)
fps   = (abs(f)).^2 ;                   % Fourier Power Spectrum (1:n)

% Significance levels: (variance=1 for the normalized SST)
[signif,fft_theor] = wave_signif(1.0,dt,scale,0,lag1,SIGLVL,-1,mother);
sig95 = (signif')*(ones(1,n));          % expand signif --> (J+1)x(N) array
sig95 = power ./ sig95;                 % where ratio > 1, power is significant
sig95av = num2str(sig95);
setappdata(0, 'sig95av', sig95av);

% Global wavelet spectrum & significance levels:
%-------------------------------------
global_ws = variance^1*(sum(power')/n); % time-average over all times !!!!
global_wsav = num2str(global_ws);
setappdata(0, 'global_wsav', global_wsav);

global_wsfps = (sum(power')/n);         % time-average over all times !!!!
global_wsfps = global_wsfps/max(global_wsfps);

global_fftps = (fps');                   % time-average over all times !!!!
global_fftps = global_fftps/max(fps);
%-------------------------------------

dof = n - scale;                        % the -scale corrects for padding at edges
%global_signif = wave_signif(variance,dt,scale,1,lag1,-1,dof,mother);
global_signif = wave_signif(variance,dt,scale,1,lag1,SIGLVL,dof,mother);
global_signifav = num2str(global_signif);
setappdata(0, 'global_signifav', global_signifav);

% Scale-average between El Nino periods of 2--8 years
avg = find((scale >= Lower_Scale) & (scale < Upper_Scale));
Cdelta = 0.776;                         % this is for the MORLET wavelet
scale_avg = (scale')*(ones(1,n));       % expand scale --> (J+1)x(N) array
scale_avg = power ./ scale_avg;         % [Eqn(24)]
scale_avg = variance*dj*dt/Cdelta*sum(scale_avg(avg,:));   % [Eqn(24)]
scaleavg_signif = wave_signif(variance,dt,scale,2,lag1,SIGLVL,[Lower_Scale,Upper_Scale],mother);


SIGLVLav = num2str(SIGLVL);
setappdata(0, 'SIGLVLav', SIGLVLav);
%------------------------------END EVALUATION-----------------------------%

%  START PLOTTING---------------------------------------------------------%
if Module==1;
%%
if sel1==1 %CURVATURE PLOT
   
%[1] Plot curvature variation
axes(axest(1))
dimlessx=Abscise*DeltaCentS./width;
dimlessy=ssto.*width;
plot(dimlessx,dimlessy,'black -','linewidth',1.0);

if filter==2
     scurv = getappdata(0, 'scurv');
     handles.scurv = str2num(scurv);
        
    if handles.scurv==0
    %    line((Abscise(handles.scurv)*DeltaCentS)./width,ssto(handles.scurv).*width, 'color', 'r', 'LineWidth',5);
    else
        line((Abscise(handles.scurv:handles.scurv+1)*DeltaCentS)./width,ssto(handles.scurv:handles.scurv+1).*width, 'color', 'r', 'LineWidth',5);
    end
    
elseif filter==1
    hold on

        bendwavelength = getappdata(0, 'bendwavelength');
        handles.bendwavelength = str2num(bendwavelength);
        indi = getappdata(0, 'indi');
        handles.indi = str2num(indi);

        for i=1:length(handles.indi)
            line((Abscise(handles.indi(i,1):handles.indi(i,2))*DeltaCentS)./width,ssto(handles.indi(i,1):handles.indi(i,2)).*width, 'color', 'r', 'LineWidth',2);
            plot((Abscise(handles.indi(i,1))*DeltaCentS)./width,ssto(handles.indi(i,1)).*width,'or','MarkerSize',6,'MarkerFaceColor','r')
            plot((Abscise(handles.indi(i,2))*DeltaCentS)./width,ssto(handles.indi(i,2)).*width,'ob','MarkerSize',6,'MarkerFaceColor','b')
            text([(Abscise(handles.indi(i,1))*DeltaCentS)./width],[ssto(handles.indi(i,1)).*width],num2str(handles.bendwavelength(i)),'FontSize',14)
        end
end
    
    set(gca,'XLim',xlim(:)./width)
    xlabel('S*','fontsize',10);
    ylabel('C*','fontsize',10);
    title('Signature of the channel curvature','fontsize',13);
    grid on;
    hold off;

    waitbar(25/100,hwait);


elseif sel1==2%ANGLE VARIATION
    % [1] Plot angle variation
    axes(axest(1))
    dimlessx=Abscise*DeltaCentS./width;
    plot(dimlessx,angle,'black -','linewidth',1.0);
    hold on;  

    %apply filter
    if filter==2
        scurv = getappdata(0, 'scurv');
        handles.scurv = str2num(scurv);
        
        if handles.scurv==0
        else
            line((Abscise(handles.scurv:handles.scurv+1)*DeltaCentS)./width,angle(handles.scurv:handles.scurv+1), 'color', 'r', 'LineWidth',5);
        end

    elseif filter==1
        bendwavelength = getappdata(0, 'bendwavelength');
        handles.bendwavelength = str2num(bendwavelength);

        indi = getappdata(0, 'indi');
        handles.indi = str2num(indi);

        hold on
        for i=1:length(handles.indi)
            line(Abscise(handles.indi(i,1):handles.indi(i,2))*DeltaCentS,angle(handles.indi(i,1):handles.indi(i,2)), 'color', 'r', 'LineWidth',2);
            plot(Abscise(handles.indi(i,1))*DeltaCentS,angle(handles.indi(i,1)),'or','MarkerSize',6,'MarkerFaceColor','r')
            plot(Abscise(handles.indi(i,2))*DeltaCentS,angle(handles.indi(i,2)),'ob','MarkerSize',6,'MarkerFaceColor','b')
            text([Abscise(handles.indi(i,1))*DeltaCentS],[angle(handles.indi(i,1))],num2str(handles.bendwavelength(i)),'FontSize',14)
        end

    end


    set(gca,'XLim',xlim(:)./width);
    set(gca,'YLim',[min(angle)-10 max(angle)+10]);
    xlabel('Intrinsic Channel Length [m]','fontsize',10);
    ylabel('Angle [degree]','fontsize',10);
    title('Signature of the channel angle','fontsize',13);
    grid on;
    hold off;

    waitbar(25/100,hwait);

end

%%
%[2]  Plot the equally spaced river centerline from the meander
%toolbox.(Plot B)
axes(axest(3))
plot(equallySpacedX, equallySpacedY, 'color', 'k', 'linewidth',2);
hold on;
plot(equallySpacedX(1,1), equallySpacedY(1,1),'*', 'MarkerSize',14,...
    'MarkerEdgeColor','b','MarkerFaceColor','b');
legend('Centerline','Upstream','Location','Best','Fontsize',10)
xlim1 = [min(equallySpacedX),max(equallySpacedX)];  % plotting range
set(gca,'XLim',xlim1(:));
xlabel('X [m]');
ylabel('Y [m]');
out = ['River Centerline '];
title(out,'fontsize',13);
grid on;
axis equal

if filter==2
    scurv = getappdata(0, 'scurv');
    handles.scurv = str2num(scurv);
    hold on
    line(equallySpacedX(handles.scurv:handles.scurv+1), equallySpacedY(handles.scurv:handles.scurv+1), 'color', 'y', 'LineWidth',8); 
    text([equallySpacedX(handles.scurv)],[equallySpacedY(handles.scurv)],['<-Here'],'FontSize',12)
    plot(equallySpacedX(handles.scurv),equallySpacedY(handles.scurv),'or','MarkerSize',6,'MarkerFaceColor','r')
    hold off
elseif filter==1

    highlightx_arc = getappdata(0, 'highlightx_arc');
    handles.highlightx_arc = str2num(highlightx_arc);
    highlighty_arc = getappdata(0, 'highlighty_arc');
    handles.highlighty_arc = str2num(highlighty_arc);

    finitedhighlightx_arc=nansum(isfinite(handles.highlightx_arc),2);
    finitedhighlighty_arc=nansum(isfinite(handles.highlighty_arc),2);

    hold on
    for j=1:size(handles.highlighty_arc,1)
        line(handles.highlightx_arc(j,1:finitedhighlightx_arc(j,1)), handles.highlighty_arc(j,1:finitedhighlighty_arc(j,1)), 'color', 'y', 'LineWidth',8); 
        plot(handles.highlightx_arc(j,1),handles.highlighty_arc(j,1),'or','MarkerSize',6,'MarkerFaceColor','r')
        plot(handles.highlightx_arc(j,finitedhighlightx_arc(j,1)),handles.highlighty_arc(j,finitedhighlighty_arc(j,1)),'ob','MarkerSize',6,'MarkerFaceColor','b')
        text([handles.highlightx_arc(j,1)],[handles.highlighty_arc(j,1)],num2str(handles.bendwavelength(j)),'FontSize',14)
    end
end
     
hold off

waitbar(50/100,hwait);

%%
%[3] Contour of significance (Sig > 1 is valid) (Plot C)
axes(axest(2))
Yticks = 2.^(fix(log2(min(period*DeltaCentS./width))):fix(log2(max(period*DeltaCentS./width))));%dimless
Yticksav = num2str(Yticks);
setappdata(0, 'Yticksav', Yticksav);
dimlessx=Abscise*DeltaCentS./width;
dimlessy=log2(period*DeltaCentS./width);

%Modifiying the sig95 to be only those that are in cone of influence
if (sig95Mod == 1)
    [msig95,nsig95]=size(sig95);
    sig95M=zeros(msig95,nsig95);
    for nn=1: nsig95               % along x-distance nodes
        for mm=1: msig95           % along period nodes
            if (period(mm)<=coi(nn))
                sig95M(mm,nn)=sig95(mm,nn);
            end
        end
    end
else
    sig95M(mm,nn)=sig95(mm,nn);
end
contourf(dimlessx,dimlessy,sig95M,[1:max(max(sig95M))],'LineColor','none');

colormap('jet');
cc=colorbar;
cc.Label.String = 'WPS';
cc.FontSize=8;
cc.Location='SouthOutside';
    
xlabel('S*','fontsize',10);
ylabel('\lambda*','fontsize',12);
title(['Wavelet Spectrum at ',num2str(SIGLVL*100),'% of confidence'],'fontsize',13);
set(gca,'XLim',xlim(:)./width);
set(gca,'YLim',log2([4,max(period*DeltaCentS./width)]), 'YDir','reverse', 'YTick',log2(Yticks(:)), 'YTickLabel',Yticks);
grid on;
hold on;
% cone-of-influence, anything "below" is dubious
plot(Abscise*DeltaCentS./width,log2(coi*DeltaCentS./width),'k','linewidth',2);

if filter==0
elseif filter==1
hold on
    for i=1:length(handles.indi)
        line([Abscise(handles.indi(i,1))*DeltaCentS./width Abscise(handles.indi(i,1))*DeltaCentS./width],...
            log2([min(period*DeltaCentS./width),max(period*DeltaCentS./width)]), 'color', 'r', 'LineWidth',2);
        line([Abscise(handles.indi(i,2))*DeltaCentS./width Abscise(handles.indi(i,2))*DeltaCentS./width],...
            log2([min(period*DeltaCentS./width),max(period*DeltaCentS./width)]), 'color', 'b', 'LineWidth',2);
        text([Abscise(handles.indi(i,1))*DeltaCentS./width],[log2(max(period*DeltaCentS./width))],num2str(handles.bendwavelength(i)),'FontSize',14)
    end
end
    
hold off

waitbar(75/100,hwait);
%%
%[4] Plot global wavelet spectrum (Plot D)
axes(axest(4))
semilogx((global_ws*DeltaCentS*DeltaCentS),log2(period*DeltaCentS./width),'linewidth',1.1);

hold on;
semilogx((global_signif*DeltaCentS*DeltaCentS),log2(period*DeltaCentS./width),'red--');
lgd=legend('Global Wavelet Spectrum','Significance','Location','Best');
lgd.FontSize = 7;
[~,in]=max(log2((global_ws*DeltaCentS*DeltaCentS./width)));

xposFM=global_ws(in)*DeltaCentS*DeltaCentS;
yposFM=log2(period(in)*DeltaCentS./width);

StrPeak = num2str((2^yposFM),'%6.2f');
ee=text(xposFM,yposFM,StrPeak,'fontsize',13);
set(ee,'Clipping','on')    

%close graph
hold off;

%labels edit
ylabel('\lambda*');
xlabel('Average Variance','fontsize',10);
Str0=num2str(lag1,2);
title(['Global Wavelet Spectrum'],'fontsize',13);
grid on
set(gca,'YLim',log2([min(period*DeltaCentS./width),max(period*DeltaCentS./width)]), 'YDir','reverse', 'YTick',log2(Yticks(:)), 'YTickLabel',Yticks,'linewidth',0.5);
xpos = log2(min(period*DeltaCentS)); ypos=log2(min(Yticks));
out_t=[ '=' Str0 ];


%Plot the greek symbol
uicontrol('Style', 'push','enable','off', 'fontsize',12, 'units', 'norm', 'position', [0.08 0.43 0.06 0.03],...
    'String',out_t);
uicontrol('Style', 'push','enable','off', 'fontsize',12, 'units', 'norm', 'position', [0.06 0.43 0.03 0.03],...
    'String','<HTML><FONT COLOR="black"> &alpha;</HTML>');

waitbar(100/100,hwait);
delete(hwait)
%%

elseif Module==2% MIGRATION ANALYZER 
  
    cla(axest(1))    
    axes(axest(1))
    Yticks = 2.^(fix(log2(min(period*DeltaCentS))):fix(log2(max(period*DeltaCentS))));
    Yticksav = num2str(Yticks);
    setappdata(0, 'Yticksav', Yticksav);
    %Modifiying the sig95 to be only those that are in cone of influence

    if (sig95Mod == 1)
        [msig95,nsig95]=size(sig95);
        sig95M=zeros(msig95,nsig95);
        for nn=1: nsig95               % along x-distance nodes
            for mm=1: msig95           % along period nodes
                if (period(mm)<=coi(nn))
                    sig95M(mm,nn)=sig95(mm,nn);
                end
            end
        end
    else
        sig95M=sig95;
    end

    
    contourf(Abscise*DeltaCentS,log2(period*DeltaCentS),sig95M,[1:max(max(sig95M))],'LineColor','none');
    colormap('jet');
    cc=colorbar;
    cc.Label.String = 'WPS';
    cc.FontSize=8;
    cc.Location='EastOutside';

    xlabel('Intrinsic Channel Lengths [m]','fontsize',8);
    ylabel('Period [m]','fontsize',8);
    title(['Wavelet Spectrum at ',num2str(SIGLVL*100),'% of confidence'],'fontsize',11);
    set(gca,'XLim',xlim(:));
    set(gca,'YLim',log2([min(period*DeltaCentS),max(period*DeltaCentS)]), 'YDir','reverse', 'YTick',log2(Yticks(:)), 'YTickLabel',Yticks);
    grid on;
    hold on;
    % cone-of-influence, anything "below" is dubious
    plot(Abscise*DeltaCentS,log2(coi*DeltaCentS),'k','linewidth',2);


%%
elseif Module==3%CONFLUENCES MODULE PLOT
    
    % read input variables
    x=Abscise*DeltaCentS;
    dimlessy=log2(period*DeltaCentS./width);

    %Modifiying the sig95 to be only those that are in cone of influence
    sig95M=[];
    if (sig95Mod == 1)
        [msig95,nsig95]=size(sig95);
        sig95M=zeros(msig95,nsig95);
        for nn=1: nsig95               % along x-distance nodes
            for mm=1: msig95           % along period nodes
                if (period(mm)<=coi(nn))
                    sig95M(mm,nn)=sig95(mm,nn);
                end
            end
        end
    else
        sig95M(mm,nn)=sig95(mm,nn);
    end
           
    if strcmp('calmain',filter)%calculate distance of area and confluence fixed point
        %select if is main channel
         [T3.f,~,~]=contourf(x,dimlessy,sig95M,[1:max(max(sig95M))],'--');
         
%          for w=1:length(T3.f)
%              if T3.f(1,w)==1 %choice the maximum area
%                  T3.X(1,1:T3.f(2,w)) = [T3.f(1,w+1:w+T3.f(2,w))];%agrupa todas las 'X'
%              end
%          end
         
         for i=1:length(vars.indexinter)
            abajo = find(T3.f(1,:)<Abscise(vars.indexinter{i})*DeltaCentS);
            arriba = find(T3.f(1,:)>Abscise(vars.indexinter{i})*DeltaCentS);
            [rmmin{i}, ~]= min(abs(T3.f(1,abajo)- (Abscise(vars.indexinter{i})*DeltaCentS))); 
            [rmtmin{i}, ~]= min(abs(T3.f(1,arriba)- (Abscise(vars.indexinter{i})*DeltaCentS))); 
            rmlocation{i} = Abscise(vars.indexinter{i})*DeltaCentS - rmmin{i};
            rmtlocation{i} =  Abscise(vars.indexinter{i})*DeltaCentS + rmtmin{i};
            inter{i}= Abscise(vars.indexinter{i})*DeltaCentS;
         end
         
        %store data
        setappdata(0, 'inter', inter);
        setappdata(0, 'rmmin', rmmin);
        setappdata(0, 'rmlocation', rmlocation);
        setappdata(0, 'rmtmin', rmtmin);
        setappdata(0, 'rmtlocation', rmtlocation);
        
    elseif strcmp('caltributary',filter)
        %this function find tributary data distance
         [T3.f,~,~]=contourf(x,dimlessy,sig95M,[1:max(max(sig95M))],'--');
% 
         for w=1:length(T3.f)
             %if T3.f(1,w)==1 %choice the maximum area
                 %T3.X(1,1:T3.f(2,w)) = [T3.f(1,w+1:w+T3.f(2,w))];%agrupa todas las 'X'
                 rtmin = x(end) - nanmax(T3.f(1,:));
                 rtlocation = nanmax(T3.f(1,:));
             %end
         end
         
         %store data
        setappdata(0, 'rtmin', rtmin);
        setappdata(0, 'rtlocation', rtlocation);
        
    elseif strcmp('graphmain',filter) | strcmp('graphtributary',filter) 
        
        axes(axest(1)) 
        Yticks = 2.^(fix(log2(min(period*DeltaCentS./width))):fix(log2(max(period*DeltaCentS./width))));%dimless
        Yticksav = num2str(Yticks);
        setappdata(0, 'Yticksav', Yticksav);

        contourf(x,dimlessy,sig95M,[1:max(max(sig95M))],'LineColor','none');
        colormap('jet');
        cc=colorbar;
        cc.Label.String = 'WPS';
        cc.FontSize=8;
        cc.Location='EastOutside';

        xlabel('S [m]','fontsize',10);
        ylabel('\lambda*','fontsize',10);
        title(['Wavelet Spectrum at ',num2str(SIGLVL*100),'% of confidence'],'fontsize',8);
        set(gca,'XLim',xlim(:));
        set(gca,'YLim',log2([4,max(period*DeltaCentS./width)]), 'YDir','reverse', 'YTick',log2(Yticks(:)), 'YTickLabel',Yticks);
        grid on;
        hold on;
        % cone-of-influence, anything "below" is dubious
        plot(Abscise*DeltaCentS,log2(coi*DeltaCentS./width),'k','linewidth',2);
        if strcmp('graphmain',filter)%only main channel
            for i=1:length(vars.indexinter)
                line([Abscise(vars.indexinter{i})*DeltaCentS Abscise(vars.indexinter{i})*DeltaCentS],...
                    [log2(4) log2(max(period*DeltaCentS./width))],'color','r','linewidth',1)
                line([vars.rmlocation{i} vars.rmlocation{i}],...
                    [log2(4) log2(max(period*DeltaCentS./width))],'color','k','linestyle','--','linewidth',0.8)
                line([vars.rmtlocation{i} vars.rmtlocation{i}],...
                    [log2(4) log2(max(period*DeltaCentS./width))],'color','k','linestyle','--','linewidth',0.8)
            end
        elseif strcmp('graphtributary',filter)%only main tributary
             line([vars.rtlocation{vars.tribuselected} vars.rtlocation{vars.tribuselected}],...
                    [log2(4) log2(max(period*DeltaCentS./width))],'color','k','linestyle','--','linewidth',0.5)
        end
        hold off
    end
        
%        %Main channel
%        if filter==0%Main channel
%          [T3.f,~,~]=contourf(x,dimlessy,sig95M,[1:max(max(sig95M))],'--');
% 
%         for w=1:length(T3.f)
%             if T3.f(1,w)==1 %choice the maximum area
%                 T3.X(1,1:T3.f(2,w))=[T3.f(1,w+1:w+T3.f(2,w))]; %agrupa todas las 'X'
%             end
%         end
%         
% %         for i=1:length(vars.XINT)
% %             [value(i),indexinter(i)]=min(T3.X(1,:)-vars.XINT{i});
% %             T3.conf(i)=Abscise(indexinter(i))*DeltaCentS;
% %             if distancemin(1,i)<vars.XINT{i}
% %                 [~,indexinter(i)]=min(abs(T3.X(1,:)-vars.XINT{i}));
% %             break
% %             end
% %         end
% %         
%        elseif filter==1%tributary channel
%            
%            [T3.f,~,~]=contourf(x,dimlessy,sig95M,[1:max(max(sig95M))],'--');
%            
%             for w=1:length(T3.f)
%                 if T3.f(1,w)==1 %choice the maximum area
%                     T3.X(1,1:T3.f(2,w))=[T3.f(1,w+1:w+T3.f(2,w))]; %agrupa todas las 'X'
%                 end
%             end
%             [~,indexinter]=min(abs(T3.X(1,:)-x(end)));
%             distancemin=T3.X(indexinter);
%                    %     %store data
%             setappdata(0, 'distancemin', distancemin);
%        end
%        

 %   end
    

    
%    if vars==1
%         %%Control the global spectrum by reach
%         %figure(4)
%         Yticks = 2.^(fix(log2(min(period*DeltaCentS./width))):fix(log2(max(period*DeltaCentS./width))));%dimless
%         Yticksav = num2str(Yticks);
%         [~,in]=max(log2((global_ws*DeltaCentS*DeltaCentS./width)));
% 
%         yposFM=log2(period(in)*DeltaCentS./width);
%         
%         setappdata(0, 'yposFM', yposFM);
%         hold on;
%         Yticks = 2.^(fix(log2(min(period*DeltaCentS./width))):fix(log2(max(period*DeltaCentS./width))));%dimless
%         semilogx((global_ws*DeltaCentS*DeltaCentS),log2(period*DeltaCentS./width),'linewidth',1.1);
%         
%         semilogx((global_signif*DeltaCentS*DeltaCentS),log2(period*DeltaCentS./width),'red--');
%         legend('Global Wavelet Spectrum','Significance','Fontsize',10,'Location','Best')
% 
%         [~,in]=max(log2((global_ws*DeltaCentS*DeltaCentS./width)));
% 
%         xposFM=global_ws(in)*DeltaCentS*DeltaCentS;
%         yposFM=log2(period(in)*DeltaCentS./width);
% 
%         StrPeak = num2str((2^yposFM),'%6.2f');
%         ee=text(xposFM,yposFM,StrPeak,'fontsize',13);
%         set(ee,'Clipping','on')    
% 
%         %close graph
%         hold off;
% 
%         %labels edit
%         ylabel('\lambda*');
%         xlabel('Average Variance','fontsize',10);
%         Str0=num2str(lag1,2);
%         title(['Global Wavelet Spectrum'],'fontsize',13);
%         grid on
%         set(gca,'YLim',log2([4,max(period*DeltaCentS./width)]), 'YDir','reverse', 'YTick',log2(Yticks(:)), 'YTickLabel',Yticks);
%         %set(gca,'YLim',log2([min(period*DeltaCentS./width),max(period*DeltaCentS./width)]), 'YDir','reverse', 'YTick',log2(Yticks(:)), 'YTickLabel',Yticks,'linewidth',0.5);
%         xpos = log2(min(period*DeltaCentS)); ypos=log2(min(Yticks));
%         out_t=[ '=' Str0 ];
% 


  %      end
    
%     dimlessx=Abscise*DeltaCentS./width;
% dimlessy=log2(period*DeltaCentS./width);
% 
%     axes(axest(1))   
%     Yticks = 2.^(fix(log2(min(period*DeltaCentS./width))):fix(log2(max(period*DeltaCentS./width))));%dimless
%     Yticksav = num2str(Yticks);
%     setappdata(0, 'Yticksav', Yticksav);
%     %Modifiying the sig95 to be only those that are in cone of influence
% 
%     if (sig95Mod == 1)
%         [msig95,nsig95]=size(sig95);
%         sig95M=zeros(msig95,nsig95);
%         for nn=1: nsig95               % along x-distance nodes
%             for mm=1: msig95           % along period nodes
%                 if (period(mm)<=coi(nn))
%                     sig95M(mm,nn)=sig95(mm,nn);
%                 end
%             end
%         end
%     else
%         sig95M=sig95;
%     end
% 
%     contourf(dimlessx,dimlessy,sig95M,[1:max(max(sig95M))],'LineColor','none');
% 
%     
%     xlabel('S*','fontsize',10);
%     ylabel('\lambda*','fontsize',12);
%     title(['Wavelet Spectrum at ',num2str(SIGLVL*100),'% of confidence'],'fontsize',13);
%     set(gca,'XLim',xlim(:)./width);
%     set(gca,'YLim',log2([min(period*DeltaCentS./width),max(period*DeltaCentS./width)]), 'YDir','reverse', 'YTick',log2(Yticks(:)), 'YTickLabel',Yticks);
%     grid on;
%     hold on;
%     % cone-of-influence, anything "below" is dubious
%     plot(Abscise*DeltaCentS./width,log2(coi*DeltaCentS./width),'k','linewidth',2);
% 
% 
%     [T3.f,~,~]=contourf(dimlessx,dimlessy,sig95M,[1:max(max(sig95M))],'--');
%     colormap('jet');
%     cc=colorbar;
%     cc.Label.String = 'WPS';
%     cc.FontSize=8;
%     cc.Location='EastOutside';
%     
%     n=1;
% 
%     for w=1:length(T3.f)
%         if T3.f(1,w)==1  
%           T3.X_Y{n}(1:2,1:T3.f(2,w))=[T3.f(1,w+1:w+T3.f(2,w));T3.f(2,w+1:w+T3.f(2,w))]; %
%           T3.Ar(n)=polyarea(T3.X_Y{n}(1,:),T3.X_Y{n}(2,:));
%           n=n+1;
%         else 
%         end
%     end
% 
%     %store data
%     setappdata(0, 'T3', T3);
% 
% %     %colormap('white');
% % 
% %     xlabel('Intrinsic Channel Lengths [m]','fontsize',10);
% %     ylabel('Arc-Wavelength [m]','fontsize',10);
% %     title(['Wavelet Spectrum at ',num2str(SIGLVL*100),'% of confidence'],'fontsize',13);
% %     set(gca,'XLim',xlim(:)./width);
% %     set(gca,'YLim',log2([min(period*DeltaCentS./width),max(period*DeltaCentS./width)]), 'YDir','reverse', 'YTick',log2(Yticks(:)), 'YTickLabel',Yticks,'linewidth',0.5);
% 
% %     set(gca,'YLim',log2([min(period*DeltaCentS),max(period*DeltaCentS)]), 'YDir','reverse', 'YTick',log2(Yticks(:)), 'YTickLabel',Yticks);
%     grid on;
%     hold on;
% 
%         if isempty(vars)
%         else 
%            Conf=vars;
%             for i=1:size(Conf.Xgraph,1)
%                 line([Conf.Xgraph{i}  Conf.Xgraph{i}],...
%                           log2([min(period*DeltaCentS),max(period*DeltaCentS)]), 'color', 'r', 'LineWidth',1,'LineStyle','--');
%             end
%         end
        
%         if isempty(vars)
%         else 
%             Conf=vars;
%             for q=1:length(Conf.Rintrinsec)
%                 if q==1
%                     line([Conf.Xgraph(2)  Conf.Xgraph(2)],...
%                         log2([min(period*DeltaCentS),max(period*DeltaCentS)]), 'color', 'r', 'LineWidth',2);%Intersection
% %                     line([Conf.Rintrinsec(q)  Conf.Rintrinsec(q)],...
% %                         log2([min(period*DeltaCentS),max(period*DeltaCentS)]), 'color', 'b', 'LineWidth',2);%Influences region
%                 else
%                     line([Conf.Rintrinsec(q-1)  Conf.Rintrinsec(q-1)],...
%                         log2([min(period*DeltaCentS),max(period*DeltaCentS)]), 'color', 'r', 'LineWidth',2);%Intersection
% %                                 line([Conf.Rintrinsec(q)  Conf.Rintrinsec(q)],...
% %                         log2([min(period*DeltaCentS),max(period*DeltaCentS)]), 'color', 'r', 'LineWidth',2);%Influences region
%                 end
%             end
%         end
% 
%     % cone-of-influence, anything "below" is dubious
%     plot(Abscise*DeltaCentS,log2(coi*DeltaCentS),'k','linewidth',2);
%     hold off
end

