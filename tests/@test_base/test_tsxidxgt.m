function self = test_tsxidxgt(self)
%test_tsxidxgt - 
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


% tsidxgt.m - greater operator for timeseries indexes 

% stress years
assert_equals(tsidxgt(1990,1,2000,365),-1)
assert_equals(tsidxgt(2010,1,2000,365),1)
assert_equals(tsidxgt(2010,1,2010,1),0)

% stress periods
assert_equals(tsidxgt(1990,20,1990,21),-1)
assert_equals(tsidxgt(1990,25,1990,21),1)
assert_equals(tsidxgt(1990,35,1990,35),0)
