function ret = end(self,k,n);
%@tsmat/END overloaded end for tsmat objects
%
% The end expression can be used only along certain dimensions of a tsmat
% In particular, when subsreferencing the tsmat object allowed expressions
% are:
% AA(1:end,1), AA(1,1:end), AA(1980,1,2000,5,1:end);
%


%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni.veronese@bancaditalia.it)
%           Emmanuele Somma   (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%
  if k==5; 
    k=2; 
  end
  ret=size(self.matdata,k);
