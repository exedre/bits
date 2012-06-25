function t = test_extend(name)
%
%  Example
%  =======
%         run(gui_test_runner, 'test_tsmat');

%  $Id: test_extend.m,v 1.2 2007/08/02 16:39:48 h856605 Exp $

tc = test_case(name);
t = class(struct([]), 'test_tsmat', tc);

v = [  0.4639    0.7878    0.4580    0.3559 ; ...
       0.3154    0.9871    0.0924    0.7414 ; ...
       0.1466    0.3632    0.2711    0.0494 ; ...
       0.9527    0.3546    0.5507    0.0325 ; ...
       0.4159    0.5354    0.4563    0.9488 ; ...
       0.3341    0.0674    0.8936    0.9819 ; ...
       0.4350    0.2618    0.8961    0.6589 ; ...
       0.4250    0.7027    0.4737    0.9558 ; ...
       0.8357    0.1027    0.7569    0.9778 ; ...
       0.0845    0.6533    0.7428    0.2288 ; ...
       0.2687    0.6348    0.3721    0.5872 ; ...
       0.3120    0.6766    0.1626    0.1015 ] ;

% Case 0
ts1=tsmat(1980,1,12,v(:,1:2));
ts2=tsmat(1981,4,12,v(:,3:4));
ts3=extend(ts1,ts2,nan,true);
assert(ts3(ts2.start_year,
assert(fix(sum(nansum(ts1))*100+sum(nansum(ts2))*100)==fix(sum(nansum(ts3))*100))
%tstab(ts1,ts2,ts3);

% Case 15
ts1=tsmat(1980,1,12,v(:,1:2));
ts2=tsmat(1981,4,12,v(:,3:4));
ts3=extend(ts2,ts1,nan,true);
assert(fix(sum(nansum(ts1))*100+sum(nansum(ts2))*100)==fix(sum(nansum(ts3))*100))
%tstab(ts1,ts2,ts3);


% Case 4
ts1=tsmat(1980,1,12,v(:,1:2));
ts2=tsmat(1980,7,12,v(:,3:4));
ts3=extend(ts1,ts2);
assert(fix(sum(nansum(ts3))*100)==1847)
%tstab(ts1,ts2,ts3);

% Case 13
ts1=tsmat(1980,1,12,v(:,1:2));
ts2=tsmat(1981,1,12,v(:,3:4));
ts3=extend(ts2,ts1);
assert(fix(sum(nansum(ts3))*100)==2386)
%tstab(ts1,ts2,ts3);

% Case 12
ts1=tsmat(1980,1,12,v(:,1:2));
ts2=tsmat(1980,7,12,v(:,3:4));
ts3=extend(ts1,ts2);
assert(fix(sum(nansum(ts3))*100)==1847)
%tstab(ts1,ts2,ts3);

% Case 5
ts1=tsmat(1980,1,12,v(:,1:2));
ts2=tsmat(1980,7,12,v(:,3:4));
ts3=extend(ts2,ts1);
assert(fix(sum(nansum(ts3))*100)==1847)
%tstab(ts1,ts2,ts3);
