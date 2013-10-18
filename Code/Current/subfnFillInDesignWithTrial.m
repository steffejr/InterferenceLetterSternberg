function Trials = subfnFillInDesignWithTrial(DesignRow, LetTrial, NumTrial)
% Cycle through the columns of the design matrix and map the load values to
% the different letter list lengths. Add a feature to also work with letter
% list lengths of 3


    Trials.LetList = LetTrial(DesignRow(1)).LetList;
    % POSITIVE PROBE
    if DesignRow(3) == 1 % LetPOS
        Trials.LetProbe = LetTrial(DesignRow(1)).LetListPOS;
        Trials.LetType = [num2str(DesignRow(1)) 'POS'];
        % NEGITIVE PROBE
    elseif DesignRow(3) == -1 % LetNEG
        Trials.LetProbe = LetTrial(DesignRow(1)).LetListNEG;
        Trials.LetType = [num2str(DesignRow(1)) 'NEG'];
    end
    % HIGH

% NUMBERS
% LOW
if DesignRow(2) == 1 % NumLow
    Trials.NumList = NumTrial.LowList;
    % POSITIVE PROBE
    if DesignRow(4) == 1 % NumPOS
        Trials.NumProbe = NumTrial.LowListPOS;
        Trials.NumType = 'LowPOS';
        % NEGITIVE PROBE
    elseif DesignRow(4) == -1 % NumNEG
        Trials.NumProbe = NumTrial.LowListNEG;
        Trials.NumType = 'LowNEG';
    end
    % HIGH
elseif DesignRow(2) == 2 % NumHigh
    Trials.NumList = NumTrial.HighList;
    % POSITIVE PROBE
    if DesignRow(4) == 1 % NumPOS
        Trials.NumProbe = NumTrial.HighListPOS;
        Trials.NumType = 'HighPOS';
        % NEGITIVE PROBE
    elseif DesignRow(4) == -1 % NumNEG
        Trials.NumProbe = NumTrial.HighListNEG;
        Trials.NumType = 'HighNEG';
    end
end



