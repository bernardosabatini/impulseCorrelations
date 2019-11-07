clear all
close all

trialDuration=10000;		% how many ms or time points of data
randEvents=rand(1,trialDuration);	% will be 1 when impulse events occur, 0 otherwise

kerDecays=10.^[-1:.03:3];	% range of decays to examine

impulseRate=.01;			% inpulse rate per point.  If points are ms, then this is 10 Hz
impulseEvents=1.0*(randEvents<=impulseRate);	% set random inpulses at that rate

ccImpulseToSensor=zeros(1, length(kerDecays));			% will store CC between the impulse evenets and the calculate sensors kinetics (Figure 2)
ccSensorToState=ccImpulseToSensor;						% will store CC between fixed sensor fluorescent and state variables (Figure 3)

sensorKernelDecay=100;									% decay constant for the fixed sensor kinetics (Figure 3)
sensorKer=exp(-[0:trialDuration-1]/sensorKernelDecay);	% kernel for the fixed kinetics sensor (Figure 3)
sensorFl=conv(impulseEvents, sensorKer);				% sensor fluorescence with fixed kernel (Figure 3)
sensorFl=sensorFl(1:trialDuration);						% keep valid part 

for counter=1:length(kerDecays)
	expKer=exp(-[0:trialDuration-1]/kerDecays(counter));	% variable decay kinetics to model response to impulses
	
	impulseConv=conv(impulseEvents, expKer);				% response to impulses
	impulseConv=impulseConv(1:trialDuration);				% first half
	
	validExtent=round(1+4*kerDecays(counter)):(trialDuration);	% only look at data more than 4 time constants out to avoid the rising transients.

	ccImpulseToSensor(counter)=corr(impulseConv(validExtent)', impulseEvents(validExtent)'); % cc between variable kinetic modeled sensor response and impulses (Figure 2)
	ccSensorToState(counter)=corr(impulseConv(validExtent)', sensorFl(validExtent)'); % cc between fixed response sensor kinetics and state variables (Figure 3)
end

figure
subplot(2,1,1)
plot(kerDecays, ccImpulseToSensor)
set(gca, 'FontSize', 14);
set(gca, 'YTick', [0, 0.5, 1])
set(gca, 'YLim', [0 1.1]);
set(gca, 'XScale', 'Log');
title('Figure 2')

subplot(2,1,2)
plot(kerDecays, ccSensorToState)
hold on
plot(kerDecays, ccImpulseToSensor, 'LineStyle', '--', 'color', 'black')
set(gca, 'FontSize', 14);
set(gca, 'YTick', [0, 0.5, 1])
set(gca, 'YLim', [0 1.1]);
set(gca, 'XScale', 'Log');
title('Figure 3')

