function res = isin01(x)
%ISIN01 Checks if input is in the unit interval [0,1]

res = (x >= 0) & (x <= 1);
