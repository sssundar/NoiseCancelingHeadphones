#! \usr\bin\python -w

# This script reads in voiceTest.wav, a test sound sample, and 
# rounds it to an 8 bit unsigned integer, then writes it out again. 
# This was intended to let me hear the difference and choose an audio sampling resolution 
# accordingly. 

# Last revised 5/26/2015 by SSundaresh

# Modules Required
import sys
import wave
import numpy as np
from numpy import sin, cos, log10, linspace, pi, floor, sqrt
from numpy.fft import rfft as dft
import matplotlib.pyplot as plt

if __name__ == '__main__':            
	# Get Sample Audio	
	readIn = wave.open('voiceTest.wav',mode='rb')
	n = readIn.getnframes()
	f = readIn.getframerate()
	# Unpack audio, being careful with byte order 
	inVals = wave.struct.unpack('%dh'%n,readIn.readframes(n))
	readIn.close()

	# Level shift the input to be strictly positive
	mi = min(inVals)
	inVals = [abs(val + mi) for val in inVals]
	ma = max(inVals)
	# scale level shifted input to [0,1] then scale up to 0, 255 in the naturals.
	inVals = [int(floor((2**8-1)*(float(val)/ma) + 0.5)) for val in inVals]
	# display the result for visual clarity on the choppiness of the conversion
	plt.plot(range(0,n),inVals)
	plt.show()
	
	# write out the result as a .wav for hearing the difference in Audacity
	writeOut = wave.open('voiceTest8bitOut.wav',mode='wb')
	writeOut.setnframes(n)
	writeOut.setnchannels(1) # Mono
	writeOut.setsampwidth(1) # Single Byte Data 
	writeOut.setframerate(f)
	writeOut.writeframes(wave.struct.pack('%dB'%n,*tuple(inVals)))
	writeOut.close()

	sys.exit(0)

