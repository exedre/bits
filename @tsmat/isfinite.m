function ret = isfinite(self,varargin)
%@tsmat/isfinite -  overload isfinite(X) for tsmat objects.
% Returns a tsmat object with 1,0 in finite elements 0 otherwise
%

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni_DOT_veronese_AT_bancaditalia_DOT_it)
%           Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  ret = self;
  ret.matdata = isfinite(self.matdata);
        



            
            
        
        
        
    
