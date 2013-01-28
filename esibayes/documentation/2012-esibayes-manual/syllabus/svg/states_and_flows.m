clear
close all
clc





state1 = 30.07
state2 = 0

dt1 = 60.777
dt2 = 85.792
dt3 = 52.672



R = 0.0030


q1 = state1 * R
state1 = state1 - q1 * dt1
state2 = state2 + q1 * dt1

q2 = state1 * R  
state1 = state1 - q2 * dt2
state2 = state2 + q2 * dt2


q3 = state1 * R  
state1 = state1 - q3 * dt3
state2 = state2 + q3 * dt3



