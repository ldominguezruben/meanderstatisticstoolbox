function varargout = mStat_ConfluencesAnalyzer(varargin)
%-----------------MEANDER STATISTICS TOOLBOX. MStaT------------------------
% MSTAT CONFLUENCE AND DIFLUENCE ANALYZER  
%
% This function evaluate the influences of the secondaries channels on 
% confluence or bifurcation in the main channel and control in how long 
% downstream modify the main channel.

% Collaborations
% Lucas Dominguez. UNL, Argentina

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mStat_ConfluencesAnalyzer_OpeningFcn, ...
                   'gui_OutputFcn',  @mStat_ConfluencesAnalyzer_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before mStat_ConfluencesAnalyzer is made visible.
function mStat_ConfluencesAnalyzer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.

% Choose default command line output for mStat_ConfluencesAnalyzer
handles.output = hObject;
set_enable(handles,'init')

set(handles.figure1,'Name',['MStaT: Confluence and Difluence Analyzer '], ...
    'DockControls','off')

% Push messages to Log Window:
% ----------------------------
log_text = {...
    '';...
    ['%----------- ' datestr(now) ' ------------%'];...
    'LETs START!!!'};
statusLogging(handles.LogWindow, log_text)
    
axes(handles.wavel_axes)
grid on

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = mStat_ConfluencesAnalyzer_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Toolbar Menu
% --------------------------------------------------------------------
function filefunctions_Callback(hObject, eventdata, handles)
% empty

% --------------------------------------------------------------------
function closefunctions_Callback(hObject, eventdata, handles)
close

% --------------------------------------------------------------------
function newprojects_Callback(hObject, eventdata, handles)
set_enable(handles,'init')

% Push messages to Log Window:
% ----------------------------
log_text = {...
            '';...
            ['%--- ' datestr(now) ' ---%'];...
            'NEW PROJECT'};
            statusLogging(handles.LogWindow, log_text)
                

% --------------------------------------------------------------------
function export_Callback(hObject, eventdata, handles)
% empty


% --------------------------------------------------------------------
function matfiles_Callback(hObject, eventdata, handles)
% empty


% --------------------------------------------------------------------
function excelfile_Callback(hObject, eventdata, handles)
% empty


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initial Panel

%Read data
% --------------------------------------------------------------------
function openfile_Callback(hObject, eventdata, handles)

handles.Module = 3;

%This function incorporate the initial data input
handles.multisel='on';
guidata(hObject,handles)

mStat_ReadInputFiles(handles);
% 
% persistent lastPath 
% % If this is the first time running the function this session,
% % Initialize lastPath to 0
% if isempty(lastPath) 
%     lastPath = 0;
% end
% 
% 
% if lastPath == 0
%     [File,Path] = uigetfile({'*.shp;*.kml;*.txt;*.xls;*.xlsx',...
%     'MStaT Files (*.shp,*.kml,*.txt,*.xls,*.xlsx)';'*.*',  'All Files (*.*)'},'Select Input File','MultiSelect',multisel);
% else %remember the lastpath
%     [File,Path] = uigetfile({'*.shp;*.kml;*.txt;*.xls;*.xlsx',...
%     'MStaT Files (*.shp,*.kml,*.txt,*.xls,*.xlsx)';'*.*',  'All Files (*.*)'},'Select Input File','MultiSelect',multisel,lastPath);
% end
% 
% 
% % Use the path to the last selected file
% % If 'uigetfile' is called, but no item is selected, 'lastPath' is not overwritten with 0
% if Path ~= 0
%     lastPath = Path;
% end
% 
% 
% if handles.numfile==1%onefile
%     [ReadVar{i}]=mStat_ReadInputFiles(handles.File,handles.Path);
%     ReadVar{i}.File=handles.File{1};
%     str=['Analyzing ' handles.File];
%     hwait = waitbar(0,str,'Name','MStaT',...
%          'CreateCancelBtn',...
%             'setappdata(gcbf,''canceling'',1)');
%     setappdata(hwait,'canceling',0)
%     waitbar(1,hwait)
%     delete(hwait)
% else%multifiles
%     [ReadVar{i}]=mStat_ReadInputFiles(handles.File{1}(i),handles.Path);
%     ReadVar{i}.File=handles.File{1}(i);
%         str=['Analyzing ' handles.File{1}(i) 'Progress' char(i) '/' char(handles.numfile)];
%     hwait = waitbar(0,str,'Name','MStaT',...
%          'CreateCancelBtn',...
%             'setappdata(gcbf,''canceling'',1)');
%     setappdata(hwait,'canceling',0)
%     waitbar(1,hwait)
%     delete(hwait)
% end
%         
% 
% if Path==0
%     %empty file
% else
%     if iscell(File)%multifile
%         handles.numfile=size(File,2); 
%     else
%         handles.numfile=1;
%     end
%     
%     %Write file readed in multiselect tool
%     mStat_AddXYData(File,Path,Module);
%      
%     handles.celltable=cell(handles.numfile,3); 
%     handles.celltable(handles.numfile,3)={''};
%     handles.celltable(:,1)={'None'};
%     
%     %Write File name
%     for i=1:handles.numfile
%         handles.celltable(i,2) = {File(i)};
%         set_enable(handles,'loadfiles')
%     end
% 
%     set(handles.inputtable,'Data',handles.celltable)
%     guidata(hObject,handles)
% end  
% 

