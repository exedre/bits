function dat=tsidx2date_nuovo(freq,year,period)
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
%   Author: Emmanuele Somma (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  if period>ifreq(freq,year)
    error([ mfilename '::PeriodOutsideFrequency'])
  end    


switch freq
    case 1
        % Yearly freq: reference date is set to Jan.1st of each year
        dat=datenum(year,1,1);
    case 2
        % Semiannual freq: reference date is set to Jan.1st and Jul.1st of each year
        dat=datenum(year,12*period-5,1);
    case 3
        % "Quadrimonthly" freq: reference date is first day of every period
        dat=datenum(year,4*period-3,1);
    case 4 
        % Quarterly frequency
        dat=datenum(year,3*period-2,1);
    case 6
        % Bimonthly frequency
        dat=datenum(year,2*period-1,1);
        case 12
        % Monthly frequency: start of the month
        dat=datenum(year,period,1);
    case 52
        % Weekly frequency: uses weeks starting on Sunday
        [month, day] =  weeks_new(year,period,'Sun');
        dat=datenum(year,month,day);
        dat=dat+1;
        
    case 365
        % Daily frequency
        dat=datenum(year-1,12,31)+period;
end
        
        