function f =ifreq(freq,year)
%IFREQ  Checks for leap year, returns 366 if true, else returns freq
%
%    F = FREQ(FREQ,YEAR)  outputs 1x1 frequency indicator. 366 if it's 365 and is a leap year
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  if nargin<2 
    f=freq;
  else
    if freq==365 & find(calendar(year,2)==29)
      f=366;
    else
      f=freq;
    end
    if freq==52
      f = 52;
      try
        [ m, d ] = weeks(year,53);
        f = 53;
      catch
      end;
    end
  end
  