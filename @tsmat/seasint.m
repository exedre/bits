function ret=seasint(self,varargin)
%SEASINT seasonal integration of tsmat object
%
%	>> y=seasint(self,T)
% where
%    self is a tsmat input data

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni.veronese@bancaditalia.it)
%           Emmanuele Somma   (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  x=self.matdata;
  T = self.freq;
  if nargin>1
	T=varargin{1};
  end

  nx=size(x,1);
  np=floor(nx/T);
  rx=rem(nx,T);
  y=zeros(size(x));
  for j=1:T
    index=[j:T:nx];
    y(index,:)=cumsum(x(index,:));
  end

  ret=tsmat(self.start_year,self.start_period,self.freq,y);
