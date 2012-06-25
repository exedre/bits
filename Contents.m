% Bank-IT Time Series Toolbox
%   Copyright 2007-2012 Banca d'Italia
%
%   (*) indicates that it is an overloaded method (i.e. MATLAB functions
%       or Toolbox functions overloaded to work with FINTS objects).
%
% Classes:
%
% @tsdb    - Timeseries data base class
% @tsmat   - Timeseries matrix class
%
% Generic functions used by tsmat class
%
% TSMATCheckArithm.m - function used to check input of arithmetics function for tsmat
% TSMATCommonArithm.m - function used by overloading basic mathematical operaotrs for tsmat
% TSMATCommonOneinput.m - function used by overloading mathematical function of tsmat
% TSMATlogical.m - function used by overloading logical function of tsmat
% TSMATstats.m - function used by overloading statistics function of tsmat
%
% Timeseries Index Functions
%
% distance2tsidx.m - delta in years and periods to move dist periods away
% tsidx2date.m - returns a timeseries index (year+period) for a given serial Matlab date
% tsidx_distance.m - returns the distance between two timeseries indexes in a given frequency
% tsidx_next.m - returns the next index for the given frequency
% tsidx_previous.m - returns the previous index for the given frequency
% tsidxgt.m - greater operator for timeseries indexes 
%
%
% tsjoin.m - joins to different timeseries if they have the same frequency
%
% Utilities
%
% ifreq.m - checks for leap year and returns 366 if true otherwise returns freq
% before_leap.m - checks if the timeseries index is before the leap day
% calendar_isleap.m - check if given year is a leap year
% freq2num.m - return 366 or 251 if year is leap and freq 'daily' or 'business'
% iperiods.m - returns the number of periods between years
% next.m - returns next index in the timeseries, 
% num2freq.m - returns a string which represents the frequency in input
% period.m - returns the period in the timeseries index given a matlab serial date and a frequency
% setrange.m - finds common and the union range of 2 tseries; 
% start2end.m - destination year and period moving dist away from given date
% rownum.m - row index to year and period in tsmat/tseries objects 
% 
% Timeseries operations
%
% annual.m  - annual aggregation of a time series
% semiannual - semiannual aggregation of a time series
% quarterly.m - quarterly aggregation of a time series 
% monthly.m - monthly aggregation of a time series 
%
% deltap.m - computes the percentage change in the tsmat/tseries object
% delta.m  - computes the absolute change in the tsmat/tseries object
% mave.m  - computes the moving average of the tsmat/tseries object
% xcov.m  - Cross-covariance function estimates for tsmat/tseries
% xcov.m  - Cross-correlation function estimates for tsmat/tseries
% cumsum.m - Cumulative sum of elements along time dimension
% seasint.m - Seasonal integration of a tsmat/tseries object
% tramoseats.m - Tramo-Seats of tseries object
% ols_ts       -Run regressions using tsmat/tseries objects
% var_tsmat    -Run VAR with tsmat objects
% 
% notnanrange - sets range of tsmat to common range where all columns are not NaN
% setrange -returns 2 arrays with the tsindexes for common and union range
% 
% Metadata
%
% addmeta - adds specified field to a tseries or tsmat object
% addmeta_cols - adds field to specific columns of a tsmat object
%
%