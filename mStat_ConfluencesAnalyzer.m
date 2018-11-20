function varargout = mStat_ConfluencesAnalyzer(varargin)
% MSTAT_CONFLUENCESANALYZER MATLAB code for mStat_ConfluencesAnalyzer.fig
%      MSTAT_CONFLUENCESANALYZER, by itself, creates a new MSTAT_CONFLUENCESANALYZER or raises the existing
%      singleton*.
%
%      H = MSTAT_CONFLUENCESANALYZER returns the handle to a new MSTAT_CONFLUENCESANALYZER or the handle to
%      the existing singleton*.
%
%      MSTAT_CONFLUENCESANALYZER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MSTAT_CONFLUENCESANALYZER.M with the given input arguments.
%
%      MSTAT_CONFLUENCESANALYZER('Property','Value',...) creates a new MSTAT_CONFLUENCESANALYZER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mStat_ConfluencesAnalyzer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mStat_ConfluencesAnalyzer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mStat_ConfluencesAnalyzer

% Last Modified by GUIDE v2.5 01-Jan-2015 00:13:14

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
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mStat_ConfluencesAnalyzer (see VARARGIN)

% Choose default command line output for mStat_ConfluencesAnalyzer
handles.output = hObject;
set_enable(handles,'init')

set(handles.figure1,'Name',['MStaT: Confluences Analizer '], ...
    'DockControls','off')


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mStat_ConfluencesAnalyzer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mStat_ConfluencesAnalyzer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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


% --------------------------------------------------------------------
function export_Callback(hObject, eventdata, handles)
% empty


% --------------------------------------------------------------------
function matfiles_Callback(hObject, eventdata, handles)
% hObject    handle to matfiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function htmlfile_Callback(hObject, eventdata, handles)
% hObject    handle to htmlfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function excelfile_Callback(hObject, eventdata, handles)
% hObject    handle to excelfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initial Panel

%Read data
% --- Executes on button press in mainchannel.
function mainchannel_Callback(hObject, eventdata, handles)

%read file
[handles.Filemain,handles.Path,indx] = uigetfile({'*.txt';'*.kml';'*.xlsx'},...
    'Select Input File', 'MultiSelect','off');

handles.celltable=cell(1,2);

handles.celltable(1,2)={''};


File=fullfile(handles.Path,handles.Filemain);

if handles.Filemain==0     

    else

    if indx==1
        %read ASCII file
        handles.xyCl=importdata(File);
        handles.xCoordMain = handles.xyCl(:,1);
        handles.yCoordMain = handles.xyCl(:,2);
        guidata(hObject,handles)
    elseif indx==2
        %read .kml file
        kmlStruct = kml2struct(File);
        %project kml in utm system
        [handles.xCoordMain, handles.yCoordMain,~] = deg2utm(kmlStruct.Lat,kmlStruct.Lon);
        guidata(hObject,handles)

    elseif indx==3
        %read .xlsx
        Ex=xlsread(File);
        handles.xCoordMain = Ex(:,1);
        handles.yCoordMain = Ex(:,2);
        guidata(hObject,handles) 

    end
    
     handles.celltable(1,1)={handles.Filemain};


    set(handles.inputtable,'Data',handles.celltable)
    guidata(hObject,handles)
    set_enable(handles,'loadfiles')
    set(handles.tributarychannel,'Enable','on');
end
    



% --- Executes on button press in tributarychannel.
function tributarychannel_Callback(hObject, eventdata, handles)
%read file
[handles.FileTributary,handles.Path,indx] = uigetfile({'*.txt';'*.kml';'*.xlsx'},...
    'Select Input File', 'MultiSelect','on');


% for i=1:length(handles.Filekml)
File=fullfile(handles.Path,handles.FileTributary);

if iscell(handles.FileTributary)
    handles.numfile=size(handles.FileTributary,2);
else
    handles.numfile=1;
end

    guidata(hObject,handles)

