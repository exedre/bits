function [ret,lags] = xcorr(self,maxlags,varargin) 
%@tsmat/xcorr tsmat overloaded function for xcorr
%
% >> [ret,lags] = xcorr(x,maxlags) 
% where:
%             x is a T-by-N tsmat array, 
%        maxlag is the max lag for calculation of correlations
%      varargin could be
%     'biased'   - scales the raw cross-correlation by 1/M.
%     'unbiased' - scales the raw correlation by 1/(M-abs(lags)).
%     'coeff'    - normalizes the sequence so that the auto-correlations
%                  at zero lag are identically 1.0.
%      'none'     - no scaling (this is the default)
% and:       
%       ret is an array 2*maxlags+1 rows whose P^2 columns contain 
%           the cross-covariance sequences for all combinations 
%           of the columns of x. 

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni_DOT_veronese_AT_bancaditalia_DOT_it)
%           Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  dat=subsref(self, substruct('.','matdata'));
  if nargin>2
    [ret,lags]=xcorr(dat,maxlags,varargin{1});
  else
    [ret,lags]=xcorr(dat,maxlags);
  end