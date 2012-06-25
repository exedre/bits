function res = tsoogle(db,label,varargin)
  if nargin==3
    query=varargin{1};
  end
  [ mid, tid ] = GetMid(db.conn,label);
  if tid~=0
    error('metadata is not serchable')
  end
  if nargin==3
    res = metaSearch(db.conn,mid,query);
  else
    res = metaDistinctValues(db.conn,mid);
  end
  

function res = metaDistinctValues(conn,mid)
  sql = sprintf(['SELECT DISTINCT(S.VALUE) FROM metastr S, meta M where ' ...
                 'M.XID = S.XID AND M.MID=%d'],mid);
  res = hquery(conn,sql);

function res = metaSearch(conn,mid,query)
  sql = sprintf(['SELECT DISTINCT(X.NAME)  FROM metastr S, meta M, series X where ' ...
                 'M.XID = S.XID AND M.ID = X.ID AND M.MID=%d AND S.VALUE ' ...
                 'LIKE ''%s'' GROUP BY M.VID'],mid,query);
  res = hquery(conn,sql);

function [ mid, tid ] = GetMid(conn,name)
  sql = sprintf('select MID,TID from metaname where Name = ''%s''',name);
  r = squery(conn,sql);
  if ~iscell(r) 
    error(sprintf('Metadata ''%s'' not present',name))
  else
    mid = r{1};
    tid = r{2};
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
  
