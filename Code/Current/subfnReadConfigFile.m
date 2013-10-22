function [ConfigData] = subfnReadConfigFile(ConfigFile,InputStruct)
% This function reads in the config file. It assumes that the config file
% has fields in square brackets, followed on the following line by a value.
% If only one arguement is passed then a new structure is created and
% passed as outout. If two arguements are passed the
if nargin == 1
    ConfigData = {};
elseif nargin == 2;
    % check to make sure the second arguement is a structure
    if isstruct(InputStruct)
        ConfigData = InputStruct;
    else errordlg('The second arguement should be a structure.');
        ConfigData = {};
        return
    end
end
if exist(ConfigFile)
    fprintf(1,'Found Config File\n');
    D = textread(ConfigFile,'%s','delimiter','\n');
    for i = 1:length(D)
        temp1 = D{i};
        if temp1(1) ~= '%'
            % This is a comment line in the config file
            if i < length(D)
                temp2 = D{i+1};
            else
                temp2 = '';
            end
            if temp1(1) == '['
                FunderL = findstr(temp1,'[');
                FunderR = findstr(temp1,']');
                field = temp1(FunderL(1)+1:FunderR(1)-1);
                if ~isempty(temp2)
                    if (temp2(1) ~= '[')
                        value = temp2;
                        if ~isempty(str2num(value))
                            value = str2num(value);
                        end
                        ConfigData = setfield(ConfigData,field,value);
                    else
                        ConfigData = setfield(ConfigData,field,'');
                    end
                end
            end
        end
    end
else errordlg('Cannot find Config file.');
    close
end
