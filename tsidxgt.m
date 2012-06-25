function gt=tsidxgt(year1,period1,year2,period2)
% TSIDXGT Greater operator for timeseries indexes 
%
%    GT = TSIDXGT(Y1,P1,Y2,P2) 
%    = 0 if year1.period == to year2.period2, 
%      1 if if year1.period >to year2.period2 
%     -1 otherwise
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  
  gt=0;

  if year1>year2
    gt=1;
    return
  elseif year2>year1
    gt=-1;
    return
  end

  if period1>period2
    gt=1;
    return
  elseif period1<period2
    gt=-1;
    return
  end

    
