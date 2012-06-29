function self = addmeta_cols(self,index,key,value)
%@tsmat\addmeta_cols - add metadata to columns 
%
% >> self = addmeta_cols(self,index,key,value)
%
% where 
%       self  is a tsmat object
%       index     is a 1xN array index of columns to be modified
%       key   is the name of meta_col field to be modified (string)
%       value is a cell containg the metadata (Nx1 cellstr)
%
% and
%      self=modified  tsmat object 
% 
% Note: if the input value is a string matrix (e.g. from strvcat) can always
%       convert it back to cell using
%
%       >> mat2cell(value,ones(size(value,1),1),size(value,2));
%
% If metadata doesn't exists then use NaN
  
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni_DOT_veronese_AT_bancaditalia_DOT_it)
%           Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  if ne(length(index),length(value)) 
	error(['@' mfilename('class') '\' mfilename '::meta data incompatible with specified column numbers'])
    return
  end

  if max(index)>size(self.matdata,2)
    error(['@' mfilename('class') '\' mfilename '::not enough time series in tsmat'])
  end

  if  ~isfield(self.meta_cols,key)
    selt.meta_cols.(key) = {};
	%self.meta_cols = setfield(self.meta_cols,key,{});
	for w=1:size(self.matdata,2)
      self.meta_cols.(key){w} = [] ;
	end
  end
	
  for w=1:length(index)
	self.meta_cols.(key){index(w)} = value{w};
  end    
