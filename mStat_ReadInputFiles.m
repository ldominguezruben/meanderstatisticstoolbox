function [ReadVar]=mStat_ReadInputFiles(multisel)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%MStaT
%This function incorporate the initial data the Centerline in diferent
%formats
%by Dominguez Ruben, UNL, Argentina
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%Start code
    
[ReadVar.File,ReadVar.Path] = uigetfile({'*.kml;*.txt;*.xls;*.xlsx',...
    'MStaT Files (*.kml,*.txt,*.xls,*.xlsx)';'*.*',  'All Files (*.*)'},'Select Input File','MultiSelect',multisel);

if ReadVar.File==0
    %warndlg('You need load two files')
else
    ReadVar.numfile=size(ReadVar.File,1);
    ReadVar.comp=mat2str(ReadVar.File(end));
    if ReadVar.comp(2)=='l'%Read kml
        %Read KML
        kmlFile=fullfile(ReadVar.Path,ReadVar.File);

        ReadVar.kmlFile{1}=kmlFile;

        % read kml
        kmlStruct = kml2struct(kmlFile);
        
        %project kml in utm system
        [ReadVar.xCoord{1}, ReadVar.yCoord{1},ReadVar.utmzone{1}] = deg2utm(kmlStruct.Lat,kmlStruct.Lon);


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