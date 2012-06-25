function close(db)
% @TSDB/CLOSE - Close tsdb connection
%
% >> close(db)
%
% 
%   Copyright 2005-2012 Emmanuele Somma    (Servizio Studi Banca d'Italia)
%                       emmanuele.somma@bancaditalia.it - esomma@ieee.org
%

  if isconnection(db.conn) 
      close(db.conn);
      db = [];
  else
      disp(sprintf('warn: not connected to %s.',db.name));       
  end
