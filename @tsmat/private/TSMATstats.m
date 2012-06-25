function out = TSMATstats(a,method,dim,varargin)
%TSMATstats: helps overloading tsmat statistics function 
%
% >> out = TSMATstats(a,method,dim,varargin)
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  if ~isa(a,'tsmat') 
    error([ mfilename '::arguments must be tsmats'])
  end

  switch method
   case 'mean'
    out = mean(a.matdata);

   case 'mode'
    out = mode(a.matdata,dim);
    
   case 'nanmean'
    out = nanmean(a.matdata,dim);
    
   case 'median'
    out = median(a.matdata,dim);
    
   case 'nanmedian'
    out = nanmedian(a.matdata,dim);
    
   case 'std'
    out = std(a.matdata,dim);
    
   case 'nanstd'
    if dim==1
      out = nanstd(a.matdata);
    elseif dim==2
      out = nanstd(a.matdata');
    end
   
   case 'iqr'
    out = iqr(a.matdata,dim);
   
   case 'sum'
    out = sum(a.matdata,dim);
   
   case 'nansum'
    out = nansum(a.matdata,dim);
   
   case 'max'
    out = max(a.matdata);
   
   case 'nanmax'
    out = nanmax(a.matdata);
   
   case 'min'
    out = min(a.matdata);
   
   case 'nanmin'
    out = nanmin(a.matdata);
   
   case 'cov'
    out = cov(a.matdata);
   
   case 'nancov'
    out = nancov(a.matdata);
   
   case 'nancorr'
    out = nancorr(a.matdata);
   
   case 'corr'
    out = corr(a.matdata);
   
   case 'var'
    out = var(a.matdata,dim);
   
   case 'nanvar'
    out = nanvar(a.matdata,dim);
   
   case 'prctile'
    %    Y = PRCTILE(X,P,DIM) calculates percentiles along dimension DIM.
    %    The
    %    DIM'th dimension of Y has length LENGTH(P).
    % dim here specifies the percentiles required, while varargin
    % is
    % actually the dimension along which to specify the
    % percentiles to be
    % calculated
    out = prctile(a.matdata,dim,cell2mat(varargin));

  end




