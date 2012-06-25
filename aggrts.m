function tsm=aggrts(ts,outfreq,varargin)
% AGGRTS aggregation of a tsmat/tseries object into lower freq tsmat
%    [Y]=MONTHLY(TS,outfreq,opt1,opt2)
%    outfreq=output frequency (ts.freq>outfreq=tsm.freq )   
%    with opt1='pad' {default}, opt2='ave' {default}, 
%    returns a Tqxm temporally aggregated series 
%    where ts (n x m) is a tseries of high frequency data
%    Optional type of temporal aggregation  is like 
%	 'ave' for average (index) (which is the default) and 
%    'stock' for last element (stock) 
%    'otherfucntion' as long as it is returning the function along the second dimension 
%
%	See also:  aggrts.m, quarterly.m, semiannual.m, annual.m
 

%   Copyright 2005-2006 Claudia Miani, Emmanuele Somma, Giovanni Veronese (Servizio Studi Banca d'Italia)
%   $Revision: 1.1 $  $Date: 2007/08/02 07:16:20 $
%	accumarray(cumsum([1;diff(year(aa.dates)]),aa.matdata,[],@mean)
%	accumarray(cumsum([1;diff(year(aa.dates)]),aa.matdata)
%  

% Default Options Settings
opt1='pad';		    % Default behavior is padding
opt2='ave'  ;	    % Mean of obs. in the quarter 		 
			 

data=ts.matdata;

if nargin==3
		opt1=varargin{1};
elseif nargin==4
		opt1=varargin{1};
		opt2=varargin{2};
elseif nargin>4
	error('too many input arguments')
end


if ts.freq<=outfreq
    error('output frequency is higher than input one!')
end




T=size(data,1);
[y1,p1]=deal(ts.start_year,ts.start_period);
data1=tsidx2date(ts.freq,y1,p1);

switch ts.freq
    case 365
        date1=data1+cumsum(ones(T,1))-1;
        
    otherwise
        date1=ts.dates;
      
end    


anno=year(date1);
periodo=ceil(month(date1)/(12/outfreq));
    
yy=anno;
nm=periodo;

out_start_year=yy(1);
out_start_period=periodo(1);


dnm=diff(nm);
dnm(diff(yy)>0,1)=1;
% Cumulative Quarter Number
cumm=cumsum([1;dnm]);


switch opt2
    case 'ave'
        fun=@mean;
    case 'stock'
        fun=@last;
     case 'nanlast'
        fun=@nanlast;
    otherwise
        fun=str2func(opt2);
end

% Accumarray works only for vector data: use consolidator instead
% newdata=accumarray(cumq,data,[],fun);


if T==1
	% if T=1 no need to do anything!
	newdata=data;
else
	[xcon,newdata] = consolidator(cumm,data,fun);
end





if strmatch(opt1,'nopad')
    p=12/outfreq;
    w=nm(1)*p-(p-1);
    r=nm(end)*p;

    % Numeric date for first day of the period in which tsmat starts
    p_s=datenum(yy(1),w,1);
    % Numeric date for last day of the period in which tsmat ends
    p_e=addtodate(datenum(yy(end),r,1),1,'month')-1;%

    if  tsidx2date(ts.freq,y1,p1)>p_s
        %Time series start after beginning of first quarter
        newdata(1,:)=NaN;
    end

    if tsidx2date(ts.freq,ts.last_year,ts.last_period)<p_e
        %Time series ends before end of last quarter:
        newdata(end,:)=NaN;
    end

end



tsm=tsmat(out_start_year,out_start_period,outfreq,newdata);





metadata=getfullcolmeta(ts);
tsm =  setfullcolmeta(tsm,metadata);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function LL=last(x)
LL=x(end,:);

function LL=nanlast(x)
% to avoid in case of daily data missing values for weekends or holidays
LL=x(end,:);
if isnan(LL)
    LL=x(end-1,:);
end
if isnan(LL)
    LL=x(end-2,:);
end
if isnan(LL)
    LL=x(end-3,:);
end
if isnan(LL)
    LL=x(end-4,:);
end


% function oned=oneday(x,whichday)
% % IF using daily data chooses a particular day in the month
% oned=x(whichday,:);


