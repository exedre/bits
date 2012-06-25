function ret = floor(self)
%@tsmat\floor - Overloaded for tsmat objects:         
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
  if nargin==1
	ret = TSMATCommonOneinput(self,oper,1);
  else
    error(['@' mfilename('class') '\' mfilename '::invalid number of inputs'])
  end
