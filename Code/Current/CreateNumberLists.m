function NumLists = CreateNumberLists(vargin)
% Need to create 
% Low difficulty number lists
% This is just 5 zeros
% Low List POSITIVE Probe is zero
% Low List NEGATIVE probe is not zero
% High difficulty number list is 5 single digit non-zero numbers
% High List POSITIVE Probe is the sum of the numbers
% High List NEGATIVE Probe is NOT the sume of the numbers
% This program can create lists of numbers whose answers are Normally
% distributed or uniformly distributed. If you take a list of single digit
% numbers and add them together and repeat this many times the resultant
% distribution is normally distributed. Therefore, there is a predicted
% mean of whatthe correct answer should be. For example, with a5 number
% list the max sum is 45 and min sum is 5. The mean answer is 25, so an
% answer of 10 is not very probable.
% The alternative is that the answers can be chosen first to be uniformly
% distributed; therefore, there would be less predicatbility in he values.
% Once the answers are chosen then the list of numbers that gives this
% answer can be chosen.
% 
ListLength = vargin(1);
if nargin == 1
   DistType = 'U';
else
    DistType = vargin(2);
end
NList = 3000; % Possible list length
AsciiNumOffset = 48;
Numbers = 3:9;
NumRange = Numbers + AsciiNumOffset; % IN ASCII
%ListLength = 5; % number of Numbers in a list
% Create lists of number WITH REPLACEMENT
NumLists = cell(1,NList);
temp = [];
switch DistType
    case 'N'
        %% NORMALLY DISTRIBUTED ANSWERS
        for i = 1:NList
            tempRHighPOS = ceil(rand(1,ListLength)*length(NumRange));
            HighPOS = num2str(sum(tempRHighPOS));
            % Create the Negative answer by creating a different list of numbers
            % and using that answer
            tempRHighNEG = ceil(rand(1,ListLength)*length(NumRange));
            HighNEG = num2str(sum(tempRHighNEG));
            temp = [ temp;sum(tempRHighPOS)];
            tempRLowNEG = ceil(rand(1,ListLength)*length(NumRange));
            LowNEG = num2str(sum(tempRLowNEG));
            NumLists{i}.HighList = char(NumRange(tempRHighPOS));
            NumLists{i}.HighListPOS = HighPOS;
            NumLists{i}.HighListNEG = HighNEG;
            NumLists{i}.LowList = char([ones(1,ListLength)*48]);
            NumLists{i}.LowListPOS = '0';
            NumLists{i}.LowListNEG = LowNEG;
        end
    case 'U'
        %% UNIFORMLY DISTRIBUTED ANSWERS
        MaxAnswer = sum(ones(ListLength,1)*max(Numbers));
        MinAnswer = sum(ones(ListLength,1)*min(Numbers));
        temp = zeros(NList,1);
        for i = 1:NList
            HighPOS = ceil(rand(1)*(MaxAnswer - MinAnswer) + MinAnswer);
            % With this answer, find numbers that add up to it
            flag = 1;
            while flag
                %% FIX THIS 
                tempRHighPOS = ceil(rand(1,ListLength)*(max(Numbers) - min(Numbers) + 1))+min(Numbers)-1;
                if sum(tempRHighPOS) == HighPOS;
                    flag = 0;
                    % write the high difficulty list
                    NumLists{i}.HighList = char(tempRHighPOS + AsciiNumOffset);
                    % write the POSITIVE answer
                    NumLists{i}.HighListPOS = num2str(HighPOS);
                end
            end
            % Using the list that has a UNIFORMLY distributed POSITIVE answer
            % create a NEGATIVE response.
            flag = 1;
            while flag
                tempRHighNEG = ceil(rand(1,ListLength)*(max(Numbers) - min(Numbers) + 1))+min(Numbers)-1;
                if sum(tempRHighNEG) ~= HighPOS;
                    flag = 0;
                end
            end
            HighNEG = sum(tempRHighNEG);
            % write the NEGATIVE answer
            NumLists{i}.HighListNEG = num2str(HighNEG);
            temp(i) = HighPOS;
            % Write the low difficulty list
            NumLists{i}.LowList = char([ones(1,ListLength)*AsciiNumOffset]);
            % write the low difficulty POSITIVE answer
            NumLists{i}.LowListPOS = '0';
            % write the low difficulty NEGATIVE answer
            LowNEG = ceil(rand(1)*(MaxAnswer - MinAnswer) + MinAnswer);
            NumLists{i}.LowListNEG = num2str(LowNEG);
            
        end
end
%  for i = 1:NList
%      fprintf(1,'%s\t%s\t',NumLists{i}.HighList,NumLists{i}.HighListPOS);
%     fprintf(1,'%s\n',NumLists{i}.HighListNEG);
%  end