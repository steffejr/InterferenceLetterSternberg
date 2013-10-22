function subfnTemporalOrderPlotTiming(Trials)
NTrials = length(Trials);
TimeAud = zeros(NTrials,3);
TimeVis = zeros(NTrials,3);
for i = 1:NTrials
    TimeAud(i,1) = Trials{i}.Auditory.ExpectedOn;
    TimeAud(i,2) = Trials{i}.Auditory.ActualOn;
    TimeAud(i,3) = Trials{i}.Auditory.ExpectedOn - Trials{i}.Auditory.ActualOn;
    
    TimeVis(i,1) = Trials{i}.Visual.ExpectedOn;
    TimeVis(i,2) = Trials{i}.Visual.ActualOn;
    TimeVis(i,3) = Trials{i}.Visual.ExpectedOn - Trials{i}.Visual.ActualOn;
end
%%
figure(1)
clf
subplot(2,2,1)
hold on
plot(TimeVis(:,1),'.-')
plot(TimeVis(:,2),'r.-')
legend('Expected','Actual')
title('Visual')
ylabel('Seconds')
subplot(2,2,2)
hold on
plot(TimeAud(:,1),'.-')
plot(TimeAud(:,2),'r.-')
legend('Expected','Actual')
title('Auditory')

subplot(2,2,3)
plot(TimeVis(:,3),'.-')
xlabel('Trial Number')
ylabel('Seconds')
subplot(2,2,4)
plot(TimeAud(:,3),'.-')
xlabel('Trial Number')
