function varargout = mStat_Waveletexport(varargin)
% MSTAT_WAVELETEXPORT MATLAB code for mStat_Waveletexport.fig
%      MSTAT_WAVELETEXPORT, by itself, creates a new MSTAT_WAVELETEXPORT or raises the existing
%      singleton*.
%
%      H = MSTAT_WAVELETEXPORT returns the handle to a new MSTAT_WAVELETEXPORT or the handle to
%      the existing singleton*.
%
%      MSTAT_WAVELETEXPORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MSTAT_WAVELETEXPORT.M with the given input arguments.
%
%      MSTAT_WAVELETEXPORT('Property','Value',...) creates a new MSTAT_WAVELETEXPORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mStat_Waveletexport_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mStat_Waveletexport_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mStat_Waveletexport

% Last Modified by GUIDE v2.5 05-Apr-2016 15:49:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mStat_Waveletexport_OpeningFcn, ...
                   'gui_OutputFcn',  @mStat_Waveletexport_OutputFcn, ...
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


% --- Executes just before mStat_Waveletexport is made visible.
function mStat_Waveletexport_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mStat_Waveletexport (see VARARGIN)

% Choose default command line output for mStat_Waveletexport
handles.output = hObject;

handles.axest=varargin{1};
guidata(hObject, handles);

set(handles.figure1,'Name',['MStaT: Export Figures'],'DockControls','off')

% UIWAIT makes mStat_Waveletexport wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mStat_Waveletexport_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in exportFig.
function exportFig_Callback(hObject, eventdata, handles)
% hObject    handle to exportFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns exportFig contents as cell array
%        contents{get(hObject,'Value')} returns selected item from exportFig


% --- Executes during object creation, after setting all properties.
function exportFig_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exportFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbuttonexport.
function pushbuttonexport_Callback(hObject, eventdata, handles,varargin)

figuresel=get(handles.exportFig,'Value');

switch figuresel
    case 1
        h=figure('Name','MStaT: Signature of the channel angle','NumberTitle','off');
        set(h, 'Position', [10 10 800 400])
        AxesH = handles.axest(1);
        fig=copyobj(AxesH,h);
    set(fig,'Units', 'normalized', 'Position', [.1 .11 .85 .8]);
    
    case 2
        h=figure('Name','MStaT: Signature of the channel curvature','NumberTitle','off');
        set(h, 'Position', [10 10 800 400])
        AxesH = handles.axest(1);
        fig=copyobj(AxesH,h);
        set(fig,'Units', 'normalized', 'Position', [.1 .11 .85 .8]);
    
    case 3
        h=figure('Name','MStaT: Significance','NumberTitle','off');
        set(h, 'Position', [10 10 800 400])
        AxesH = handles.axest(2);
        fig=copyobj(AxesH,h);
        cc=colorbar;
        colormap('jet');
%          hcol=findobj(h,'Type','Colorbar');
%         copyobj(hcol,fig); %copy to figure 2
        
    set(fig,'Units', 'normalized', 'Position', [.12 .12 .8 .8]);
    
    case 4
        h=figure('Name','MStaT: River centerline','NumberTitle','off');
        set(h, 'Position', [10 10 800 400])
        AxesH = handles.axest(3);
        fig=copyobj(AxesH,h);
    set(fig,'Units', 'normalized', 'Position', [.1 .1 .85 .8]);
    case 5
        h=figure('Name','MStaT: Global Wavelet Spectrum','NumberTitle','off');
        set(h, 'Position', [10 10 800 400])
        AxesH = handles.axest(4);
        fig=copyobj(AxesH,h);
    set(fig,'Units', 'normalized', 'Position', [.13 .13 .83 .8]);
end
%figure1_CloseRequestFcn(hObject, eventdata, handles)

%delete(hObject)
 %close hidden 
 

% hObject    handle to pushbuttonexport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
%delete(hObject)
%close all hidden
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
