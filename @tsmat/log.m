function ret = log(self)
%@tsmat/log - Overloaded for tsmat objects: logarithm

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni_DOT_veronese_AT_bancaditalia_DOT_it)
%           Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  oper=mfilename;
  if nargin==1
	ret = TSMATCommonOneinput(self,oper,1);
  else
    error(['@' mfilename('class') '\' mfilename '::invalid number of inputs'])
  end
