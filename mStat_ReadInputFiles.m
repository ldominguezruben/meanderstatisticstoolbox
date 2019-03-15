function [ReadVar]=mStat_ReadInputFiles(multisel,lastpath)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%MStaT
%This function incorporate the initial data the Centerline in diferent
%formats
%by Dominguez Ruben, UNL, Argentina
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%Start code
if lastpath == 0
[ReadVar.File,ReadVar.Path] = uigetfile({'*.kml;*.txt;*.xls;*.xlsx',...
    'MStaT Files (*.kml,*.txt,*.xls,*.xlsx)';'*.*',  'All Files (*.*)'},'Select Input File','MultiSelect',multisel);
else %remember the lastpath
    [ReadVar.File,ReadVar.Path] = uigetfile({'*.kml;*.txt;*.xls;*.xlsx',...
    'MStaT Files (*.kml,*.txt,*.xls,*.xlsx)';'*.*',  'All Files (*.*)'},'Select Input File','MultiSelect',multisel,lastpath);
end

if isempty(ReadVar.File)
    %empty 
else
    
    if iscell(ReadVar.File)%determinate the number of secondary channels
        ReadVar.numfile=size(ReadVar.File,2);    
    
    for i=1:ReadVar.numfile
        ReadVar.comp{i}=mat2str(ReadVar.File{i}(end));
            if ReadVar.comp{i}(2)=='l'%Read kml

                kmlFile=fullfile(ReadVar.Path,ReadVar.File{i});

                ReadVar.kmlFile{i}=kmlFile;

                kmlStruct = kml2struct(kmlFile);

                %project kml in utm system
                [ReadVar.xCoord{i}, ReadVar.yCoord{i},ReadVar.utmzone{i}] = deg2utm(kmlStruct.Lat,kmlStruct.Lon);

                clear kmlFile kmlStruct

            elseif  ReadVar.comp{i}(2)=='t'%Read ASCII File

                %read ascii
                ReadVar.xyCl=importdata(fullfile(ReadVar.Path,ReadVar.File));
                ReadVar.xCoord{1} = ReadVar.xyCl(:,1);
                ReadVar.yCoord{1} = ReadVar.xyCl(:,2);
                ReadVar.utmzone{1}=[];%without data

                 if isnumeric(ReadVar.xCoord{1}(1,1)) | isnumeric(ReadVar.yCoord{1}(1,1))%Quit the first row
                 else
                    ReadVar.xCoord{1}(1,1) =[];
                    ReadVar.yCoord{1}(1,1) =[]; 
                 end

            elseif  ReadVar.comp(2)=='s'%read office 2007 File
                    %read xlsx
                    xlsxFile=fullfile(ReadVar.Path,ReadVar.File);
                    ReadVar.utmzone{1}=[];%without data
                    Ex=xlsread(xlsxFile);

                    ReadVar.xCoord{1} = Ex(:,1);
                    ReadVar.yCoord{1} = Ex(:,2);

                if isnumeric(ReadVar.xCoord{1}(1,1)) | isnumeric(ReadVar.yCoord{1}(1,1))
                else
                    ReadVar.xCoord{1}(1,1) =[];
                    ReadVar.yCoord{1}(1,1) =[]; 
                end          
            elseif  ReadVar.comp(2)=='x'%read office 2013 File
                    %read xlsx
                    xlsxFile=fullfile(ReadVar.Path,ReadVar.File);
                    ReadVar.utmzone{1}=[];%without data
                    Ex=xlsread(xlsxFile);

                    ReadVar.xCoord{1} = Ex(:,1);
                    ReadVar.yCoord{1} = Ex(:,2);

                if isnumeric(ReadVar.xCoord{1}(1,1)) | isnumeric(ReadVar.yCoord{1}(1,1))
                else
                    ReadVar.xCoord{1}(1,1) =[];
                    ReadVar.yCoord{1}(1,1) =[]; 
                end 

            end
    end
    
    else% one file
        ReadVar.numfile=1;
    
            for i=1:ReadVar.numfile
                ReadVar.comp=mat2str(ReadVar.File(end));
            if ReadVar.comp(2)=='l'%Read kml

                kmlFile=fullfile(ReadVar.Path,ReadVar.File);

                ReadVar.kmlFile=kmlFile;

                kmlStruct = kml2struct(kmlFile);

                %project kml in utm system
                [ReadVar.xCoord{1}, ReadVar.yCoord{1},ReadVar.utmzone{1}] = deg2utm(kmlStruct.Lat,kmlStruct.Lon);

                clear kmlFile kmlStruct

            elseif  ReadVar.comp(2)=='t'%Read ASCII File

                %read ascii
                ReadVar.xyCl=importdata(fullfile(ReadVar.Path,ReadVar.File));
                ReadVar.xCoord{1} = ReadVar.xyCl(:,1);
                ReadVar.yCoord{1} = ReadVar.xyCl(:,2);
                ReadVar.utmzone{1}=[];%without data

                 if isnumeric(ReadVar.xCoord{1}(1,1)) | isnumeric(ReadVar.yCoord{1}(1,1))%Quit the first row
                 else
                    ReadVar.xCoord{1}(1,1) =[];
                    ReadVar.yCoord{1}(1,1) =[]; 
                 end

            elseif  ReadVar.comp(2)=='s'%read office 2007 File
                    %read xlsx
                    xlsxFile=fullfile(ReadVar.Path,ReadVar.File);
                    ReadVar.utmzone{1}=[];%without data
                    Ex=xlsread(xlsxFile);

                    ReadVar.xCoord{1} = Ex(:,1);
                    ReadVar.yCoord{1} = Ex(:,2);

                if isnumeric(ReadVar.xCoord{1}(1,1)) | isnumeric(ReadVar.yCoord{1}(1,1))
                else
                    ReadVar.xCoord{1}(1,1) =[];
                    ReadVar.yCoord{1}(1,1) =[]; 
                end          
            elseif  ReadVar.comp(2)=='x'%read office 2013 File
                    %read xlsx
                    xlsxFile=fullfile(ReadVar.Path,ReadVar.File);
                    ReadVar.utmzone{1}=[];%without data
                    Ex=xlsread(xlsxFile);

                    ReadVar.xCoord{1} = Ex(:,1);
                    ReadVar.yCoord{1} = Ex(:,2);

                if isnumeric(ReadVar.xCoord{1}(1,1)) | isnumeric(ReadVar.yCoord{1}(1,1))
                else
                    ReadVar.xCoord{1}(1,1) =[];
                    ReadVar.yCoord{1}(1,1) =[]; 
                end 

            end
            end
    end
    
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