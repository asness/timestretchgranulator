// first, load time-stretch-granulator.scd SynthDef

(
var
inputAudioPath = "/Users/alexanderness/Downloads/projects/audiovisual/listening-practice/granulation-and-time-stretching/symphonies/schubert-8/schubert-8-sample_compressed_stereo.wav",
oscPath = "/Users/alexanderness/Downloads/projects/audiovisual/listening-practice/granulation-and-time-stretching/symphonies/schubert-8/osc-path",
outputAudioPath = "/Users/alexanderness/Downloads/projects/audiovisual/listening-practice/granulation-and-time-stretching/symphonies/schubert-8/schubert-8-sample_time-stretched_quieter_shorter_v2.wav",
serverOpts = ServerOptions.new,
outputDur = 60*13, // seconds
score;

TempoClock.default.tempo = 1;
outputAudioPath.postln;
score = [
	[0, [\b_allocRead, 0, inputAudioPath, 0, 0]],
	[0, [\s_new, \timestretch, -1, 0, 0,
		\bufnum, 0,
		\amp, 0.015,
		\startPos, 0,
		\endPos, 87,
		\outputDur, outputDur,
		\playbackSpeed, 1,
		\samplerFreq, 2,
		\pitchSmear, 1.01,
		\out_bus, 0]],
	[outputDur, [\c_set, 0, 0]]]; // finish

serverOpts.memSize = 8192 * 2;
serverOpts.numOutputBusChannels = 2;
Score.recordNRT(score, oscPath, outputAudioPath, sampleFormat: "int24", options: serverOpts);
)