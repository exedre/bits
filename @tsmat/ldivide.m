function c=ldivide(self,oth,varargin)
%@tsmat/ldivide   - element wise left division
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
  [sself,ooth]= TSMATCheckArithm(self,oth);
  if nargin==3;    
    c = TSMATCommonArithm(sself,ooth,oper,1);
  else
	c = TSMATCommonArithm(sself,ooth,oper);
  end
