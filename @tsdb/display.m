function display(db)
% @TSDB/DISPLAY - List of series in DB
%
% >> series = tsseries(db)
%
%
%   Copyright 2005-2012 Emmanuele Somma    (Servizio Studi Banca d'Italia)
%                       emmanuele_DOT_somma_AT_bancaditalia_DOT_it - esomma@ieee.org
%
   
   disp(sprintf('     BITSDB Database %s (ver. %1.1f)\n      User: %s\n   On Host: %s\nBackup Dir: %s\n    Driver: %s\nConnection: %d', ...
            db.name,db.version,db.username,db.host,db.localpath,db.dburl,isconnection(db)));
    
    