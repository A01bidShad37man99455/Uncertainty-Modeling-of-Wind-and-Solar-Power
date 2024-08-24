clc
clear all
close all
%% Irradiance
% Please replace with your sample irradiance values values in W/m^2 unit at solar_irradiance1
samplesize=500
solar_irradiance1=rand(1,samplesize)*800
% samplesize=10
% solar_irradiance1=[113.05	308.92	558.65	666.07	724.46	679.47	513.88	365.89	225.12	70.62
% ];
solar_irradiance=solar_irradiance1/max(solar_irradiance1);
%% BETA PDF MODELING
mu_G = mean(solar_irradiance)
sigma_G2 = var(solar_irradiance)
beta =abs((1 - mu_G) * (mu_G * (1 + mu_G / sigma_G2) - 1));
alpha =abs((mu_G * beta) / (1 - mu_G));
distributed_solar_irradiance = betarnd(alpha, beta, samplesize, 1)*max(solar_irradiance1);
%% SOLAR PARAMETERS
Solarcapacity = 5000000;     % 5MW-Rated power of the solar plant
STC_G = 1000;    % Standard Test Condition irradiance (W/m^2)
CertainIRpoin = 120;        % Critical irradiance point

%% BETA CALCULATION OF SOLAR OUTPUT
power_output = zeros(samplesize, 1);
for i = 1:samplesize
    G = distributed_solar_irradiance(i);
    if G < CertainIRpoin
        power_output(i) = (Solarcapacity * (G)^2) / (STC_G * CertainIRpoin);
    else
        power_output(i) = (Solarcapacity * G) / STC_G;
    end
end
%% Results
fprintf('Beta Distributed Solar Irradiance (W/m^2):\n');
disp(distributed_solar_irradiance');
fprintf('Power Output (MW):\n');
disp(power_output);
figure;
subplot(3, 1, 1);
plot(1:samplesize, solar_irradiance1, '-o');
xlabel('Sample');
ylabel('Orignal Solar Irradiance (W/m^2)');
subplot(3, 1, 2);
plot(1:samplesize, distributed_solar_irradiance, '-o');
xlabel('Sample');
ylabel('Beta Distributed Solar Irradiance (W/m^2)');
subplot(3, 1, 3);
plot(1:samplesize, power_output, '-o');
xlabel('Sample');
ylabel('Beta Distributed Power Output');


