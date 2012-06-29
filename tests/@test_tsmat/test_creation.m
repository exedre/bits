function self = test_creation(self)
%test_creation
%
%
%
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%


% Empty timeseries
ts = tsmat();
assert_equals(ts.start_year+ts.start_period/1000,0.0);

% 3/5 args -> error
fail=0;
try
    ts = tsmat(1980,-10,12) ;
	fail = 1;
catch
end;
assert(fail == 0, '4 args required not 4');

fail=0;
try
    ts = tsmat(1980,-10,12,rand([40 40]),0) ;
	fail = 1;
catch
end;
assert(fail == 0, '4 args required not 5');

% starting period must be positive 
fail=0;
try
    ts = tsmat(1980,-10,12,rand([40 40])) ;
	fail = 1;
catch
end;
assert(fail == 0, 'starting period must be positive');

% freq = 366
ts = tsmat(1980,18,366,rand([40 40])) ;
assert_equals(ts.freq,365);

% freq = 53 
ts = tsmat(1980,18,53,rand([40 40])) ;
assert_equals(ts.freq,52);

% period greater than freq
fail=0;
try
    ts = tsmat(1980,18,12,rand([40 40])) ;
	fail = 1;
catch
end;
assert(fail == 0, 'period must not be greater than frequency');

% Create a 40x40 element timeseries
ts = tsmat(1980,1,12,rand([40 40])) ;
assert_equals(ts.last_year+ts.last_period/1000,1983.004);

% Copy constructor from tsmat
ts2 = tsmat(ts);
assert_equals(ts.last_year+ts.last_period/1000,ts2.last_year+ts2.last_period/1000);

% Copy constructor from tseries
% ?!?

%
  v = [ 0.9501      0.8913      0.8214 ; 
        0.2311      0.7621      0.4447 ; ...
        0.6068      0.4565      0.6154 ; ...
        0.4860      0.0185      0.7919 ];
  t1 = tsmat(1980,1,12,v,'GOOF');
  a=t1.meta_cols.label;
  assert(strcmp(a{3},'GOOF3'),'label');
  
  t1 = tsmat(1980,1,12,v,{'foo','bar','baz'});
  a=t1.meta_cols.label;
  assert(strcmp(a{3},'baz'),'label');
  
% TODO: Testing for release date

 t1 = tsmat(1980,1,12,v,nan,733253);
 assert(t1.meta.release==733253.0);
 
 t1 = tsmat(1980,1,12,v,nan,'30-Jul-2007');
 assert(t1.meta.release==733253.0);
 
 t1 = tsmat(1980,1,12,v,nan,{'01-Jul-2007' '02-Jul-2007' '03-Jul-2007'});
 a=t1.meta_cols.release;
 assert(t1.meta.release==today);
 for i=1:size(a,1)  
   assert(a{i}==(733223+i));
 end
 