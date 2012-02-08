function subfnTempOrderPlotDurationVsRT(Trials)
LongKey = '/?';
ShortKey = 'z';
SplitTime = 1.5;
NTrials = length(Trials);
RT = zeros(NTrials,1);
Durations = zeros(NTrials,1);
Accuracy = zeros(NTrials,1);
Rating = zeros(NTrials,1);
for i = 1:NTrials
    RT(i) = Trials{i}.ResponseTime;
    Durations(i) = Trials{i}.Visual.duration + Trials{i}.Auditory.duration;
    if strcmp(Trials{i}.ResponseKey,LongKey)
        Rating(i) = 1;
        if (Durations(i) > SplitTime)
            Accuracy(i) = 1;
        else
            Accuracy(i) = -1;
        end
    elseif strcmp(Trials{i}.ResponseKey,ShortKey)
        Rating(i) = -1;
        if (Durations(i) < SplitTime)
            Accuracy(i) = 1;
        else
            Accuracy(i) = -1;
        end
    end
end

figure(101)
clf
hold on
Correct = find(Accuracy == 1);
Incorrect = find(Accuracy == -1);
ShortCorrect = find((Accuracy == 1)&(Rating == -1));
ShortIncorrect = find((Accuracy == -1)&(Rating == -1));
LongCorrect = find((Accuracy == 1)&(Rating == 1));
LongIncorrect = find((Accuracy == -1)&(Rating == 1));

plot(Durations(ShortCorrect),RT(ShortCorrect),'bo');
plot(Durations(LongCorrect),RT(LongCorrect),'ro');
plot(Durations(ShortIncorrect),RT(ShortIncorrect),'bx');
plot(Durations(LongIncorrect),RT(LongIncorrect),'rx');
legend('Short, Correct','Long, Correct','Short, Incorrect','Long, Incorrect')
xlabel('Duration');
ylabel('RT');