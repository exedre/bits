function [tss]=semiannual(ts,varargin)
%SEMIANNUAL aggregation of a monthly tsmat/tseries object 
%    [Y]=SEMIANNUAL(TS,opt1,opt2)
%    with opt1='ave' {default}, opt2='pad' {default}
%    returns a Tsxm temporally aggregated series 
%    where ts (n x m) is a tseries of high frequency data
%    Optional type of temporal aggregation  is like 
%	 'sum' for sum (flow), 
%    'ave' for average (index) (which is the default) and 
%    'stock' for last element (stock) 
%
%	See also:  aggrts.m,consolidator.m
 

%   Copyright 2005-2006 Claudia Miani, Emmanuele Somma, Giovanni Veronese (Servizio Studi Banca d'Italia)
%   $Revision: 1.2 $  $Date: 2006/11/08 10:47:24 $
%	accumarray(cumsum([1;diff(year(aa.dates)]),aa.matdata,[],@mean)
%	accumarray(cumsum([1;diff(year(aa.dates)]),aa.matdata)
%  

% Default Options Settings
opt1='nopad';		% Nopadding
opt2='ave'  ;	    % Mean of obs. in the semiannual  		 
			 

switch class(ts)
	case 'tseries'
		tipo=1;
		data=ts.data;
	case 'tsmat'
		tipo=2;
		data=ts.matdata;
end

if nargin==2
		opt1=varargin{1};
elseif nargin==3
		opt1=varargin{1};
		opt2=varargin{2};
elseif nargin>3
	error('too many input arguments')
end





T=size(data,1);
numdate=ts.dates	;		%needs to be column vector
ns=semi(numdate) ;
yy=year(numdate);

dns=diff(ns);
dns(find(dns==-1))=1;
% Cumulative semiannual  Number
cums=cumsum([1;dns]);
switch opt2
	case 'ave'
		fun=@mean;
	case 'sum'
		fun=@sum;
	case 'stock'
		fun=@last;
end

% Accumarray works only for vector data: use consolidator instead
% newdata=accumarray(cumq,data,[],fun);
if T==1
	% if T=1 no need to do anything!
	newdata=data;
else
	[xcon,newdata,ind] = consolidator(cums,data,fun);
end

%indi=accumarray(cums,ones(T,1),[],@sum);


% Numeric date for first day of the semiannual  in which ts starts
s_s=datenum(yy(1),ns(1)*6-6,1);
% Numeric date for last day of the semiannual  in which ts end
s_e=datenum(yy(end),ns(end)*6,1)-1;


if strmatch(opt1,'nopad')
	% Fill with Nan start and end dates if needed
	
	if fix(numdate(1))>s_s
		%Time series start after beginning of first semiannual 
		newdata(1,:)=NaN;
	end

	if fix(numdate(end))<s_e
		%Time series ends before end of last semiannual :
		newdata(end,:)=NaN;
	end

end

% Final Semiannual Series

switch class(ts)
	case 'tseries'
		tss=tseries(yy(1),ns(1),2,newdata);
	case 'tsmat'
		tss=tsmat(yy(1),ns(1),2,newdata);
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find Period number from month
function ns=semi(numdates);
nm=month(numdates);
ns=NaN*numdates;
ns([find(nm<=6)])=1;
ns([find(nm>=7)])=2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to obtain last obs in given period
function LL=last(x);
LL=x(end,:);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [n,m] = month(d)
%MONTH Month of date. 
%   [N,M] = MONTH(D) returns the month in numeric and string form given
%   a serial date number or a date string, D.
%       
%   For example, [n,m] = month(728647) or [n,m] = month('19-Dec-1994')
%   returns n = 12 and m = Dec.
%
%   See also DATEVEC, DAY, YEAR.
 
%       Copied from finance toolbox
%       
%       

if nargin < 1
  error('Please enter D.')
end
if isstr(d)
  d = datenum(d);
end

c = datevec(d(:));           % Generate date vectors

mths = ['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';
        'Aug';'Sep';'Oct';'Nov';'Dec'];
n = c(:,2);              % Extract months
m = mths(c(:,2)+(c(:,2)==0),:);      % Month strings
if ~isstr(d)
  n = reshape(n,size(d));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = year(d) 
%YEAR Year of date. 
%   Y = YEAR(D) returns the year of a serial date number or a date string, D. 
% 
%   For example, y = year(728647) or y = year('19-Dec-1994') returns y = 1994. 
%  
%   See also DATEVEC, DAY, MONTH. 
 
%       Copied from finance toolbox
%       

 
if nargin < 1 
  error('Please enter D.') 
end 
if isstr(d) 
  d = datenum(d); 
end 
 
c = datevec(d(:));          % Generate date vectors from dates 
y = c(:,1);             % Extract years  
if ~isstr(d) 
  y = reshape(y,size(d)); 
end 

