function NumTrials = sufnCalcNumberOfTrials(handles,LetLoad,NumLen,NumBlocks)
% The following updates the text on the GUI showingthe number of trials
% that result from the choices selected.

% Get the letter list selected based on the actually pull-down menu and not
% from an intrinsic definition.
tempLetList = get(LetLoad,'string');
tempLetListSelection = get(LetLoad,'value');
LetListSelected = tempLetList{tempLetListSelection};

LetTemp = 2*length(str2num(char(LetListSelected)));
NumTemp = str2num(char(handles.NumList(NumLen)));
if NumTemp > 0
    NumTemp = 4;
else
    NumTemp = 1;
end
NumBlocksTemp = str2num(char(handles.BlockList(NumBlocks)));
NumTrials = LetTemp*NumTemp*NumBlocksTemp;