if iscell(handles.FileTributary) %read multy files

    if indx==1
        %read ASCII file
        for i=1:handles.numfile
        handles.xyCl{i}=importdata(File{i});
        handles.xCoordTri{i} = handles.xyCl{i}(:,1);
        handles.yCoordTri{i} = handles.xyCl{i}(:,2);     
        handles.celltable(i+1,1)={handles.FileTributary{i}};
        guidata(hObject,handles)
        end
    elseif indx==2
        for i=1:handles.numfile
        kmlStruct{i} = kml2struct(File{i});
        handles.celltable(i+1,1)={handles.FileTributary{i}};

        %project kml in utm system
        [handles.xCoordTri{i}, handles.yCoordTri{i},~] = deg2utm(kmlStruct{i}.Lat,kmlStruct{i}.Lon);   
        guidata(hObject,handles)
        end
    elseif indx==3
        for i=1:handles.numfile
        %read .xlsx
        Ex{i}=xlsread(File{i});
        handles.xCoordTri{i} = Ex{i}(:,1);
        handles.yCoordTri{i} = Ex{i}(:,2);
        handles.celltable(i+1,1)={handles.FileTributary{i}};
        guidata(hObject,handles)
        end
    end
    else %read one tributary file
        i=1;
        if indx==1
            %read ASCII file
            handles.xyCl{i}=importdata(File);
            handles.xCoordTri{i} = handles.xyCl{i}(:,1);
            handles.yCoordTri{i} = handles.xyCl{i}(:,2);     
            handles.celltable(i+1,1)={handles.FileTributary};
            guidata(hObject,handles)

        elseif indx==2
            %Read kml file
            kmlStruct{i} = kml2struct(File);
            handles.celltable(2,1)={handles.FileTributary};
            %project kml in utm system
            [handles.xCoordTri{i}, handles.yCoordTri{i},~] = deg2utm(kmlStruct{i}.Lat,kmlStruct{i}.Lon);   
            guidata(hObject,handles)

    elseif indx==3

            %read .xlsx
            Ex{i}=xlsread(File);
            handles.xCoordTri{i} = Ex{i}(:,1);
            handles.yCoordTri{i} = Ex{i}(:,2);
            handles.celltable(2,1)={handles.FileTributary};
            guidata(hObject,handles)
        end
        
    end    
    
    set(handles.inputtable,'Data',handles.celltable)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Push button Calculate

% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
%%

tableData = get(handles.inputtable, 'data');

if size(tableData,1)==1
    warndlg('You need incorporate Tributaries Channels')
