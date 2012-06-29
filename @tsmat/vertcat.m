function res=vertcat(varargin)
% Find non-empty arrays

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  res = nan;
  for i=1:length(varargin)
    if isa(res,'tsmat')
      if isa(varargin{i},'tsmat')
        res = extend(res,varargin{i},nan,true);
      end
    else
      res = varargin{i};
    end
  end
