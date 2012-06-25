function dat=subts(ts,sy,sp,ey,ep,varargin)
%SUBTS returns a subset of the tsmat over the period specified 
%  
%    dat=subts(ts,sy,sp,ey,ep,varargin)
%
%    Example:
%        dat=subts(ts,1980,1,1985,12) returns the ts(1980,1,1985,12,:) 
%   if nargin==5 ---> returns an array with only the data  
%   if nargin==6 ---> returns an array with dates (in numeric format) and data
% see also 
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

sottots=ts(sy,sp,ey,ep,:);
if nargin<6
    dat=sottots;
elseif nargin==6
    dati=sottots.matdata;
    dat=[dati];
elseif nargin==7;
    dates=sottots.dates;
    dati=sottots.matdata;
    dat=[dates,dati];
end