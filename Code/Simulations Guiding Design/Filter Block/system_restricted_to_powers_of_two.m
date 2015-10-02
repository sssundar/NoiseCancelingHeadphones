# This script is a sw implementation of the filter update algorithm implemented
# for my headphones. The script uses full binary arithmetic. It deviates from
# the final algorithm implemented in that the LFSR is not always running.

# I tied down the specifications for the filter update algorithm using this script.
# Namely, how to implement the LFSR based random walk, how long to let the LFSR run before
# it was a decent generator, how far to extend multiplication precision, 
# how many powers-of-two coefficients should be able to access,
# accumulator precision, when it was safe to truncate the accumulator, DC offset effects,
# the effect of truncation to an 8-bit signed integer (DAC capping),
# whether an absolute value norm for the residual was sufficient,
# how long to let the filter update as a function of input complexity (# tones),
# as well as sampling rate, filter coefficient resolution, etc.,
# and, finally, the number of filter coefficients/length of filter update interval.

# In older revisions I studied the effect of decaying filter step size,
# which results in the user not having to press any buttons to 'stop adapting'
# and so on, but in the end I decided to go with a simple first-pass algorithm.

# Last Revised Sep 25, 2015 by Sushant Sundaresh

clear;

                                  # Set up sampling parameters to mimic ADC
samplingPeriod = 1/1000;          # seconds per sample
samplingRate = 1/samplingPeriod;  # Hz
endSecond = 40;                   # seconds
times = 0:samplingPeriod:endSecond;
N = length(times);                # length of simulation in 'clock steps'

freq1 = (1/100) * samplingRate;   # generate two-tone signal
freq2 = (1/10) * samplingRate;    
amp1 = 64;                        # let p-p amplitude just top out 8-bit range
amp2 = 63;
inputPropagationDelay = 10 * samplingPeriod;  # simulate a delay-filter from external mic to internal mic
 
inputAtFilter = @(t) round(amp1 * sin(2*pi*freq1*t) + amp2 * sin(2*pi*freq2*t));
inputAtTarget = @(t) inputAtFilter(t-inputPropagationDelay); 

outputPropagationDelay = 8;       # samples output from filter is delayed (simulated filter)
outputHistory = zeros(outputPropagationDelay,1);  # as implemented by this buffer

K = 32; # filter length           # number of coefficients in the filter

randFilter = zeros(K,1);          # the working filter


global currentState = zeros(2*K, 1);  # the LFSR state
function [result] = xnor(a,b,c,d)     # LFSR feedback is via XNORs to make stuck state high
  temp = sum([a,b,c,d]);
  if ((temp == 0) || (temp == 2) || (temp == 4))
    result = 1;
  else 
    result = 0;
  endif;
endfunction;


                                  # max-len LFSR for K = 32.
function [result] = lfsrUnifRnd(K)
  global currentState;
  temp = xnor(currentState(60), currentState(61), currentState(63), currentState(64));
  currentState(2:64) = currentState(1:63);
  currentState(1) = temp;
  result = zeros(2*K, 1);
  for m = 1:2:2*K
    result(((m-1)/2)+1) = 2*currentState(m) + currentState(m+1);
  endfor;
endfunction;

                                # bit-wise arithmetic with 2^-3 precision to convolve filter with input history.
function [outputAtFilter] = myFilter (currFilt, inputHistory)
  # inputHistory' * currFilt truncating intermediate values at 2^-2 place.
  outputAtFilter = 0;
  precision = 8;
  for m = 1:length(inputHistory)
    temp = precision*(currFilt(m) * inputHistory(m));
    if temp < 0
      outputAtFilter += ceil(temp);
    else
      outputAtFilter += floor(temp); 
    endif;
  endfor;
  outputAtFilter /= precision;
  if outputAtFilter < 0
    outputAtFilter = ceil(outputAtFilter);
  else
    outputAtFilter = floor(outputAtFilter); 
  endif;
  
  if outputAtFilter < -128
    outputAtFilter = -128;
  elseif outputAtFilter > 127
    outputAtFilter = 127;
  endif;
endfunction;

                              # Filter Update Logic
                              # Can shift right, left, or stay invariant. 
                              # Cap at 0.5 and -0.5. 
                              # When walking from 0 -> negative, or positive <- 0,
                              # magnitude is set at 2**-8
