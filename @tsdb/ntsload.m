function varargout = ntsload(db, namelist, varargin)
% @TSDB/TSLOAD - Load a series from database 
%
% >> ts = tsload(db,{series},{releases})
%
% >> ts = tsload(db, 'NAME' )
%    Gets last release of the series 
%
% >> ts = tsload(db, { 'NAME1' 'NAME2' } )
%    Gets last release of the namelist 
%
% >> ts = tsload(db, 'NAME', { '01-Jan-2007', '01-Mar-2007' } )
%    Gets multiple releases for one series
%
% >> ts = tsload(db, { 'NAME1' 'NAME2' }, { '01-Jan-2007', '01-Mar-2007' } )
%    Gets single release for each series 
%    NAME1->01-Jan-2007, NAME2->02-Mar-2007
%
% >> ts = tsload(db, { 'NAME1' 'NAME2' }, { { '01-Jan-2007', ...
%                 '01-Mar-2007' }, { '01-Mar-2005' '01-Jun-2007' } )
%    Gets single release for each series 
%    NAME1->01-Jan-2007, 01-Mar-2007
%    NAME2->01_Mar-2005, 01-Jun-2007
%
%
% >> ts = tsload(db, namelist, release | nan , interval)
%    where interval is
%                          [ start ]
%                          [ nan end ]
%                          [ start end ]
%
%    where start or end are
%
%          tsidx    [ yy mm ]
%          datestr  'dd-mmm-yyyy'
%
%  NYI()
%          double   yy.mm
%          datenum  dddddd > 3000
%          string   '+<n>' '-<n>'
%
%
%   Copyright 2005-2012 Emmanuele Somma    (Servizio Studi Banca d'Italia)
%                       emmanuele_DOT_somma_AT_bancaditalia_DOT_it - esomma@ieee.org
%
%                       Giuseppe Acito
%                       giuseppe_DOT_acito_AT_bancaditalia_DOT_it
%
% $Id: tsload.m,v 1.3 2007/11/27 16:35:39 m024000 Exp $


conn = db.conn ;
diffrel = false ; % Dafault is that all series have same release date

% Namelist Management
[ok, namelist] = check_opt(namelist, { { 'char' } , ...  % ie 'SERIES' 
                                       { 'cell' } }, ... % ie. { 'SERIES1', 'SERIES2' } 
                           'cell' );                     % RESULT TYPE is cell
if ~ok
    error(['Error in option ''namelist'' (' namelist ')'])
end

[a,b]=size(namelist);
if a>b
  namelist=namelist';
end

% Release Management
if nargin>2
    [ok, release] = check_opt(varargin{1}, { { 'char' },     ...               % ie. '01-Jul-2007'
                                             { 'double' },   ...               % ie. 733229
                                             { 'cell' } },   ...
                                      'cell', { 'double' 'datenum' } );


    if ~isa(release,'cell')
        if isnan(release) & nargin>3
          ok = true;
        end
        release = { nan };
    end
    
    if ~ok 
        error(['Error in option ''release'' (' release ')'])
    end
else
    release = {nan};
end

% If have single timeseries name and multiple releases
% download the timeseries for all the release given

% && isa(release,'cell')
if length(namelist)==1 && length(release)>1
    r = [];
    for i=1:length(release)
        r(i) = release{i};
    end
    release{1} = r(:);
end

% First Phase: Know if tsmat has right metadatas
rel = 0;
%i=1;

% Order Namelist by freq
%tnm = tsinfo(db,namelist,'orderbyfreq');
%namelists = tnm{1}; 
%freqs = tnm{2};
%freq = freqs{:};
%namelists = reordernames(namelists,namelist);
%release  = orderrel(namelists,namelist,release);
% release

% Limits
%if nargin>3
%  [ok, interval] = check_opt(varargin{2}, { { 'char' }, ...
%                                           {'double'}, ...
%                                           {'cell'  } }, ...
%                                         'cell', { 'double', 'date2tsidx' }, freq );
%  if ~ok
%    error(['Error in option ''interval'' (' interval ')'])
%  end
%else
%  interval = { nan, nan };
%end


nargin


% 
if nargin<3 
  ts = ntsload_native(db, namelist);
else
  ts = ntsload_native(db, namelist,varargin{1});
end
tsdata = tsmat(ts.start_year,ts.start_period,ts.freq,ts.matdata');

if ~isnan(ts.meta_cols)
  tsdata.meta_cols=ts.meta_cols
end

varargout{1} = tsdata;


