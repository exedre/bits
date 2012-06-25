function varargout = plottsg1(ts,varargin)
%% Plot a là excel, for monthly/quarterly timeseries
%% Always force it from jan to dec, then can adjust it later

%ts=varargin{1};
switch nargin
    case 1
        % default behavior
        fontname='Garamond';
        fontsize=18;
        fontweight='Bold';
        
    case 2
        fontname=varargin{1};
        fontsize=18;
        fontweight='Bold';
    case 3
        fontname=varargin{1};
        fontsize=varargin{2};
        fontweight='Bold';
    case 4
        fontname=varargin{1};
        fontsize=varargin{2};
        fontweight=varargin{3};
    case 5
        fontname=varargin{1};
        fontsize=varargin{2};
        fontweight=varargin{3};
        YLIM=varargin{4};
end
[sysp,eyep,freq]=deal(ts.start_year,ts.last_year,ts.freq)

TimeSeries=ts(sysp(1),1,eyep(1),freq,:);


dati=TimeSeries.matdata;
date=TimeSeries.dates;

T=size(date,1);
plot_handle=plot(1.5:1:T+0.5,dati);
%set(plot_handle,'marker','o')

ax1=gca;

set(gca,'Xlim',[1,T+1],'Xtick',1:T+1,'Xticklabel',num2str([1:T+1]'),'Fontname',fontname,'Fontweight',fontweight,'Fontsize',fontsize);

if exist('YLIM','var')
    base=YLIM;
    set(gca,'Ylim',YLIM)
else
    base=get(gca,'Ylim');
end
    
steps=1;
% Set here the minorticks frequency
if nargin==2
    steps=varargin{1};
end
s=NaN(T,1);

offset=diff(base)/100;

for j=1:steps:T
     s(j,1)=line([j,j],[base(1),base(1)+offset]);
     set(s(j,1),'Color','k');

%      if mod(j,freq)==0
%          a(r)=line([j,j],[base(1),base(1)+2*offset]);
%          set(a(r),'Color','k');
%          r=r+1;
%      end

end


prd='yyyy';
nuovi=datestr(date,prd);
mese=month(date);

if freq==4
    mese=(mese+2)/3;
end

gen=1;

anno=sysp(1);
k=1;
for j=freq/2:freq:T
    basex(k)=text(j,base(1)-diff(base)/20,num2str(anno));
    set(basex(k),'Fontname',fontname,'Fontsize',fontsize,'Fontweight',fontweight)
    anno=anno+1;
    k=k+1;
end

%ax2=ticklabel(gca);
%set(ax2,'Xminortick','on')


% This puts grids and ticks right before first period of each year
set(ax1,'Xtick',gen:freq:T+1,'Xminortick','off','Xticklabel',' ');
set(ax1,'Xgrid','on','Ygrid','on')

varargout{1}=plot_handle;
varargout{2}=basex;
varargout{3}=s;
varargout{4}=ax1;
% set(ax1,'Ytickmode','manual')
% set(ax1,'Yticklabelmode','manual')
% set(ax2,'Ytickmode','manual')
% set(ax2,'Yticklabelmode','manual')

