function [nyear,nperiod]=tsidx_next(freq,year,period)
% TSIDX_NEXT returns the next tsindex from 
%
%    [ PY, PP ] = TSIDX_NEXT(FREQ,Y,P) returns year and period of next observation
%
%    For example [py,pp]=tsidx_next(12,1980,1) 
%    will return py=1980 and  pp=2;
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  if freq>=1 & period>ifreq(freq,year)
    error([ mfilename '_next::PeriodOutsideFrequency'])
  elseif freq<1 & period ~= 1
    error([ mfilename '_next::PeriodNotOneOnDecimalFrequency']) 
  end

  nyear=year;
  nperiod=period;
  npy=ifreq(freq,nyear);

  if freq<1
    nyear =nyear + fix(1/freq);
  else
    nperiod=nperiod+1;
    if nperiod==npy+1
      nyear=nyear+1;
      nperiod=1;
    end
  end
