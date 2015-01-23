BoldEff

mBoldEff = squeeze(mean(BoldEff,1));
X = mBoldEff(:,end);
sBoldEff = squeeze(std(BoldEff,1));
s = sBoldEff(:,end);

XN = squeeze(mean(NTrialsPerLoad,1));
sN = squeeze(mean(NTrialsPerLoad,1));
lowN = XN(:,8) - 1.96*(sN(:,8)/sqrt(50));
hiN =  XN(:,8) + 1.96*(sN(:,8)/sqrt(50));

lowCI = X - 1.96*(s/sqrt(100));
upCI = X + 1.96*(s/sqrt(100));
%%
figure(1)
clf
hold on
plot(1-ErrorList,X,'k')
plot(1-ErrorList,lowCI,'--k')
plot(1-ErrorList,upCI,'--k')
axis([0.5 1 0.4 0.8])
xlabel('Accuracy')
ylabel('Percentage BOLD Change')

figure(2)
clf
hold on
plot(XN(:,8),X,'k')
plot(lowN,X,'k--')
plot(hiN,X,'k--')
%axis([0.5 1 0 17])
xlabel('Accuracy')
ylabel('Percentage BOLD Change')
%%
M = [mX1(1) mX2(1) mX3(1) mX4(1)];
S = [sX1(1) sX2(1) sX3(1) sX4(1)];
lowCI = M - 1.96*S/sqrt(2);
hiCI = M + 1.96*S/sqrt(2);
figure(3)
clf
hold on
plot([2 4 6 8],M,'k')
plot([2 4 6 8],lowCI,'k--')
plot([2 4 6 8],hiCI,'k--')
axis([2 8 0 17])
ylabel('Statistical Efficiency')
xlabel('Trials Per Load Level')
