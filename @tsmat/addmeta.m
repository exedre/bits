function self = addmeta(self,key,value)
%@tsmat/addmeta: Adds metadata on the tsmat: 
% 
% >> self = addmeta(self,key,value)
%
% where self is input tsmat 
%          key   is the name of the field to be added (must be a string with no blanks)
%          value metadata to be added  in the field key
%
% Use  addmeta_cols to add specific info on certain columns of the tsmat

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni.veronese@bancaditalia.it)
%           Emmanuele Somma   (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%
% self.meta = setfield(self.meta,key,value);
selt.meta.(key) = value;
    
    