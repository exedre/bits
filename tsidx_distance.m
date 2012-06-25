function  y = tsidx_distance(freq,tsidx1,tsidx2)
% TSIDX_DISTANCE returns the distance between two timeseries indexes in a given frequency
%
%    N = TSIDX_DISTANCE(FREQ,TSIDX1,TSIDX2) 
%
%    Example:
%             N = TSIDX_DISTANCE(12,[1980 1],[1982 9])
%
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  if freq==366
    error([ mfilename '_distance::daily freq mismatch (==366)'])
  end

  if tsidx1(2) > ifreq(freq,tsidx1(1)) || tsidx2(2) > ifreq(freq,tsidx2(1)) 
    error([ mfilename '_distance::period greater than freq=%d [%d] [%d]',freq,tsidx1(2),tsidx2(2)])
  end

  if tsidx1(2) < 1 || tsidx2(2)< 1
     error([ mfilename '_distance::period less than 1 [%d] [%d]',tsidx1(2),tsidx2(2)])
  end

  d = (tsidx2(1)+.1*tsidx2(2)/freq)-(tsidx1(1)+.1*tsidx1(2)/freq);

  if d < 0
    y = -tsidx_distance(freq,tsidx2,tsidx1);
    return
  end

  switch freq
      case{365}
          date1=datenum(tsidx1(1),1,1)+tsidx1(2)-1;
          date2=datenum(tsidx2(1),1,1)+tsidx2(2)-1;
          y=date2-date1;
      case {52}
          date1=tsidx2date_nuovo(52,tsidx1(1),tsidx1(2));
          date2=tsidx2date_nuovo(52,tsidx2(1),tsidx2(2));
          y=(date2-date1)/7;
      otherwise
          ly=freq*(tsidx2(1)-tsidx1(1));
          y=ly+(tsidx2(2)-tsidx1(2));
  end
