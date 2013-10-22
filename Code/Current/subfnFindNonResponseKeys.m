function ListOfKeysIgnore = subfnFindNonResponseKeys(handles)
% create a list of all ASCII values
ListOfKeysIgnore = 1:256;
%% set all response values to zero in this list

ListOfKeysIgnore(subfnButtonsToIgnore(handles.Buttons_LetterYes)) = 0;
ListOfKeysIgnore(subfnButtonsToIgnore(handles.Buttons_LetterNo)) = 0;
ListOfKeysIgnore(subfnButtonsToIgnore(handles.Buttons_NumberYes)) = 0;
ListOfKeysIgnore(subfnButtonsToIgnore(handles.Buttons_NumberNo)) = 0;
ListOfKeysIgnore(subfnButtonsToIgnore('ESCAPE')) = 0;

ListOfKeysIgnore(subfnButtonsToIgnore(handles.Trigger1)) = 0;
ListOfKeysIgnore(subfnButtonsToIgnore(handles.Trigger2)) = 0;

ListOfKeysIgnore(subfnIgnoreSingleKey('ESCAPE')) = 0;


ListOfKeysIgnore = find(ListOfKeysIgnore);
function List = subfnButtonsToIgnore(StringList)
List = [];
for i = 1:length(StringList)
    KeyMappings = KbName('KeyNames');
    for j = 1:length(KeyMappings)
        if strfind(KeyMappings{j}, StringList(i))
            % Make sure it is not a function key with a number in its name
            if ~isempty(str2num(StringList(i)))
                if ~length(strfind(KeyMappings{j},'F'))>0 && length(KeyMappings{j})<3
                    List = [List; j];
                %    fprintf(1,'%s: %d\n',KeyMappings{j},j);
                end
            elseif length(KeyMappings{j})<3 % it must be a string
                % fprintf(1,'%s: %d\n',KeyMappings{j},j)
                List = [List; j];
            end
        end
    end
end

function List = subfnIgnoreSingleKey(KeyboardKey)
KeyMappings = KbName('KeyNames');
List = [];
for j = 1:length(KeyMappings)
    if strfind(upper(KeyMappings{j}), upper(KeyboardKey))
        % Make sure it is not a function key with a number in its name
        if ~isempty(str2num(KeyboardKey))
            if ~length(strfind(KeyMappings{j},'F'))>0 && length(KeyMappings{j})<3
                List = [List; j];
                fprintf(1,'%s: %d\n',KeyMappings{j},j);
            end
        else
           % fprintf(1,'%s: %d\n',KeyMappings{j},j)
            List = [List; j];
        end
    end
end
