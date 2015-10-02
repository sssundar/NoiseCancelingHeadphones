
samplingPeriod = 1/100; # seconds per sample
endSecond = 10; # seconds

freq1 = 0.1 * (1/samplingPeriod); 
amp1 = 1;
inputAtTarget = @(t) amp1 * sin(2*pi*freq1 * t);

outputPropagationDelay = 2; # samples
outputHistory = zeros(outputPropagationDelay,1);

times = 0:samplingPeriod:endSecond;
NSamples = length(0:samplingPeriod:endSecond);
inputs = zeros(NSamples,1);
outputs = zeros(NSamples,1);
cnt = 0;
for t = 0:samplingPeriod:endSecond 
    cnt = cnt + 1;
    inputs(cnt) = inputAtTarget(t);
    outputs(cnt) = outputHistory(outputPropagationDelay);
    error = inputs(cnt) + outputs(cnt);
    outputHistory(2:outputPropagationDelay) = outputHistory(1:outputPropagationDelay-1);
    outputHistory(1) = -0.8*error;
endfor;

plot(times,inputs+outputs,'r-');
