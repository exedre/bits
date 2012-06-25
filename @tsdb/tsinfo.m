function ts = tsinfo(db, namelist, varargin)
% @TSDB/TSINFO - Information about BITSDB contents
%
% res = tsinfo(db,[operation, [arg, ... ] ] ...)
% op_res = res{#op,2}
%
% == NSERIES -  Number of series in DB ==
%
% >> res = tsinfo(db, nan, 'nseries')
% >> nseries = res{2}
%
% == SERIES - Names of the series in DB ==
%
% >> series = tsinfo(db,nan, 'series')
%
% TODO: Regex selection, subquery
%
% == NRELEASES - Number of releases in series ==
%
% >> res = tsinfo(db, {series}, 'nreleases')
% >> nrels = res{1,1}
% >> nerls_serie1 = nrels{1}
%
% == RELEASES - Set of release dates for a given series ==
%
% >> rels = tsinfo(db, {series}, 'releases'}
% >> rels_serie1 = rels{1}
% 
% == ORDERBYFREQ - returns series ordered by frequency ==
%
% >> [ordered, freqs] = tsinfo(db, {series}, 'orderbyfreq'} 
%
%
%   Copyright 2005-2012 Emmanuele Somma    (Servizio Studi Banca d'Italia)
%                       emmanuele.somma@bancaditalia.it - esomma@ieee.org
%                       Giuseppe Acito     
%                       giuseppe.acito@bancaditalia.it
% $Id: tsinfo.m,v 1.4 2007/11/27 16:35:39 m024000 Exp $

%% Main
k=2;
if nargin==1
    disp('No operation')
    return
end

if nargin==3 & ~isa(varargin{1},'char')
    disp('No operation')
    return
end

if isa(namelist,'cell')
    k=2;
elseif isa(namelist,'tsmat')
    namelist=varargin{1}.meta_cols.label;
    k=2;
end

ts=[];
nop = nargin-k;
j=1;
for i=k-1:nargin-2
    op = varargin{i};
    if strcmp(op,'nseries') == 1
        ts{j,1} = 'nseries' ;
        ts{j,2} = GetNumSeries(db.conn);
        
    elseif strcmp(op,'series') == 1
        ts = GetSeries(db.conn);
        
    elseif strcmp(op,'nreleases') == 1
        ts{j,1} = 'nreleases' ;
        [ n, r ] = GetNumReleases(db.conn,namelist);
        ts{j,2} = r ;
        ts{j,3} = n ;

    elseif strcmp(op,'releases') == 1
        [ n, r ] = GetReleases(db.conn,namelist);
        ts = n;

    elseif strcmp(op,'orderbyfreq') == 1
        [a,b]= OrderByFreq(db.conn,namelist);
        ts{1} = a;
        ts{2} = b;

    else
        ts{j} = nan;
        disp(sprintf('operation %s not understood',op))
        
    end
    j=j+1;
end

%% Support functions
%


function ret = GetNumSeries(conn)
    ret = xquery(conn,'select COUNT(ID) from series ');

function [ ret, namelist ] = GetNumReleases(conn,namelist)
    query = 'select I.Name, COUNT(R.VID) from version R, series I where  I.ID = R.ID and I.Name in (';   
    for i=1:length(namelist)
        query = [query '''' namelist{i} ''','];
    end
    query = [query(1:end-1) ') group by I.Name'];
    curr = squery(conn, query);
    namelist = curr(:,1);
    ret = curr(:,2);

function [ ret, namelist ] = GetReleases(conn,namelist)
    query = 'select  R.Rel,I.Name from version R, series I where I.ID= R.ID and I.Name in (';
%     cond = ' I.Name = ''%s'' OR';
    L = length(namelist);
    for i=1:L
%       newcond = sprintf(cond, namelist{i});
        query = [query '''' namelist{i} ''','];
    end
    query = query(1:end-1);
    query = [query ') order by I.Name, R.Rel'];
    data = fetch(conn, query);
    righe = size(data);
    if righe == 0
        ret = [];
        namelist = [];
    else
        ret = data(:,1)';
        namelist = data(:,2)';
    end
%    for i=1:length(namelist)
%       r = xquery(conn,sprintf('select R.Rel from version R, series I where  I.ID = R.ID and I.Name = ''%s'' ORDER BY Rel',namelist{i}));
%        ret(i) =   {r} ; 
%    end


function ret = GetSeries(conn)
    ret = fetch(conn,sprintf('select Name from series'));

function [ ret, freqs ] = OrderByFreq(conn,namelist)
    query = 'select Name,Freq from series where Name in (';
    for i=1:length(namelist)
       query = [query '''' namelist{i} ''','];          
    end
    query = query(1:end-1);
    query = [query ') order by freq desc'];
    curs = fetch(conn, query);
    ret = {curs(:,1)};
    freqs = curs(:,2);

