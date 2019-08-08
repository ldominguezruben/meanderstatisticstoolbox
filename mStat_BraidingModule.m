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

% Last Modified by GUIDE v2.5 08-Aug-2019 17:32:10

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

set(handles.calculate,'Enable','off'); 

% Update handles structure
guidata(hObject, handles);

axes(handles.braiding_axes)
grid on



% --- Outputs from this function are returned to the command line.
function varargout = mStat_BraidingModule_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in LogWindow.
function LogWindow_Callback(hObject, eventdata, handles)
% hObject    handle to LogWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LogWindow contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LogWindow


% --- Executes during object creation, after setting all properties.
function LogWindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LogWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function open_Callback(hObject, eventdata, handles)
%empty


% --------------------------------------------------------------------
function single_Callback(hObject, eventdata, handles)
cla 'reset'
%This function incorporate the initial data
handles.multisel = 'on';
handles.Module = 4;%Braiding module
handles.first = 1;
handles.multi=0;
guidata(hObject,handles)

%read file funtion
mStat_ReadInputFiles(handles);


% --------------------------------------------------------------------
function multi_Callback(hObject, eventdata, handles)
cla 'reset'
%This function incorporate the initial data
handles.multisel = 'on';
handles.Module = 4;%Braiding module
handles.first = 1;
handles.multi=1;
guidata(hObject,handles)

%read file funtion
mStat_ReadInputFiles(handles);


% %This function incorporate the initial data input
% multisel='off';
% 
% Module = 4;%braiding Module
% 
% persistent lastPath 
% % If this is the first time running the function this session,
% % Initialize lastPath to 0
% if isempty(lastPath) 
%     lastPath = 0;
% end
% 
% if lastPath == 0
%     [File,Path] = uigetfile({'*.shp;*.kml;*.txt;*.xls;*.xlsx',...
%     'MStaT Files (*.shp,*.kml,*.txt,*.xls,*.xlsx)';'*.*',  'All Files (*.*)'},'Select Input File','MultiSelect',multisel);
% else %remember the lastpath
%     [File,Path] = uigetfile({'*.shp;*.kml;*.txt;*.xls;*.xlsx',...
%     'MStaT Files (*.shp,*.kml,*.txt,*.xls,*.xlsx)';'*.*',  'All Files (*.*)'},'Select Input File','MultiSelect',multisel,lastPath);
% end
% 
% % Use the path to the last selected file
% % If 'uigetfile' is called, but no item is selected, 'lastPath' is not overwritten with 0
% if Path ~= 0
%     lastPath = Path;
% end
% 
% if Path==0
%     %empty file
% else
%     handles.numfile=1;   
%     Primary=1;
%     %Write file readed in multiselect tool
%     mStat_AddXYData(File,Path,Module,Primary);                                 
% end 


% % --- Executes on button press in readsecondary.
% function readsecondary_Callback(hObject, eventdata, handles)
% %This function incorporate the initial data
% handles.multisel = 'on';
% handles.Module = 4;%Braiding module
% handles.main = 0;
% guidata(hObject,handles)
% 
% %read file funtion
% mStat_ReadInputFiles(handles);

% %This function incorporate the initial data input
% multisel='on';
% 
% Module =4; %Braiding module
% persistent lastPath 
% % If this is the first time running the function this session,
% % Initialize lastPath to 0
% if isempty(lastPath) 
%     lastPath = 0;
% end
% 
% if lastPath == 0
%     [File,Path] = uigetfile({'*.shp;*.kml;*.txt;*.xls;*.xlsx',...
%     'MStaT Files (*.shp,*.kml,*.txt,*.xls,*.xlsx)';'*.*',  'All Files (*.*)'},'Select Input File','MultiSelect',multisel);
% else %remember the lastpath
%     [File,Path] = uigetfile({'*.shp;*.kml;*.txt;*.xls;*.xlsx',...
%     'MStaT Files (*.shp,*.kml,*.txt,*.xls,*.xlsx)';'*.*',  'All Files (*.*)'},'Select Input File','MultiSelect',multisel,lastPath);
% end
% 
% % Use the path to the last selected file
% % If 'uigetfile' is called, but no item is selected, 'lastPath' is not overwritten with 0
% if Path ~= 0
%     lastPath = Path;
% end
% 
% if Path==0
%     %empty file
% else
%     if iscell(File)%multifile
%         handles.numfile=size(File,2); 
%     else
%         handles.numfile=1;
%     end
%     Primary=0;
%     %Write file readed in multiselect tool
%     mStat_AddXYData(File,Path,Module,Primary);
%                                           
% end 


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



