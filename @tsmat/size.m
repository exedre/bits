function varargout=size(self,varargin)
%@tsmat/size - size of timeseries internal object
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
  c=size(self.matdata);

  if nargin>1
	dim=varargin{1};
	c=c(dim);
	varargout{1}=c;
	return
  end

  if nargout<=1
	varargout{1}=c;
  elseif nargout==2
	varargout{1}=c(1);
	varargout{2}=c(2);
  end
