function self = test_aggrts(self)
% test_aggrts test for aggregation of timeseies
%
%   BITS -  Banca d'Italia Time Series
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali
%           Banca d'Italia
%
%
%  Example
%  =======
%         run(gui_test_runner, 'test_assert(''test_ifreq'');');
%

% ifreq.m - aggregates time series: start from a leap year (1980)
T=length(datenum('01-Jan-1980'):datenum('31-Dec-1991'))
ny=1991-1980+1;

% start from highest available frequency (daily)
daily_tsmat=tsmat(1980,1,365,ones(T,1));
% correct ndays
% for annual tseries
nd_annual=repmat([366;ones(3,1)*365],3,1);
% for semiannual tseries
nd_semiannual=repmat([182;184;repmat([181;184],3,1)],3,1);

% for quadrimessrale
nd_quadri=repmat([121;123;122;repmat([120;123;122],3,1)],3,1)
% for trimestrale
nd_trime=repmat([91;91;92;92;repmat([90;91;92;92],3,1)],3,1)
% for bimonthly
nd_bime=repmat([60;61;61;62;61;61;repmat([59;61;61;62;61;61],3,1)],3,1);
%for monthly
nd_monthly=repmat([31;29;31;30;31;30;31;31;30;31;30;31;repmat([31;28;31;30;31;30;31;31;30;31;30;31],3,1)],3,1)

giuste={nd_annual,nd_semiannual,nd_quadri,nd_trime,nd_bime,nd_monthly};
frequenze=[1,2,3,4,6,12];
for j=1:length(giuste)
    outfreq=frequenze(j);
    upper_tsmat=aggrts(daily_tsmat,outfreq,'pad','sum');
    qq{j}=upper_tsmat.matdata-giuste{j};
%     if sum(qq{j})
%         disp(outfreq)
%         pause
%         disp(qq{j})
%         keyboard
%     end
assert_equals(sum(qq{j}),0, 'should be zero');
end





