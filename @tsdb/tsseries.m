function ret = tsseries(db)
% @TSDB/TSSERIES - List of series in DB
%
% >> series = tsseries(db)
%
%
%   Copyright 2005-2012 Emmanuele Somma    (Servizio Studi Banca d'Italia)
%                       emmanuele.somma@bancaditalia.it - esomma@ieee.org
%
    ret = tsinfo(db,nan,'series');
    
    