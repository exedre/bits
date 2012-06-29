function self = test_tsidx_distance(self)
%test_tsidx_distance - 
%
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%
%
%
%  Example
%  =======
%         run(gui_test_runner, 'test_assert(''test_pass'');');
%
% tsidx_distance.m - returns the distance between two timeseries indexes in a given frequency
assert_equals(tsidx_distance(12, [1980 1],[1982 9]),32)

fail = 0;
try
    assert_equals(tsidx_distance(4, [1980 1],[1982 9]),32)
    fail = 1;
catch
end;
assert(fail == 0, 'tsidx_distance(4, [1980 1],[1982 9]) == 32 fails to fail.');

% stress last day of leap year
assert_equals(tsidx_distance(365, [1980 1],[1984 366]),1826)

% stress range
for i=1:365
    assert_equals(tsidx_distance(365, [1980 1],[1980 i]),i-1)
end

for i=1:-1:365
    assert_equals(tsidx_distance(365, [1980 1],[1979 i]),365-i)
end

% stress negative distance
for i=1:100
    assert_equals(tsidx_distance(365, [1980 i],[1984 365-i]),-tsidx_distance(365, [1984 365-i],[1980 i]))
end