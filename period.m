function pp =period(serial_date, freq);
%PERIOD returns the period in the timeseries index given a matlab serial date and a frequency
%
%    P = PERIOD(SERIAL_DATE,FREQ)
%
%    Example:
%          P = PERIOD( datenum(1980,3,1), 12 ) returns 3
%
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%
  [anno,pp]=date2tsidx(freq,serial_date);
