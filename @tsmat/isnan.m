function ret=isnan(self,varargin)
%@tsmat/isnan - overload isnan(X) for tsmat objects.
%   Returns a tsmat object with 1,0

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni.veronese@bancaditalia.it)
%           Emmanuele Somma   (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  ret=self;
  ret.matdata = isnan(self.matdata) ;
        



            
            
        
        
        
    
