function ret=mave(self,p)
%@tsmat/mave (moving average of order p).
% TODO  May be nice to add the type of moving average (centered, etc...)

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni_DOT_veronese_AT_bancaditalia_DOT_it)
%           Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

          ret = self;
       TSdata = self.matdata;
            b = ones(1,p)/p;
            a = 1;
       TSdata = filter(b,a,TSdata);
TSdata(1:p,:) = NaN;
  ret.matdata = TSdata;
