function db = tsprefs(db,varargin)
% @TSDB/TSPREFS - Setup DB preferences
%
% == LOG - DB Logging ==
%
% >> db = tsprefs(db,'log',1) 
% >> db = tsprefs(db,'log',0) 
%
% == MERGE - Timeseries Merging ==
%
% >> db = tsprefs(db,'merge',1) 
% >> db = tsprefs(db,'merge',0) 
%
%
%   Copyright 2005-2012 Emmanuele Somma    (Servizio Studi Banca d'Italia)
%                       emmanuele.somma@bancaditalia.it - esomma@ieee.org
%
  if nargin==1
     return
  end

  i=1;
  while i<nargin
    op = varargin{i};
    if strcmp(op,'log') == 1
      [ i, arg ] = get_next_arg(i,varargin,'log');
      db.log = arg;
    elseif strcmp(op,'merge') == 1
      [ i, arg ] = get_next_arg(i,varargin,'merge');
      db.merge = arg;
    else
      disp(sprintf('operation %s not understood',op))
    end
    i=i+1;
  end

%% Supporting functions

function [i, arg] = get_next_arg(i,varargin,load)
   i=i+1;
   arg = varargin{i};

