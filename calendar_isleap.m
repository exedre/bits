function leapyear=calendar_isleap(year)
%CALENDAR_ISLEAP checks if given year is a leap year
%
%     L = CALENDAR_ISLEAP(YEAR) 
%     1 if YEAR is a leap year, 
%     0 otherwise
%
%     Example:  CALENDAR_ISLEAP(1980) returns 1
%
% The Gregorian calendar, the current standard calendar in most of the world, 
% adds a 29th day to February in all years evenly divisible by 4, except for 
% centennial years (those ending in -00), which receive the extra day only if 
% they are evenly divisible by 400. Thus 1600, 2000 and 2400 are leap years 
% but 1700, 1800, 1900 and 2100 are not. (from wikipedia.org)
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  if find(calendar(year,2)==29)
    leapyear=1;
  else
    leapyear=0;
  end
