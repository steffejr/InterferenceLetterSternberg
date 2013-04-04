function TrialStartTime = subfnPresentAuditory(pahandle,OnTime)
TrialStartTime = GetSecs;
PsychPortAudio('Start', pahandle, [0],[],[],GetSecs+OnTime);
