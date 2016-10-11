A = [1,3,5,7,9,-1,-3,-5,-7,-9,1,3,5,7,9,-1,-3,-5,-7,-9,1,3,5,7,9,-1,-3,-5,-7,-9,1,3,5,7,9,-1,-3,-5,-7,-9]  
 

Case1 = [A(1:2:end), A(2:2:end)];
Case2 = [A(2:2:end), A(1:2:end)];
Case3 = [A(1:3:end), A(2:3:end), A(3:3:end)];
Case4 = [A(3:3:end), A(1:3:end), A(2:3:end)];
Case5 = [A(2:3:end), A(3:3:end), A(1:3:end)];

% Create the Designs using these cases
NTrials = length(A);
% Create a structure for each trial
Trials = cell(NTrials,1);
LoadLevels = unique(abs(A));
NumberListLength = 0;

LetTemp = length(LoadLevels);

if NumberListLength > 0
    [NumLists] = CreateNumberLists(NumberListLength);
else
    [NumLists] = CreateNumberLists(1);
end
[LetLists] = CreateLetterLists(handles);

Design = ones(length(A),4);
Design(:,1) = abs(Case1);
Design(:,3) = sign(Case1);
% Now that the Design is created it needs to be populated appropriately;
% however, some conditions need to be met regarding previous presentations
% of the letters.
% Ensure that the current trial's probe letter WAS NOT included in the
% previous set.
%
% It is also possible that with large letter sets the design itself cannot
% be fullfilled. An example is 14 possible letters with consecutive trials 
% of 7 or 8 letter set sizes.
%
% With a max letter load of 8 and a 15 leter pool 64 trials can be created
% but not more.
%
%AvailableLetters = 26 - length(handles.LetToExclude);
%NeededLettersPerTrial = Design(:,1) + 1;
%LeftOverLetters = AvailableLetters - NeededLettersPerTrial;
%[Design(2:end,1) LeftOverLetters(1:end-1) NeededLettersPerTrial(2:end)]
flagDesign = 1;
flagDesignOrder = 1;
BothflagDesign = 1;
DesignCount = 1;


NumberAttemptsToCreateDesign = 10^6;
while BothflagDesign == 1 && DesignCount < NumberAttemptsToCreateDesign
    
    Design = Design(randperm(NTrials),:);
    % check to see if the current trial is consecutive in
    % either direction with the previous trial
    % Map the design loads to their position in the load level list
    LoadListMapDesign = zeros(NTrials,1);
    for i = 1:LetTemp
       LoadListMapDesign(find(Design(:,1) == LoadLevels(i))) = i;
    end
    % the absolute value of the difference has to be greater then one.
%    if sum(abs(diff(LoadListMapDesign)) < 2) > 0 ;
%        flagDesignOrder = 1;
%    else 
        flagDesignOrder = 0;
%    end
    AvailableLetters = 26 - length(handles.LetToExclude);
    % The number of letters needed for the current trial
    NeededLettersPerTrial = Design(:,1) + 1;
    % But extra letters are needed because soem letters were used in the
    % previous trial and are therefore exlcuded.
    LeftOverLetters = AvailableLetters - NeededLettersPerTrial;
    
    if ~sum(([LeftOverLetters(1:end-1) - NeededLettersPerTrial(2:end)])<0)>0
        flagDesign = 0;
    end
    if flagDesign == 0 && flagDesignOrder == 0
        BothflagDesign = 0;
    end
    DesignCount = DesignCount + 1;
end
DesignCount


if DesignCount == NumberAttemptsToCreateDesign;
    %errordlg('Tried permuting the design matrix 1000 times and could not find a good trial order.')
    Design = [];
    return
end
fprintf(1,'\n\nNumber of Design permutations: %d\n',DesignCount);
%[Design(2:end,1) LeftOverLetters(1:end-1) NeededLettersPerTrial(2:end)]


% Create a random list of numbers
NTotal = min([length(LetLists) length(NumLists)]);
%R = randperm(NTotal);

% TRY to do it and if it fails try again.
madeDesignFlag = 1;
while madeDesignFlag
    % Traverse the Let/Num Lists and ensure that successive probes are not in the previous lists.
    trial = 1; % First trial
    % Each time this program fails to create a design, select a new order
    % of load levels and try again.
    % The restrictions are:
    %   current probe cannot be in the previous trial letter set
    %   current trial letter set cannot include letters from the previous
    %   probe or letter set.
    %   current probe cannot equal previous probe
    % 
    Trials{1} = subfnFillInDesignWithTrial(Design(trial,:), LetLists{trial}, NumLists{trial});
    % Instead of using a random order to pick from pick from the list without
    % replacement. So if a list is eligible use it and remove it. If it is not
    % put it back into the list.
    try
        while trial < NTrials
           
            trial = trial + 1;
            PreviousTrialOneStep = Trials{(trial - 1)};
            % Compare the current trial with the previous trial
            flag = 0;
            count = 0;
            while ~flag
                count = count + 1;
                %tempTrialPick = subfnFillInDesignWithTrial(Design(trial,:), LetLists{R(count)}, NumLists{R(count)});
              % This next line causes the error which triggers the end of
              % this attempt and to create a new list of letters.
                tempTrialPick = subfnFillInDesignWithTrial(Design(trial,:), LetLists{count}, NumLists{count});

                
                % This checks the letters of the current and previous trial
                flag = subfnCompareTrials(PreviousTrialOneStep, tempTrialPick);
                if flag
                    % remove this trial from the list
                    Z = ones(length(LetLists),1);
                    Z(count) = 0;
                    LetLists = LetLists(find(Z));
                    NumLists = NumLists(find(Z));
                    
                end
            end
            Trials{trial} = tempTrialPick;
            fprintf(1,'Trial: %3d, count: %4d\n',trial,count);
        end
        madeDesignFlag = 0;
        fprintf('Design made successfully!\n');
        
    catch me
        madeDesignFlag = madeDesignFlag + 1;
        if madeDesignFlag > NumberAttemptsToCreateDesign
            errordlg({sprintf('%d unsuccessful attempts were made at creating letter lists.',NumberAttemptsToCreateDesign)...
                'Please EXCLUDE less letters for creating the lists.'...
                'See program: CreateLetterLists.m'})
            break
        end
        fprintf(1,'Trouble making letter list: %s\n',me.message);
        fprintf(1,'Trying again for attempt %d of %d.\n',madeDesignFlag,NumberAttemptsToCreateDesign)
    end
end
% Print out all trials to the screen
% for i = 1:NTrials
%      fprintf(1,'%10s %s\t',Trials{i}.LetList,Trials{i}.LetProbe);
%      fprintf(1,'%10s %s\n',Trials{i}.NumList,Trials{i}.NumProbe);
% end

% 
% for i = 1:length(Trials)
%     fprintf(1,'%4d\t%10s\t%s\t%s\t%s\n',i,Trials{i}.LetList,Trials{i}.LetProbe,Trials{i}.NumList,Trials{i}.NumProbe);
% end
