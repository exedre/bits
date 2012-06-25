function [ yy, pp ] = start2end(freq, sy, sp, dist )
% START2END  destination year and period moving dist away from given date
%
%      [ YP, PP ] = START2END( FREQ, SY, SP, N ) returns a timeseries index N steps away from the 
%      given input index SP,SN
%
%      Example:
%               [ YP, PP ] = START2END( 12, 1980, 1, 14) returns [ 1981, 3 ]
%
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%


  if freq<=12;
    pp=mod(sp+dist,freq)*double(mod(sp+dist,freq)~=0)+ freq*double(mod(sp+dist,freq)==0);
    ny=fix((sp+dist)/freq);
    resto=sign(sp+dist)*mod(sp+dist,freq);
    if dist<0
      if resto<=0
        ny=ny -1;
      else
        ny=0;
      end
    else
      if mod(sp+dist,freq)==0
            ny=ny -1;
      end
      
    end
    
    yy=sy+ny;
    

    
  elseif freq==365
    
    mat_date0   = datenum(sy,1,1);
    mat_date    = mat_date0+sp-1;
    end_date    = mat_date+dist;
    y1          = datevec(end_date);
    yy          = y1(1);
    mat_date1   = datenum(yy,1,1);
    pp          = end_date-mat_date1+1;
    
  elseif freq==52
    d = dist;
    y = sy;
    pp = sp;
    while d > 0
      f = ifreq(freq,y);
      if d > f
        d = d - f;
        y = y + 1;         
      else
        pp = pp + d;
            yy = y;
            if pp > ifreq(freq,y)
              pp = pp - ifreq(freq,yy);
              yy = yy + 1;
            end
            d = 0;
      end
    end
  end  