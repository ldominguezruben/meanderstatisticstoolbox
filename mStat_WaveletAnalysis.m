function varargout = mStat_WaveletAnalysis(varargin)
%MStaT mStat_WaveletAnalysis function determinate and graphs the wavelet
%analyzes

% Last Modified by GUIDE v2.5 20-Nov-2018 16:32:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mStat_WaveletAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @mStat_WaveletAnalysis_OutputFcn, ...
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

%--------------------------------------------------------------------------

% --- Executes just before mStat_WaveletAnalysis is made visible.
function mStat_WaveletAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for mStat_WaveletAnalysis
handles.output = hObject;
%       Update GUI data.
guidata(hObject, handles);

set(handles.figure1,'Name',['MStaT: Wavelet Analysis '], ...
    'DockControls','off')

%data cursor
dcm_obj = datacursormode(gcf);

set(dcm_obj,'UpdateFcn',@mStat_myupdatefcnWaveletAnalysis);

set(dcm_obj,'Displaystyle','Window','Enable','on');

%selector de angulo o curvatura
sel=1;

%significancia
SIGLVL=0.95;

handles.geovar=varargin{1};
handles.filter=0; 
handles.axest=[handles.curveandangle_axes handles.wavel_axes handles.centerline_axes handles.power_axes];
guidata(hObject, handles);

Tools=1;

vars=[];

%this function go to plt function
mStat_plotWavel(varargin{1},sel,SIGLVL,handles.filter,handles.axest,Tools,vars)

%      End bend selection section.  
%--------------------------------------------------------------------------
% --- Outputs from this function are returned to the command line.
function varargout = mStat_WaveletAnalysis_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


function figure1_CreateFcn(hObject, eventdata, handles)
% Empty


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
%Empty


% --------------------------------------------------------------------
function close_Callback(hObject, eventdata, handles)
close

% --- Executes during object creation, after setting all properties.
function wavelet_axes_CreateFcn(hObject, eventdata, handles)
% Empty


% --- Executes during object deletion, before destroying properties.
function wavelet_axes_DeleteFcn(hObject, eventdata, handles)
% Empty


% --- Executes on mouse press over axes background.
function centerline_plot_ButtonDownFcn(hObject, eventdata, handles)
% Empty


% --- Executes during object creation, after setting all properties.
function centerline_plot_CreateFcn(hObject, eventdata, handles)
% Empty


% --- Executes on selection change in bendNumbers.
function bendNumbers_Callback(hObject, eventdata, handles)
% Empty


% --- Executes during object creation, after setting all properties.
function bendNumbers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bendNumbers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in select.
function select_Callback(hObject, eventdata, handles)
% Empty

% --------------------------------------------------------------------
function exportfigure_Callback(hObject, eventdata, handles)
% Empty

% --------------------------------------------------------------------
function exportFIG_Callback(hObject, eventdata, handles)

handles.getexport = mStat_Waveletexport(handles.axest);
uiresume(gcbf);



% --- Executes during object creation, after setting all properties.

function significance_Callback(hObject, eventdata, handles)
% Empty


% --- Executes during object creation, after setting all properties.
function significance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to significance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calculatesignificance.
function calculatesignificance_Callback(hObject, eventdata, handles)

 significance=get(handles.significance,'String');
 if isempty(significance)
    SIGLVL=0.95;
else
 SIGLVL=str2num(significance)/100;
 end
 

 sel=get(handles.selector1,'Value');
 
 Tools=1;

vars=[];

mStat_plotWavel(handles.geovar,sel,SIGLVL,handles.filter,handles.axest,Tools,vars)


% --- Executes on selection change in selector1.
function selector1_Callback(hObject, eventdata, handles)
 
significance=get(handles.significance,'String');

if isempty(significance)
    SIGLVL=0.95;
else
 SIGLVL=str2num(significance)/100;
end
 
 sel=get(handles.selector1,'Value');
 
Tools=1;

vars=[];

mStat_plotWavel(handles.geovar,sel,SIGLVL,handles.filter,handles.axest,Tools,vars)


