function varargout = find(self);
%@tsmat/find -  Works for one column tsmat objects

%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni.veronese@bancaditalia.it)
%           Emmanuele Somma   (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  data     = self.matdata;
  s.type   = '.';
  s.subs   = 'dates';
  alldates = subsref(self,s);
  freq     = self.freq;
  z = find(data);
  
  if nargout==1
      varargout{1} = z;
  end
  
  if nargout==2
      varargout{2} = alldates(z);
  end