function varargout = mStat_AdvancedSetting(varargin)
% MSTAT_ADVANCEDSETTING MATLAB code for mStat_AdvancedSetting.fig
%      MSTAT_ADVANCEDSETTING, by itself, creates a new MSTAT_ADVANCEDSETTING or raises the existing
%      singleton*.
%
%      H = MSTAT_ADVANCEDSETTING returns the handle to a new MSTAT_ADVANCEDSETTING or the handle to
%      the existing singleton*.
%
%      MSTAT_ADVANCEDSETTING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MSTAT_ADVANCEDSETTING.M with the given input arguments.
%
%      MSTAT_ADVANCEDSETTING('Property','Value',...) creates a new MSTAT_ADVANCEDSETTING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mStat_AdvancedSetting_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mStat_AdvancedSetting_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mStat_AdvancedSetting

% Last Modified by GUIDE v2.5 18-Jul-2019 20:10:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mStat_AdvancedSetting_OpeningFcn, ...
                   'gui_OutputFcn',  @mStat_AdvancedSetting_OutputFcn, ...
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


% --- Executes just before mStat_AdvancedSetting is made visible.
function mStat_AdvancedSetting_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mStat_AdvancedSetting (see VARARGIN)

% Choose default command line output for mStat_AdvancedSetting
handles.output = hObject;

% Set the name and version
set(handles.figure1,'Name',['MStaT: Advanced Setting'], ...
    'DockControls','off')

handles.ChannelSel=varargin{1};

% Update handles structure
guidata(hObject, handles);

ReadVar=getappdata(0, 'ReadVar');
AdvancedSet=getappdata(0, 'AdvancedSet');

%General Paranameters
%Write
set(handles.width,'String',ReadVar{handles.ChannelSel}.width)
set(handles.level,'String',ReadVar{handles.ChannelSel}.Level)

%Curvature Parameters
%Write
set(handles.polyorder,'String',AdvancedSet{handles.ChannelSel}.polyOrder)
set(handles.smooth,'String',AdvancedSet{handles.ChannelSel}.nTimesToSmooth)
set(handles.window,'String',AdvancedSet{handles.ChannelSel}.nPointsInWindow)
set(handles.reachpoints,'String',AdvancedSet{handles.ChannelSel}.nReachPoints)

%Get equally data
[~, equallySpacedX, equallySpacedY, ...
   ~, ~] =...
    mStat_getxyResampled(ReadVar{handles.ChannelSel}.xCoord,ReadVar{handles.ChannelSel}.yCoord,...
    ReadVar{handles.ChannelSel}.width,AdvancedSet{handles.ChannelSel});

%Plot initial configuration
axes(handles.previewpicture)

%plot original data
grid on
plot(ReadVar{handles.ChannelSel}.xCoord,ReadVar{handles.ChannelSel}.yCoord,'-k')
hold on
plot(equallySpacedX,equallySpacedY,'-r')
xlabel('X [m]');
ylabel('Y [m]');
axis equal
legend('Original Data','MStaT Smoothing Data')
hold off



% --- Outputs from this function are returned to the command line.
function varargout = mStat_AdvancedSetting_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function polyorder_Callback(hObject, eventdata, handles)
% hObject    handle to polyorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of polyorder as text
%        str2double(get(hObject,'String')) returns contents of polyorder as a double


% --- Executes during object creation, after setting all properties.
function polyorder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to polyorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function smooth_Callback(hObject, eventdata, handles)
% hObject    handle to smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smooth as text
%        str2double(get(hObject,'String')) returns contents of smooth as a double


% --- Executes during object creation, after setting all properties.
function smooth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function window_Callback(hObject, eventdata, handles)
% hObject    handle to window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of window as text
%        str2double(get(hObject,'String')) returns contents of window as a double


% --- Executes during object creation, after setting all properties.
function window_CreateFcn(hObject, eventdata, handles)
% hObject    handle to window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function reachpoints_Callback(hObject, eventdata, handles)
% hObject    handle to reachpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of reachpoints as text
%        str2double(get(hObject,'String')) returns contents of reachpoints as a double


% --- Executes during object creation, after setting all properties.
function reachpoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reachpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in previewandsave.
function previewandsave_Callback(hObject, eventdata, handles)
ReadVar=getappdata(0, 'ReadVar');
AdvancedSet=getappdata(0, 'AdvancedSet');

%General Paranameters
%Read
ReadVar{handles.ChannelSel}.width=str2num(get(handles.width,'String'));
ReadVar{handles.ChannelSel}.Level=str2num(get(handles.level,'String'));

%Curvature Parameters
%Read
AdvancedSet{handles.ChannelSel}.polyOrder=str2num(get(handles.polyorder,'String'));
AdvancedSet{handles.ChannelSel}.nTimesToSmooth=str2num(get(handles.smooth,'String'));
AdvancedSet{handles.ChannelSel}.nPointsInWindow=str2num(get(handles.window,'String'));
AdvancedSet{handles.ChannelSel}.nReachPoints=str2num(get(handles.reachpoints,'String'));


%Get equally data
[~, equallySpacedX, equallySpacedY, ...
   ~, ~] =...
    mStat_getxyResampled(ReadVar{handles.ChannelSel}.xCoord,ReadVar{handles.ChannelSel}.yCoord,...
    ReadVar{handles.ChannelSel}.width,AdvancedSet{handles.ChannelSel});

%Plot initial configuration
axes(handles.previewpicture)

%plot original data
grid on
plot(ReadVar{handles.ChannelSel}.xCoord,ReadVar{handles.ChannelSel}.yCoord,'-k')
hold on
plot(equallySpacedX,equallySpacedY,'-r')
axis equal
xlabel('X [m]');
ylabel('Y [m]');
legend('Original Data','MStaT Smoothing Data')
hold off


function width_Callback(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width as text
%        str2double(get(hObject,'String')) returns contents of width as a double


% --- Executes during object creation, after setting all properties.
function width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function level_Callback(hObject, eventdata, handles)
% hObject    handle to level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of level as text
%        str2double(get(hObject,'String')) returns contents of level as a double


% --- Executes during object creation, after setting all properties.
function level_CreateFcn(hObject, eventdata, handles)
% hObject    handle to level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in savedata.
function savedata_Callback(hObject, eventdata, handles)
%Read all Data
ReadVar=getappdata(0, 'ReadVar');
AdvancedSet=getappdata(0, 'AdvancedSet');

%General Paranameters
%Read
ReadVar{handles.ChannelSel}.width=str2num(get(handles.width,'String'));
ReadVar{handles.ChannelSel}.Level=str2num(get(handles.level,'String'));

%Curvature Parameters
%Read
AdvancedSet{handles.ChannelSel}.polyOrder=str2num(get(handles.polyorder,'String'));
AdvancedSet{handles.ChannelSel}.nTimesToSmooth=str2num(get(handles.smooth,'String'));
AdvancedSet{handles.ChannelSel}.nPointsInWindow=str2num(get(handles.window,'String'));
AdvancedSet{handles.ChannelSel}.nReachPoints=str2num(get(handles.reachpoints,'String'));

%Store Data
setappdata(0, 'ReadVar',ReadVar);
setappdata(0, 'AdvancedSet',AdvancedSet);


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function close_Callback(hObject, eventdata, handles)
close
