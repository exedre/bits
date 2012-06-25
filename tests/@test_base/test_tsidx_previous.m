function self = test_tsidx_previous(self)
%test_tsidx_previous - 
%
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%
%
%
%  Example
%  =======
%         run(gui_test_runner, 'test_assert(''test_pass'');');
%


% tsidx_previous.m - returns the previous index for the given frequency

% stress period out of range
fail = 0;
try
    assert_equals(tsidx_previous(366, 1980,  1))
    fail = 1;
catch
end;
assert(fail == 0, 'tsidx_previous() period out of range.');


% stress biennal frequency 
[y,p] = tsidx_next(0.5,1990,1);
assert_equals(y+p/1000,1992.001)

% stress not decimal frequency with high period
fail = 0;
try
    [y,p] = tsidx_previous(0.5,1990,2);
    fail = 1;
catch
end;
assert(fail == 0, 'tsidx_previous() period out of range on decimal freq.');

% stress biennal frequency 
[y,p] = tsidx_previous(0.5,1990,1);
assert_equals(y,1988)

% no stress at all
[y,p] = tsidx_previous(365,1990,45);
assert_equals(y+p/1000,1990.044)

% stress first year day
[y,p] = tsidx_previous(365,1991,1);
assert_equals(y+p/1000,1990.365)

% stress last year day on leap year
[y,p] = tsidx_previous(365,1993,1);
assert_equals(y+p/1000,1992.366)
[y,p] = tsidx_previous(365,1992,366);
assert_equals(y+p/1000,1992.365)
