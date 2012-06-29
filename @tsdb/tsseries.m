function ret = tsseries(db)
% @TSDB/TSSERIES - List of series in DB
%
% >> series = tsseries(db)
%
%
%   Copyright 2005-2012 Emmanuele Somma    (Servizio Studi Banca d'Italia)
%                       emmanuele_DOT_somma_AT_bancaditalia_DOT_it - esomma@ieee.org
%
    ret = tsinfo(db,nan,'series');
    
    