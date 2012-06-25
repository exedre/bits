function ret = normaliz(self)
%@tsmat/center - overloaded normaliz for tsmat objects: normalized columns 
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
  
  ret = TSMATCommonOneinput(self,oper,1);


