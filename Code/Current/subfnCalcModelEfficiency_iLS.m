function [eff VRF BoldEffect] = subfnCalcModelEfficiency_iLS(SPM)
X = SPM.xX.X;
[m n] = size(X);
eff = zeros(1,3);
BoldEffect = zeros(1,3);
count = 0;
tcrit = 3;
noise = 0.66;
Q = pinv(X'*X);

for i = 1:length(SPM.xCon)
    if SPM.xCon(i).STAT == 'T'
        count = count + 1;
        C = SPM.xCon(i).c';
        C = [C; zeros(n-length(C),1)];
        eff(count) = 1/(trace(C'*inv(X'*X)*C));
        VRF(count) = 1/(diag(C'*inv(X'*X)*C));
        X2 = X*Q*C*pinv(C'*Q*C);
        h2 = max(X2) - min(X2);
        D = h2 / (sqrt(X2'*X2));
        BoldEffect(count) = tcrit*D*noise;
    end
end



