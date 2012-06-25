function m = merge(db,varargin)
% @TSDB\MERGE - Setup merge preference on db
%
% >> db = merge(db,1)  % Set
% >> db = merge(db,0)  % Reset
% >> m = merge(db) 
%
%
%   Copyright 2005-2012 Emmanuele Somma    (Servizio Studi Banca d'Italia)
%                       emmanuele.somma@bancaditalia.it - esomma@ieee.org
%
  if nargin==2
    db.merge = varargin{1};
    m = db;
    return
  end
  m = db.merge;
