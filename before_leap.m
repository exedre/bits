function [bfl] = before_leap(freq, year, period)
%before_leap - checks if the timeseries index is before the leap day
%
%     B = before_leap(FREQ,Y,P) returns 1 if year is a leap year and 
%     period is equal or before Feb. 29, 0 if year is not a leap year, 
%     -1 otherwise 
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  if period<1 || period>ifreq(freq,year)
    error([ mfilename '::ifreq error: period out of range'])
  end
  
  if ~calendar_isleap(year)
    bfl=0;
  elseif  tsidx2date(freq,year,period)>datenum(year,2,29) 
    bfl=1;
  else
    bfl=-1;
  end
