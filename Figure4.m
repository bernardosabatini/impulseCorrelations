clear all
close all

trialDuration=10000;		% how many ms or time points of data
randEvents=rand(1,trialDuration);	% will be 1 when impulse events occur, 0 otherwise

kerDecays=10.^[-1:.03:3];	% range of decays to examine
impulseRates=10.^[-3:.1:-1]; % impulse rates per point.  If points are ms, then multiply by 1000 to get Hz

ccImpulseToSensor=zeros(length(impulseRates),length(kerDecays));	% will store CC between the impulse evenets and the calculate sensors kinetics (Figure 2)
ccSensorToState=ccImpulseToSensor;						% will store CC between fixed sensor fluorescent and state variables (Figure 3)

for impulseCounter=1:length(impulseRates)
	impulseRate=impulseRates(impulseCounter);
	impulseEvents=1.0*(randEvents<=impulseRate);	% set random inpulses at that rate

	sensorKernelDecay=100;									% decay constant for the fixed sensor kinetics (Figure 3)
	sensorKer=exp(-[0:trialDuration-1]/sensorKernelDecay);	% kernel for the fixed kinetics sensor (Figure 3)
	sensorFl=conv(impulseEvents, sensorKer);				% sensor fluorescence with fixed kernel (Figure 3)
	sensorFl=sensorFl(1:trialDuration);						% keep valid part 

	for counter=1:length(kerDecays)
		expKer=exp(-[0:trialDuration-1]/kerDecays(counter));	% variable decay kinetics to model response to impulses

		impulseConv=conv(impulseEvents, expKer);				% response to impulses
		impulseConv=impulseConv(1:trialDuration);				% first half

		validExtent=round(1+4*kerDecays(counter)):(trialDuration);	% only look at data more than 4 time constants out to avoid the rising transients.

		ccImpulseToSensor(impulseCounter, counter)=corr(impulseConv(validExtent)', impulseEvents(validExtent)'); % cc between variable kinetic modeled sensor response and impulses (Figure 2)
		ccSensorToState(impulseCounter, counter)=corr(impulseConv(validExtent)', sensorFl(validExtent)'); % cc between fixed response sensor kinetics and state variables (Figure 3)
	end
end

figure;
imagesc(ccImpulseToSensor);
set(gca, 'CLim', [0 1])
title('Figure 4A')

figure; 
plot(ccImpulseToSensor')
title('Figure 4A for each rate')

figure;
imagesc(ccSensorToState);
set(gca, 'CLim', [0 1])
title('Figure 4B')

figure; 
plot(ccSensorToState')
title('Figure 4B for each rate')

