// first, load time-stretch-granulator.scd SynthDef

(
var
inputAudioPath = "INPUTFILEPATH.WAV",
oscPath = "OSCPATH",
outputAudioPath = "OUTPUTFILEPATH.WAV",
serverOpts = ServerOptions.new,
outputDur = 60*60, // seconds
score;

TempoClock.default.tempo = 1;
outputAudioPath.postln;
score = [
	[0, [\b_allocRead, 0, inputAudioPath, 0, 0]],
	[0, [\s_new, \timestretch, -1, 0, 0,
		\bufnum, 0,
		\amp, 0.001,
		\startPos, 0,
		\endPos, 10,
		\outputDur, outputDur,
		\playbackSpeed, 1,
		\samplerFreq, 1,
		\pitchSmear, 1.01,
		\out_bus, 0]],
	[outputDur, [\c_set, 0, 0]]]; // finish

serverOpts.memSize = 8192 * 2;
serverOpts.numOutputBusChannels = 2;
Score.recordNRT(score, oscPath, outputAudioPath, sampleFormat: "int24", options: serverOpts);
)
