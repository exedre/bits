function c=minus(self,oth,varargin)
%@tsmat/minus   - element wise subtraction
%

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni_DOT_veronese_AT_bancaditalia_DOT_it)
%           Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
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
