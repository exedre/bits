function [month, day] =  weeks(year,week)
%WEEKS return the month and the day when the requested weeks begins
% Week begins by convention on SUNDAY!
% [ M, D ] = weeks(Y, W)
%
% Example:
%
% [ M, D ] = weeks(2000, 52) 
%
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

    if or( week < 0, week > 53 )
         error([ mfilename '::WeekIndexOutsideRange'])
    end
    if calendar_isleap(year)==0 & week == 53
       error([ mfilename '::WeekIndexOutsideRangeOnNonLeapYear'])
    end 
    start_week = [];
    for m=1:12
        a = calendar(year,m);
        start_week = [ start_week ; a(:,1) ];
    end
    n = 0;
    i = 0;
    while n < week
        i = i + 1;
        day = start_week(i);
        if day ~= 0
            n = n + 1;
        end
    end
    month = fix((i-1)/6)+1;
    