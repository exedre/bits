function self = test_ifreq(self)
% test_ifreq test frequency 
%
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
%         run(gui_test_runner, 'test_assert(''test_ifreq'');');
%

% ifreq.m - checks for leap year and returns 366 if true otherwise returns freq (sic)
assert_equals(ifreq(365,2000), 366, 'on leap years ifreq should be 366');
assert_equals(ifreq(365,1900), 365, 'on non leap years ifreq should be 366');

assert_equals(ifreq(4,2000)  , 4  , 'on leap years ifreq should return the freq itself if it''s not 365');
assert_equals(ifreq(4,1900)  , 4  , 'on non leap years should return the freq itself  if it''s not 365');
