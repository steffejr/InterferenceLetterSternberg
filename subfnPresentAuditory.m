function TrialStartTime = subfnPresentAuditory(pahandle,OnTime)

numAudioLoops=round(OnTime/(.2));
TrialStartTime = GetSecs;
PsychPortAudio('Start', pahandle, numAudioLoops, 0, 1);