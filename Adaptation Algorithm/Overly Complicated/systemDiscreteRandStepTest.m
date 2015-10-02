clear;

% This is wrong - still taking tiny steps. Want it to be shifters not multiplers.

# Things to Try
#  decreasing step size for fixed time - exponential but discrete
#  binarize all arithmetic, choose how to add about 32 unsorted numbers to see effect of truncation error, abs (2s comp)
# truncate to 8 bits or 10 bits or whatever - right now am stepping in 2exp, but not truncating at 8 bits.

#  longer/shorter search times -> 0.75 of 20 seconds at kHz sampling, with update every 64 samples, gets us to 1-3% original amplitude consistently with abs-error

samplingPeriod = 1/1000; # seconds per sample
samplingRate = 1/samplingPeriod; # Hz
endSecond = 20; # seconds
times = 0:samplingPeriod:endSecond;
N = length(times);

freq1 = 0.1 * samplingRate; 
amp1 = 1;
inputPropagationDelay = 10 * samplingPeriod;
 
inputAtFilter = @(t) amp1 * sin(2*pi*freq1*t);
inputAtTarget = @(t) inputAtFilter(t-inputPropagationDelay); 

outputPropagationDelay = 8; # samples
outputHistory = zeros(outputPropagationDelay,1);

K = 32; # filter length

randFilter = zeros(K,1);
function [scale] = getScale(sample) 
  if sample > 1000
    scale = 4;
  elseif sample > 2000
    scale = 5;
  elseif sample > 3000
    scale = 6;
  else
    scale = 3;
  endif;
endfunction

function [steps] = filtUpdate (K, sample)
  steps = floor(unifrnd(-8,9,K,1));
  for m = 1:K
    stepm = steps(m);
    if stepm < 0
      if (stepm-getScale(sample) < -8)
        stepm = 0;
      else
        stepm = -(2**(stepm-getScale(sample)));
      endif;
    else
      if (stepm + getScale(sample) > 8)
        stepm = 0;
      else
        stepm = 2**-(stepm+getScale(sample));
      endif;
    endif;
    steps(m) = stepm;
  endfor;
endfunction

inputsAtTarget = zeros(1,N);
outputsAtTarget = zeros(1,N);

# Every K samples let filter update.
# Keep track of best filter, and that error, squared, summed. 
# Only keep updated filter and update min error if better.
allFilters = [];
bestFilter = zeros(K,1);
bestError = Inf;

currentUpdateIndex = 0;
absResidual = 0;

inputHistory = zeros(K,1);
errorHistory = zeros(N,1);



for k = 1:N
  inputsAtTarget(k) = inputAtTarget(times(k));
  
  inputHistory(2:K) = inputHistory(1:K-1);
  inputHistory(1) = inputAtFilter(times(k));
  
  if k < 3*N/4
    filtOutput = inputHistory' * randFilter;
  else
    filtOutput = inputHistory' * bestFilter;
  endif;
  outputsAtTarget(k) = outputHistory(outputPropagationDelay);
  outputHistory(2:outputPropagationDelay) = outputHistory(1:outputPropagationDelay-1);
  outputHistory(1) = filtOutput;
  
  currentError = inputsAtTarget(k) + outputsAtTarget(k);   
  errorHistory(k) = currentError;  
  absResidual = absResidual + abs(currentError);
  currentUpdateIndex = currentUpdateIndex + 1;
  
  if ((k < 3*N/4) && (currentUpdateIndex == 2*K))
    currentUpdateIndex = 0;    
    if absResidual < bestError
      bestError = absResidual;
      bestFilter = randFilter;
    endif;
    randFilter = bestFilter + filtUpdate(K,k);           
    absResidual = 0;
    allFilters = [allFilters, randFilter];                   
  endif;
    
endfor;

epsilon = 1E-7;
plot(times,100*abs(inputsAtTarget+outputsAtTarget)/amp1 + epsilon,'r-');
ylim([0 10]);
xlim([19.9,20]);
ylabel("Percent Error");