% %Create celltable

% 
% if ReadVar.File==0
%     
% else
%     
%     % Push messages to Log Window:
%     % ----------------------------
%     log_text = {...
%                 '';...
%                 ['%--- ' datestr(now) ' ---%'];...
%                 'Main Channel Centerline Loaded:';[cell2mat({ReadVar.File})]};
%                 statusLogging(handles.LogWindow, log_text)
%                 
%     %Convert information
%     handles.NameMain = {ReadVar.File};
%     handles.xCoordMain = [];
%     handles.yCoordMain = [];
%     handles.xCoordMain(:,1) = ReadVar.xCoord{:,1};
%     handles.yCoordMain(:,1) = ReadVar.yCoord{:,1};
%     handles.formatfileread = ReadVar.comp;
%     guidata(hObject, handles);    
% 
%     %Write File name
%     handles.celltable(1,1) = {ReadVar.File};
%     set(handles.inputtable,'Data',handles.celltable)
%     guidata(hObject,handles)
%     set_enable(handles,'loadfiles')
%     set(handles.tributarychannel,'Enable','on');    
%     
%     %Plot
%     axes(handles.pictureReach)
%     plot(handles.xCoordMain,handles.yCoordMain,'-k')%Main
%     hold on 
%     plot(handles.xCoordMain(1,1),handles.yCoordMain(1,1),'ob')   
%     grid on
%     legend('Main Channel','Initial point','Location','Best')
%     xlabel('X');ylabel('Y')
%     axis equal
%     hold off
%     
% end



