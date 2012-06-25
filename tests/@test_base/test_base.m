function t = test_base(name)
%test_base - tests the base functions for bits
%
%  Example
%  =======
%         run(gui_test_runner, 'test_...');
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

tc = test_case(name);
t = class(struct([]), 'test_base', tc);
