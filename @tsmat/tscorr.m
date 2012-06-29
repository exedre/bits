function A= tscorr(self,nlags,plot)
%@tsmat/tscorr: It evaluates the empirical autoccorelation and cross-correlation of the elements of the matrix self 
%
%
% >>    A= tscorr(self,nlags,plot)
% where: 
%       self     = tsmat object
%       nlags = number of lags
%       plot  = it plots the graph of the cross-correlation
%      
% and:
%      A= = matrix with all the cross-corrlation
% 
%See also plotautoc.m
%GM 2003

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Gianluca Moretti  (gianluca.moretti_AT_bancaditalia_DOT_it)
%           Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  self=self.matdata;
  if nargin==2
    plot=[];
  end
  %check each time series is in a TxN matrix
  if size(self,1)<size(self,2)
    self=self';
  end
  [T,N]=size(self);
  if nlags>T;
    error(['@' mfilename('class') '\' mfilename '::number of lags is bigger than T']);
  end;
  b = zeros(N);
  A = zeros(N*(nlags+1),N);
  for k=1:nlags+1;
    for i=1:N;
      for j=1:N;
        x      = corrcoef([self(k:T,i),self(1:T-k+1,j)]);
        b(i,j) = x(2,1);
      end
    end
    A((k-1)*N+1:k*N,:) = b;
  end
 


  [N,KK] = size(A);
  for i = 1:nlags + 1;
    disp(sprintf('correlations at lag: %s',int2str(i-1)))
    disp(A(((i-1)*KK)+1:i*KK,:));
  end

  if nargin >2
    plotautoc(A);
  end