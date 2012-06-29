function varargout=unique(self,varargin)
%@tsmat/unique - unique of timeseries  object (along the label identifier)
%
  
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni_DOT_veronese_AT_bancaditalia_DOT_it)
%           Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  oper=mfilename;
  [c,ia,ib]=unique(self.meta_cols.label);
   

  % behavior is slightly modified with respect to native unique
  if nargout<=1
	varargout{1}=subsref(self,substruct('()',{':',ia}));
  elseif nargout==2
	varargout{1}=subsref(self,substruct('()',{':',ia}));
	varargout{2}=c;
       
  end
