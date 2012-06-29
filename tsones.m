function  y = tsones(ranges,freq,N)
% tsones = ones for tsmats
%    y = tsones(ranges,freq,N)
%
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%
sy=ranges(1);sp=ranges(2);ey=ranges(3);ep=ranges(4);
T=numprd([sy,sp,ey,ep],freq);
y=tsmat(sy,sp,freq,ones(T,N));
