function ret = tsreleases(db,series)
% @TSDB/TSRELEASES - Lists releases for series
%
% >> rels = tsreleases(db,'SERIE')
%
% or
%
% >> rels = tsreleases(db,{ 'SERIE1', ... , 'SERIEN' })
%
%
%   Copyright 2005-2012 Emmanuele Somma    (Servizio Studi Banca d'Italia)
%                       emmanuele_DOT_somma_AT_bancaditalia_DOT_it - esomma@ieee.org
%

    if isa(series,'char')
        series={ series };
    end

    ret = tsinfo(db,series,'releases');

    if isa(series,'char')
        ret =ret{1}        
    end
