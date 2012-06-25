function pp=setgraphts(ff,freq,startg,endg,varargin)
% setgraphts: Restricts graph ff to sample defined by startg and endg
% ff=gca
% freq=frequency of the time series
% startg=[start_year,start_period]
% endg  =[end_year,end_period]
xlim1=tsidx2date(freq,startg(1),startg(2));
xlim2=tsidx2date(freq,endg(1),endg(2));
set(ff,'Xlim',[xlim1,xlim2])

% Recompute the x axis ticks and labels
% Here the default is to set k=1, one tick per year
if nargin==4
k=1;
else
    k=varargin{1};
end
anni=year(xlim1):k:year(xlim2)+1;
datesy=datenum(anni',1,1);
set(ff,'Xtick',datesy)
switch freq
    case 12
        fmt='mmm-yyyy';
    case 4
        fmt='QQ-yyyy';
    case 1
        fmt='yyyy';
    case 366
        fmt='mmm-yyyy'
end

set(ff,'Xticklabel',datestr(datesy,fmt))


% set(ff,'Xticklabel',[year(xlim1):year(xlim2)])

