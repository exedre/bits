function ts = tsadmin(db, varargin)
% @TSDB\TSADMIN - Database Administrative Commands
%
% res = tsadmin(db,[operation, [arg, ... ] ] ...)
%
% == TRUNC - Truncate database values == 
%
% >> tsadmin(db,'trunc')
%
% == DROP  - Drop database ==
%
% >> tsadmin(db,'drop',dbname)
%
% == SETUP - Setup bits user and instance ==
%
% >> tsadmin(db,'setup',username,dbname)
%
% adds prefix 'bits' to dbname
%
% == FULLBACKUP/FULLRESTORE - Make full database backup/restore  ==
% Save an SQL backup file named dbname_data_label.sql in backup directory 
% (ie. C:\Documents and Settings\<login>\Application Data\BITSDB\bkup )
%
% >> tsadmin(db,'fullbackup',label)
% >> tsadmin(db,'fullrestore',label,datestr)
%
% == TSBACKUP/TSRESTORE - Make Timeseries backup/restore for all releases ==
%
% >> tsadmin(db,'tsbackup' , { series },  label)
% >> tsadmin(db,'tsrestore', { series },  label, date)
%
% == RELBACKUP/RELRESTORE (NIY) - Make Timeseries backup/restore for a single release ==
%
% >> tsadmin(db,'relbackup', serie, release, label )
% >> tsadmin(db,'relbackup', { series }, release, label )
% >> tsadmin(db,'relbackup', { series }, { releases }, label )
% >> tsadmin(db,'relrestore', { series }, { releases }, label, date )
%
% == USER - Check if user exists ==
%
% == CP - Copy Timeseries from a db to another ==
% == MV (NIY) - Move Timeseries from a db to another ==
%
% >> tsadmin(db1,'cp', { series }, db2 )
% >> tsadmin(db1,'mv', { series }, db2 )
%
%
% == RM (NIY) - Remove Timeseries from the db ==
%
% >> tsadmin(db,'rm', { series } )
% >> tsadmin(db,'rm', { series }, { releases } )
%
% == SQL (NIY) - SQL query on bits db ==
%
% >> cursor = tsadmin(db,'sql', 'sql command')
%
%
%   Copyright 2005-2012 Emmanuele Somma    (Servizio Studi Banca d'Italia)
%                       emmanuele.somma@bancaditalia.it - esomma@ieee.org
%
%

  conn = db.conn ;
  a = functions(@tsdb);
  lpath = fileparts(a.file);

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
    
    if strcmp(op,'trunc') == 1
      ts{j,1} = 'trunc' ;
      if Sure()
        ts{j,2} = DBTruncate(conn);
      else
        ts{j,2} = 'aborted';
      end
      
    elseif strcmp(op,'setup') == 1                        % SETUP
      ts{j,1} = 'setup' ;
      [ i, arg ] = get_next_arg(i,varargin,'username');
      [ i, arg2] = get_next_arg(i,varargin,'dbname');
      arg2 = sprintf('bits%s',arg2 );
      ts{j,2} = DBSetup(db,arg,arg2);
      

    elseif strcmp(op,'drop') == 1                         % DROP
      ts{j,1} = 'drop' ;
      [ i, arg ] = get_next_arg(i,varargin,'dbname');
      if Sure()
        ts{j,2} = DBDropDB(db,arg);
      else
        ts{j,2} = 'aborted';
      end
      
    elseif strcmp(op,'fullbackup') == 1                   % FULLBACKUP
      ts{j,1} = 'fullbackup' ;
      [ i, arg ] = get_next_arg(i,varargin,'label');
      r  = DBFullBackup(db,arg);
      ts{j,2} = r ;
      
    elseif strcmp(op,'fullrestore') == 1                  % FULLRESTORE
      ts{j,1} = 'fullrestore' ;
      [ i, arg ] = get_next_arg(i,varargin,'label');
      [ i, arg2] = get_next_arg(i,varargin,'date');
      r  = DBFullRestore(db,arg,arg2);
      ts{j,2} = r ;

    elseif strcmp(op,'import') == 1                  % FULLRESTORE
      ts{j,1} = 'import' ;
      [ i, arg ] = get_next_arg(i,varargin,'path');
      arg = fullfile(lpath,arg);
      r  = DBImport(db,arg);
      ts{j,2} = r ;
      
    elseif strcmp(op,'tsbackup') == 1                     % TSBACKUP
      ts{j,1} = 'tsbackup' 
      [ i, arg ] = get_next_arg(i,varargin,'ts');
      [ i, arg2] = get_next_arg(i,varargin,'label');
      ts{j,2} = DBTsBackup(db,arg,arg2);
      
    elseif strcmp(op,'tsrestore') == 1                    % TSRESTORE
      ts{j,1} = 'tsrestore' ;
      [ i, arg ] = get_next_arg(i,varargin,'ts');
      [ i, arg2] = get_next_arg(i,varargin,'label');
      [ i, arg3] = get_next_arg(i,varargin,'date');
      ts{j,2}=DBTsRestore(db,arg,arg2,arg3);
      
    elseif strcmp(op,'relsbackup') == 1                  % RELBACKUP
      NIY();
      ts{j,1} = 'relbackup' ;
      [ i, arg ] = get_next_arg(i,varargin,'ts'      );
      [ i, arg2] = get_next_arg(i,varargin,'releasse');
      [ i, arg3] = get_next_arg(i,varargin,'label'   );
      r  = DBRelBackup(db,arg,arg2,arg3);
      ts{j,2} = r ;
      
    elseif strcmp(op,'relrestore') == 1                  % RELRESTORE
      NIY()
      ts{j,1} = 'relrestore' ;
      [ i, arg ] = get_next_arg(i,varargin,'ts'      );
      [ i, arg2] = get_next_arg(i,varargin,'releasse');
      [ i, arg3] = get_next_arg(i,varargin,'label'   );
      r  = DBRelRestore(db,arg,arg2,arg3);
      ts{j,2} = r ;       
      
    elseif strcmp(op,'cp') == 1                  % CP
      ts{j,1} = 'cp' ;
      [ i, arg ] = get_next_arg(i,varargin,'ts'      );
      [ i, arg2] = get_next_arg(i,varargin,'db2'     );
      
      r  = DBTsCp(db,arg,arg2);
      ts{j,2} = r ;       
      
    elseif strcmp(op,'mv') == 1                  % MV
      ts{j,1} = 'mv' ;
      [ i, arg ] = get_next_arg(i,varargin,'ts'      );
      [ i, arg2] = get_next_arg(i,varargin,'db2'     );
      
      r  = DBTsCp(db,arg,arg2);
      ts{j,2} = r ;       
      
    elseif strcmp(op,'rm') == 1                  % CP
      ts{j,1} = 'rm' ;
      [ i, arg ] = get_next_arg(i,varargin,'ts'      );
      
      r  = DBTsRm(db,arg);
      ts{j,2} = r ;       
      
    elseif strcmp(op,'tables') == 1
      ts{j,1} = 'tables' ;
      r  = DBShowTables(conn);
      ts{j,2} = r ;
      
    elseif strcmp(op,'user') == 1
      ts{j,1} = 'user' ;
      [ i, arg ] = get_next_arg(i,varargin,'user'      );
      r  = DBUserExists(conn,arg)
      ts{j,2} = r ;
      
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
  if strcmp(curs.Message,'Invalid Cursor')
    ret = nan;
    return
  end
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
  
function ret = DBFullBackup(db,arg)
  conn = db.conn;
  path = fullfile(db.backup,strcat('FULLBACKUP_',date,'-',arg,'.sql'));
  path = strrep(path,'\','/');
  CMD=sprintf([ fullfile(db.mysql_binpath,'mysqldump') ' -h%s -u%s %s %s >"%s"'],db.host,db.username,db.mpasswd, db.name, path);    
  ret = system(CMD)
  if ret~=0
    ret = nan;
    disp(path)
  end
  
function ret = DBFullRestore(db,arg,indate)
  if isa(indate,'numeric')
    indate = datestr(indate);
  end        
  conn = db.conn;
  path = fullfile(db.backup,strcat('FULLBACKUP_',indate,'-',arg,'.sql'));
  path = strrep(path,'\','/');
  CMD=sprintf(strcat(fullfile(db.mysql_binpath, 'mysql'),' -h%s -u%s %s %s <"%s"'),db.host,db.username,db.mpasswd, db.name, path);
  ret = system(CMD);
  if ret~=0
    ret = nan;
    disp(path)
  end
  
function ret = DBImport(db,arg)
  conn = db.conn;
  path = arg;
  path = strrep(path,'\','/');
  CMD=sprintf(strcat(fullfile(db.mysql_binpath ,'mysql'), [' -h%s -u%s %s ' ...
  '%s <"%s"']),db.host, db.username,db.mpasswd, db.name, path);
  ret = system(CMD);
  if ret~=0
    ret = nan;
    disp(path)
  end
  
function ret = DBTsBackup(db,arg,arg2)
% Get all releases of given series
  if isa(arg,'char')
    arg= {arg};
  end
  ret = [];
  for i=1:length(arg)
    rels = tsreleases(db,arg{i});        
    r=rels{1};
    for j=1:length(r)
      ts{j} = tsload(db, { arg{i} },r(j,1));
    end
    ret{i}=rels{1};
    path = fullfile(db.backup,strcat(arg{i},'_',date,'-',arg2,'.mat'));
    path = strrep(path,'\','/');
    save(path,'ts');
  end
  
function ret=DBTsRestore(db,arg,arg2,indate) 
   % Get all releases of given series
  if isa(arg,'char')
    arg= {arg};
  end
  if isa(indate,'numeric')
    indate = datestr(indate);
  end        
  for i=1:length(arg)
    path = fullfile(db.backup,strcat(arg{i},'_',indate,'-',arg2,'.mat'));
    path = strrep(path,'\','/');
    backup_tsmat = load(path,'ts');
    nrels = length(backup_tsmat.ts);
    r=backup_tsmat.ts;
    for j=1:length(r)
      tsstore(db, r{j});
      ret{j}=r{j}.meta_cols.release;
    end
  end
  
function ret = DBRelBackup(db,arg,arg2)
% Get all releases of given series
  NYI();
  if isa(arg,'char')
    arg= {arg};
  end
  ret = [];
  for i=1:length(arg)
    rels = tsreleases(db,arg{i});        
    r=rels{1};
    for j=1:length(r)
      ts{j} = tsload(db, { arg{i} },r(j,1));
    end
    ret{i}=rels{1};
    path = fullfile(db.backup,strcat(arg{i},'_',date,'-',arg2,'.mat'));
    path = strrep(path,'\','/');
    save(path,'ts');
  end
  
function ret = DBTsCp(db,arg,db2)
% Get all releases of given series
  if ~isconnection(db2)
    error(['@' mfilename('class') '\' mfilename '::Destination DB not accessible'])
  end
  if isa(arg,'char')
    arg= {arg};
  end
  ret = [];
  for i=1:length(arg)
    rels = tsreleases(db,arg{i});
    if isa(rels,'cell') 
      if ~isnan(rels{1})
        ts = tsload(db, { arg{i} }, rels  ) ;
        ret{i}=rels;
        tsstore(db2,ts);
      end
    end 
  end
  
function ret = DBTsRm(db,arg)
% Get all releases of given series
  if ~isconnection(db)
    error(['@' mfilename('class') '\' mfilename '::Destination DB not accessible'])
  end
  if isa(arg,'char')
    arg= {arg};
  end
  ret = [];
  for i=1:length(arg)
    xrels = tsreleases(db,arg{i});
    x = xrels{1};
    RELS=sprintf('%s',x(1,1));
    for j=2:size(x,1)
      RELS=sprintf('%s,%d',x(j,1));
    end
    RELS
    SQL=sprintf('DELETE FROM series, version, data USING series, version, data WHERE series.ID=version.ID AND version.VID=data.VID AND series.ID=data.ID AND series.NAME=''%s'' AND version.Rel IN [ %s ];',arg,RELS);
    % r=xexec(db.conn,SQL);
  end
  
function ret = DBTruncate(conn)    
  tables = { 'series' 'data' 'version' 'meta' 'metaname' 'metastr' 'metanum' };
  ret = [];
  for i=1:length(tables)
    query=sprintf('TRUNCATE %s',tables{i});
    r = xexec(conn,query);
    s = strcat(query ,' =  ', r.Message );
    ret = { ret s };
  end
  
  
function ret = DBSetup(db,username,dbname)
  ret = [];
  if strcmp(db.username,'root')==1
    % Create User
    if username(1,1)=='*'
      username=username(2:end);
      emptypass=true;
    else
      emptypass=false;
    end
    if DBUserExists(db.conn,username)==0 
      if ~emptypass
        prompt = {'Username: ', 'Password: '};
        defans = { username, '' };
        answer{1} = input(prompt{1},'s');
        answer{2} = input(prompt{2},'s');
        DBMakeUser(db,answer{1},answer{2});
        DBSetup(db,username,dbname);
        return
      else
        DBMakeUser(db,username,'');
        DBSetup(db,username,dbname);
        return
      end
    end
  end
  if DBExistsDB(db,dbname)
    if ~DBDropDB(db,dbname)
      error(['@' mfilename('class') '\' mfilename '::cannot drop old db'])
    end
  end
  % Create DB
  % java:mysql:
  if length(db.dburl) > 10 & strcmp(db.dburl(1:11),'java:mysql:') == 0
    DBCreateRemoteDB(db,dbname);
  else
    DBCreateDB(db.conn,dbname);
  end
  DBFlushPrivileges(db)
  
function ret = DBFlushPrivileges(db)
    query = sprintf('FLUSH PRIVILEGES');
    try 
        squery(db.conn,query);
        ret = 1;
    catch
        ret = 0;
    end
  

  
function ret = DBExistsDB(db,dbname)
    query = sprintf('SHOW TABLE STATUS FROM %s',dbname);
    try 
        squery(db.conn,query);
        ret = 1;
    catch
        ret = 0;
    end
  
% aggiunto per gestire le DML sul DB remoto
% 
function xexecuteupdate(db,sql)
  con = db.conn;
  con = con.Handle;
  stm = con.createStatement();
  stm.executeUpdate(sql);
  stm.close();

function ret = DBCreateRemoteDB(db,dbname) 
    con = db.conn;
    con = con.Handle;

    sql = sprintf('create database %s',dbname);
    try
        stm = con.createStatement();
        stm.executeUpdate(sql);
        sql = sprintf('use %s',dbname);
        stm.executeUpdate(sql);
        sql = FileLoad('bitsdb.sql');
        for i=1:length(sql)
            stm.executeUpdate(sql(i));
        end
        stm.close();
    catch
        error(lasterror);
    end
  
function ret = FileLoad(fname)
  ret = textread(fname,'%[^\n]');
  
function DBCreateDB(conn,dbname)    
  sql = sprintf('create database %s',dbname);
  curs = xexec(conn,sql);
  sql = sprintf('use %s',dbname);
  xexec(conn,sql);
  sql = FileLoad('bitsdb.sql');
  arrexec(conn,sql);
  
function ret = DBDropDB(db,dbname)
log='';
 if ~db.log
  log='>/dev/null 2>/dev/null';
   if strcmp(computer,'PCWIN')
     log='>NUL: 2>NUL:';
   end
 else
   log=sprintf('>>"%s" 2>>"%s"',db.logname,db.logname);
 end
 CMD=sprintf(strcat(fullfile(db.mysql_binpath , 'mysqladmin'),[' -h%s -s ' ...
                     '-f -u%s %s drop %s %s']),db.host, db.username, db.mpasswd, dbname, log);
 disp(CMD);
 ret = system(CMD);
 if ret~=0
   ret = false;
   disp(CMD)
 else
   ret = true;
 end

  
function ret = DBShowTables(conn,username)
  sql = sprintf( 'SHOW TABLES');
  ret = squery(conn, sql);
  
function ret = DBUserExists(conn,username)
  sql = sprintf( 'SELECT COUNT(*) FROM mysql.user WHERE USER=''%s''', username);
  ret = xquery(conn, sql);  
  ret = ret{1};

function ret = DBMakeUser(db,username,password)
  con = java.sql.DriverManager.getConnection(db.dburl, db.username, db.passwd);
  stm = con.createStatement();
  if length(password)>0 
    sql = sprintf( 'CREATE USER ''%s''@''%%'' IDENTIFIED BY ''%s'';\n', username,password );
    stm.executeUpdate(sql);
    sql = sprintf( 'GRANT ALL PRIVILEGES ON `bits%`.* TO ''%s''@''%%'' IDENTIFIED BY ''%s'' WITH GRANT OPTION;' ,username,password );
    stm.executeUpdate(sql);
    sql = sprintf( 'GRANT ALL PRIVILEGES ON `bits%`.* TO ''%s''@''localhost'' IDENTIFIED BY ''%s'' WITH GRANT OPTION;' ,username,password );
    stm.executeUpdate(sql);
  else 
%    sql = sprintf( 'CREATE USER %s@"%%" ;', username )
%    stm.executeUpdate(sql);
    sql = sprintf( 'GRANT ALL PRIVILEGES ON `bits%%`.* TO %s@"%%" ;' ,username )
    stm.executeUpdate(sql);
    sql = sprintf( 'GRANT ALL PRIVILEGES ON `bits%%`.* TO %s@localhost ;' ,username )
    stm.executeUpdate(sql);
  end
  sql = sprintf( 'FLUSH PRIVILEGES;' );
  stm.executeUpdate(sql);
  stm.close();
  con.close();
  
function NIY()
  error(['@' mfilename('class') '\' mfilename '::Not Implemented Yet. Please wait next BITS version'])
  