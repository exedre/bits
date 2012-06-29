function c = norm(a,varagin)
%@tsmat/norm - Overloaded norm for tsmat objects:
% varargin can be 1,2,inf and 'fro'

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  if nargin==1
    c = norm(a.matdata);
  elseif nargin==2
    c = norm(a.matdata,varargin{1});
  else
    error(['@' mfilename('class') '\' mfilename '::invalid number of inputs'])
  end
