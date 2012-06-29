function ret = getcolmeta(self,col,key,varargin)
%@tsmat/getcolmeta: get metadata on a tsmat column: 
%
% >> self = getcolmeta(self,col,key)
% where
%         self is the input tsmat 
%          col is the column number
%          key is the name of the field to get
%
% Alternate Use:
%
% >> self = getmeta(self,col,key,default)
% where
%          default: if field doesn't exists then return default value 
%                   instead of NAN

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni_DOT_veronese_AT_bancaditalia_DOT_it)
%           Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%


if isfield(self.meta_cols, key)
    %ret = getfield(self.meta_cols,key);
    ret = self.meta_cols.(key);
    ret = ret(col);
    if strcmp(ret,'')==1 && nargin > 3
        ret = varargin{1};
    elseif strcmp(ret,'')==1
        ret = [];
    end
else
    if nargin > 3
        ret = varargin{1};
    else
        ret = [];
    end
end

    