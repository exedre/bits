function ret = ge(self, oth)
%@tsmat/ge - overloaded operator: greater or equal
%

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni.veronese@bancaditalia.it)
%           Emmanuele Somma   (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  oper = mfilename;
  [ sself, ooth ] = TSMATCheckArithm(self,oth);
  et = TSMATCommonArithm(sself, ooth, oper);
  
  