% --- Executes during object creation, after setting all properties.
function selector1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selector1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mincurvature_Callback(hObject, eventdata, handles)
% Empty


% --- Executes during object creation, after setting all properties.
function mincurvature_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mincurvature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% function edit3_Callback(hObject, eventdata, handles)
% % Empty
% 
% 
% % --- Executes during object creation, after setting all properties.
% function edit3_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to edit3 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% 
% 
% 
% function edit4_Callback(hObject, eventdata, handles)
% % Empty
% 
% 
% % --- Executes during object creation, after setting all properties.
% function edit4_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to edit4 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% 
% 
% 
% function edit5_Callback(hObject, eventdata, handles)
% % Empty
% 
% 
% % --- Executes during object creation, after setting all properties.
% function edit5_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to edit5 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end


% --------------------------------------------------------------------
function savefigure_ClickedCallback(hObject, eventdata, handles)
%Save figures
handles.save=mStat_Waveletexport;


% --------------------------------------------------------------------
function clearfigure_ClickedCallback(hObject, eventdata, handles)
mStat_plotWavel


% --- Executes on button press in filterarc.
function filterarc_Callback(hObject, eventdata, handles)
% Empty

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% Empty

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in filter.
function filter_Callback(hObject, eventdata, handles)
    %Read input variables
riverName = getappdata(0, 'riverName');
guidata(hObject, handles);

handles.filter=1;
guidata(hObject,handles)

x = newid({'Min Arc-Wavelength','Max Arc-Wavelength','Min Sinuosity','Max Sinuosity'},...
              'mStat',[1 50;1 50;1 50;1 50],{'0','0','0','0'});
 [handles.minarcwavelength,handles.maxarcwavelength,handles.minsinuosity,handles.maxsinuosity] = x{:};
 
 
 %Apply of Filter
 handles.minarc = str2num(handles.minarcwavelength);
 handles.maxarc = str2num(handles.maxarcwavelength);
 handles.minsin = str2num(handles.minsinuosity);
 handles.maxsin = str2num(handles.maxsinuosity);
 guidata(hObject,handles)
% 

if handles.minarc==handles.maxarc & handles.minsin~=handles.maxsin
inds = +not(abs(sign(sign(handles.minsin - handles.geovar.sinuosityOfBends) + sign(handles.maxsin - handles.geovar.sinuosityOfBends))));

% 
bendwavelength=find(inds==1);

%upload data
handles.bendwavelength = num2str(bendwavelength);
setappdata(0, 'bendwavelength', handles.bendwavelength);
guidata(hObject,handles)

%Apply filter
 handles.filter=1;

% 
% Call the "userSelectBend" function to get the index of intersection
% points and the highlighted bend limits.  
highlightx_arc=nan(length(bendwavelength),200);
highlighty_arc=nan(length(bendwavelength),200);
% 

%Find bends using the Filter
for i=1:length(bendwavelength)
[highlightX, highlightY, indi1] = userSelectBend(handles.geovar.intS, bendwavelength(i),...
    handles.geovar.equallySpacedX,handles.geovar.equallySpacedY,handles.geovar.newInflectionPts,...
    handles.geovar.sResample);
    highlightx_arc(i,1:length(highlightX))=highlightX;
    highlighty_arc(i,1:length(highlightY))=highlightY;
    indi(i,1:2)=indi1(1,1:2);
end


%upload data
handles.highlightx_arc = num2str(highlightx_arc);
setappdata(0, 'highlightx_arc', handles.highlightx_arc);
handles.highlighty_arc = num2str(highlighty_arc);
setappdata(0, 'highlighty_arc', handles.highlighty_arc);
handles.indi = num2str(indi);
setappdata(0, 'indi', handles.indi);
guidata(hObject,handles)



elseif handles.minarc~=handles.maxarc & handles.minsin==handles.maxsin
inds = +not(abs(sign(sign(handles.minarc - handles.geovar.wavelengthOfBends) + sign(handles.maxarc - handles.geovar.wavelengthOfBends))));
    
