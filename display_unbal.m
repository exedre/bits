function varargout=display_unbal(X,nperiods,varargin)
% DISPLAY_UNBAL display the unbalancing at the END of a tsmat object
% up to the last nperiods
%  varargout{1}=fine;  % missing at the end of the sample for each column
%  varargout{2}=Xrich; % Dataset with new metadata info on sample end 
if nargin==2
    graphon=0;
else 
    graphon=1;
end


[sy,sp,ey,ep,freq]=deal(X.start_year,X.start_period,X.last_year,X.last_period,X.freq);

[T,N]=size(X);
Xm = X.matdata;
fine=sum(isnan(Xm(T-nperiods+1:end,1:end)));
scadv=[0:max(fine)];
histogr=flipud([scadv;histc(fine,scadv)]');
[py, pp]=deal(ey,ep);
dateimp=tsidx2date(freq,py,pp);
for j=1:max(fine)
    [ py, pp ] = tsidx_previous(freq,py,pp);
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

last_months=flipud(datestr(dateimp,formato));

table_histogr=cat(2,last_months,repmat(' | ',max(fine)+1,1),num2str(histogr));


if length(find(fine==0))==0;
disp('Warning: no column of the TSMAT reaches end of TSMAT sample')
end


if graphon
    qq=histc(fine,0:nperiods);
    pp=qq(setdiff(1:nperiods,find(qq==0)));
    dd=find(qq);
    datebone=X.dates;
    datebonex=flipud(datebone(end-dd+1));
    g=bar(1:length(pp),fliplr(pp));
    set(gca,'Xtick',1:length(pp),'Xticklabel',datestr(datebonex,'mmm-yy'),'Fontsize',8)
    ylabel(['Number of series ending at date shown: total =', num2str(N)] )
    title(['End of sample unbalance'])
end
% Add metacol information on missing values at end of sample
value=num2str(fine');
metafine=mat2cell(value,ones(size(value,1),1),size(value,2));
Xrich=addmeta_cols(X,1:N,'End_Unbalance',metafine);

if nargout==0
    disp(' ')
    disp(table_histogr)
    disp(' ');
end

if nargout>0;
    for j=1:nargout
        varargout{1}=fine;
        varargout{2}=Xrich;
        varargout{3}=table_histogr;
%        varargout{4}=g;
    end
end