function self = test_weeks(self)
%test_weeks - 
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


% Week Index Outside Range
fail = 0;
try
    [a b] =weeks(2000,54);
	fail = 1;
catch
end;
assert(fail == 0, 'Week Index Outside Range');

% Week Index Outside Range On NonLeap Year
fail = 0;
try
    [a b] =weeks(1999,53) ;
	fail = 1;
catch
end;
assert(fail == 0, 'Week Index Outside Range On NonLeap Year');

% Week
[a b] =weeks(1999,52) ;
assert_equals(a+b/1000,12.026)

% Week on Leap Year
[a b] =weeks(2000,53) ;
assert_equals(a+b/1000,12.031)
