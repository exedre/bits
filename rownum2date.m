function [year,period]=rownum2date(ts,pos);
%ROWNUM2DATE for tsmat,tseries objects, year and period corresponding to a
% certain row index 
% pos= 1= first element, 
%      2= second element (1st element after start period)
%      ...
%      0= previous element (1 element before start)
%     -1= 2 elemnts befire start 
% usage [year,period]=rownum2date(ts,pos);
% Input: 
%       ts a tsmat,tseries object
%       rownum= scalar rownumber (positive, but can be zero or negative)
% gives year and period corresponding to certain rownum
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
  [ year, period ] = start2end(freq, start_ts(1), start_ts(2), pos-1 );
