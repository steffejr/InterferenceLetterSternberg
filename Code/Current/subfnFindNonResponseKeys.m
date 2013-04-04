function ListOfKeysIgnore = subfnFindNonResponseKeys(handles)
% create a list of all ASCII values
ListOfKeysIgnore = 1:256;
% set all response values to zero in this list
ListOfKeysIgnore(eval(sprintf('''%s''-0', handles.Buttons_LetterNo))) = 0;
% enusre that UPPERCASE letters are also ignored
ListOfKeysIgnore(eval(sprintf('''%s''-0', upper(handles.Buttons_LetterNo)))) = 0;
ListOfKeysIgnore(eval(sprintf('''%s''-0', handles.Buttons_NumberYes))) = 0;
ListOfKeysIgnore(eval(sprintf('''%s''-0', upper(handles.Buttons_NumberYes)))) = 0;
ListOfKeysIgnore(eval(sprintf('''%s''-0', handles.Buttons_NumberYes))) = 0;
ListOfKeysIgnore(eval(sprintf('''%s''-0', upper(handles.Buttons_NumberYes)))) = 0;
ListOfKeysIgnore(eval(sprintf('''%s''-0', handles.Buttons_LetterNo))) = 0;
ListOfKeysIgnore(eval(sprintf('''%s''-0', upper(handles.Buttons_LetterNo)))) = 0;
% also make sure to NOT ignore the trigger
ListOfKeysIgnore(eval(sprintf('''%s''-0', (handles.Trigger1)))) = 0;
ListOfKeysIgnore(eval(sprintf('''%s''-0', upper(handles.Trigger1)))) = 0;
ListOfKeysIgnore(eval(sprintf('''%s''-0', (handles.Trigger2)))) = 0;
ListOfKeysIgnore(eval(sprintf('''%s''-0', upper(handles.Trigger2)))) = 0;


% return the list of keys to ignore.
ListOfKeysIgnore = ListOfKeysIgnore(find(ListOfKeysIgnore));