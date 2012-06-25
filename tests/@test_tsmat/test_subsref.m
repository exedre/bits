function self = test_subsref(self)
% Bank-IT Time Series Toolbox
%   Copyright 2005-2006 Claudia Miani, Emmanuele Somma, Giovanni Veronese 
%   (Servizio Studi Banca d'Italia)
%   $Revision: 1.2 $  $Date: 2007/08/02 16:39:48 $

% setup needed tsmat
myts=tsmat(1980,1,12,[1 2 3;4 5 6]);

% too many level of subsref (.dates(1).end)
fail=0;
try
    myts.dates(1).end
    fail=1;
catch
end
assert(fail==0)

% . ref
% myts.meta ?!?
% myts.meta_cols ?!?
assert_equals(fix(norm(size(myts.matdata))*10),36)
assert_equals(myts.freq,12)
assert_equals(myts.start_year,1980)
assert_equals(myts.start_period,1)
assert_equals(myts.start(1)+myts.start(2)/1000,1980.001)
assert_equals(myts.end(1)+myts.end(2)/1000,1980.002)
assert_equals(myts.range(1,1)+myts.range(1,2)/1000,1980.001)
assert_equals(myts.range(2,1)+myts.range(2,2)/1000,1980.002)
assert_equals(myts.last_year+myts.last_period/1000,1980.002)
assert_equals(norm(myts.dates), norm([ 723181  723212]))

% Finds .goofy in tsmat struct
fail=0;
try
    myts.goofy;
    fail=1;
catch
end
assert(fail==0,'subelement not present')

% () -- 2 args

% correct: extract right value
assert(fix(norm(myts(2,2))*100)==500);
assert(fix(norm(myts([1 2],[1 2]))*100)==676);

% error('dates are not contiguous')
fail=0;
try
    mysub = myts([1 3],2);
    fail=1;
catch
end
assert(fail==0,'dates are not contiguous')

% error('TS Index exceeds matrix dimensions')
fail=0;
try
    mysub = myts(6,2);
    fail=1;
catch
end
assert(fail==0,'Index exceeds matrix dimensions')

% error('negative TS Index')
fail=0;
try
    mysub = myts(6,-2);
    fail=1;
catch
end
assert(fail==0,'Negative TS Index')

% test on metadata

% () - 5 args

% {}
