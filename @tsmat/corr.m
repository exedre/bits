function ret=corr(self,varargin)
% @tsmat/corr -  overloaded operation for tsmat: correlation coefficient
%
% needs a similar vector operation (from Mathworks Statistics Toolbox 
%                                     or Anders Holtberg's stixbox )
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
  dim=1;
  if nargin>1
    dim=varargin{1};
  end
  ret = TSMATstats(self,oper,dim);

 