% % --- Executes on button press in tributarychannel.
% function tributarychannel_Callback(hObject, eventdata, handles)
% %Advantages
% msg='Please select all the secondary channels to analyze';
% 
% warndlg(msg)
% 
% %This function read the tributaries data
% multisel='on';
% persistent lastPath 
% % If this is the first time running the function this session,
% % Initialize lastPath to 0
% if isempty(lastPath) 
%     lastPath = 0;
% end
% 
% [ReadVar]=mStat_ReadInputFiles(multisel,lastPath);
% 
% % Use the path to the last selected file
% % If 'uigetfile' is called, but no item is selected, 'lastPath' is not overwritten with 0
% if ReadVar.Path ~= 0
%     lastPath = ReadVar.Path;
% end
% 
% if isempty(ReadVar.File)
%     
% else
%     if iscell(ReadVar.File)%determinate the number of secondary channels
%         handles.numfile=size(ReadVar.File,2);
%     else
%         handles.numfile=1;
%     end
%     
%     for i=1:handles.numfile
%         if iscell(ReadVar.File)%Multi selection
%             handles.celltable(i+1,1)={ReadVar.File{i}};
%             Filename={ReadVar.File{i}};
%             guidata(hObject,handles)
%         else %Single selection
%             handles.celltable(i+1,1)={ReadVar.File};
%             Filename={ReadVar.File};
%             guidata(hObject,handles)
%         end
% 
%         %Convert information
%         handles.NameTributary = {ReadVar.File};
%         handles.xCoordTri=[];
%         handles.yCoordTri=[];
%         handles.xCoordTri=ReadVar.xCoord;
%         handles.yCoordTri=ReadVar.yCoord;
%         handles.formatfileread=ReadVar.comp;
%         guidata(hObject, handles);    
% 
%         % Push messages to Log Window:
%         % ----------------------------
%         log_text = {...
%                     '';...
%                     ['%--- ' datestr(now) ' ---%'];...
%                     'Tributary Channel Centerline Loaded:';[cell2mat(Filename)]};
%                     statusLogging(handles.LogWindow, log_text)
% 
%         clear Filename
%     end
%     
%     %Plot
%     axes(handles.pictureReach)
%     plot(handles.xCoordMain,handles.yCoordMain,'-k')%Main
%     hold on 
%     plot(handles.xCoordMain(1,1),handles.yCoordMain(1,1),'ob') 
%     for i=1:handles.numfile
%         plot(handles.xCoordTri{i},handles.yCoordTri{i},'-r')%Main
%         sec = sprintf('Secondary%d',i);
%         ee=text(handles.xCoordTri{i}(1,1),handles.yCoordTri{i}(1,1),sec);
%         set(ee,'Clipping','on')
%         clear sec
%     end
%     grid on
%     legend('Main Channel','Initial point','Secondary Channels','Location','Best')
%     xlabel('X');ylabel('Y')
%     axis equal
%     hold off
%     
%     guidata(hObject,handles)
%     
%     %write filename data
%     set(handles.inputtable, 'Data', cell(handles.numfile+1,2));
%     if handles.numfile==1
%         set(handles.inputtable, 'RowName', {'Main Channel','Secondary1'});
%     elseif handles.numfile==2
%         set(handles.inputtable, 'RowName', {'Main Channel','Secondary1','Secondary2'});
%     elseif handles.numfile==3
%         set(handles.inputtable, 'RowName', {'Main Channel','Secondary1','Secondary2','Secondary3'});
%     elseif handles.numfile==4
%         set(handles.inputtable, 'RowName', {'Main Channel','Secondary1','Secondary2','Secondary3','Secondary4'});
%     elseif handles.numfile==3
%         set(handles.inputtable, 'RowName', {'Main Channel','Secondary1','Secondary2','Secondary3','Secondary4','Secondary5'});
%     end
%     
%     set(handles.inputtable, 'Data', handles.celltable)
%     
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Push button Calculate

% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
ReadVar  = getappdata(0, 'ReadVar');
geovar = getappdata(0, 'geovar');

% Run the calculate function

