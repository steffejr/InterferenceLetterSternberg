function subfn_PlotEffOfOneSubject(SPM,eff,BoldEffect)
NCon = length(SPM.xCon);
[m n] = size(SPM.xX.X);
% Plot Effeciciency
     f = figure(11);
    clf
    for i = 1:NCon
        subplot(NCon,2,(i-1)*2+1:i*2)
        C = SPM.xCon(i).c;
        C = [C zeros(1,n/3-length(C))];
        bar(C)
        axis off
        text(-4,1,SPM.xCon(i).name)
        text(40,1,num2str(eff(i)))
    end
%     subplot(NCon+8,2,NCon*2+1:NCon*2+16)
%     imagesc(SPM.xX.X)
    xlabel(num2str(sum(eff)))
    set(f,'Name','Efficiency')

    % Plot Effeciciency
    f = figure(13);
    clf
    for i = 1:NCon
        subplot(NCon,2,(i-1)*2+1:i*2)
        C = SPM.xCon(i).c;
        C = [C zeros(1,n/3-length(C))];
        bar(C)
        axis off
        text(-4,1,SPM.xCon(i).name)
        text(40,1,num2str(BoldEffect(i)))
    end
%     subplot(NCon+8,2,NCon*2+1:NCon*2+16)
%     imagesc(SPM.xX.X)
    xlabel(num2str(sum(BoldEffect)))
    set(f,'Name','BOLD Effect')
f = figure(14);
imagesc(SPM.xX.X)
%colormap('gray')