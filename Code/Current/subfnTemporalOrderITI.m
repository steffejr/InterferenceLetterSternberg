function ITI = subfnTemporalOrderITI(NTrials,G,offset)

ITI = (round(((randg(ones(NTrials,1))*G) + offset)*100)/100);