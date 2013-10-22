function LetEncodeString = subfnCreateLetterString(CharBetLet, LetList, NLetRows)
NLetters = length(LetList);

switch NLetters
    case 1
        LetEncodeString = sprintf('%s%s%s%s%s','*',CharBetLet,LetList(1),CharBetLet,'*');
        switch NLetRows
            case 1
            case 2
                LetEncodeString = sprintf('%s\n\n%s%s%s%s%s',LetEncodeString,'*',CharBetLet,'*',CharBetLet,'*');
            case 3
                LetEncodeString = sprintf('%s%s%s%s%s\n\n%s','*',CharBetLet,'*',CharBetLet,'*',LetEncodeString);
                LetEncodeString = sprintf('%s\n\n%s%s%s%s%s',LetEncodeString,'*',CharBetLet,'*',CharBetLet,'*');
        end
        
        % Two Letter List
    case 2
        LetEncodeString = ['*' CharBetLet LetList(1) CharBetLet ...
            '*\n\n*' CharBetLet LetList(2) CharBetLet '*'];
        LetEncodeString = sprintf('%s%s%s%s%s',LetList(1),CharBetLet,'*',CharBetLet,LetList(2));
        switch NLetRows
            case 1
            case 2
                LetEncodeString = sprintf('%s\n\n%s%s%s%s%s',LetEncodeString,'*',CharBetLet,'*',CharBetLet,'*');
            case 3
                LetEncodeString = sprintf('%s%s%s%s%s\n\n%s','*',CharBetLet,'*',CharBetLet,'*',LetEncodeString);
                LetEncodeString = sprintf('%s\n\n%s%s%s%s%s',LetEncodeString,'*',CharBetLet,'*',CharBetLet,'*');
        end
        
        % Three Letter List
    case 3
        LetEncodeString = sprintf('%s%s%s%s%s',LetList(1),CharBetLet,LetList(2),CharBetLet,LetList(3));
        switch NLetRows
            case 1
            case 2
                LetEncodeString = sprintf('%s\n\n%s%s%s%s%s',LetEncodeString,'*',CharBetLet,'*',CharBetLet,'*');
            case 3
                LetEncodeString = sprintf('%s%s%s%s%s\n\n%s','*',CharBetLet,'*',CharBetLet,'*',LetEncodeString);
                LetEncodeString = sprintf('%s\n\n%s%s%s%s%s',LetEncodeString,'*',CharBetLet,'*',CharBetLet,'*');
        end
        
        % Four Letter List
    case 4
        LetEncodeStringR1 = sprintf('%s%s%s%s%s',LetList(1),CharBetLet,'*',CharBetLet,LetList(2));
        LetEncodeStringR2 = sprintf('%s%s%s%s%s',LetList(3),CharBetLet,'*',CharBetLet,LetList(4));
        switch NLetRows
            case 1
                error('Mismatch between number of letters to present and allowable rows to present one.')
            case 2
                LetEncodeString = sprintf('%s\n\n%s',LetEncodeStringR1,LetEncodeStringR2);
            case 3
                LetEncodeString = sprintf('%s\n\n%s%s%s%s%s\n\n%s',LetEncodeStringR1,'*',CharBetLet,'*',CharBetLet,'*',LetEncodeStringR2);
        end
        
        % Five Letter List
    case 5
        LetEncodeStringR1 = sprintf('%s%s%s%s%s',LetList(1),CharBetLet,LetList(2),CharBetLet,LetList(3));
        LetEncodeStringR2 = sprintf('%s%s%s%s%s',LetList(4),CharBetLet,'*',CharBetLet,LetList(5));
        switch NLetRows
            case 1
                error('Mismatch between number of letters to present and allowable rows to present one.')
            case 2
                LetEncodeString = sprintf('%s\n\n%s',LetEncodeStringR1,LetEncodeStringR2);
            case 3
                LetEncodeString = sprintf('%s\n\n%s%s%s%s%s\n\n%s',LetEncodeStringR1,'*',CharBetLet,'*',CharBetLet,'*',LetEncodeStringR2);
        end
        
        % Six Letter List
    case 6
        LetEncodeStringR1 = sprintf('%s%s%s%s%s',LetList(1),CharBetLet,LetList(2),CharBetLet,LetList(3));
        LetEncodeStringR2 = sprintf('%s%s%s%s%s',LetList(4),CharBetLet,LetList(5),CharBetLet,LetList(6));
        switch NLetRows
            case 1
                error('Mismatch between number of letters to present and allowable rows to present one.')
            case 2
                LetEncodeString = sprintf('%s\n\n%s',LetEncodeStringR1,LetEncodeStringR2);
            case 3
                LetEncodeString = sprintf('%s\n\n%s%s%s%s%s\n\n%s',LetEncodeStringR1,'*',CharBetLet,'*',CharBetLet,'*',LetEncodeStringR2);
        end
        % Seven Letter List
    case 7
        LetEncodeStringR1 = sprintf('%s%s%s%s%s',LetList(1),CharBetLet,LetList(2),CharBetLet,LetList(3));
        LetEncodeStringR2 = sprintf('%s%s%s%s%s','*',CharBetLet,LetList(4),CharBetLet,'*');
        LetEncodeStringR3 = sprintf('%s%s%s%s%s',LetList(5),CharBetLet,LetList(6),CharBetLet,LetList(7));
        switch NLetRows
            case 1
                error('Mismatch between number of letters to present and allowable rows to present one.')
            case 2
                error('Mismatch between number of letters to present and allowable rows to present one.')
            case 3
                LetEncodeString = sprintf('%s\n\n%s\n\n%s',LetEncodeStringR1,LetEncodeStringR2,LetEncodeStringR3);
        end
        
        % Eight Letter List
    case 8
        LetEncodeStringR1 = sprintf('%s%s%s%s%s',LetList(1),CharBetLet,LetList(2),CharBetLet,LetList(3));
        LetEncodeStringR2 = sprintf('%s%s%s%s%s',LetList(4),CharBetLet,'*',CharBetLet,LetList(5));
        LetEncodeStringR3 = sprintf('%s%s%s%s%s',LetList(6),CharBetLet,LetList(7),CharBetLet,LetList(8));
        switch NLetRows
            case 1
                error('Mismatch between number of letters to present and allowable rows to present one.')
            case 2
                error('Mismatch between number of letters to present and allowable rows to present one.')
            case 3
                LetEncodeString = sprintf('%s\n\n%s\n\n%s',LetEncodeStringR1,LetEncodeStringR2,LetEncodeStringR3);
        end
    case 9
        LetEncodeStringR1 = sprintf('%s%s%s%s%s',LetList(1),CharBetLet,LetList(2),CharBetLet,LetList(3));
        LetEncodeStringR2 = sprintf('%s%s%s%s%s',LetList(4),CharBetLet,LetList(5),CharBetLet,LetList(6));
        LetEncodeStringR3 = sprintf('%s%s%s%s%s',LetList(7),CharBetLet,LetList(8),CharBetLet,LetList(9));
        switch NLetRows
            case 1
                error('Mismatch between number of letters to present and allowable rows to present one.')
            case 2
                error('Mismatch between number of letters to present and allowable rows to present one.')
            case 3
                LetEncodeString = sprintf('%s\n\n%s\n\n%s',LetEncodeStringR1,LetEncodeStringR2,LetEncodeStringR3);
        end
end