function subreachlength_Callback(hObject, eventdata, handles)
% hObject    handle to subreachlength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subreachlength as text
%        str2double(get(hObject,'String')) returns contents of subreachlength as a double


% --- Executes during object creation, after setting all properties.
function subreachlength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subreachlength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)

ReadVar=getappdata(0, 'ReadVar');
AdvancedSet  = getappdata(0, 'AdvancedSet');
sel=1;%Inflection method

TableData=get(handles.inputtable,'Data');
if handles.multi==0
    p=1;
    for i=1:size(TableData,1)
        if strcmp(TableData(i,2),'Main Channel')
    %         %Calculate and plot planar variables
    %         [geovar{i}]=mStat_planar(ReadVar{i}.xCoord,ReadVar{i}.yCoord,ReadVar{i}.width,ReadVar{i}.File,...
    %         sel,ReadVar{i}.Module,ReadVar{i}.Level, AdvancedSet{i});
            ReadVarPri=ReadVar{i};
        elseif strcmp(TableData(i,2),'Secondary Channel')

            ReadVarSec{p}=ReadVar{i};
            p=p+1;
        end
    end

    %Determinate distance of primary channel

    for i=1:length(ReadVarPri.xCoord)-1
        DistancePrimarySeg(i)=((ReadVarPri.xCoord(i+1)-ReadVarPri.xCoord(i))^2+...
            (ReadVarPri.yCoord(i+1)-ReadVarPri.yCoord(i))^2)^0.5;
    end

    DistancePrimary=nansum(DistancePrimarySeg);


    for u=1:length(ReadVarSec)
        for i=1:length(ReadVarSec{u}.xCoord)-1
            DistanceSecondary{u}(i)=((ReadVarSec{u}.xCoord(i+1)-ReadVarSec{u}.xCoord(i))^2+...
                (ReadVarSec{u}.yCoord(i+1)-ReadVarSec{u}.yCoord(i))^2)^0.5;
        end
        DistanceSecondaryTo(u)=nansum(DistanceSecondary{u});
    end

    DistanceSecondaryT=nansum(DistanceSecondaryTo);

    BraidedIndex=(DistancePrimary+DistanceSecondaryT)/DistancePrimary;
    
                        % Push messages to Log Window:
        %     % ----------------------------
        log_text = {...
                    '';...
                    ['%--- ' datestr(now) ' ---%'];...
                    'Filename:';[cell2mat({ReadVar{1}.File})];
                    'Braided Index:';[cell2mat({BraidedIndex})]};
                    statusLogging(handles.LogWindow, log_text)
                    
elseif handles.multi==1
    
    for o=1:size(TableData,1)
        p=1;
            ReadVarPri=ReadVar{o}.Brad{1};
            for t=2:length(ReadVar{o}.Brad)
                ReadVarSec{p}=ReadVar{o}.Brad{t};
                p=p+1;
            end

        %Determinate distance of primary channel

        for i=1:length(ReadVarPri.xCoord)-1
            DistancePrimarySeg(i)=((ReadVarPri.xCoord(i+1)-ReadVarPri.xCoord(i))^2+...
                (ReadVarPri.yCoord(i+1)-ReadVarPri.yCoord(i))^2)^0.5;
        end

        DistancePrimary=nansum(DistancePrimarySeg);


        for u=1:length(ReadVarSec)
            for i=1:length(ReadVarSec{u}.xCoord)-1
                DistanceSecondary{u}(i)=((ReadVarSec{u}.xCoord(i+1)-ReadVarSec{u}.xCoord(i))^2+...
                    (ReadVarSec{u}.yCoord(i+1)-ReadVarSec{u}.yCoord(i))^2)^0.5;
            end
            DistanceSecondaryTo(u)=nansum(DistanceSecondary{u});
        end

        DistanceSecondaryT=nansum(DistanceSecondaryTo);

        BraidedIndex{o}=(DistancePrimary+DistanceSecondaryT)/DistancePrimary;
        
        % Push messages to Log Window:
        % ----------------------------
        log_text = {...
                    '';...
                    ['%--- ' datestr(now) ' ---%'];...
                    'Filename:';[cell2mat({ReadVar{o}.File})];
                    'Braided Index:';[cell2mat({BraidedIndex{o}})]};
                    statusLogging(handles.LogWindow, log_text)               
    end

    
