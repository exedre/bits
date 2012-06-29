function [ dy, du ] = distance2tsidx(freq, dist, varargin)
%DISTANCE2TSIDX Delta in years and periods to move # periods away
%
%
%     >> [DY,DU] = DISTANCE2TSIDX(FREQ,DIST) 
%     returns the number of years and periods to add to a 
%     timeseries index (year,period) to move avay by a DIST periods
%     Dist>0 if to move forward
%     Dist<0 if to move backward
% 
%    Note:  additional input YEAR is needed if frequency > monthly
%    >> [DY,DU] = DISTANCE2TSIDX(FREQ,DIST,YEAR)  
%
%     Example: 
%           [dy du ]=distance2tsidx(4, -6 ) return [ -1, 2 ] 
%           need  to add -1 year and then add 2 quarters as
%           frequency is quarterly
%           
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%


if nargin > 2 
    % year matters for daily and business freq series
    year = varargin{1};
else 
    year = 1980;
end 

dy = 0;
du = 0;

f = ifreq(freq,year);
    if dist < 0
        year = year - 1;
        f = ifreq(freq,year);
        if dist >= -ifreq(freq,year)
            dy = - 1;
            du = f + dist;
            return
        end
        [ dy, du ] = distance2tsidx(freq, dist+f,year);
        dy = dy - 1;
        du=du;
        return
    end
    if dist == 0
        dy = 0;
        du = 0;
        return
    end
    if dist < ifreq(freq,year)
        f = ifreq(freq,year);
        dy = dy + fix(dist/f);
        du = du + mod(dist,f);
        return
    end

    if dist >= ifreq(freq,year)
        [ dy, du ] = distance2tsidx(freq, dist-ifreq(freq,year),year+1);
        dy = dy + 1;
        return
    end

dy = dy + fix(dist/f);
du = du + mod(dist,f);


        

        
        
    

    





