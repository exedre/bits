function ret = deltap(self,varargin)
%@tsmat\deltap Overloaded deltap for tsmat objects: percentage change over varargin periods
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
  if nargin>1
    if str2num(version('-release'))<14
      ord = varargin{1};
      condord = all([~isempty(ord) ~isinf(ord) ~isnan(ord) isreal(ord) isnumeric(ord) length(ord)==1]);
    else
      condord = ~isscalar(varargin{1});
    end;
    ret = TSMATCommonOneinput(self,oper,varargin{1});
  else
    ret = TSMATCommonOneinput(self,oper,1);
  end