end



% %Segmentation
% e=1;
% for i=1:length(ReadVarPri.xCoord)   
%     if e==1;
%         IndexSubreach(e,1)=i;
%         DistSubreachPri(i)=((ReadVarPri.xCoord(i)-ReadVarPri.xCoord(1))^2+...
%             (ReadVarPri.yCoord(i)-ReadVarPri.yCoord(1))^2)^0.5;
%     
%         if DistSubreachPri(i)>SubreachLength
%             IndexSubreach(e,2)=i;
%             e=e+1;
%         end       
%     else
%         IndexSubreach(e,1)=IndexSubreach(e-1,2);
%         DistSubreachPri(i)=((ReadVarPri.xCoord(i)-ReadVarPri.xCoord(IndexSubreach(e-1,2)))^2+...
%             (ReadVarPri.yCoord(i)-ReadVarPri.yCoord(IndexSubreach(e-1,2)))^2)^0.5;
%     
%         if DistSubreachPri(i)>SubreachLength
%             IndexSubreach(e,2)=i;
%             e=e+1;
%         end   
%     end
% end
% 
% %Sinuosity
% for i=1:size(IndexSubreach,1)
%     Sinuosity(i)=DistancePrimary(IndexSubreach(i,2))/DistSubreachPri(IndexSubreach(i,2));
% end
% 
% %%
% %Secondary channels
% NumfileSec=size(ReadVarSec,2);
% 
% for u=1:NumfileSec
%     for i=1:length(ReadVarSec.xCoord)-1 
%         DistSubreachSec{u}(i)=((ReadVarSec.xCoord(i+1)-ReadVarSec.xCoord(i))^2+...
%             (ReadVarSec.yCoord(i+1)-ReadVarSec.yCoord(i))^2)^0.5;
%     end
% end

% %Braiding Index
% for i=1:size(IndexSubreach,1)
%     BraidingIndex(i)=DistancePrimary(IndexSubreach(i,2))/(
% end

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function channelname_Callback(hObject, eventdata, handles)
% hObject    handle to channelname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of channelname as text
%        str2double(get(hObject,'String')) returns contents of channelname as a double


% --- Executes during object creation, after setting all properties.
function channelname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function ruler_OnCallback(hObject, eventdata, handles)
axes(handles.braiding_axes)
%imdistline(hparent)

 axis manual
 handles.Figruler = imline(gca);
 % Get original position
 pos = getPosition(handles.Figruler);
 % Get updated position as the ruler is moved around
 id = addNewPositionCallback(handles.Figruler,@(pos) title(mat2str(pos,3)));
 
 x=pos(:,1);
 y=pos(:,2);
 
 handles.ruler=imdistline(handles.pictureReach,x,y);
 guidata(hObject,handles)


% --------------------------------------------------------------------
function ruler_OffCallback(hObject, eventdata, handles)
delete(handles.ruler)
delete(handles.Figruler)


% --------------------------------------------------------------------
function datacusor_OnCallback(hObject, eventdata, handles)
axes(handles.braiding_axes); 

%data cursor type
dcm_obj = datacursormode(gcf);

set(dcm_obj,'UpdateFcn',@mStat_myupdatefcn);

set(dcm_obj,'Displaystyle','Window','Enable','on');
pos = get(0,'userdata');
