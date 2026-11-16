tic
close all
clear 
clc
%% Call functions used in the program for calculations and plots
path(path,'../data');
path(path,'../math');
path(path,'../plot');
%% Apply BF on 400 speakers
selected_mics = [1:32]; % Just you must change this
for i=1:20
    for j=1:10
        name = sprintf('F%d_%d',i,j);
        [outPut] = TD_Delay_and_Sum(name,selected_mics);
        stop
    end
end
for i=1:20
    for j=1:10
        name = sprintf('M%d_%d',i,j);
        [outPut] = TD_Delay_and_Sum(name,selected_mics);
    end
end
toc