function db = tsdb(varargin)
%@TSDB/TSDB Database for timeseries.
%
% db = tsdb()             - null constructor
% db = tsdb(another_tsdb) - copy constructor
% db = tsdb(dsn,password) - connect to DSN for actual username with
%                           password 
% db = tsdb(dsn,password,user) - connect to DSN for user with
%                                password 

% dsn could be a simple string as 'MYROOT'              for ODBC DSN connection
%              a string prefixed by 'O:' as 'O:bitsdb1' for ODBC DSN-Less connection
%              a string prefixed by 'J:' as 'O:bitsdb1' for JDBC connection
%              a string prefixed by 'X:' as 'J:stu2xx:bitsdb1' for JDBC remote connection

%
%   Copyright 2005-2012 Emmanuele Somma    (Servizio Studi Banca d'Italia)
%                       emmanuele_DOT_somma_AT_bancaditalia_DOT_it - esomma@ieee.org
%
% $Id: tsdb.m,v 1.5 2007/11/27 16:35:39 m024000 Exp $
%
% -Main---------------------------------------------------------------
  db=[];

  if nargin == 0 
    % null constructor
    
	error('No database informations specified: see the help pages with "help tsdb" ');
    
  elseif and(nargin==1,isa(varargin{1},'tsdb'))
    % copy constructor

    db  = varargin{1};
	return
    
  elseif nargin == 2
    % constructor/2

    db.name = varargin{1};
    db.username = getenv('USERNAME');
    db.passwd = varargin{2};

  elseif nargin == 3
    % constructor/3

    db.name = varargin{1};
    db.username = varargin{2};    
    db.passwd = varargin{3};
    
  elseif nargin > 4
  
    error(['@' mfilename('class') '\' mfilename '::need at least 4 arguments'])

  end 

  arch = computer();
 
  if strcmpi(arch,'PCWIN') ==  0
     logname = '/tmp/tsdb.log';
     mysql_binpath = '/usr/bin/';
  else
      logname = 'C:\tsdb.log';
     mysql_binpath = 'D:/xampp/mysql/bin/';
  end

  % tsdb options
  db.merge = false;           % merge tseries (default: NO)

  db.log=1;                   % logging       (default: ACTIVE)
  db.logname = logname;         % log name      (default: C:\tsdb.log)

  % Setup connection
  prefix = strfind(db.name,':');
  prefix = db.name(1:prefix(end));
  db.prefix      = prefix;
  db.dsn         = db.name;
  db.host        = 'localhost';
  db.driver      = [];
  db.dburl       = [];
  db.dirname     = 'BITSDB';
  db.bkupdirname = 'bkup'  ;
  db.localpath   = []      ;
  db.backup      = []      ;
  db.prefs       = []      ;
  db.version     = 0.0     ; % Fallback
  db.mpasswd     = ''      ;
  db.db          = 'mysql' ;
  db.mysql_binpath = mysql_binpath;
  
  if strcmp(db.name(1:2),'O:')==1        % ODBC DSN-Less
    db.name = db.name(3:end);
    db.dsn = sprintf('Driver={MySQL ODBC 3.51 Driver};Server=localhost;Option=16834;Database=%s',db.name);
    db.conn = database(db.dsn,db.username,db.passwd);
    db.dburl = sprintf('odbc-nodsn:%s',db.dsn)
    
  elseif strcmp(db.name(1:2),'J:')==1    % JDBC
    db.name = db.name(3:end);
    db.driver = 'com.mysql.jdbc.Driver';
    db.dburl = sprintf('jdbc:mysql://localhost/%s',db.name);
    db.conn = database(db.name,db.username,db.passwd,db.driver,db.dburl);
    
  elseif strcmp(db.name(1:2),'X:')==1    % JDBC - remote
    db.name = db.name(3:end);
    nx = find(db.name == ':');
    db.db = db.name(1:nx(1)-1);    
    db.host = db.name(nx(1)+1:nx(2)-1);
    

    % if db host begins with $ then take the environment var
    if strncmp(db.host,'$',1) == 1
      db.host = getenv(db.host(2:end));
    end

    db.name = db.name(nx(2)+1:end);
    if(strcmpi(db.db,'mysql'))
       db.driver = 'com.mysql.jdbc.Driver';
       db.dburl = sprintf('jdbc:mysql://%s/%s',db.host,db.name);
    else
       db.driver = 'org.postgresql.Driver';
       db.dburl = sprintf('jdbc:postgresql://%s/%s',db.host,db.name);
    end    
    db.conn = database(db.name,db.username,db.passwd,db.driver,db.dburl);
    
  else                                   % ODBC DSN
    db.conn = database(db.name,db.username,db.passwd);
    db.dburl = sprintf('odbc:%s',db.name)
    
  end
  
  if length(db.passwd)
    db.mpasswd = sprintf('-p%s',db.passwd);
  else
    db.mpasswd = '';
  end
  
  % Check Connection
  if isconnection(db.conn)
    p = ping(db.conn);
    
  else
    error(['@' mfilename('class') '\' mfilename '::' db.conn.Message ])
    
  end
  
  %%% - Setup backup directories on Windows Machines
  if strcmp(computer,'PCWIN')
    db.localpath = fullfile(getenv('HOMEDRIVE'),getenv('HOMEPATH'),'\Application Data');
    if exist(fullfile(db.localpath,db.dirname),'dir') ~= 7 
      [S,M,MID] = mkdir(db.localpath,db.dirname);
      if S ~= 1
        error 'cannot create local db directory (needed for backups)'
      end
    end
    db.localpath=fullfile(db.localpath,db.dirname);
    if exist(fullfile(db.localpath,db.bkupdirname),'dir') ~=  7
      [S,M,MID] = mkdir(db.localpath,db.bkupdirname);
      if S ~= 1
        error 'cannot create local db bakcup directory'
      end
    end
    db.backup = fullfile(db.localpath,db.bkupdirname);    
    db.logname = fullfile(db.localpath,'tsdb.log');
   
  elseif strcmp(computer,'MACI')
    db.localpath = fullfile(getenv('HOME'),'.BITSDB');
    if exist(fullfile(db.localpath,db.dirname),'dir') ~= 7 
      [S,M,MID] = mkdir(db.localpath,db.dirname);
      if S ~= 1
        error 'cannot create local db directory (needed for backups)'
      end
    end
    db.localpath=fullfile(db.localpath,db.dirname);
    if exist(fullfile(db.localpath,db.bkupdirname),'dir') ~=  7
      [S,M,MID] = mkdir(db.localpath,db.bkupdirname);
      if S ~= 1
        error 'cannot create local db bakcup directory'
      end
    end
    db.backup = fullfile(db.localpath,db.bkupdirname);    
    db.mysql_binpath = '/usr/local/mysql/bin';
    db.logname = fullfile(db.localpath,'tsdb.log');
  end
  

  %% Get variables from db
  if DBExistsTable(db,'info') % pre 1.0 
    db.version = DBGetVersion(db);
  end

  %% link class to db
  db=class(db,'tsdb');

%% Support functions
%
function ret = hquery(conn,query)
    curs = exec(conn,query);
    curs = fetch(curs);
    if rows(curs) > 0
        ret = curs.Data;
    else
        ret = nan; 
    end

%function ret = xquery(conn,query)
%    setdbprefs('DataReturnFormat','numeric');
%    ret = hquery(conn,query);
    
%function ret = squery(conn,query)
%    setdbprefs('DataReturnFormat','cellarray');
%    ret = hquery(conn,query);

function ret = DBExistsTable(db,tablename)
    if(strcmpi(db.db , 'mysql'))
        ret = hquery(db.conn,sprintf('SHOW TABLE STATUS LIKE ''%s''',tablename));
        if isa(ret,'cell')
            ret = 1;
        else
            ret = ~isnan(ret);
        end
    else
        ret = 1;
    end
    
function ret = DBGetVersion(db)
    ret = cell2mat(hquery(db.conn,sprintf('select VD from info where KWORD=''VERSION''')));

