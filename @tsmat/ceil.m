function ret = ceil(self)
%@tsmat\ceil - Overloaded operation for tsmat objects: ceil
%
% >> t1 = tsmat(1968,10,12,rand(12,3))
% >> tc = ceil(t1)

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
