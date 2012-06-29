function [ nyear, nperiod ] = next( timeseries, year, period, varargin )
%NEXT returns next index in the timeseries, 
%
%     [ YP, PP ] = NEXT(TS, Y,P ) returns next index after Y,P in the TS
%
%     [ YP, PP ] = NEXT(TS, Y,P , TRUE) returns next index after Y,P in the TS 
%     if index is after the end of the timeseries returns [ NaN, NaN ]
%
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%
  pp=struct(timeseries);
  [ nyear, nperiod ]= tsidx_next( pp.freq, year, period);

  if nargin == 3
    limit = 1;
  else 
    limit = 0;
  end
  
  if isfinite(pp.last_year) && limit 
    if nyear >= pp.last_year && nperiod > pp.last_period
      nyear = NaN;
      nperiod = NaN;
      return
    end
  end


