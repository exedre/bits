function ret = isconnection(db)
% @TSDB/ISCONNECTION - Get status information about database connection
%
% >> ret = isconnection(db)
%
%
%   Copyright 2005-2012 Emmanuele Somma    (Servizio Studi Banca d'Italia)
%                       emmanuele_DOT_somma_AT_bancaditalia_DOT_it - esomma@ieee.org
%
  ret = isconnection(db.conn);
