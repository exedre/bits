function ret = setcolmeta(self,col,key,value,varargin)
%@tsmat/getcolmeta: set metadata on a tsmat column
%
% >> self = getcolmeta(self,col,key,value)
% where
%       self is the input tsmat 
%        col is the column number
%        key is the name of the field to set
%      value is the value of the field to set

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni.veronese@bancaditalia.it)
%           Emmanuele Somma   (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  if isfield(self.meta_cols, key)
    ret = getfield(self.meta_cols,key);
    ret(col) = value;
    setfield(self.meta_cols,key,value);
  end

    