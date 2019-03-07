clear
clc
close all
%cd('Y:\DATA\corticostriatal\LabView Data June 2017\20170718\s1chr222am')
%cd('Y:\DATA\corticostriatal\LabView Data August 2017 analysis\20170913 LED sessions\s1chr2-24am second run')
cd('R:\Margolis Lab Server\DATA\corticostriatal\Labview data November 2017\20171201\s1chr2-32pm')
load('decision_log.mat')

LED_On = 0; %set this value to zero if there are no LED on trials.
%otherwise set this value to the first trial where there was stimulation.
LED_Off = size(decision_log, 1) - 1; %set this value to the last trial where LED stimulation was present.

ind = 1;
ind_on = 1;

if LED_On == 0;
    
    total_trials = str2double(decision_log{end, 1});
    perc_Gos = (size(Gos, 2)/total_trials)*100
    perc_nogo = (size(NoGos, 2)/total_trials)*100
    perc_miss = (size(Misses, 2)/total_trials)*100
    perc_FAs = (size(FAs, 2)/total_trials)*100
    combined_rt = [FAtimes GoTimes];
    mean_rt = mean(combined_rt);
    mean_gort = mean(GoTimes)
    mean_fart = mean(FAtimes)
    
else
led_off_go_time = [];
led_off_fa_time = [];
for i = 2:LED_On;
    if decision_log{i,7} == '1'
        LED_off_respTimes(ind) = str2double(decision_log{i,6});
        off_go_res = str2double(decision_log{i, 6});
        led_off_go_time = [led_off_go_time off_go_res];
        ind = ind + 1;
    elseif decision_log{i, 10} == '1'
        LED_off_respTimes(ind) = str2double(decision_log{i, 11});
        ind = ind + 1;
        off_fa_res = str2double(decision_log{i, 11});
        led_off_fa_time = [led_off_fa_time off_fa_res];
    end
end

mean_led_off_gort = mean(led_off_go_time)
mean_led_off_fart = mean(led_off_fa_time)
%Avg_LedOff = mean(LED_off_respTimes)

led_on_go_time = [];
led_on_fa_time = [];
for j = LED_On + 1:LED_Off + 1;
    if decision_log{j,7} == '1'
        LED_on_respTimes(ind_on) = str2double(decision_log{j,6});
        on_go_res = str2double(decision_log{j, 6});
        led_on_go_time = [led_on_go_time on_go_res];
        ind_on = ind_on + 1;
    elseif decision_log{j, 10} == '1'
        LED_on_respTimes(ind_on) = str2double(decision_log{j, 11});
        on_fa_res = str2double(decision_log{j, 11});
        led_on_fa_time = [led_on_fa_time on_fa_res];
        ind_on = ind_on + 1;
    end
end

mean_led_on_gort = mean(led_on_go_time)
mean_led_on_fart = mean(led_on_fa_time)
%Avg_LedOn = mean(LED_on_respTimes)

GosCol = 1;
NoGosCol = 1;
MissCol = 1;
FAsCol = 1;
LED_Off_Gos = 0;
LED_Off_NoGos = 0;
LED_Off_Miss = 0;
LED_Off_FAs = 0;
for accum = 2:LED_On;
    if decision_log{accum, 7} == '1'
        LED_Off_Gos(1, GosCol) = 1;
        GosCol = GosCol + 1;
    elseif decision_log{accum, 8} == '1'
        LED_Off_NoGos(1, NoGosCol) = 1;
        NoGosCol = NoGosCol + 1;
    elseif decision_log{accum, 9} == '1'
        LED_Off_Miss(1, MissCol) = 1;
        MissCol = MissCol + 1;
    elseif decision_log{accum, 10} == '1'
        LED_Off_FAs(1, FAsCol) = 1;
        FAsCol = FAsCol + 1;
    end
end

nLED_Go_proportion = (sum(LED_Off_Gos)/(LED_On - 1)) * 100
nLED_NoGo_proportion = (sum(LED_Off_NoGos)/(LED_On - 1)) * 100
nLED_Miss_proportion = (sum(LED_Off_Miss)/(LED_On - 1)) * 100
nLED_FA_proportion = (sum(LED_Off_FAs)/(LED_On - 1)) * 100

nLED_response_proportion = nLED_Go_proportion + nLED_FA_proportion;
nLED_nresponse_proportion = nLED_NoGo_proportion + nLED_Miss_proportion;

% figure;
% piedata_on = [LED_Go_proportion LED_NoGo_proportion LED_Miss_proportion LED_FA_proportion]
% pie(piedata_on)

% piedata_resp_nled = [nLED_response_proportion nLED_nresponse_proportion]
% pie(piedata_resp_nled)
% title('piedata resp nled');

GosCol = 1;
NoGosCol = 1;
MissCol = 1;
FAsCol = 1;
LED_ON_Gos = 0;
LED_ON_NoGos = 0;
LED_ON_Miss = 0;
LED_ON_FAs = 0;

for accum2 = LED_On + 1:LED_Off + 1;
    if decision_log{accum2, 7} == '1'
        LED_ON_Gos(1, GosCol) = 1;
        GosCol = GosCol + 1;
    elseif decision_log{accum2, 8} == '1'
        LED_ON_NoGos(1, NoGosCol) = 1;
        NoGosCol = NoGosCol + 1;
    elseif decision_log{accum2, 9} == '1'
        LED_ON_Miss(1, MissCol) = 1;
        MissCol = MissCol + 1;
    elseif decision_log{accum2, 10} == '1'
        LED_ON_FAs(1, FAsCol) = 1;
        FAsCol = FAsCol + 1;
    end
end

LED_Go_proportion = (sum(LED_ON_Gos)/((LED_Off - LED_On) + 1)) * 100
LED_NoGo_proportion = (sum(LED_ON_NoGos)/((LED_Off - LED_On) + 1)) * 100
LED_Miss_proportion = (sum(LED_ON_Miss)/((LED_Off - LED_On) + 1)) * 100
LED_FA_proportion = (sum(LED_ON_FAs)/((LED_Off - LED_On) + 1)) * 100

LED_response_proportion = LED_Go_proportion + LED_FA_proportion;
LED_nresponse_proportion = LED_NoGo_proportion + LED_Miss_proportion;

% figure;
% piedata_on = [LED_Go_proportion LED_NoGo_proportion LED_Miss_proportion LED_FA_proportion]
% pie(piedata_on)

% piedata_resp_led = [LED_response_proportion LED_nresponse_proportion]
% pie(piedata_resp_led)
% title('piedata resp led')
end
