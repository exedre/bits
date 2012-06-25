function self = setfullcolmeta(self,metacol,varargin)
%@tsmat/setfullcolmeta: set metadata array on tsmat columns
%
% >> self = setfullcolmeta(self,col,k)
% where
%       self is the input/output tsmat 
%       meta is the struct array with metadata fields

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni.veronese@bancaditalia.it)
%           Emmanuele Somma   (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  ncols = size(self,2);

  if size(metacol,2) < ncols 
    error(['@' mfilename('class') '\' mfilename '::not enough metacols'])
  end

  if size(metacol,2) > ncols 
      % EMMANUELE NON CAPISCO PERCHE' DOBBIAMO METTERE QUESTO CHECK!
      % MI HA CREATO VARI CAsINI se concatenavo horizontally
      % due tmat con diverso numero di meta_cols!
   % error(['@' mfilename('class') '\' mfilename '::not enough tsmat columns'])
  end

  meta={};
  fnames = fieldnames(metacol);
  for i=1:size(fnames,1);
    for j=1:ncols
      m = getfield(metacol,{j},fnames{i});
      if isa(m,'cell') 
        meta{j}=m{1};
      elseif isa(m,'double') 
        meta{j}=m;
      elseif isa(m,'char') 
        meta{j}=m;
      end
    end
    if length(meta)>0
      self = addmeta_cols(self, [1:ncols] ,fnames{i}, meta);
    end
  end

