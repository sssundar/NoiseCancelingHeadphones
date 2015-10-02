clear;

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
mu = 0.1; # filter update scaling
stepSizes = mu*exp(-times/4);

randFilter = zeros(K,1);
filtUpdate = @(mu) mu*unifrnd(-1,1,K,1);

inputsAtTarget = zeros(1,N);
outputsAtTarget = zeros(1,N);

# Every K samples let filter update.
# Keep track of best filter, and that error, squared, summed. 
# Only keep updated filter and update min error if better.
allFilters = [];
bestFilter = zeros(K,1);
bestError = Inf;

currentUpdateIndex = 0;
summedSQResidual = 0;

inputHistory = zeros(K,1);
errorHistory = zeros(N,1);



for k = 1:N
  inputsAtTarget(k) = inputAtTarget(times(k));
  
  inputHistory(2:K) = inputHistory(1:K-1);
  inputHistory(1) = inputAtFilter(times(k));
  
  filtOutput = inputHistory' * randFilter;
  outputsAtTarget(k) = outputHistory(outputPropagationDelay);
  outputHistory(2:outputPropagationDelay) = outputHistory(1:outputPropagationDelay-1);
  outputHistory(1) = filtOutput;
  
  currentError = inputsAtTarget(k) + outputsAtTarget(k);   
  errorHistory(k) = currentError;  
  summedSQResidual = summedSQResidual + currentError^2;
  currentUpdateIndex = currentUpdateIndex + 1;
  
  if currentUpdateIndex == 2*K
    currentUpdateIndex = 0;    
    if summedSQResidual < bestError
      bestError = summedSQResidual;
      bestFilter = randFilter;
    endif;
    randFilter = bestFilter + filtUpdate(stepSizes(k));           
    summedSQResidual = 0;
    allFilters = [allFilters, randFilter];                   
  endif;
    
endfor;

subplot(2,1,1);
semilogy(times,100*abs(inputsAtTarget+outputsAtTarget)/amp1,'r-');
ylim([0.1 100]);
ylabel("Percent Error");
subplot(2,1,2); 
plot(times,stepSizes,'b-');
ylabel("Step Size");
xlabel("Time, seconds");

%figure;
%plot3(log10((allErrors'*ones(1,K))'),cumsum(ones(K,length(allFilters(1,:)))),allFilters);
%xlabel("Log10 Error");
%ylabel("Filter Coefficient");
%zlabel("Filter Value");
