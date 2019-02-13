function varargout = mStat_ConfluencesAnalyzer(varargin)
%-----------------MEANDER STATISTICS TOOLBOX. MStaT------------------------
%MSTAT CONFLUENCESANALYZER  
%
% This function evaluate the influences of the secondaries channels on 
%confluence or bifurcation in the main channel and control in how long 
%downstream modify the main channel.

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

set(handles.figure1,'Name',['MStaT: Confluences and Bifurcation Analyzer '], ...
    'DockControls','off')


% Push messages to Log Window:
    % ----------------------------
    log_text = {...
        '';...
        ['%----------- ' datestr(now) ' ------------%'];...
        'LETs START!!!'};
    statusLogging(handles.LogWindow, log_text)
    

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
% --- Executes on button press in mainchannel.
function mainchannel_Callback(hObject, eventdata, handles)
%This function incorporate the main channel data
multisel='off';
[ReadVar]=mStat_ReadInputFiles(multisel);

%Create celltable
handles.celltable=cell(1,2);

handles.celltable(1,2)={''};

if ReadVar.File==0
else
    
    % Push messages to Log Window:
    % ----------------------------
    log_text = {...
                '';...
                ['%--- ' datestr(now) ' ---%'];...
                'Main Channel Centerline Loaded:';[cell2mat({ReadVar.File})]};
                statusLogging(handles.LogWindow, log_text)
                
    %Convert information
    handles.NameMain = {ReadVar.File};
    handles.xCoordMain = [];
    handles.yCoordMain = [];
    handles.xCoordMain(:,1) = ReadVar.xCoord{:,1};
    handles.yCoordMain(:,1) = ReadVar.yCoord{:,1};
    handles.formatfileread = ReadVar.comp;
    guidata(hObject, handles);    

    %Write File name
    handles.celltable(1,1) = {ReadVar.File};
    set(handles.inputtable,'Data',handles.celltable)
    guidata(hObject,handles)
    set_enable(handles,'loadfiles')
    set(handles.tributarychannel,'Enable','on');    
    
end


% --- Executes on button press in tributarychannel.
function tributarychannel_Callback(hObject, eventdata, handles)
%Advantages
msg='Please select all the tributaries channels to analyze';

warndlg(msg)

%This function read the tributaries data
multisel='on';
[ReadVar]=mStat_ReadInputFiles(multisel);

if iscell(ReadVar.File)
    handles.numfile=size(ReadVar.File,2);
else
    handles.numfile=1;
end
    
for i=1:handles.numfile
    if iscell(ReadVar.File)%Multi selection
        handles.celltable(i+1,1)={ReadVar.File{i}};
        Filename={ReadVar.File{i}};
        guidata(hObject,handles)
    else %Single selection
        handles.celltable(i+1,1)={ReadVar.File};
        Filename={ReadVar.File};
        guidata(hObject,handles)
    end
    
    %Convert information
    handles.NameTributary = {ReadVar.File};
    handles.xCoordTri{i}=[];
    handles.yCoordTri{i}=[];
    handles.xCoordTri{i}(:,1)=ReadVar.xCoord{:,1};
    handles.yCoordTri{i}(:,1)=ReadVar.yCoord{:,1};
    handles.formatfileread=ReadVar.comp;
    guidata(hObject, handles);    
    
     
    % Push messages to Log Window:
    % ----------------------------
    log_text = {...
                '';...
                ['%--- ' datestr(now) ' ---%'];...
                'Tributary Channel Centerline Loaded:';[cell2mat(Filename)]};
                statusLogging(handles.LogWindow, log_text)
                
    clear Filename
end
    
guidata(hObject,handles)

set(handles.inputtable,'Data',handles.celltable)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Push button Calculate

% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% Run the calculate function

hwait = waitbar(0,'Confluences and Bifurcation Analysis. Processing...','Name','MStaT ',...
         'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
setappdata(hwait,'canceling',0)

tableData = get(handles.inputtable, 'data');

if size(tableData,1)==1
    warndlg('You need incorporate Tributaries Channels')
else
    %Calculate
    sel=2;%Toolbox inflection points method by defect
    handles.bendSelect=[];
    Tools=3;%CBT Confluencer Bifurcation Tools
    level=5;%default level
    % Read Main
    widthMain=str2double(cell2mat(tableData(1,2)));
    [Main]=mStat_planar(handles.xCoordMain,handles.yCoordMain,widthMain,sel,...
        handles.pictureReach,handles.bendSelect,Tools,level);
    
    waitbar(30/100,hwait);

    %Read Tributary data
    for i=1:handles.numfile
         widthTri{i}=str2double(cell2mat(tableData(1+i,2)));
         [Tri{i}]=mStat_planar(handles.xCoordTri{i},handles.yCoordTri{i},widthTri{i},...
             sel,handles.pictureReach,handles.bendSelect,Tools,level);
         
         LongTri(i)=Tri{i}.intS(end,1);
         
         waitbar((30+(i*10))/100,hwait);
    end

    %save data
    handles.Main=Main;
    handles.Tri=Tri;
    guidata(hObject,handles)

    if handles.numfile==1 %single file
        geovar{1}=Main;
        geovar{2}=Tri{1};
    else
        for t=1:handles.numfile+1
            if t==1
                geovar{1}=Main;
            else
                geovar{t}=Tri{t-1};
            end
        end
    end
    
    waitbar(70/100,hwait);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Obtain data to incorporate the 
    
    %relation BT/BM
    for t=1:handles.numfile
        BTdivBM(t)=widthTri{t}./widthMain;
    end
    
    %Lambdas relations
    for t=1:handles.numfile
        lambdaTdivlambdaM(t)=nanmean(Tri{t}.wavelengthOfBends)./nanmean(Main.wavelengthOfBends);
    end
    
    %Amplitude relations
    for t=1:handles.numfile
        AmplitudeTdivAmplitudeM(t)=nanmean(Tri{t}.amplitudeOfBends)./nanmean(Main.amplitudeOfBends);
    end

    waitbar(75/100,hwait);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Wavelet analyzes
    %go to wavelet analyzer
    %%Plotting
    SIGLVL=0.95;
    sel=2;
    filter=0;
    axest=[handles.wavel_axes];
    Tools=3;%Confluences Tools
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
    legend('Main Channel','Secondary Channels','Intersection point',...
        'Influences Region','Location','Best')
    xlabel('X');ylabel('Y')
    axis equal
    hold off
    
    %Wavelet analyzes
    %go to wavelet analyzer
    %%Plotting
    SIGLVL=0.95;
    sel=2;
    filter=0;
    axest=[handles.wavel_axes];
    Tools=3;%Confluences And Bifurcation Tools

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
        cla(handles.pictureReach)
        cla(handles.wavel_axes)
        set(handles.calculate,'Enable','off');
        set(handles.tributarychannel,'Enable','off');
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
