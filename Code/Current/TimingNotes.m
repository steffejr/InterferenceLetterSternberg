12 seconds per trial
32 trials
Intro delay = 5
End Delay = 10

Total processing time = 384 sec = 6:24
Total time with delays = 399 sec = 6:39


480 - 384 - 15 = 81


flag = 1;
count = 0;
while flag 
    ITI = (round(((randg(ones(NTrials,1))*2) + 1)*100)/100);
    sITI = sum(ITI);
    count = count + 1;
    if sITI == 81
        break
    end
end
count
    
    
MRI Scans 