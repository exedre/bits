function ret=prctile(self, lev ,varargin)
% @tsmat/prctile -  
%

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni.veronese@bancaditalia.it)
%           Emmanuele Somma   (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  oper=mfilename;
  if nargin==1;
    dim=1;
  elseif nargin==3
    dim=varargin{3};
  end
  ret = TSMATstats(self, oper, lev, dim);

 