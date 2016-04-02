#! \usr\bin\python -w

# This is a software implementation of a Sigma-Delta DAC 
# It was used to specify the oversampling rate for good SNR in the audio range, 
# and integrator bit-width required to avoid overflow. 

# Last Revised: 5/24/2015 by SSundaresh

# Modules Required
import sys
import wave
import numpy as np
from numpy import sin, cos, log10, linspace, pi, floor, sqrt
from numpy.fft import rfft as dft
import matplotlib.pyplot as plt

# Generate an input tone of frequency w in [0,normalizeTo], natural.
def generateInputTone (w,duration,Fs,numbits,t,normalizeTo):
    tone = [int(x) for x in floor( ((sin(w*t)+1)/2)*normalizeTo + 0.5)] 
    #plt.plot(t,tone)
    #plt.xlabel('Time (s)')
    #plt.ylabel('Audio Input')
    #plt.ylim(0,normalizeTo)
    #plt.show()
    return tone

# Check for overflow in signed two's complement bitwise arithmetic.
def checkOverflow(a,b,signbitmask):    
    asb = a & signbitmask
    bsb = b & signbitmask
    temp = a+b
    tsb = temp & signbitmask
    if (asb == bsb) & (tsb !=asb):
        return 1
    return 0    

if __name__ == '__main__':    
    # Configuration of this Test    
    Fs = 40000 			# 40kHz 'input' sampling rate
    duration = 0.1 		# seconds
    w1 = 2*pi*440 		# Hz target tone 1
    amplitude1 = 0.00 	# relative to full swing
    w2 = 2*pi*10000 	# Hz target tone 2
    amplitude2 = 0.05 	# relative to full swing
    numbits = 8 		# unsigned 8 bit PCM
    DACextensionbits = 2 # addition/integration extension bits
    K = 64 				# oversampling output rate multiplier   
    tsampInput = linspace(0, duration, duration*Fs) 	# Sample times for input
    tsampOutput = linspace(0, duration, duration*Fs*K) 	# Sample times for oversampled outputs
    normalizeTo = 2**numbits - 1 						# Set scale of generated input samples
    
    # DAC Setup
    intMask = 2**(numbits+DACextensionbits+1)-1 		# A mask limiting integrator
    signBit = (intMask+1)/2 							# Get the sign bit from the mask
    signExtensionMask = ~intMask
    qH = normalizeTo 									# quantizer high level - input is unsigned numbits
    qL = 0 												# quantizer low level - input is unsigned numbits

    intOverFlag = 0 									# if integrator addition overflows
 
    intQ = 0 											# Integrator, bit-width numbits+DACextensionbits+1 (sign bit), goes 0 on reset
    quantized = 1 										# single quantized output bit, 1 on reset
    
    analogLPFMemory = 8 								# A buffer to windowed-average and display the DAC output, for testing purposes.
    AnalogDACBuffer = [(qH+qL)/2 for x in xrange(0,analogLPFMemory)]
    LPFBufferIndex = 0
    
    quant2int = qH 										# initial condition for feedback from quantizer
    analogOut = 0 										# initially 
    
    dacInput = [generateInputTone(w1,duration,Fs,numbits,tsampInput,int(floor(float(normalizeTo)*amplitude1))),\
                generateInputTone(w2,duration,Fs,numbits,tsampInput,int(floor(float(normalizeTo)*amplitude2)))]
    dacInput = [dacInput[0][x] + dacInput[1][x] for x in xrange(len(dacInput[0]))] 

    dacOutput = []    
    overFlow = []
    quantizedVals = []
    integratorOut = []

    													# generate low pass filter y(n) = k2 (x(n) + x(n-1)) - k1 y(n-1) 
    RC = 0.9; 											# 'low' relative to K*Fs integrator and quant frequency
              											# shitty low pass filter
              											# took analog RC filter and applied bilinear transform
              											# s = z-1 / z+1 to generate DT LPF
    k1 = (1-RC)/(1+RC)
    k2 = 1/(1+RC)
    #w = linspace(-1,1,1000)
    #g = 20*log10 (abs(2*cos(w*pi/2)) / \
    #        (sqrt((1/(1+k1**2))+2*k1*cos(w*pi)))) + 20*log10(k2)
    #plt.plot(w,g)
    #plt.xlabel('Normalized w')
    #plt.ylabel('LPF Gain Response G(z)')
    #plt.ylim(-50,0)
    #plt.show()
    
    # execute DAC   
    for dacIn in dacInput:
        for oversample in xrange(0,K):
            											# keep track of output
            dacOutput.append(analogOut)
            overFlow.append(intOverFlag)            
            quantizedVals.append(quantized)
            											# if the integrator is negative, 
            											# bitwise or with the sign extended mask
            											# so we can easily check for overflows
            if (intQ & signBit) == signBit:
                integratorOut.append(intQ | signExtensionMask)
            else:
                integratorOut.append(intQ)
                										# subtract the feedback from the quantizer
            fbsum = (dacIn + ~quant2int + 1) & intMask 	# can't overflow
            											
            											# check whether the integration addition will overflow
            											# to help properly size integrator
            intOverFlag = checkOverflow(fbsum,intQ,signBit)
            											# accumulate in integrator and mask out overflow
            intQ = (fbsum + intQ) & intMask              
            											# quanitize result
            if (intQ & signBit) == signBit: 			
                quantized = 0
            else:
                quantized = 1    
    	
    													# store output history for filtering
            AnalogDACBuffer[LPFBufferIndex] = quantized * normalizeTo             
            LPFBufferIndex = (LPFBufferIndex + 1) % analogLPFMemory                                     
            analogOut = sum(AnalogDACBuffer)/analogLPFMemory 

            											# set feedback from quantizer
            if quantized == 0:
                quant2int = 0
            else:
                quant2int = qH            
            
  
    													# scale DacOut to view alongside input
    dacOut = [255 if x == 1 else 0 for x in quantizedVals]

    													# compute dfts to study noise properties associated with sampling in audio band
    lenDFT = 2048
    dftIn = abs(dft(dacInput,lenDFT))
    fIn = [x*float(Fs)/lenDFT for x in range(0,(lenDFT/2)+1)]
    dftOut = abs(dft(dacOut,lenDFT*K))
    fOut = [x*float(Fs)/lenDFT for x in range(0,(lenDFT*K/2)+1)]
    
    													# ignore DC component & normalize the ffts
    dftIn = dftIn[1::]
    fIn = fIn[1::]
    dftOut = dftOut[1::]
    fOut = fOut[1::]
    mdftIn = max(dftIn)
    mdftOut = max(dftOut)
    dftIn = [x / mdftIn for x in dftIn]
    dftOut = [x / mdftOut for x in dftOut]

    													# plot analog output, digital input, and overflows 
    f, axarr = plt.subplots(5, sharex=True)
    axarr[0].plot(tsampOutput,quantizedVals)     
    axarr[1].plot(tsampOutput,integratorOut)    
    axarr[2].plot(tsampOutput,overFlow)
    axarr[3].plot(tsampInput,dacInput)  
    axarr[4].plot(tsampOutput,dacOutput)

    f1, axarr2 = plt.subplots(2,sharex=True)    
    axarr2[0].plot(fIn,dftIn)   
    axarr2[1].plot(fOut,dftOut)
    plt.show()
    
    													# write input to wav file to hear it
    writeIn = wave.open('testIn.wav',mode='wb')
    writeIn.setnchannels(1)
    writeIn.setsampwidth(1)
    writeIn.setframerate(Fs)
    writeIn.setnframes(len(dacInput))
    dacIn = wave.struct.pack('%dB'%len(dacInput),*tuple(dacInput))
    writeIn.writeframes(dacIn)
    writeIn.close()

    													# write output to wav file to hear it
    writeOut = wave.open('testOut.wav',mode='wb')
    writeOut.setnchannels(1)
    writeOut.setsampwidth(1)
    writeOut.setframerate(Fs*K)
    writeOut.setnframes(len(dacOut))
    dacOut = wave.struct.pack('%dB'%len(dacOut),*tuple(dacOut))
    writeOut.writeframes(dacOut)
    writeOut.close()

    sys.exit(0)

