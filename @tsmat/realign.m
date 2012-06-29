function res=realign(self,realignement)
% Shift forward each column of tsmat according to a given realignement
% vector

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni_DOT_veronese_AT_bancaditalia_DOT_it)
%           Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

   res = self;
  dati = NaN*res.matdata;
    mm = max(realignement);

  for j=1:size(dati,2)
	dati(mm+1:end,j)=res.matdata(mm-realignement(j)+1:end-realignement(j),j);
  end
  res.matdata=dati;
