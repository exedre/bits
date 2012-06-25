function varargout=display_start_unbal(X,nperiods,varargin);
% display the unbalancing at the start of a tsmat object
% up to the first nperiods
% Works for monthly tsmats
if nargin==2
    graphon=0;
else 
    graphon=1;
end
[sy,sp,ey,ep,freq]=deal(X.start_year,X.start_period,X.last_year,X.last_period,X.freq);

[T,N]=size(X);
dati=X.matdata;
freq=X.freq;
iniz=sum(isnan(dati(1:nperiods,1:end)));
scadv=[0:max(iniz)];
histogr=[scadv;histc(iniz,scadv)]';
[py, pp]=deal(sy,sp);

dateimp=tsidx2date(freq,sy,sp);
for j=1:max(iniz);
    [ py, pp ] = tsidx_next(freq,py,pp);
    dateimp=[dateimp;tsidx2date(freq,py,pp)];
end

switch freq
    case 12
        formato='mmm-YYYY';
    case 4
        formato='QQ-YYYY';
    case 1
        formato='YYYY';
end

start_months=datestr(dateimp,formato);

table_histogr=cat(2,start_months,repmat(' | ',max(iniz)+1,1),num2str(histogr));
% disp(' ')
% disp(table_histogr)
% disp(' ');

if length(find(iniz==0))==0;
disp('Warning: no column of the TSMAT has obs at TSMAT start')
end

if graphon
    qq=histc(iniz,0:nperiods);
    pp=qq(setdiff(1:nperiods,find(qq==0)));
    dd=find(qq);
    datebone=X.dates;
    datebonex=datebone(dd);
    g=bar(1:length(pp),pp);
    set(gca,'Xtick',1:length(pp),'Xticklabel',datestr(datebonex,'mmm-yy'),'Fontsize',8)
    ylabel(['Number of series starting at date shown: total =', num2str(N)] )
    title(['Unbalance at start of sample'])
end



if nargout==0
        disp(' ')
        disp(table_histogr)
        disp(' ');
else
    varargout{1}=iniz;
end
