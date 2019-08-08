function [ReadVar]=mStat_ReadInputFiles(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%MStaT
%This function incorporate the initial data the Centerline in diferent
%formats
%by Dominguez Ruben, UNL, Argentina
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%Start code
persistent lastPath 
% If this is the first time running the function this session,
% Initialize lastPath to 0
if isempty(lastPath) 
    lastPath = 0;
end


if lastPath == 0
    [File,Path] = uigetfile({'*.shp;*.kml;*.txt;*.xls;*.xlsx',...
    'MStaT Files (*.shp,*.kml,*.txt,*.xls,*.xlsx)';'*.*',  'All Files (*.*)'},'Select Input File','MultiSelect',handles.multisel);
else %remember the lastpath
    [File,Path] = uigetfile({'*.shp;*.kml;*.txt;*.xls;*.xlsx',...
    'MStaT Files (*.shp,*.kml,*.txt,*.xls,*.xlsx)';'*.*',  'All Files (*.*)'},'Select Input File','MultiSelect',handles.multisel,lastPath);
end


% Use the path to the last selected file
% If 'uigetfile' is called, but no item is selected, 'lastPath' is not overwritten with 0
if Path ~= 0
    lastPath = Path;
end

if Path==0
else
    if iscell(File)%multifile
        numfile=size(File,2); 
    else
        numfile=1;
    end
     
    for i=1:numfile    

        if numfile==1
            str=['Reading ' File];
            ReadVar{i}.File=char(File);
        else
            str=['Reading ' File(i)];
            ReadVar{i}.File=char(File(i));
        end
        
        hwait = waitbar(0,str,'Name','MStaT',...
             'CreateCancelBtn',...
                'setappdata(gcbf,''canceling'',1)');
        setappdata(hwait,'canceling',0)

        ReadVar{i}.numfile=numfile;
        ReadVar{i}.Path=Path;
        %   

        ReadVar{i}.comp=ReadVar{i}.File(end);
        if ReadVar{i}.comp=='l'%Read kml

            kmlFile=fullfile(ReadVar{i}.Path,ReadVar{i}.File);

            ReadVar{i}.kmlFile=kmlFile;

            kmlStruct = kml2struct(char(kmlFile));

            %project kml in utm system

           [ReadVar{i}.xCoord, ReadVar{i}.yCoord,ReadVar{i}.utmzone] =...
            deg2utm(kmlStruct.Lat,kmlStruct.Lon);

            ReadVar{i}.CS=3;
            
            clear kmlFile kmlStruct

        elseif  ReadVar{i}.comp=='t'%Read ASCII File

            %read ascii
            ReadVar{i}.xyCl=importdata(fullfile(ReadVar{i}.Path,ReadVar{i}.File));
            ReadVar{i}.xCoord = ReadVar{i}.xyCl(:,1);
            ReadVar{i}.yCoord = ReadVar{i}.xyCl(:,2);
            ReadVar{i}.utmzone=[];%without data

             if isnumeric(ReadVar{i}.xCoord(1,1)) | isnumeric(ReadVar{i}.yCoord(1,1))%Quit the first row
             else
                ReadVar{i}.xCoord(1,1) =[];
                ReadVar{i}.yCoord(1,1) =[]; 
             end
             
             if ReadVar{i}.xCoord(1,1)>180
                ReadVar{i}.CS=3;%UTM
             else
                ReadVar{i}.CS=2;%Geographic 
             end
             
        elseif  ReadVar{i}.comp=='s'%read office 2007 File
                %read xls
                xlsxFile=fullfile(ReadVar{i}.Path,ReadVar{i}.File);
                ReadVar{i}.utmzone=[];%without data
                Ex=xlsread(char(xlsxFile));

                ReadVar{i}.xCoord = Ex(:,1);
                ReadVar{i}.yCoord = Ex(:,2);

            if isnumeric(ReadVar{i}.xCoord(1,1)) | isnumeric(ReadVar{i}.yCoord(1,1))
            else
                ReadVar{i}.xCoord(1,1) =[];
                ReadVar{i}.yCoord(1,1) =[]; 
            end
            
            if ReadVar{i}.xCoord(1,1)>180
                ReadVar{i}.CS=3;%UTM
             else
                ReadVar{i}.CS=2;%Geographic 
             end

        elseif  ReadVar{i}.comp=='x'%read office 2013 File
                %read xlsx
                xlsxFile=fullfile(ReadVar{i}.Path,ReadVar{i}.File);
                ReadVar{i}.utmzone=[];%without data
                Ex=xlsread(char(xlsxFile));

                ReadVar{i}.xCoord = Ex(:,1);
                ReadVar{i}.yCoord = Ex(:,2);

            if isnumeric(ReadVar{i}.xCoord(1,1)) | isnumeric(ReadVar{i}.yCoord(1,1))
            else
                ReadVar{i}.xCoord(1,1) =[];
                ReadVar{i}.yCoord(1,1) =[]; 
            end 

             if ReadVar{i}.xCoord(1,1)>180
                ReadVar{i}.CS=3;%UTM
             else
                ReadVar{i}.CS=2;%Geographic 
             end
             
            elseif  ReadVar{i}.comp=='p'%Read shapefile

            %read ShapeFile
            ReadVar{i}.ShapeData=shaperead(fullfile(ReadVar{i}.Path,ReadVar{i}.File));

            Class=ReadVar{i}.ShapeData.Geometry;

            if strcmp(Class,'Point')
                 k = struct2dataset(ReadVar{i}.ShapeData);
                 Lat = double(k(:,3));
                 Lon = double(k(:,2));
                 ReadVar{i}.Ids = double(k(:,4));
             %found Id
             n=1;%number of sample
             m=1;%number od Ids
                while size(k,1)>=n
                    if n==1
                        Id(m) = double(k(n,4));
                        m=m+1;
                        n=n+1;
                    else
                        if double(k(n,4))==Id(m-1)
                          n=n+1;  
                        else
                            Id(m)= double(k(n,4));
                            m=m+1;
                            n=n+1;
                        end
                    end

                end
            elseif strcmp(Class,'Line')
                 Lat = ReadVar{i}.ShapeData.Y;
                 Lon = ReadVar{i}.ShapeData.Y;
                 ReadVar{i}.Ids = ReadVar{i}.ShapeData.id;
            end

            %Define what class of element

            [ReadVar{i}.xCoord, ReadVar{i}.yCoord,ReadVar{i}.utmzone] =...
            deg2utm(Lat,Lon);
            
            ReadVar{i}.CS=3;
            
            for t=1:length(Id)
                ReadVar{i}.stringsId{t} = Id(t);
            end

        end
        
            ReadVar{i}.Module = handles.Module;
            ReadVar{i}.Level = 5;%Decomposition level default
            %      General parameters to get equally spaced data.
            AdvancedSet{i}.nTimesToSmooth = 2; %2 
            AdvancedSet{i}.polyOrder = 3;% equivalent to "order" in "curvature" function.
            AdvancedSet{i}.nPointsInWindow = 7;%  equivalent to "window" in "curvature" function.
            AdvancedSet{i}.nReachPoints = 1500; % 1500 150 equivalent to "nDiscr" in "curvature" function 
                     %  in the banks: 1500 works well in most of the cases.
            waitbar(1,hwait)
            delete(hwait)
    end
    
    if handles.first==1;
        setappdata(0, 'ReadVar', ReadVar);
        setappdata(0, 'AdvancedSet', AdvancedSet);
        
    elseif handles.first==0;
        ReadVar1=getappdata(0, 'ReadVar');
        AdvancedSet1=getappdata(0, 'AdvancedSet');
    
        for i=1:length(ReadVar)
            ReadVar1{length(ReadVar1)+i}=ReadVar{i};
            AdvancedSet1{length(ReadVar1)+i}=AdvancedSet{i};
        end
       
        setappdata(0, 'ReadVar', ReadVar1);
        setappdata(0, 'AdvancedSet', AdvancedSet1); 
    end
    
    
    mStat_AddXYData(handles);

end




function rememberUigetfile
persistent lastPath pathName
% If this is the first time running the function this session,
% Initialize lastPath to 0
if isempty(lastPath) 
    lastPath = 0;
end
% First time calling 'uigetfile', use the pwd
if lastPath == 0
    [fileName, pathName] = uigetfile;
    
% All subsequent calls, use the path to the last selected file
else
    [fileName, pathName] = uigetfile(lastPath);
end
% Use the path to the last selected file
% If 'uigetfile' is called, but no item is selected, 'lastPath' is not overwritten with 0
if pathName ~= 0
    lastPath = pathName;
end