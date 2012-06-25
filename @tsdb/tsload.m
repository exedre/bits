function varargout = tsload(db, namelist, varargin)
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
%                       emmanuele.somma@bancaditalia.it - esomma@ieee.org
%
%                       Giuseppe Acito
%                       giuseppe.acito@bancaditalia.it
%
% $Id: tsload.m,v 1.3 2007/11/27 16:35:39 m024000 Exp $


conn = db.conn ;
diffrel = false ; % Dafault is that all series have same release date

[ok, namelist] = check_opt(namelist, { { 'char' } , { 'cell' } }, 'cell' );   
if ~ok
    error(['Error in option ''namelist'' (' namelist ')'])
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
tnm = tsinfo(db,namelist,'orderbyfreq');
namelists = tnm{1}; 
freqs = tnm{2};
freq = freqs{:};
namelists = reordernames(namelists,namelist);
release  = orderrel(namelists,namelist,release);


% Limits
if nargin>3
  [ok, interval] = check_opt(varargin{2}, { { 'char' }, ...
                                           {'double'}, ...
                                           {'cell'  } }, ...
                                         'cell', { 'double', 'date2tsidx' }, freq );
  if ~ok
    error(['Error in option ''interval'' (' interval ')'])
  end
else
  interval = { nan, nan };
end


for k=1:size(namelists,2)
    try
        series  = namelists{k};
        serie   = series{1};
        nseries = length(series);
        rx = release{k,1};
        if  ~isa(rx,'cell')
            rx = { rx };
        end

  % Gets the all releases for the first serie
        [ts,rmax] = GetTSR(db, serie, rx, interval);
        if ~isnan(rmax)
            ts = addmeta(ts,'release',rmax);
            rel = max(rel,rmax);
        end
  
  % If there are other series in the same frequency bin
        if nseries > 1 
            for i=2:nseries      
                serie = series{i};
                if size(release,2)>1
                    rx = release{k,i};
                end
                if  ~isa(rx,'cell')
                    rx = { rx };
                end
                [tse, r] = GetTSR(db,serie,rx,interval);
                if ~isnan(r)
                    tse = addmeta(tse,'release',r);
                    ts = [ ts tse ];
                    rel = max(rel,r);
                end
            end
        end
        st = size(ts,1);
        if st(1)> 0
            ts = addmeta(ts,'release',rel);
        end
        varargout{k} = ts;
        commit(db);
    catch errore 
        rollback(db);
        rethrow(errore);
    end
end

function namelists2 = reordernames(namelists,namelist)
  class(namelists);
  namelists2 = {};
  m=1;
  for i=1:length(namelists)
        bin = namelists{i};    
        bin1 = {};
        n = 1;
        if isa(bin,'cell')
          for k=1:length(namelist)
            ser = namelist(k);
            if ismember(ser,bin)
              bin1(n,1) = ser;
              n = n + 1;
            end
          end
        end
        namelists2{1,m}=bin1;
        m=m+1;
    end
    

function rel = orderrel(namelists,namelist,release)   
%
% This function put release in order for reordered series
%
    if isnan(release{1})
        for i=1:length(namelists)
            for j=1:length(namelists{i})
                rel{i,j} = nan;
            end
        end
        return
    end
    if size(release,1) ~= size(namelist,1)
        for i=1:length(namelists)
            for j=1:length(namelists{i})
                rel{i,j} = release{size(release,1)};
            end
        end
        return
    end
    for i=1:length(namelists)
        bin = namelists{i};
        if isa(bin,'cell')
            for j=1:length(bin)
                name = bin{j};
                rel{i,j}=release(strmatch(name,namelist));
            end
        else
            rel{i,1}=release(strmatch(bin,namelist));
        end
    end
        




