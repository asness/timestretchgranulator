SynthDef.new(
    "timestretch", {
        arg
        bufnum,
        amp = 1,
        startPos = 0,        // within the source file, in seconds
        endPos = 60,         // within the source file, in seconds
        outputDur = 60,      // in seconds
        playbackSpeed = 1,   // relative to original speed
        samplerFreq	= 1,     // in Hz
        pitchSmear	= 1.001, // interval ratio.  Should be slightly >1 to avoid a mechanical sound
        out_bus;

        var
        numSamplers = 4096,
        pitchOffsets = Array.new,
        position,
        samplers = Array.new,
        samplerOffsets = Array.new,
        samplingPos,
        samplerEnvs = Array.new,        // envelopes for reducing clicks
        triggerFreq,
        triggers = Array.new,
        outSignal;

        triggerFreq = samplerFreq * playbackSpeed;
        samplingPos = Line.kr(startPos, endPos, outputDur);
        position = BufFrames.kr(bufnum) * samplingPos / BufDur.kr(bufnum);

        numSamplers.do {
            arg i;

            samplerEnvs = samplerEnvs.add(
                0.5 * SinOsc.kr(
                    triggerFreq,
                    (2 * pi) * i / numSamplers - (pi / 2), // phase offset in radians
                    1,
                    1
                );
            );

            // (2 * pi) * i / n spaces n envelopes evenly over one cycle,
            // each envelope in sync with a sample trigger (see below).
            // - ( pi/2 ) shifts each waveform so that it starts and ends
            // with 0 (silence)

            triggers = triggers.add(
                Impulse.kr(
                    triggerFreq,
                    i / numSamplers        	// phase offset between 0 and 1
                );
            );

            // pitch smear is an interval above and below a center frequency

            pitchOffsets = pitchOffsets.add(
                TExpRand.kr(
                    1 / pitchSmear,
                    pitchSmear,
                    triggers[i]
                )
            );

            samplers = samplers.add(
                PlayBuf.ar(
                	2,
                	bufnum,
                	BufRateScale.kr(bufnum) * playbackSpeed * pitchOffsets[i],
                	triggers[i],
                	position,
                	1
                ) * samplerEnvs[i]
        	)
        };
        outSignal = amp * Mix(samplers); // Mix an array of stereo arrays
        // down to a single stereo array
        Out.ar(
            out_bus,
        	outSignal
        );
    }
).writeDefFile;
