% Main script for demo
clear 
rng(123)
addpath('functions','steps','package_funcs','Figures')
% Load small synthetic data
YData = readtable('YData_DEMO.txt');
XData = readtable('XData_DEMO.txt');

res=scalableCS(YData,XData,2000,"MNL_RC");