function varargout = mStat_AddXYData(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------------MEANDER STATISTICS TOOLBOX. MStaT------------------------
% This function read multi files and processes all data.

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mStat_AddXYData_OpeningFcn, ...
                   'gui_OutputFcn',  @mStat_AddXYData_OutputFcn, ...
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


% --- Executes just before mStat_AddXYData is made visible.
function mStat_AddXYData_OpeningFcn(hObject, eventdata, handles, varargin)

% This function has no output args, see OutputFcn.
% Set the name and version
set(handles.figure1,'Name',['MStaT: Input Data'], ...
    'DockControls','off')

% Choose default command line output for mStat_AddXYData
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%Write info in inputtable 
if iscell(varargin{1,1})%multifile
    handles.numfile=size(varargin{1,1},2); 
    filetable(:,1)=varargin{1,1}';
    filetable(1:handles.numfile,2)={''};
    set(handles.inputtable,'Data',filetable) 
else%onefile
    handles.numfile=1;
    filetable(1,1)={varargin{1,1}};
    filetable(1,2)={''};
    set(handles.inputtable,'Data',filetable)  
end

handles.File=varargin(:,1);
handles.Path=varargin(:,2);
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = mStat_AddXYData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in addfiles.
function addfiles_Callback(hObject, eventdata, handles)

multisel='on';

[File,Path] = uigetfile({'*.kml;*.txt;*.xls;*.xlsx',...
'MStaT Files (*.kml,*.txt,*.xls,*.xlsx)';'*.*',  'All Files (*.*)'},...
'Select Input File','MultiSelect',multisel,handles.Path{1});

if ischar(File)%empty file
    
    FileName=[handles.File{1} File];
    
    PathName=[handles.Path{1} Path];
    
    handles.File{1}=FileName;
    handles.Path=PathName;
    handles.numfile=handles.numfile+size(File,2);
    filetable(:,1)=handles.File{1}';
    filetable(1:handles.numfile,2)={''};
    guidata(hObject,handles)
    
    set(handles.inputtable,'Data',filetable)
end
    
% --- Executes on button press in quitfiles.
function quitfiles_Callback(hObject, eventdata, handles)
%This function quit files readed
if handles.quitfile==0
    warndlg('Please select the file that you can delete')
else
    
    handles.File{1}(handles.quitfile)=[];
    
    handles.numfile=handles.numfile-1;
    filetable(:,1)=handles.File{1}';
    filetable(1:handles.numfile,2)={''};
    
    guidata(hObject,handles)
    
    set(handles.inputtable,'Data',filetable)
end

% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles,varargout)

sel=1;%

Tools=1;%Geometric parameters Module

%Read width data
TableFile=get(handles.inputtable,'Data');

handles.width=TableFile(:,2);

handles.CS=get(handles.coordinatesystem,'Value');

[Control]=control(handles);

if Control==1
    for i=1:handles.numfile

        if handles.numfile==1%onefile
            [ReadVar{i}]=mStat_ReadInputFiles(handles.File,handles.Path);
            ReadVar{i}.File=handles.File{1};
        else%multifiles
            [ReadVar{i}]=mStat_ReadInputFiles(handles.File{1}(i),handles.Path);
            ReadVar{i}.File=handles.File{1}(i);
        end
        
        ReadVar{i}.Level=5;%Decomposition level default
        %      General parameters to get equally spaced data.
        AdvancedSet{i}.nTimesToSmooth = 3;  
        AdvancedSet{i}.polyOrder = 3;% equivalent to "order" in "curvature" function.
        AdvancedSet{i}.nPointsInWindow = 7;%  equivalent to "window" in "curvature" function.
        AdvancedSet{i}.nReachPoints = 1500; % 1500 150 equivalent to "nDiscr" in "curvature" function 
                 %  in the banks: 1500 works well in most of the cases.
            
        ReadVar{i}.width=str2double(cellstr(handles.width(i)));
        ReadVar{i}.Path=handles.Path;
        ReadVar{i}.CS=handles.CS;
        
        if handles.CS==2
            %project kml in utm system
            [ReadVar{i}.xCoord, ReadVar{i}.yCoord,ReadVar{i}.utmzone] =...
                deg2utm(ReadVar{i}.xCoord,ReadVar{i}.yCoord);
        end
        
        %Calculate and plot planar variables
        [geovar{i}]=mStat_planar(ReadVar{i}.xCoord,ReadVar{i}.yCoord,ReadVar{i}.width,ReadVar{i}.File,...
            sel,Tools,ReadVar{i}.Level,AdvancedSet{i});
    end

%Store data file
setappdata(0, 'ReadVar', ReadVar);
setappdata(0, 'geovar', geovar);
setappdata(0, 'AdvancedSet', AdvancedSet);

guidata(hObject,handles)

close
end


% --- Executes on selection change in coordinatesystem.
function coordinatesystem_Callback(hObject, eventdata, handles)
% hObject    handle to coordinatesystem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns coordinatesystem contents as cell array
%        contents{get(hObject,'Value')} returns selected item from coordinatesystem


% --- Executes during object creation, after setting all properties.
function coordinatesystem_CreateFcn(hObject, eventdata, handles)
% hObject    handle to coordinatesystem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected cell(s) is changed in inputtable.
function inputtable_CellSelectionCallback(hObject, eventdata, handles)
% Define the row number selected
handles.quitfile=eventdata.Indices(:,1);
guidata(hObject,handles)

function [Control]=control(handles)
Control=1;

%This function control all input data is complete
if handles.CS==1
    warndlg('Please select a Coordinate System')
    Control=0;
end

%control width inputs
if  nansum(isfinite(str2double(handles.width)))==handles.numfile
    
else
    warndlg('Please input all channels width')
    Control=0;
end


% --- Executes on selection change in popupXData.
function popupXData_Callback(hObject, eventdata, handles)
% hObject    handle to popupXData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupXData contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupXData


% --- Executes during object creation, after setting all properties.
function popupXData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupXData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupYData.
function popupYData_Callback(hObject, eventdata, handles)
% hObject    handle to popupYData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupYData contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupYData


% --- Executes during object creation, after setting all properties.
function popupYData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupYData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
