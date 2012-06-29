function self = test_tsidx_next(self)
%test_tsidx_next - 
%
%
% Bank-IT Time Series Toolbox
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%
%
%  Example
%  =======
%         run(gui_test_runner, 'test_assert(''test_pass'');');
%


% stress period out of range
fail = 0;
try
    assert_equals(tsidx_next(366, 1980,  1))
    fail = 1;
catch
end;
assert(fail == 0, 'tsidx_next() period out of range.');


% stress biennal frequency 
[y,p] = tsidx_next(0.5,1990,1);
assert_equals(y,1992)

% stress not decimal frequency with high period
fail = 0;
try
    [y,p] = tsidx_next(0.5,1990,2);
    fail = 1;
catch
end;
assert(fail == 0, 'tsidx_next() period out of range on decimal freq.');

% no stress at all
[y,p] = tsidx_next(365,1990,45);
assert_equals(y+p/1000,1990.046)

% stress last year day
[y,p] = tsidx_next(365,1990,365);
assert_equals(y+p/1000,1991.001)

% stress last year day on leap year
[y,p] = tsidx_next(365,1992,365);
assert_equals(y+p/1000,1992.366)
[y,p] = tsidx_next(365,1992,366);
assert_equals(y+p/1000,1993.001)
