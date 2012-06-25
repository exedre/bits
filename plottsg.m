function varargout = plottsg(varargin)
%@tsmat/plot - overloaded plotting facility for tsmat objects
% 2nd input can be a specific field name of the ts metadata
%
% Example 1:
%    hh=plot(X)
%    Input:
%    X=Tsmat object
%    Output:
%    hh = column vector of handles to lineseries objects, one
%    handle per plotted line
%
% Example 2:
%    [hh,rr]=plot(X,namefield)
%    Input:
%    X=Tsmat object
%    namefield= string with name of column metadata field
%    Output:
%    hh = column vector of handles to lineseries objects, one
%    handle per plotted line
%    rr = column vector of handles to legend text objects, one
%    handle per plotted line
%

%   BITS -  Banca d'Italia Time Series
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni.veronese@bancaditalia.it)
%           Emmanuele Somma   (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali
%           Banca d'Italia
%

ts=varargin{1};
namets=inputname(1);
descrts=[];
leg_handle=[];
if length(ts.meta_cols)
    if nargin==1
        namets=inputname(1);
    elseif nargin==2
        % if specific meta description desired
        if isfield(ts.meta_cols,varargin{2})
            if str2num(version('-release'))<14
                descrts=char(getfield(ts.meta_cols,varargin{2}));
            else
                descrts=getfield(ts.meta_cols,varargin{2});
            end;
        end
    end
end

TimeSeries=ts;
freq=TimeSeries.freq;

Properties='';
dati=TimeSeries.matdata;
date=TimeSeries.dates;

T=size(date,1);
plot_handle=plot(1.5:1:T+0.5,dati,Properties);
set(plot_handle,'marker','o')

ax1=gca;
set(gca,'Xlim',[1,T+1],'Xtick',1:T+1,'Xticklabel',num2str([1:T+1]'));

ax2=ticklabel(gca);
set(ax2,'Xminortick','on')
prd='yyyy';
nuovi=datestr(date,prd);
mese=month(date);
mese=[mese;NaN];
giugno=find(mese==6);
nuovolab=repmat(' ',length(get(ax2,'Xtick')),1);
nuovolab(giugno,1:size(nuovi,2))=nuovi(giugno,:);
gen=min(find(mese(1:end)==1));

set(ax2,'XtickLabel',nuovolab);
set(ax1,'Xtick',gen:12:T+1,'Xminortick','on');


% Still need to fix label for tsmat starting after june and ending before
% june!

varargout{1}=plot_handle;
varargout{2}=leg_handle;
varargout{3}=[ax1,ax2];


return

switch freq
    case 1
        nuovi=datestr(date,'yyyy');
    case 12
        %  nuovi(month(date)~=6,:)='';
        %          quali=union(find(month(date)==1),find(month(date)==12));
        %  quali=find(month(date)==12);

        %          set(gca,'Xlim',[0,T+1]])
        %set(gca,'XMinorTick','on')
        %axis('tight')
    case {365;366}
        prd='dd-mmm-yyyy';
end



primi=min(find(month(date)==1));
set(ax1,'visible','off')
set(ax2,'XMinorTick','on')
set(ax2,'Xtick',primo:12:T,'Xticklabel',nuovi);

aa1=get(ax1,'xlim');
aa2=get(ax2,'xlim');



if nargout
    varargout{1}=plot_handle;
    varargout{2}=leg_handle;
    varargout{3}=[ax1,ax2];

end
