function self = test_leap(self)
%test_leap - test leap function
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%
%
%  Example
%  =======
%         run(gui_test_runner, 'test_assert(''test_pass'');');
%
%  See also ASSERT, ASSERT_EQUALS, ASSERT_NOT_EQUALS.
%

% calendar_isleap.m - check if given year is a leap year
j = 0;
for y = 1800:2000
    j = j + calendar_isleap(y);
end
assert_equals(j, 49, 'leap years: 1800 and 1900 are not leap year/1');

% before_leap.m - checks if the timeseries index is before the leap day
j=0;
for y = 1800:2000
    b=before_leap(366, y, 60);
    j = j + b;
end
assert_equals(j, -49, 'leap years: 1800 and 1900 are not leap year/2');

j=0;
for p=1:366
    b=before_leap(366,2000,p);
    j = j + b;
end
assert_equals(j, 246, 'on leap years before_leap should return -1 before and 1 after leap');

j=0;
for p=1:12
    j = j + before_leap(12,2000,p);
end
assert_equals(j, 8, 'on leap years before_leap should return -1 before and 1 after leap');

j=0;
for p=1:366
    j = j + before_leap(366,1999,p);
end
assert_equals(j, 0, 'on non leap years before_lead should return 0 ever');

% Catch the error raised on period out of range
fail=0;
try
    assert_not_equals(before_leap(365,1999,366),0);
    fail = 1;
catch
end;
assert(fail == 0, 'before_leap should throw an exception if period i > ifreq()');

% ifreq.m - checks for leap year and returns 366 if true otherwise returns freq (sic)
assert_equals(ifreq(365,2000), 366, 'on leap years ifreq should be 366');
assert_equals(ifreq(365,1900), 365, 'on non leap years ifreq should be 366');

assert_equals(ifreq(4,2000)  , 4  , 'on leap years ifreq should return the freq itself if it''s not 365');
assert_equals(ifreq(4,1900)  , 4  , 'on non leap years should return the freq itself  if it''s not 365');

% freq2num.m - return 366 or 251 if year is leap and freq 'daily' or 'business'

% iperiods.m - returns the number of periods between years

% next.m - returns next index in the timeseries, 

% num2freq.m - returns a string which represents the frequency in input

% period.m - returns the period in the timeseries index given a matlab serial date and a frequency

% setrange.m - finds common and the union range of 2 tseries; 

% start2end.m - destination year and period moving dist away from given date

% rownum.m - row index to year and period in tsmat/tseries objects 



% TSCheckArithm.m - function used to check input of arithmetics function for tseries
% TSCommonArithm.m - function used by overloading basic mathematical operaotrs for tseries
% TSCommonOneinput.m - function used by overloading mathematical function of tseries
% TSlogical.m - function used by overloading logical function of tseries
% TSstats.m - function used by overloading statistics function of tseries
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

% tsjoin.m - joins to different timeseries if they have the same frequency

% Utilities


 
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