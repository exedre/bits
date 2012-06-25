function self = setcolmeta1(self,col,key,value,varargin)
%@tsmat/setcolmeta1: set metadata on a tsmat column
%
% >> self = getcolmeta(self,col,key,value)
% where 
%       self is the input tsmat 
%        col is the column number
%        key is the name of the field to get
%      value is the value of the field to set

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni.veronese@bancaditalia.it)
%           Emmanuele Somma   (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  if col>size(self.matdata,2)
    error(['@' mfilename('class') '\' mfilename '::not enough series'])
  end

  if isfield(self.meta_cols, key)
    ret = getfield(self.meta_cols,key);
  else
    ret = {}
  end

  ret{col} = value;
  self.meta_cols = setfield(self.meta_cols,key,ret);