else
    %Calculate
    sel=2;%Toolbox inflection points
    handles.bendSelect=[];
    Tools=3;
    % Main
    widthMain=str2double(cell2mat(tableData(1,2)));
    [Main]=mStat_planar(handles.xCoordMain,handles.yCoordMain,widthMain,sel,handles.pictureReach,handles.bendSelect,Tools);

    % %Tributary
    for i=1:handles.numfile
     widthTri{i}=str2double(cell2mat(tableData(1+i,2)));
     [Tri{i}]=mStat_planar(handles.xCoordTri{i},handles.yCoordTri{i},widthTri{i},sel,handles.pictureReach,handles.bendSelect,Tools);
    end

    %save data
    handles.Main=Main;
    handles.Tri=Tri;
    guidata(hObject,handles)

    if iscell(handles.FileTributary) %read multy files
    for t=1:handles.numfile+1
        if t==1
            geovar{1}=Main;
        else
            geovar{t}=Tri{t-1};
        end
    end
    else
            geovar{1}=Main;
            geovar{2}=Tri{1};
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Obtain data to incorporate the 
    
    %relation BT/BM
    for t=1:handles.numfile
        BTdivBM(t)=widthTri{t}./widthMain;
        handles.celltable1(t,1)={BTdivBM(t)};
    end
    
    %Lambdas relations
    for t=1:handles.numfile
        lambdaTdivlambdaM(t)=nanmean(Tri{t}.wavelengthOfBends)./nanmean(Main.wavelengthOfBends);
        handles.celltable1(t,2)={lambdaTdivlambdaM(t)};
    end
    
    %Amplitude relations
    for t=1:handles.numfile
        AmplitudeTdivAmplitudeM(t)=nanmean(Tri{t}.amplitudeOfBends)./nanmean(Main.amplitudeOfBends);
        handles.celltable1(t,3)={AmplitudeTdivAmplitudeM(t)};
    end


    set(handles.uitableResults,'Data',handles.celltable1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Wavelet analyzes
    %go to wavelet analyzer
    %%Plotting
    SIGLVL=0.95;
    sel=2;
    filter=0;
    axest=[handles.wavel_axes];
    Tools=3;%Confluences

    vars=[];

    mStat_plotWavel(geovar{1},sel,SIGLVL,filter,axest,Tools,vars)
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Determinate the intersection o point close
[Conf]=mStat_ConfluencesInfluences(geovar);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %plot reach
    axes(handles.pictureReach)
    plot(geovar{1}.equallySpacedX,geovar{1}.equallySpacedY,'-k')%Main
    hold on %Tributaries
    
    if iscell(handles.FileTributary) %read multy files
    for t=1:handles.numfile
    plot(geovar{1+t}.equallySpacedX,geovar{1+t}.equallySpacedY,'-r')
    plot(Conf.XINT{1+t},Conf.YINT{1+t},'or')%Main
    %Graph cicle
    th = 0:pi/50:2.01*pi;
    xunit = Conf.R(t) * cos(th) + Conf.XINT{1+t};
    yunit = Conf.R(t) * sin(th) + Conf.XINT{1+t};
    plot(xunit, yunit,'-b','Linewidth',2);
    end
    else
    plot(geovar{2}.equallySpacedX,geovar{2}.equallySpacedY,'-r')
    plot(Conf.XINT{2},Conf.YINT{2},'or')%Main
    %Graph cicle
    th = 0:pi/50:2.01*pi;
    xunit = Conf.R(1) * cos(th) + Conf.XINT{2};
    yunit = Conf.R(1) * sin(th) + Conf.YINT{2};
    plot(xunit, yunit,'-b','Linewidth',2);
    end
    grid on
    legend('Main Channel','Tributaries Channels','Influences','Location','Best')
    xlabel('X');ylabel('Y')
    axis equal
    hold off
    
    %plot acces wavelet
    
        %Wavelet analyzes
    %go to wavelet analyzer
    %%Plotting
    SIGLVL=0.95;
    sel=2;
    filter=0;
    axest=[handles.wavel_axes];
    Tools=3;%Confluences

    vars=Conf;

    mStat_plotWavel(geovar{1},sel,SIGLVL,filter,axest,Tools,vars)
    
    
%     axes(handles.wavel_axes)
%     hold on
%     for q=1:length(Conf.Rintrinsec)
%         if q==1
%             line([Conf.Xgraph(2)  Conf.Rintrinsec(q)],...
%                 log2([0 131072]), 'color', 'r', 'LineWidth',2);
%         else
%             line([Conf.Rintrinsec(q-1)  Conf.Rintrinsec(q)],...
%                 log2([0 131072]), 'color', 'r', 'LineWidth',2);
%         end
%     end
end

set_enable(handles,'results')



function rm_Callback(hObject, eventdata, handles)
% empty


% --- Executes during object creation, after setting all properties.
function rm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

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
    set(handles.uitableResults, 'Data', cell(size(get(handles.uitableResults,'Data'))));
    set(findall(handles.resultspanel, '-property', 'enable'), 'enable', 'off')
    
    
    case 'loadfiles'
    set(handles.calculate,'Enable','on');
    
    case 'results'
    set(findall(handles.resultspanel, '-property', 'enable'), 'enable', 'on')
    otherwise
end


%%Log Window
% --- Executes on selection change in logwindow.
function logwindow_Callback(hObject, eventdata, handles)
% hObject    handle to logwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns logwindow contents as cell array
%        contents{get(hObject,'Value')} returns selected item from logwindow


% --- Executes during object creation, after setting all properties.
function logwindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to logwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
