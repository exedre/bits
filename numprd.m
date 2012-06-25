function  y = numprd(dates_vec, freq)
%numprd  number of periods between two timeseries indexes with given frequency
%    N = NUMPRD( [TSIDX1,TSIDX2], FREQ) 
%
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  y=1+tsidx_distance(freq,dates_vec(1:2),dates_vec(3:4));
