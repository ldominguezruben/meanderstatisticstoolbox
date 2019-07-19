function varargout = mStat_BraidingModule(varargin)
% MSTAT_BRAIDINGMODULE MATLAB code for mStat_BraidingModule.fig
%      MSTAT_BRAIDINGMODULE, by itself, creates a new MSTAT_BRAIDINGMODULE or raises the existing
%      singleton*.
%
%      H = MSTAT_BRAIDINGMODULE returns the handle to a new MSTAT_BRAIDINGMODULE or the handle to
%      the existing singleton*.
%
%      MSTAT_BRAIDINGMODULE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MSTAT_BRAIDINGMODULE.M with the given input arguments.
%
%      MSTAT_BRAIDINGMODULE('Property','Value',...) creates a new MSTAT_BRAIDINGMODULE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mStat_BraidingModule_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mStat_BraidingModule_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mStat_BraidingModule

% Last Modified by GUIDE v2.5 19-Jul-2019 16:53:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mStat_BraidingModule_OpeningFcn, ...
                   'gui_OutputFcn',  @mStat_BraidingModule_OutputFcn, ...
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


% --- Executes just before mStat_BraidingModule is made visible.
function mStat_BraidingModule_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mStat_BraidingModule (see VARARGIN)

set(handles.figure1,'Name',['MStaT: Braiding Module '], ...
    'DockControls','off')

% Choose default command line output for mStat_BraidingModule
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

axes(handles.braiding_axes)
grid on

axes(handles.sinuosityandbraiding_axes)
grid on


% --- Outputs from this function are returned to the command line.
function varargout = mStat_BraidingModule_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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


% --- Executes on button press in readmainchannel.
function readmainchannel_Callback(hObject, eventdata, handles)
%This function incorporate the initial data input
multisel='off';

persistent lastPath 
% If this is the first time running the function this session,
% Initialize lastPath to 0
if isempty(lastPath) 
    lastPath = 0;
end

if lastPath == 0
    [File,Path] = uigetfile({'*.kml;*.txt;*.xls;*.xlsx',...
    'MStaT Files (*.kml,*.txt,*.xls,*.xlsx)';'*.*',  'All Files (*.*)'},'Select Input File','MultiSelect',multisel);
else %remember the lastpath
    [File,Path] = uigetfile({'*.kml;*.txt;*.xls;*.xlsx',...
    'MStaT Files (*.kml,*.txt,*.xls,*.xlsx)';'*.*',  'All Files (*.*)'},'Select Input File','MultiSelect',multisel,lastPath);
end

%[ReadVar]=mStat_ReadInputFiles(multisel,lastPath);

% Use the path to the last selected file
% If 'uigetfile' is called, but no item is selected, 'lastPath' is not overwritten with 0
if Path ~= 0
    lastPath = Path;
end

if Path==0
    %empty file
else
    if iscell(File)%multifile
        handles.numfile=size(File,2); 
    else
        handles.numfile=1;
    end
    
    %Write file readed in multiselect tool
    mStat_AddXYData(File,Path,handles.pictureReach,handles.bendSelect);

    %Write in popupChannel
     str{1,1}=['Select Channel'];
     if handles.numfile==1
         str{2,1}=File;
     else
        for i=1:handles.numfile
            str{i+1,1}=File{i};
        end
     end
     
     set(handles.popupChannel, 'String', str,'Enable','on');
                                     
end 


function mainchannel_Callback(hObject, eventdata, handles)
% hObject    handle to mainchannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mainchannel as text
%        str2double(get(hObject,'String')) returns contents of mainchannel as a double


% --- Executes during object creation, after setting all properties.
function mainchannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mainchannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in readsecondarychannel.
function readsecondarychannel_Callback(hObject, eventdata, handles)
%This function incorporate the initial data input
multisel='on';

persistent lastPath 
% If this is the first time running the function this session,
% Initialize lastPath to 0
if isempty(lastPath) 
    lastPath = 0;
end

if lastPath == 0
    [File,Path] = uigetfile({'*.kml;*.txt;*.xls;*.xlsx',...
    'MStaT Files (*.kml,*.txt,*.xls,*.xlsx)';'*.*',  'All Files (*.*)'},'Select Input File','MultiSelect',multisel);
else %remember the lastpath
    [File,Path] = uigetfile({'*.kml;*.txt;*.xls;*.xlsx',...
    'MStaT Files (*.kml,*.txt,*.xls,*.xlsx)';'*.*',  'All Files (*.*)'},'Select Input File','MultiSelect',multisel,lastPath);
end

%[ReadVar]=mStat_ReadInputFiles(multisel,lastPath);

% Use the path to the last selected file
% If 'uigetfile' is called, but no item is selected, 'lastPath' is not overwritten with 0
if Path ~= 0
    lastPath = Path;
end

if Path==0
    %empty file
else
    if iscell(File)%multifile
        handles.numfile=size(File,2); 
    else
        handles.numfile=1;
    end
    
    %Write file readed in multiselect tool
    mStat_AddXYData(File,Path,handles.pictureReach,handles.bendSelect);

    %Write in popupChannel
     str{1,1}=['Select Channel'];
     if handles.numfile==1
         str{2,1}=File;
     else
        for i=1:handles.numfile
            str{i+1,1}=File{i};
        end
     end
     
     set(handles.popupChannel, 'String', str,'Enable','on');
                                     
end 



function secondarychannel_Callback(hObject, eventdata, handles)
% hObject    handle to secondarychannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of secondarychannel as text
%        str2double(get(hObject,'String')) returns contents of secondarychannel as a double


% --- Executes during object creation, after setting all properties.
function secondarychannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to secondarychannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function widthmain_Callback(hObject, eventdata, handles)
% hObject    handle to widthmain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of widthmain as text
%        str2double(get(hObject,'String')) returns contents of widthmain as a double


% --- Executes during object creation, after setting all properties.
function widthmain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to widthmain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
