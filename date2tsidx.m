function [year, prd] = date2tsidx(freq, date)
%DATE2TSIDX- year,period representation of numeric Matlab date given frequency.
%
% >>  [yy, pp] = date2tsidx(freq, date)
%
% where freq is a 1x1 frequency indicator
%       date is a datenum representation of the date, e.g. datenum(date) 
%       [ yy, pp ] is the output tsidx 
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%


if length(date)>1
    error([mfilename '::input date must be a scalar'])
end

month_days = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];

[year,mese,giorno] = datevec(date);

% Under annual frequency (b careful, may not work on strange freqs)
switch freq
        
    case 1
        % If ts is annual it's always on first period of the given year
        prd=1;

    case 52
        % Default format: weeks start on Sunday
        [year, prd] =  date2weeks(date);
        
    otherwise
        
        days = 0;
        period = 0;
        counter = 12/freq-1;
        if counter < 0
            counter = 1;
        end
        
        % Count days for each month in the year
        for i=1:mese-1
            days=days + month_days(i);
            % One day more for leap years
            if calendar_isleap(year) & i == 2
                days=days + 1;
            end
            
            % step the period if right time has flown
            if counter <= 0
                counter = 12/freq-1;
                if counter < 0
                    counter = 1;
                end
                period = period + 1;
            else
                counter = counter - 1;
            end
        end
        
        % add last month's date
        dd = datevec(date);
        days =days+dd(3);
        if freq == 365
            prd = days ;
        else
            % advance last period
            prd = period + 1;
        end
        
        
        
        
        
end

% That's all folks