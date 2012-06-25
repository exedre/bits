function dat=tsidx2date_old(freq,year,period)
%TSIDX2DATE returns Matlab serial date, from a timeseries index (year,period) given freq
%
%    DAT = TSIDX2DATE(FREQ,YEAR,PERIOD)
%
%    Example:
%        DAT = TSIDX2DATE(12,1980,1) returns 723181
%
% see also DATE2TSIDX
%
%   BITS -  Banca d'Italia Time Series
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali
%           Banca d'Italia
%

if period>ifreq(freq,year)
    error([ mfilename '::PeriodOutsideFrequency'])
end

switch freq
    case {1;2;3;4;6;12;365}
        month_days=[31,28,31,30,31,30,31,31,30,31,30,31];
        
        n=fix(12/freq);
        dat=datenum(year,1,1,0,0,1);
        days=0;
        
        if n==0
            ngp=fix(366/ifreq(freq,year));
            days=days+period*ngp-1;
        else
            for j=1:(period-1)*n
                days=days+month_days(j);
                if and(find(calendar(year,2)==29) , j==2)
                    days=days+1;
                end
            end
            
        end
        
        
        dat = dat + days;
        V = datevec(dat);
        if V(4)==23
            dat = datenum(V(1),V(2),V(3)+1);
        end
        dat=floor(dat);
        
    
    otherwise
    % Caso frequenze weekly:
    % default case: weeks are the isoweeks (those containing the first Sunday of the year)
      
    [month, day] =  weeks_new(year,period,'Sun');
      dat=  datenum(year,month,day);
end