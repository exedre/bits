function ret = mod(self, modulus)
%@tsmat\mod -  Overloaded modulus for tsmat objects:  
%
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
	error(['@' mfilename('class') '\' mfilename '::invalid use of mod function'])
	return
  elseif nargin==2
	if ~isscalar(modulus)
      error(['@' mfilename('class') '\' mfilename '::must be a scalar'])
	end
	ret = TSmatCommonOneinput(a,oper,modulus);
  else
    error(['@' mfilename('class') '\' mfilename '::invalid number of inputs'])
  end
