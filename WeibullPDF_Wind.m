clc
clear all
close all
%% Wind Speed
% Please replace with your wind speed values with m/s unit at wind_speed1
samplesize=500
wind_speed1=rand(1,samplesize)*10
% samplesize=24;
% wind_speed1=[2.7	2.69	2.58	2.48	2.37	2.28	2.18	2.08	1.86	1.63	1.41	1.44	1.47	1.5	1.67	1.84	2.01	2.32	2.63	2.94	2.91	2.87	2.84	2.75
% ]*3;
wind_speed=wind_speed1/max(wind_speed1);

%% Weibull PDF MODELING
mu_v = mean(wind_speed);
sigma_v = std(wind_speed);
k = (sigma_v / mu_v)^(-1.086);% Shape parameter
c = mu_v / gamma(1 + 1/k);% Scale parameter
betaDistributed_wind_speed = wblrnd(c, k, samplesize, 1)*max(wind_speed1);
%% Wind turbine parameters
windcapacity = 5000000;  % Rated power of the wind turbine (5 MW)
v_cut_in = 3.5; % Cut-in wind speed (m/s)
v_rated = 12.5; % Rated wind speed (m/s)
v_cut_out = 25; % Cut-out wind speed (m/s)
%% WEIBULL CALCULATION OF SOLAR OUTPUT
betadistributed_power_output = zeros(samplesize, 1);
for i = 1:samplesize
    v = betaDistributed_wind_speed(i);
    
    if v < v_cut_in || v > v_cut_out
        betadistributed_power_output(i) = 0; % No power generated
    elseif v_cut_in <= v && v < v_rated
        % Power output is proportional to the cube of wind speed
        betadistributed_power_output(i) = windcapacity * ((v - v_cut_in) / (v_rated - v_cut_in));
    else
        betadistributed_power_output(i) = windcapacity; % Rated power output
    end
end
%% Results
fprintf('Weibull Distributed Wind Speed (m/s)');
disp(betaDistributed_wind_speed);
fprintf('Weibull Distributed Power Output');
disp(betadistributed_power_output);
figure;
subplot(3, 1, 1);
plot(1:samplesize, wind_speed1, '-o');
xlabel('Sample');
ylabel('Orignal Wind Speed (m/s)');
subplot(3, 1, 2);
plot(1:samplesize, betaDistributed_wind_speed, '-o');
xlabel('Sample');
ylabel('Weibull Distributed Wind Speed (m/s)');
subplot(3, 1, 3);
plot(1:samplesize, betadistributed_power_output, '-o');
xlabel('Sample');
ylabel('Weibull Distributed Power Output');


