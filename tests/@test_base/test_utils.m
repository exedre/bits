function self = test_utils(self)
%test_utils - 
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%
% TODO: Check this file
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

% tsjoin.m - joins to different timeseries if they have the same frequency
% Timeseries operations
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
% addmeta - adds specified field to a tseries or tsmat object
% addmeta_cols - adds field to specific columns of a tsmat object

assert(true);
assert(sin(pi/2) == cos(0));

% With message
assert(1, 'Assertion must pass, so message is never seen.');

% Equals
assert_equals(1, 1);
assert_equals('Foo', 'Foo');
assert_equals([1 2 3], [1 2 3]);
assert_equals(sin(1), sin(1));
assert_equals(true, true);

% Not equals
assert_not_equals(0, 1)
assert_not_equals('Foo', 'Bar');
assert_not_equals([1 2 3], [4 5 6]);
assert_not_equals(sin(0), sin(1));
assert_not_equals(true, false);