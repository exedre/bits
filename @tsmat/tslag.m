function res=tslag(self,p)
%   @tsmat/tslag  of order p (+ =lag, -=lead)
%   p=array of desired lags

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni.veronese@bancaditalia.it)
%           Emmanuele Somma   (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  s.type='{}';
  if length(p)==1
	s.subs{1}=-p;
	res=subsref(self,s);
  else
	% create array of various lead/lags
	res=self; % create empty
	for j=1:length(p)
      s.subs{1}=-p(j);
      TSin=subsref(self,s);
      res=[res,TSin];
	end
	N1=size(self.matdata,2);
	N2=size(res.matdata,2);
	res=subsref(res,substruct('()',{':',N1+1:N2}));
  end
