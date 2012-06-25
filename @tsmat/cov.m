function ret=cov(self,varargin)
% @tsmat/cov -  overloaded operator for tsmat: covariance
%
% needs a similar vector operation (from Mathworks Statistics Toolbox 
%                                     or Anders Holtberg's stixbox )
%

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni.veronese@bancaditalia.it)
%           Emmanuele Somma   (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  oper=mfilename;
  dim=1;
  if nargin>1
    dim=varargin{1};
  end
  ret = TSMATstats(self,oper,dim);

 