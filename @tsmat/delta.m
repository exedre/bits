function ret = delta(self,varargin)
%@tsmat/delta - overloaded delta for tsmat objects:  change over varargin periods
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
  if nargin==1
    ret = TSMATCommonOneinput(self,oper,1);
  elseif nargin==2
	if ~isscalar(varargin{1})
      error(['@' mfilename('class') '\' mfilename '::order of delta must be a scalar'])
	end
	ret = TSMATCommonOneinput(self,oper,varargin{1});
  else
    error(['@' mfilename('class') '\' mfilename '::invalid number of inputs'])
  end
