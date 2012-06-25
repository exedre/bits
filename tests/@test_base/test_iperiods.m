function self = test_iperiods(self)
% test_iperiod
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
%         run(gui_test_runner, 'test_assert(''test_iperiod'');');
%

% iperiods.m - returns the number of periods between years
assert_equals(iperiods(4,1990,2000),40, 'iperiods returns strange results')
assert_equals(iperiods(12,1990,2000),120, 'iperiods returns strange results')
assert_equals(iperiods(365,1990,2000),3653, 'iperiods returns strange results')
assert_equals(iperiods(4,2004,2000),-16, 'iperiods returns strange results')
assert_equals(iperiods(365,2004,2000),-1462, 'iperiods returns strange results')
