function self = test_start2end(self)
%test_start2end
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
%         run(gui_test_runner, 'test_assert(''test_pass'');');
%

% start2end.m - destination year and period moving dist away from given
% date
[ yp, pp ] = start2end( 12, 1980, 1, 14) ;
assert_equals(yp+pp/1000, 1981.003) ;
