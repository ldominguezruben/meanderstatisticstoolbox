function txt = mStat_myupdatefcnMigration(obj,event_obj,handles)
% 

%Read input variables

geovar= getappdata(0, 'geovarf');
Migra= getappdata(0, 'Migra');
handles= getappdata(0, 'handles');

% %data window
  post0 = get(event_obj,'Position');
  clickX=round(post0(1)*10000)/10000;
  clickY=round(post0(2)*10000)/10000;

%%
%t0
%create vector
cursorXt0=nan(length(geovar{1}.bendID1),500);
cursorYt0=nan(length(geovar{1}.bendID1),500);

for hf=1:length(geovar{1}.bendID1)
 [highlightXt0, highlightYt0,indit0] = userSelectBend(geovar{1}.intS, geovar{1}.bendID1(hf),...
    geovar{1}.equallySpacedX,geovar{1}.equallySpacedY,geovar{1}.newInflectionPts,...
    geovar{1}.sResample);

 len=length(highlightXt0);
 cursorXt0(hf,1:len)=highlightXt0;
 cursorYt0(hf,1:len)=highlightYt0;
end


%t1

%create vector
cursorXt1=nan(length(geovar{2}.bendID1),500);
cursorYt1=nan(length(geovar{2}.bendID1),500);

for hft1=1:length(geovar{2}.bendID1)
 [highlightX1t1, highlightY1t1,indi] = userSelectBend(geovar{2}.intS, geovar{2}.bendID1(hft1),...
    geovar{2}.equallySpacedX,geovar{2}.equallySpacedY,geovar{2}.newInflectionPts,...
    geovar{2}.sResample);

 lent1=length(highlightX1t1);
 cursorXt1(hft1,1:lent1)=highlightX1t1;
 cursorYt1(hft1,1:lent1)=highlightY1t1;
end


%find equal
% 
 [rowt0,~]= find(clickX==round(cursorXt0*10000)/10000);
    

if isempty(rowt0)
  [rowt1,~]= find(clickX==round(cursorXt1*10000)/10000);

[indit1,~]= find(clickX==round(geovar{2}.equallySpacedX*10000)/10000);

for t=1:length(Migra.Indext1)

    if length(Migra.Indext1{1,t}.ind)<3
    else
    if nansum(indit1==Migra.Indext1{1,t}.ind(1,2:end-1))==1;
	migrarowt1=t;
    break
    else
    end
    end
end


post1 = get(event_obj,'Position');
txt = {['BendID: ',num2str(rowt1)],['Sinuosity: ',num2str(geovar{2}.sinuosityOfBends(rowt1))],...
    ['Arc Wavelength [m]: ',num2str(geovar{2}.lengthCurved(rowt1))],...
    ['Wavelength [m]: ',num2str(geovar{2}.wavelengthOfBends(rowt1))],...
    ['Amplitude [m]: ',num2str(geovar{2}.amplitudeOfBends(rowt1))],...
    ['Average Migration [m/year]: ',num2str(Migra.AreaTot(migrarowt1)/Migra.deltat)]};
set(0,'userdata',post1);

%Re-Plot migration
 axes(handles.signalvariation);

 [hAx,hLine1] = plot(geovar{1}.sResample(1:length(Migra.MigrationSignal),1),Migra.MigrationSignal/Migra.deltat);%,geovar{1}.sResample(1:length(Migra.MigrationSignal),1),Migra.Direction,'plot');
hold on
if length(Migra.Indext1{1,migrarowt1}.ind)<3
    else
plot(geovar{1}.sResample(Migra.Indext1{1,migrarowt1}.ind(1,2):Migra.Indext1{1,migrarowt1}.ind(1,end-1),1),Migra.MigrationSignal(Migra.Indext1{1,migrarowt1}.ind(1,2):Migra.Indext1{1,migrarowt1}.ind(1,end-1),1)/Migra.deltat, 'color', 'r', 'LineWidth',3)
end

xlabel('Intrinsic Channel Lengths [m]');
% Define limits
    FileBed_dataMX=geovar{1}.sResample(1:length(Migra.MigrationSignal),1);
    xmin=min(FileBed_dataMX);     
    DeltaCentS=FileBed_dataMX(2,1)-FileBed_dataMX(1,1);  %units. 
    n=length((Migra.MigrationSignal/Migra.deltat)');
    xlim = [xmin,(n-1)*DeltaCentS+xmin];  % plotting range
    set(gca,'XLim',xlim(:));
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
grid on
ylabel(hAx(1),'Migration/year [m/yr]') % left y-axis
ylabel(hAx(2),'Direction [º] ') % right y-axis

hLine1.LineStyle = '-';
hLine2.LineStyle = '--';
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


else 


 post0 = get(event_obj,'Position');
txt = {['BendID: ',num2str(rowt0)],['Sinuosity: ',num2str(geovar{1}.sinuosityOfBends(rowt0))],...
    ['Arc Wavelength [m]: ',num2str(geovar{1}.lengthCurved(rowt0))],...
    ['Wavelength [m]: ',num2str(geovar{1}.wavelengthOfBends(rowt0))],...
    ['Amplitude [m]: ',num2str(geovar{1}.amplitudeOfBends(rowt0))]};
 set(0,'userdata',post0);

end


end