function [nextFilt] = filtUpdate (currFilt, K)
  #shifts = floor(unifrnd(0,3,K,1));
  shifts = lfsrUnifRnd(K); # K numbers in 0-3
  nextFilt = zeros(K,1);
  for m = 1:K
    shiftm = shifts(m);
    if ((shiftm == 0) || (shiftm == 3))
      nextFilt(m) = currFilt(m);
    elseif shiftm == 1
      if currFilt(m) == 0
        nextFilt(m) = -2**-8;
      elseif ((currFilt(m) > 0) && (abs(currFilt(m) / 2) <= 2**-8))
        nextFilt(m) = 0;
      elseif (currFilt(m) > 0)
        nextFilt(m) = currFilt(m)/2;
      elseif ((currFilt(m) < 0) && (abs(currFilt(m) * 2) <= 2**-1))
        nextFilt(m) = currFilt(m) * 2;
      else 
        nextFilt(m) = -2**-1;
      endif;
    elseif shiftm == 2
      if currFilt(m) == 0
        nextFilt(m) = 2**-8;
      elseif ((currFilt(m) > 0) && (abs(currFilt(m) * 2) <= 2**-1))
        nextFilt(m) = currFilt(m) * 2;
      elseif (currFilt(m) > 0)
        nextFilt(m) = 2**-1;
      elseif ((currFilt(m) < 0) && (abs(currFilt(m) / 2) >= 2**-8))
        nextFilt(m) = currFilt(m) / 2;
      else 
        nextFilt(m) = 0;
      endif;    
    endif;
  endfor;
endfunction

                        # Simulate Filter
                        # Save inputs and outputs at target for later plotting
inputsAtTarget = zeros(1,N);
outputsAtTarget = zeros(1,N);

                        # Every 2*K samples let filter update.
                        # Keep track of best filter, and that abs(error), summed. 
                        # Only keep updated filter and update minimum error if better.
allFilters = [];
bestFilter = zeros(K,1);
bestError = Inf;        # initialize high

currentUpdateIndex = 0;   # out of 2*K till the next update
absResidual = 0;          # working residual

inputHistory = zeros(K,1);  # for convolution


# seed the LFSR away from all zeros and into a mixed state. 
# user would do this by initializing the FPGA without allowing updates
# for a second or so, so the LFSR could clock a million times.
for k = 1:5000
  lfsrUnifRnd(K);
endfor;

# run system forward in time
for k = 1:N
  # Input At Ear
  inputsAtTarget(k) = inputAtTarget(times(k));
  
  # Update Input History
  inputHistory(2:K) = inputHistory(1:K-1);
  inputHistory(1) = inputAtFilter(times(k));
  
  # Stop updating after 3/4 time, to see best filter in action
  if k < 3*N/4
    filtOutput = myFilter(randFilter, inputHistory); 
  else
    filtOutput = myFilter(bestFilter, inputHistory);
  endif;

  # Simulate Delayed Output
  outputsAtTarget(k) = outputHistory(outputPropagationDelay);
  outputHistory(2:outputPropagationDelay) = outputHistory(1:outputPropagationDelay-1);
  outputHistory(1) = filtOutput;
 
  # Calculate Error At Internal Mic and calculate a running sum of its absolute value
  currentError = inputsAtTarget(k) + outputsAtTarget(k);  # during development I forgot to truncate this to 8 bits
  absResidual = absResidual + abs(currentError);          
  currentUpdateIndex = currentUpdateIndex + 1;

  if ((k < 3*N/4) && (currentUpdateIndex == 2*K))   
    # It is time to update the best filter
    currentUpdateIndex = 0;    
    if absResidual < bestError
      bestError = absResidual;
      bestFilter = randFilter;
    endif;
    # It is time to take a random step in our walk to find a perfect cancelation filter
    randFilter = filtUpdate(bestFilter, K);               
    absResidual = 0;

    allFilters = [allFilters, randFilter];       # record all filters for analysis of coefficient scale
  endif;
    
endfor;

figure;

# Plot the percent error at the ear as the filter adapts, as a measure of dB reduction
#epsilon = 1E-7;
#plot(times,100*abs(inputsAtTarget+outputsAtTarget)/(amp1+amp2) + epsilon,'r-');
#xlim([endSecond-100*samplingPeriod,endSecond]);
#ylim([0 10]);

# Plot the simulated waveform at the ear against the undisturbed input at the target
# as the filter adapts, as a visual measure of dB reduction
subplot(2,1,1); 
plot(times,inputsAtTarget+outputsAtTarget,'r-'); 
xlim([endSecond-100*samplingPeriod,endSecond]);
subplot(2,1,2); 
plot(times,inputsAtTarget,'b-'); 
xlim([endSecond-100*samplingPeriod,endSecond]);