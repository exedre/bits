function ret = le(self, oth)
%@tsmat/le - overloaded operator
%

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni_DOT_veronese_AT_bancaditalia_DOT_it)
%           Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  oper = mfilename;
  [ sself, ooth ] = TSMATCheckArithm(self,oth);
  ret = TSMATCommonArithm(sself, ooth, oper);
  