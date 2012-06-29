function t=rownum(ts,year_period);
%ROWNUM for tsmat,tseries objects, row index to year and period 
%
% >> t=rownum(ts,year_period);
% where ts a tsmat object
%   and year_period=[year , period] array 
% gives row number corresponding to the year and period specified
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  start_ts=[ts.start_year,ts.start_period];
  freq=ts.freq;	
  t=tsidx_distance(freq,start_ts,[year_period])+1;
  tmax=size(ts.matdata,1);
  if any([t<0,t>tmax])
	error([ mfilename '::date outside range of the object'])
	return
  end