%% Supporting functions
function [ts,maxrel] = GetTSR(db,serie,release,interval) % Get Time Series
                                                 % Releases
    ts = [];
    maxrel=0;
    if isa(release,'cell') 
        release = release{1};
    end
    if isnan(release)
        r = nan;
        [ tse, r ] = GetTS(db,serie,r,interval) ;
        maxrel = max(maxrel,r);
        ts = [ ts tse ];                  
        return;
    end
    if isa(release,'double') & ~isscalar(release)
        release = num2cell(release);        
    end
    for j=1:length(release)
        if isa(release,'cell')
            r = release{j};
        else
            r = release ;
        end
        [ tse, r ] = GetTS(db,serie,r,interval) ;
        maxrel = max(maxrel,r);
        ts = [ ts tse ];          
    end
function [ts,release] = GetTS(db,serie,release,interval)
    [ts,release] = GetTS_old(db,serie,release,interval);
    
function [ts,release] = GetTS_old(db,serie,release,interval)
    if isa(release,'cell')
        error(['@' mfilename('class') '\' mfilename '::cannot load ts with release class'])
    end
    [ID,ts.freq]=GetInfo(db,serie);
    if isnan(ID)
        ts = [];
        release = nan;        
        return
    end
    begin_seq = 0;
    end_seq = inf;
    if isnan(release)
        [VID, release,ts.start_year,ts.start_period] = GetLastRelease(db,ID);
        [begin_seq,end_seq] = seqfind(ts,interval);
    else
        try
            [VID,ts.start_year,ts.start_period] = GetRelease(db,release, ...
                                                             ID);
            [begin_seq,end_seq] = seqfind(ts,interval);
        catch
            fprintf('release %s for series %s does not exists',datestr(release),serie)
            return
        end
    end
    if begin_seq>0 || end_seq<inf
      data = GetDataInterval(db,VID,ID,begin_seq,end_seq);
    else
      data = GetData(db,VID,ID);
    end
    [ year, period ] = seqadvance(ts,begin_seq);
    ts = tsmat(year,period,ts.freq,data);
    ts = GetMetaData(db,ts,VID,ID);
    ts = addmeta_cols(ts,1,'release',{release});
    
    
    
function [ts,release] = GetTS_new(db,serie,release,interval)
    
    [ID,ts.freq]=GetInfo(db,serie);
    if isnan(ID)
        ts = [];
        release = nan;        
        return
    end
    
    
    begin_seq = 0;
    end_seq = inf;
    if ~isa(release,'cell') 
        [VID, release,ts.start_year,ts.start_period] = GetLastRelease(db,ID);
        [begin_seq,end_seq] = seqfind(ts,interval);
    else
        try
            [VID,ts.start_year,ts.start_period] = GetRelease(db,release, ...
                                                             ID);
            [begin_seq,end_seq] = seqfind(ts,interval);
        catch
            fprintf('release %s for series %s does not exists',datestr(release),serie)
            return
        end
    end
    if begin_seq>0 | end_seq<inf
      data = GetDataInterval(db,VID,ID,begin_seq,end_seq);
    else
      data = GetData(db,VID,ID);
    end
    [ year, period ] = seqadvance(ts,begin_seq);
    ts = tsmat(year,period,ts.freq,data);
    ts = GetMetaData(db,ts,VID,ID);
    ts = addmeta_cols(ts,1,'release',{release});    

function [begins,ends] = seqfind(ts,interval)
    % find begin and end sequence number given start, freq and interval
    % interval is { begin/nan, end/nan }
    % where begin/end are [ y p ]
    begins = 0;
    if isnan(interval{1})
      begins = 0;
    else
      idx = interval{1};
      begins = tsidx_distance(ts.freq, [ts.start_year ts.start_period ], idx);
    end
    ends = inf;
    if isnan(interval{2})
      ends = inf;
    else
      idx = interval{2};
      ends = tsidx_distance(ts.freq, [ts.start_year ts.start_period ], idx) + 1;
    end    
    
function [ year, period] = seqadvance(ts, begins)
    % Gives begin year and period 
    [ dy, du ] = distance2tsidx(ts.freq, begins, ts.start_year);
    year = ts.start_year + dy;
    period = ts.start_period + du;
    
function tse = AppendTSData(db,ts,VID,ID)
    tse = [ts tsx];
    
function tse = GetData(db,VID,ID)
    flog(db,sprintf('Get Data: %d/%d ',VID,ID));
    %setdbprefs('DataReturnFormat','numeric');
    query = sprintf('select VALUE from data where VID=%d and ID=%d ORDER BY SEQ',VID,ID);
    curs = exec(db.conn,query);
    curs = fetch(curs);
    if rows(curs) > 0
        tse = cell2mat(curs.Data);
    else
        tse = nan;
    end

function tse = GetDataInterval(db,VID,ID,begins,ends)
    flog(db,sprintf('Get Data: %d/%d %d-%d',VID,ID,begins,ends));
    %setdbprefs('DataReturnFormat','numeric');
    limit = '';
    if ~isnan(begins)
        limit = sprintf(' AND SEQ>%d ',begins);
    end    
    if ~isinf(ends)
        limit = sprintf('%s AND SEQ<=%d ',limit,ends);
    end
    query = sprintf('select VALUE from data where VID=%d and ID=%d %s ORDER BY SEQ',VID,ID,limit);
    curs = exec(db.conn,query);
    curs = fetch(curs);
    if rows(curs) > 0
        tse = cell2mat(curs.Data);
    else
        tse = nan;
    end

function tse = GetMetaDataVars(db,VID,ID)
    flog(db,sprintf('Get MetaDataVars: %d/%d ',VID,ID));
    %setdbprefs('DataReturnFormat','cellarray');
    query = sprintf('select N.TID, M.XID, N.Name, M.MID, M.VID from meta M, metaname N where N.MID = M.MID and M.VID=%d and M.ID=%d ORDER BY N.TID',VID,ID);
    curs = exec(db.conn,query);
    curs = fetch(curs);
    if rows(curs) > 0
        tse = curs.Data;
    else
        tse = nan;
    end
 function tse = GetMetaDataValues(db,TID,XID)
    flog(db,sprintf('Get MetaDataValues: %d/%d ',TID,XID));
    %setdbprefs('DataReturnFormat','cellarray');
    if TID==0
        meta = 'metastr';
    elseif TID==1
        meta = 'metanum';
    else
        error 'TID not supported'
    end
    query = sprintf('select VALUE from %s where XID=%d',meta,XID);
    curs = exec(db.conn,query);
    curs = fetch(curs);
    if rows(curs) > 0
        tse = curs.Data{1};
    else
        tse = nan;
    end

function ts = GetMetaData_old(db,ts,VID,ID)
    vars = GetMetaDataVars(db,VID,ID);                       % ?!?
    n = size(vars,1);
    for i=1:n
        val = GetMetaDataValues(db,vars{i,1},vars{i,2});
        if isa(val,'double')
            flog(db,sprintf('Adding Metadata %s = %d to %d/%d',vars{i,3},val,ID,VID));
        else
            flog(db,sprintf('Adding Metadata %s = %s to %d/%d',vars{i,3},char(val),ID,VID));
        end
        ts=addmeta_cols(ts,[1],vars{i,3},{val});
    end

function ts = GetMetaData_new(db,ts,VID,ID)
    flog(db,sprintf('Get MetaData: %d/%d ',VID,ID));
    %setdbprefs('DataReturnFormat','cellarray');    
    % Occorre fare due distinzioni: per TID = 1 e TID = 0
    %
    
    queryText = sprintf('SELECT N.Name, s.value FROM meta M, metaname N, metastr s WHERE N.MID = M.MID AND M.VID =%d AND M.ID =%d AND s.XID = M.XID', VID, ID);
    queryNum = sprintf('SELECT N.Name, s.value FROM meta M, metaname N, metanum s WHERE N.MID = M.MID AND M.VID =%d AND M.ID =%d AND s.XID = M.XID', VID, ID);
    
    curs = exec(db.conn, queryText);
    curs = fetch(curs);
    data = curs.Data;
    [righe,colonne] = size(data);
    
    %patch 27-10-08 Giuseppe
    if(righe == 1 && colonne ==1) 
         flog(db,sprintf('Warning! No Metastrings for ID=%d/VID=%d',ID,VID));
        % Se entro qui non ho dati!    
    % fine patch
    else
        for i=1:righe
            key = data{i,1};
            value = data{i,2};
        %    flog(db,sprintf('Adding Metadata %s = %s to %d/%d',key,value,ID,VID));
            ts=addmeta_cols(ts,[1],key,{value});
        end
    end % patch
    
    curs = exec(db.conn, queryNum);
    curs = fetch(curs);
    data = curs.Data;
    [righe,colonne] = size(data);
    if(righe == 1 && colonne ==1) 
        flog(db,sprintf('Warning! No Metanumbers for ID=%d/VID=%d',ID,VID));
    else
       for i=1:righe
           key = data{i,1};
           value = data{i,2};
       %    flog(db,sprintf('Adding Metadata %s = %d to %d/%d',key,value,ID,VID));
           ts=addmeta_cols(ts,[1],key,{value});
       end
    end
     
function ts = GetMetaData(db,ts,VID,ID)
    ts = GetMetaData_new(db, ts, VID, ID);
   % ts = GetMetaData_old(db, ts, VID, ID);

    
function [ID, freq ] = GetInfo(db,label)
    flog(db,sprintf('Get Info: %s ',label));
    query = sprintf('select ID,Freq from series where Name=''%s''',label);
    setdbprefs('DataReturnFormat','cellarray');
    curs = exec(db.conn,query);
    curs = fetch(curs,1);
    if rows(curs) > 0
        ID = curs.Data{1};
        freq = curs.Data{2};
    else
        ID = nan;
        freq = nan;
    end

function [VID,release, start_y, start_p,version, resolution] = GetLastRelease(db,ID)
    flog(db,sprintf('Get Last Release: %d ',ID));
%    setdbprefs('DataReturnFormat','cellarray');
%   query = sprintf('select MAX(Rel) from version where ID=%d', ID);
    query = sprintf('select VID,Start_year,Start_period,version,resolution, rel from version where ID=%d order by rel desc limit 1', ID); 
%    curs = exec(db.conn,query);
    curs = fetch(db.conn,query,1);
    righe = size(curs);
    % if size(curs.Data) > 0
    if  righe >= 1
        VID = curs{1,1};
        start_y = curs{1,2};
        start_p = curs{1,3};
        version = curs{1,4};
        resolution = curs{1,5};
        release = curs{1,6};
%        [ VID, start_y, start_p, version, resolution] = GetRelease(db,release,ID);
    else
        VID = nan;
        release = nan;
        start_y = nan;
        start_p = nan;
        version = nan;
        resolution = nan;
    end




function [VID, start_y, start_p, version, resolution] = GetRelease(db,release,ID)
    flog(db,sprintf('Get Release: %d on %d ',release,ID));
    query = sprintf('select VID,Start_year,Start_period,version,resolution from version where Rel=%d and ID=%d',release, ID);
    curs = exec(db.conn,query);
    curs = fetch(curs,1);
    if rows(curs) > 0
        VID = curs.Data{1};
        start_y = curs.Data{2};
        start_p = curs.Data{3};
        version = curs.Data{4};
        resolution = curs.Data{5};
    else
        VID = nan;
        start_y = nan;
        start_p = nan;
        version = nan;
        resolution = nan;
    end

function flog(db,var)
    if db.log
        fd = fopen(fullfile('',db.logname),'a');
        fprintf(fd,strcat('tsload::',var,'\n'));
        fclose(fd);        
    end
