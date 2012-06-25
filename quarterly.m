function tsq=quarterly(ts,varargin)
%QUARTERLY aggregation of a monthly tsmat/tseries object 
%    [Y]=QUARTERLY(TS,opt1,opt2)
%    with opt1='pad' {default},opt2='ave' {default},
%    returns a Tqxm temporally aggregated series 
%    where ts (n x m) is a tseries of high frequency data
%    Optional type of temporal aggregation  is like 
%	 'sum' for sum (flow), 
%    'ave' for average (index) (which is the default) and 
%    'stock' for last element (stock) 
%
%	See also: consolidator.m, aggrts.m
 

%   Copyright 2005-2006 Claudia Miani, Emmanuele Somma, Giovanni Veronese (Servizio Studi Banca d'Italia)
%   $Revision: 1.4 $  $Date: 2007/03/19 11:33:13 $
%	accumarray(cumsum([1;diff(year(aa.dates)]),aa.matdata,[],@mean)
%	accumarray(cumsum([1;diff(year(aa.dates)]),aa.matdata)
%  

% Default Options Settings
opt1='nopad';		% Nopadding
opt2='ave'  ;	    % Mean of obs. in the quarter 		 
			 
if nargin==2
		opt1=varargin{1};
elseif nargin==3
		opt1=varargin{1};
		opt2=varargin{2};
elseif nargin>3
	error('too many input arguments')
end

metadata = getfullcolmeta(ts);
[t n] = size(ts);
if iscell(opt2)
    opt2 = char(opt2);
end
if size(opt2,1) == 1 || size(ts,2) == 1
    tsq      = aggrts(ts,4,opt1,opt2);
elseif size(ts,2) >1 && size(opt2,1) == n
    if strcmp(opt1,'nopad')
        tsq = tsmat(ts.start_year,ceil(ts.start_period/3),4,NaN(ceil((t-1)/3),n));
    else
        tsq = tsmat(ts.start_year,ceil(ts.start_period/3),4,NaN(ceil((t-1)/3)+1,n));
    end
    for kk = 1:size(ts,2)
        opzi = opt2(kk,isletter(opt2(kk,:)));       % questo è un mezzo casino, ma è l'unico modo che ho trovato per cavarci le gambe
        tsq(:,kk) = aggrts(ts(:,kk),4,opt1,opzi);
    end
else 
    error('Wrong second argument size')
end
tsq      = setfullcolmeta(tsq,metadata);