hwait = waitbar(0,'Confluence and Difluence Analyzer. Processing...','Name','MStaT ',...
         'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
setappdata(hwait,'canceling',0)

tableData = get(handles.inputtable, 'data');

if size(tableData,1)==1
    warndlg('You need incorporate almost one secondary channels')
else
    %Check what is main and secondary channels
    p=1;
    
    for i=1:size(tableData,1)
        if strcmp(tableData(i,2),'Main Channel')
            widthMain=ReadVar{i}.width;
            Main=geovar{i};
        elseif strcmp(tableData(i,2),'Secondary Channel')            
            Tri{p}=geovar{i};
            LongTri(p)=Tri{p}.intS(end,1);
            widthTri{p}=ReadVar{i}.width;
            p=p+1;
        end
    end

    %save data
    handles.Main=Main;
    handles.Tri=Tri;
    guidata(hObject,handles)

    if size(tableData,1)==2%single file
        geovar{1}=Main;
        geovar{2}=Tri{1};
    elseif size(tableData,1)>2
        for t=1:size(tableData,1)
            if t==1
                geovar{t}=Main;
            else
                geovar{t}=Tri{t-1};
            end
        end
    end
    
    waitbar(70/100,hwait);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Obtain data to incorporate the 
    
    %relation BT/BM
    for t=1:size(tableData,1)-1
        BTdivBM(t)=widthTri{t}./widthMain;
    end
    
    %Lambdas relations
    for t=1:size(tableData,1)-1
        lambdaTdivlambdaM(t)=nanmean(Tri{t}.wavelengthOfBends)./nanmean(Main.wavelengthOfBends);
    end
    
    %Amplitude relations
    for t=1:size(tableData,1)-1
        AmplitudeTdivAmplitudeM(t)=nanmean(Tri{t}.amplitudeOfBends)./nanmean(Main.amplitudeOfBends);
    end

    waitbar(75/100,hwait);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Wavelet analyzes
    %go to wavelet analyzer
    %%Plotting
    SIGLVL=0.95;
    sel=2;%Toolbox inflection points method by defect
    filter=0;
    axest=[handles.wavel_axes];
    Tools=3;%Confluence and Difluence Analyzer
    vars=[];

    mStat_plotWavel(geovar{1},sel,SIGLVL,filter,axest,Tools,vars)
   
    waitbar(80/100,hwait);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Determinate the intersection o point close
    [Conf]=mStat_ConfluencesInfluences(geovar);

    waitbar(90/100,hwait);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %PLOT
    axes(handles.pictureReach)
    plot(geovar{1}.equallySpacedX,geovar{1}.equallySpacedY,'-k')%Main
    hold on 
    plot(geovar{1}.equallySpacedX(1,1),geovar{1}.equallySpacedY(1,1),'ob')
    
    if handles.numfile>1 %read multy files
        for t=1:handles.numfile
            plot(geovar{1+t}.equallySpacedX,geovar{1+t}.equallySpacedY,'-r')%secondary coordinate
            plot(Conf.XINT{1+t},Conf.YINT{1+t},'or')%Intersection point
            %Graph cicle
            th = 0:pi/50:2.01*pi;
            xunit = Conf.R(t) * cos(th) + Conf.XINT{1+t};
            yunit = Conf.R(t) * sin(th) + Conf.XINT{1+t};
            plot(xunit, yunit,'-b','Linewidth',2);%circle
        end
    else%single read file
        plot(geovar{2}.equallySpacedX,geovar{2}.equallySpacedY,'-r')%secondary coordinate
        plot(Conf.XINT{2},Conf.YINT{2},'or')%Intersection point
        %Graph cicle
        th = 0:pi/50:2.01*pi;
        xunit = Conf.R(1) * cos(th) + Conf.XINT{2};
        yunit = Conf.R(1) * sin(th) + Conf.YINT{2};
        plot(xunit, yunit,'-b','Linewidth',2);%Circle
    end
    grid on
    legend('Main Channel','Initial point','Secondary Channels','Intersection point',...
        'Influences Region','Location','Best')
    xlabel('X');ylabel('Y')
    axis equal
    hold off
    
    %Wavelet analyzes
    %go to wavelet analyzer
    %%Plotting
    SIGLVL=0.95;
    sel=2;%Toolbox inflection points method by defect
    filter=0;
    axest=[handles.wavel_axes];
    Tools=3;%Confluence and Difluence Module

    vars=Conf;

    mStat_plotWavel(geovar{1},sel,SIGLVL,filter,axest,Tools,vars)
    
end

set_enable(handles,'results')

% Push messages to Log Window:
% ----------------------------
log_text = {...
            '';...
            ['%--- ' datestr(now) ' ---%'];...
            'Summary of CBA';...
            'Total Length Analyzed [km]:';[cell2mat({(geovar{1}.intS(end,1)+nansum(LongTri))/1000})];...
            'B_T/B_M:';[cell2mat({BTdivBM})];...
            '\lambda_T/\lambda_M:';[cell2mat({lambdaTdivlambdaM})];...
            '\Amp_T/Amp_M:';[cell2mat({AmplitudeTdivAmplitudeM})];...
            'R [m]:';[cell2mat({Conf.R})];};

        statusLogging(handles.LogWindow, log_text)

%Close waitbar        
waitbar(1,hwait)
delete(hwait)


function rm_Callback(hObject, eventdata, handles)
% empty


% --- Executes during object creation, after setting all properties.
function rm_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
%Extra Function
%%%%%%%%%%%%%%%%%%%%%%%%%%

function set_enable(handles,enable_state)
%Set initial an load files
switch enable_state
    case 'init'
        legend(handles.pictureReach,'hide')
        cla(handles.pictureReach)
        cla(handles.wavel_axes)
        set(handles.calculate,'Enable','off');
        set(handles.inputtable, 'Data', cell(2,2));
        set(handles.export,'Enable','off');
    case 'loadfiles'
        set(handles.calculate,'Enable','on');
    case 'results'
        set(handles.export,'Enable','on');
    otherwise
end

%%Log Window
% --- Executes on selection change in LogWindow.
function LogWindow_Callback(hObject, eventdata, handles)
% empty

% --- Executes during object creation, after setting all properties.
function LogWindow_CreateFcn(hObject, eventdata, handles)

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
