function [tsout,weeknum]= toweekly(tsin,fn,varargin) 


if tsin.freq~=365
    error('Input tsmat needs to be daily')
end
% To weekly freq can only be from daily tsmat 
% identify unique week number (use Sunday as first weekday)
whichday='Sun';
if nargin==3
    whichday=varargin{1};
end

[sy,sp,ey,ep,dates]=deal(tsin.start_year,tsin.start_period,tsin.last_year,tsin.last_period,tsin.dates);

spw=isoweek_custom(tsidx2date(365,sy,sp));
epw=isoweek_custom(tsidx2date(365,ey,ep));

% If the first day of the tseries belongs to week of the previous year I
% shift the start of the daily tseries to include the full 7 days which belong to it
nsp_daily=sp;

datan_daily=dates(1)-(mod(weekday(dates(1))-2,7));
[nsy,nsp_daily]=date2tsidx(365,datan_daily);
    

% Fine daily timeseries che chiuda la serie settimanale
day_end=weekday(dates(end));
[ney,ned]=date2tsidx(365,dates(end)+(7-day_end));

ntsin=tsin(nsy,nsp_daily,ney,ned,:);
ndates=ntsin.dates;
q=isoweek_custom(ndates,'vec',whichday);
weeknum=q(:,1)*1000+q(:,2);
dataout = accumTS([weeknum,ntsin.matdata],fn);



    
tsout=tsmat(sy,spw,52,dataout(:,2:end));



