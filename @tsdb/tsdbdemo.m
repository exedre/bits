function ts = tsdbdemo(db, varargin)
% @TSDB\TSDEMO - Database Administrative Commands
%
% res = tsadmin(db,[operation, [arg, ... ] ] ...)
%
% == CREATE - Create Demo Database == 
%
% >> tsdemo(db,'create')
%
%
%   Copyright 2005-2012 Emmanuele Somma    (Servizio Studi Banca d'Italia)
%                       emmanuele.somma@bancaditalia.it - esomma@ieee.org
%
%
% $Id: tsdbdemo.m,v 1.2 2007/11/27 16:35:39 m024000 Exp $
%
conn = db.conn ;

if nargin==1
    disp('No operation')
    return
end

j=1;
ts=[];
nop = nargin;
i=1;
while i<nargin
    op = varargin{i};

    if strcmp(op,'create') == 1
        ts{j,1} = 'create' ;
        if Sure()
            ts{j,2} = DBCreate(db);
        else
            ts{j,2} = 'aborted';
        end


    else
        disp(sprintf('operation %s not understood',op))
    
    end

    j=j+1;
    i=i+1;
end

%% Supporting functions

function [i, arg] = get_next_arg(i,varargin,load)
   i=i+1;
   arg = varargin{i};

function ret = Sure()
    answer = input('Are you sure (please enter ''yes'' or ''no'')? ','s');
    if strcmp(answer,'yes')~= 1
        disp('operation aborted');
        ret = false;
    else
        ret = true;
    end

function ret = hquery(conn,query)
    curs = exec(conn,query);
    curs = fetch(curs);
    if rows(curs) > 0
        ret = curs.Data;
    else
        ret = nan; 
    end

function ret = xquery(conn,query)
    setdbprefs('DataReturnFormat','numeric');
    ret = hquery(conn,query);
    
function ret = squery(conn,query)
    setdbprefs('DataReturnFormat','cellarray');
    ret = hquery(conn,query);

function curs = xexec(conn,query)
    curs = exec(conn,query);

function curs = arrexec(conn,query)
    for i=1:length(query)
        curs = xexec(conn,query{i})
    end

function ret = DBCreate(db)
    ret = [];
    if strcmp(db.username,'root')==1
        tsadmin(db,'setup','*BITS','demo');
        dbin = tsdb(strcat(db.prefix,'bitsdemo'),'BITS','');
        if isconnection(dbin)
            tsadmin(dbin,'import','FULLBACKUP_DEMODB.sql');
            close(dbin);
        end
    end 
    
    


        
    
function NIY()
   error(['@' mfilename('class') '\' mfilename '::Not Implemented Yet. Please wait next BITS version'])
