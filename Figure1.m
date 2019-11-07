clear all
close all

impulseEvent=zeros(1, 1000);	% array for the impulses
impulseEvent(500)=1;			% put one in the middle

expKer=zeros(1, 1000);			% array for the exponential convolution kernel

figure;
subplot(2,1,1);

plot(-499:500, impulseEvent);	% Figure 1A
set(gca, 'XLim', [-100 500])
set(gca, 'FontSize', 12)
title('Figure 1A')
subplot(2,1,2);

for tau=[10 50 100]
	expKer(500:1000)=exp(-[0:500]/tau);
	plot(-499:500, expKer)
	hold on
	corr(expKer', impulseEvent') % print out the correlation coefficient
end
set(gca, 'XLim', [-100 500])
set(gca, 'FontSize', 12)

%%
impulseRate=0.01;	% 1% chance per time point.  If each time point is 1 ms then this is 10 Hz
impulseEvent=0.1*(rand(1, 1000)<=impulseRate);	% set up random impulses
expKer=zeros(1, 1000);

figure;
subplot(2,1,1);

plot(1:1000, impulseEvent);
set(gca, 'FontSize', 12)
title('Figure 1B');
subplot(2,1,2);

for tau=[10 50 100]
	expKer=exp(-[0:999]/tau); % calculate the kernel
	convR=conv(impulseEvent, expKer); % for the convolution
	convR=convR(1:1000); % take the first 1/2
	plot(0:999, convR);
	hold on
	corr(convR', impulseEvent') % print out the correlation coefficient
end
set(gca, 'FontSize', 12)