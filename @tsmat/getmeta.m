function ret = getmeta(self,key,varargin)
%@tsmat/getmeta: get metadata on the tsmat
%
% >> self = getmeta(self,key)
% where 
%        self is the input tsmat 
%         key is the name of the field to get
%
% Alternate Use:
%
% >> self = getmeta(self,key,default)
%
%   if field doesn't exists then return default value instead of NAN

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni_DOT_veronese_AT_bancaditalia_DOT_it)
%           Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  if isfield(self.meta, key)
      %ret = getfield(self.meta,key);
      ret = self.meta.(key);
  else
      if nargin > 2
          ret = varargin{1};
      else
          ret = nan;
      end
  end

    