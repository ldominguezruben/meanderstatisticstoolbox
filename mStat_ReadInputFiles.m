function [ReadVar]=mStat_ReadInputFiles(File,Path)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%MStaT
%This function incorporate the initial data the Centerline in diferent
%formats
%by Dominguez Ruben, UNL, Argentina
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%Start code
ReadVar.File=File;
ReadVar.Path=Path;
%   
    
ReadVar.comp=mat2str(ReadVar.File{1}(end));
if ReadVar.comp(2)=='l'%Read kml

    kmlFile=fullfile(ReadVar.Path,ReadVar.File);

    ReadVar.kmlFile=kmlFile;

    kmlStruct = kml2struct(char(kmlFile));

    %project kml in utm system
    ReadVar.xCoord=kmlStruct.Lat;

    ReadVar.yCoord=kmlStruct.Lon;

    clear kmlFile kmlStruct

elseif  ReadVar.comp(2)=='t'%Read ASCII File

    %read ascii
    ReadVar.xyCl=importdata(fullfile(ReadVar.Path{1},ReadVar.File{1}));
    ReadVar.xCoord = ReadVar.xyCl(:,1);
    ReadVar.yCoord = ReadVar.xyCl(:,2);
    ReadVar.utmzone=[];%without data

     if isnumeric(ReadVar.xCoord(1,1)) | isnumeric(ReadVar.yCoord(1,1))%Quit the first row
     else
        ReadVar.xCoord(1,1) =[];
        ReadVar.yCoord(1,1) =[]; 
     end

elseif  ReadVar.comp(2)=='s'%read office 2007 File
        %read xlsx
        xlsxFile=fullfile(ReadVar.Path{1},ReadVar.File{1});
        ReadVar.utmzone=[];%without data
        Ex=xlsread(xlsxFile);

        ReadVar.xCoord = Ex(:,1);
        ReadVar.yCoord = Ex(:,2);

    if isnumeric(ReadVar.xCoord(1,1)) | isnumeric(ReadVar.yCoord(1,1))
    else
        ReadVar.xCoord(1,1) =[];
        ReadVar.yCoord(1,1) =[]; 
    end          
elseif  ReadVar.comp(2)=='x'%read office 2013 File
        %read xlsx
        xlsxFile=fullfile(ReadVar.Path{1},ReadVar.File{1});
        ReadVar.utmzone=[];%without data
        Ex=xlsread(xlsxFile);

        ReadVar.xCoord = Ex(:,1);
        ReadVar.yCoord = Ex(:,2);

    if isnumeric(ReadVar.xCoord(1,1)) | isnumeric(ReadVar.yCoord(1,1))
    else
        ReadVar.xCoord(1,1) =[];
        ReadVar.yCoord(1,1) =[]; 
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