function self = test_tsidx2date(self)
%test_tsidx2date
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
% tsidx2date.m - returns a timeseries index (year+period) for a given serial Matlab date
assert_equals(tsidx2date(12,1980,1), 723181, 'tsidx2date()')
