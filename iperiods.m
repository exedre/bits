function nperiods=iperiods(freq,ybeg,yend)
%IPERIODS number of periods between two given years
% 
%     N = IPERIODS(FREQ, YBEG, YEND) 
%     returns the number of periods between 
%     the two years YBEG and YEND, it makes particular sense when FREQ is 
%     daily (365,366) and there are leap years between beginning and end
%     year.
%
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  if ybeg == yend
    nperiods = 0;
    return 
  end
  
  if ybeg<yend
    ll=1;
  else
    ll=-1;
  end
  
  if freq == 365 | freq == 366
    aa=0;
    for j=ybeg:ll:yend
      if find(calendar(j,2)==29)
        aa=aa+1;
      end
    end
    frequ= 365*(yend-ybeg)+aa*ll;
  else    
    frequ=freq*(yend-ybeg);
  end
  
  nperiods=frequ;
  