function [month, day] =  weeks_new(year,week,varargin)
%WEEKS return the month and the day when the requested weeks begins
% The year is not needed as it refers always to weeks in the given year
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
% Default start of the week is on Sunday
whichday=1;
if nargin==3
    strday=varargin{1};
    switch strday
        case 'Sun'
            whichday=1;
        case 'Mon'
            whichday=2;
        case 'Tue'
            whichday=3;
        case  'Wed'
            whichday=4;
        case  'Thu'
            whichday=5;
        case  'Fri'
            whichday=6;
        case  'Sat'
            whichday=7;
        otherwise
            error('Input for day of week must be 3 letters acronym')
    end
    
end

    if or( week < 0, week > 53 )
         error([ mfilename '::WeekIndexOutsideRange'])
    end
    if calendar_isleap(year)==0 && week == 53
       error([ mfilename '::WeekIndexOutsideRangeOnNonLeapYear'])
    end 
    start_week = [];
    
    for m=1:12
        a = calendar(year,m);
        start_week = [ start_week ; a(:,whichday) ];
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
    