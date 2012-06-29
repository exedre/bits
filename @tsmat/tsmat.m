function ts = tsmat(varargin)
%@tsmat/tsmat - constructs a time series matrix object.
%
% 
%   A time series matrix (TSMAT) object is a MATLAB object that minimally
%   contains a data matrix, a frequency indicator and 
%   a start year and period  (henceforth called a tsidx).
%   The frequency and tsidx *must* be explicitly specified.  
%   In addition to these four items (start year and period, frequency, data) 
%   the time series can also contain a bunch of metadatas, which 
%   can be added separately with addmeta commands.
%
%   There is a single way to instantiate a TSMAT object
%   using the constructor.  It is:
%
%      TS = tsmat(YEAR,PERIOD,FREQ,DATAMATRIX);
%
%   TS = tsmat(YEAR,PERIOD,FREQ,DATAMATRIX) generates a time series object,TS.
%   The data in the input matrix needs to be of size 
%   T x N where T=number of periods, N=number of columns (individual time series).
%
%   For example:
%
%      t = tsmat(1980,1,12,rand([1 40])
%
%   You can specify the frequency indicator, FREQ, using these 
%    valid frequency indicators:
%
%      DAILY,      Daily,      daily,      D, d, 365
%      WEEKLY,     Weekly,     weekly,     W, w, 52
%      MONTHLY,    Monthly,    monthly,    M, m, 12
%      QUARTERLY,  Quarterly,  quarterly,  Q, q, 4
%      SEMIANNUAL, Semiannual, semiannual, S, s, 2
%      ANNUAL,     Annual,     annual,     A, a, 1
%   
%   You can even use some other frequencies as:
%       .5   One observation every two years
%       .25  One observation every four years
%       .125 One observation every eight years
%   or:
%        730  Twice a day
%       1460  Four times a day
%
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni_DOT_veronese_AT_bancaditalia_DOT_it)
%           Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%
  
%% -Main---------------------------------------------------------------

if nargin == 0
	ts.matdata = [];
	ts.start_year= 0;
	ts.start_period = 0;
	ts.freq = 0;
	ts.last_year = NaN;
	ts.last_period = NaN;
	ts.meta = {};
	ts.meta_cols=struct([]); % to avoid problems with empty meta_cols when using getfullcolmeta             
	ts=class(ts,'tsmat');
	met = [];
	% sistemato il caso del display di una tsmat vuota.
	% 15-2-08 G.Acito
	met.label = {'EMPTY'};
	ts.meta_cols = met;
		
elseif isa(varargin{1},'tsmat')
    % copy constructor
    ts  = varargin{1};
	return

elseif isa(varargin{1},'struct')
  % copy constructor
    ts  = varargin{1};
    [ ts.last_year, ts.last_period ] = start2end(ts.freq, ts.start_year, ts.start_period, size(ts.matdata,1)-1 );
    ts=class(ts,'tsmat');
	return

elseif and(nargin==1,isa(varargin{1},'tseries'))
    % copy constructor: input is monovariate tseries
    disp(['WARNING: be advised that tseries are no more supported and will ' ...
          'be deleted in the next release of tsmat code' ]);
    TSE=varargin{1};
    ts  =tsmat(TSE.start_year,TSE.start_period,TSE.freq,TSE.data);	
    return

elseif nargin < 4
  error(['@' mfilename('class') '\' mfilename '::need at least 4 arguments'])

else
    % Column Labels management
    %
    base='T';
    if nargin<5
      for i=1:size(varargin{4},2)
        colnames{i}=strcat(base,num2str(i));
      end
    end
    if nargin>5
        if isa(varargin{5},'double') 
            if isnan(varargin{5})
                varargin{5}=base;
            end
        end
    end
    if nargin>4 
      [ok, colnames] = check_opt(varargin{5}, { { 'char' } , { 'cell' } }, 'cell' );   
      if ~ok
        error(['@' mfilename('class') '\' mfilename '::Error in option ''namelist'''])
      end
      n = length(colnames);
      l = size(varargin{4},2);
      base=colnames{n};
      if n<l
        for i=n:l
          colnames{i}=strcat(base,num2str(i));
        end      
      end      
    end

    % Release Date Management
    release=today;
    
    % Release Management
    if nargin>5 
        [ok, release] = check_opt(varargin{6}, { { 'char' },     ...               % ie. '01-Jul-2007'
                                                 { 'double' },   ...               % ie. 733229
                                                 { 'cell' } },   ...
                                          'cell', { 'double' 'datenum' } );


        if ~isa(release,'cell')
            if isnan(release) & nargin>6
              ok = true;
            end
            release = { nan };
        end
    
        if ~ok 
          error(['@' mfilename('class') '\' mfilename '::Error in option ''release'' (' release ')']);
        end
    else
        release = { nan };
    end
    

    syear   = varargin{1};  % Start Year
    speriod = varargin{2};  % Start Period
    freq    = varargin{3};  % Frequency
    matdata = varargin{4};  % Values
    
    % Check if start period is less than 0
	if speriod < 1
		error(['@' mfilename('class') '\' mfilename '::starting period must be positive'])
	end

    % Adjusts high frequencies as conventional
    if freq == 366 
        freq = 365;
    elseif freq == 53 
        freq = 52;
    end

    % Get the right freq for given year
    f = ifreq(freq,syear);

    % Check if start period is greater than real year ifreq
    if speriod > f
      error(['@' mfilename('class') '\' mfilename '::period greater than freq'])
    end
	
    % Setup struct variables
    ts.matdata      = matdata;
    ts.start_year   = syear;
    ts.start_period = speriod;
    ts.freq         = freq;
    ts.last_year    = NaN;
    ts.last_period  = NaN;
    ts.meta         = {};
    ts.meta_cols    = {};
    ts = class(ts, 'tsmat');

    % Setup ending tsidx
    [ ts.last_year, ts.last_period ] = start2end(freq, syear, speriod, size(matdata,1)-1 );

    % Adding Names to columns
    ts=addmeta_cols(ts, 1:size(colnames,2),'label',colnames);

    % Adding Created and Release date
    if ~isnan(release{1})
        if length(release)==1
          ts = addmeta(ts,'release',release{1});
        else
          ts = addmeta(ts,'release',today);
          ts = addmeta_cols(ts, 1:size(release,2),'release',release);
        end
    else
        ts = addmeta(ts,'release',today);
    end
    
end