% 
bendwavelength=find(inds==1);

%upload data
handles.bendwavelength = num2str(bendwavelength);
setappdata(0, 'bendwavelength', handles.bendwavelength);
guidata(hObject,handles)

handles.filter=1;

%Apply Filter 
% Call the "userSelectBend" function to get the index of intersection
% points and the highlighted bend limits.  
highlightx_arc=nan(length(bendwavelength),200);
highlighty_arc=nan(length(bendwavelength),200);
% 

%Find bends using the Filter
for i=1:length(bendwavelength)
[highlightX, highlightY, indi1] = userSelectBend(handles.geovar.intS, bendwavelength(i),...
    handles.geovar.equallySpacedX,handles.geovar.equallySpacedY,handles.geovar.newInflectionPts,...
    handles.geovar.sResample);
    highlightx_arc(i,1:length(highlightX))=highlightX;
    highlighty_arc(i,1:length(highlightY))=highlightY;
    indi(i,1:2)=indi1(1,1:2);
end


%upload data
handles.highlightx_arc = num2str(highlightx_arc);
setappdata(0, 'highlightx_arc', handles.highlightx_arc);
handles.highlighty_arc = num2str(highlighty_arc);
setappdata(0, 'highlighty_arc', handles.highlighty_arc);
handles.indi = num2str(indi);
setappdata(0, 'indi', handles.indi);
guidata(hObject,handles)

elseif handles.minsin~=handles.maxsin & handles.minarc~=handles.maxarc
%Find values between min and max
inds = +not(abs(sign(sign(handles.minarc - handles.geovar.wavelengthOfBends) + sign(handles.maxarc - handles.geovar.wavelengthOfBends))));
inds1 = +not(abs(sign(sign(handles.minsin - handles.geovar.sinuosityOfBends) + sign(handles.maxsin - handles.geovar.sinuosityOfBends))));

    for i=1:length(inds)
        if inds(i)==1 & inds1(i)==1
            d(i)=1;
        else
            d(i)=0;
        end
    end

inds=d';

% 
bendwavelength=find(inds==1);

%upload data
handles.bendwavelength = num2str(bendwavelength);
setappdata(0, 'bendwavelength', handles.bendwavelength);
guidata(hObject,handles)

 handles.filter=1;


% Apply Filter 
% Call the "userSelectBend" function to get the index of intersection
% points and the highlighted bend limits.  
highlightx_arc=nan(length(bendwavelength),200);
highlighty_arc=nan(length(bendwavelength),200);
% 

%Find bends using the Filter
for i=1:length(bendwavelength)
[highlightX, highlightY, indi1] = userSelectBend(handles.geovar.intS, bendwavelength(i),...
    handles.geovar.equallySpacedX,handles.geovar.equallySpacedY,handles.geovar.newInflectionPts,...
    handles.geovar.sResample);
    highlightx_arc(i,1:length(highlightX))=highlightX;
    highlighty_arc(i,1:length(highlightY))=highlightY;
    indi(i,1:2)=indi1(1,1:2);
end


%upload data
handles.highlightx_arc = num2str(highlightx_arc);
setappdata(0, 'highlightx_arc', handles.highlightx_arc);
handles.highlighty_arc = num2str(highlighty_arc);
setappdata(0, 'highlighty_arc', handles.highlighty_arc);
handles.indi = num2str(indi);
setappdata(0, 'indi', handles.indi);
guidata(hObject,handles)


elseif handles.minarc==0 & handles.maxarc==0 & handles.minsin==0 &handles.maxsin==0
    handles.filter=0;
end


%%
%Function to plot
 significance=get(handles.significance,'String');
 if isempty(significance)
    SIGLVL=0.95;
else
 SIGLVL=str2num(significance)/100;
 end

 sel=get(handles.selector1,'Value');
 
Tools=1;

vars=[];

mStat_plotWavel(handles.geovar,sel,SIGLVL,handles.filter,handles.axest,Tools,vars)
