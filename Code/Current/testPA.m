function testPA(on,pahandle)
Start = GetSecs;
tic;
testPA2(on,pahandle)
toc
status = PsychPortAudio('GetStatus', pahandle)
function testPA2(on2,pahandle)
PsychPortAudio('Start', pahandle, [0],[],[],GetSecs+on2)
