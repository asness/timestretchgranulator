# AmazingTimeStretchGranulator

I wrote this SuperCollider script a long time ago.  It time-stretches audio files using [granulation](https://en.wikipedia.org/wiki/Granular_synthesis), jiggling the samples a little to smooth them out.  I think it sounds great, and I've used it for a series of albums called (Not Knowing)[https://alexness.bandcamp.com/album/not-knowing], for very patient listeners.

Most time-stretching software (e.g. [PaulStretch](http://hypermammut.sourceforge.net/paulstretch/)) uses a frequency transform approach, roughly as follows:

1. take an [STFT](https://en.wikipedia.org/wiki/Short-time_Fourier_transform);
2. randomize each frame's phase data while preserving its amplitude data;
3. interpolate the frames;
4. resynthesize.

But I think that granulation sounds better, particular for noisy samples.  It takes a long time to generate high-quality output, but that's okay.

Incidently, [9BeetStretch](http://www.xn--lyf-yla.com/) uses a granulation technique as well.
