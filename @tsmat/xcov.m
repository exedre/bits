function [xycov,lags] = xcov(x,y,option1,option2) 
%@tsmat/xcov Overloaded Cross-cov function estimates for tsmat objects.
% 
%    options:
%     'biased'   - scales the raw cross-correlation by 1/M.
%     'unbiased' - scales the raw correlation by 1/(M-abs(lags)).
%     'coeff'    - normalizes the sequence so that the auto-correlations
%                  at zero lag are identically 1.0.
%      'none'     - no scaling (this is the default).
%
%   See the signal toolbox XCORR, CORRCOEF, CONV, COV and XCORR2 functions
%   

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni_DOT_veronese_AT_bancaditalia_DOT_it)
%           Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  mx = size(subsref(x,substruct('.', 'matdata')),1);

  if nargin == 1
	xdata=subsref(x,substruct('.', 'matdata'));
    [xycov,l] = xcorr(xdata-ones(mx,1)*mean(x));
  elseif nargin == 2
    if ischar(y)||(~ischar(y)&&length(y)==1)
      xdata=subsref(x,substruct('.', 'matdata'));
      [xycov,l] = xcorr(xdata-ones(mx,1)*mean(x),y);
      
    else        
      xdata=subsref(x,substruct('.', 'matdata'));
      ydata=subsref(y,substruct('.', 'matdata'));
      my = size(ydata, 1);
      [xycov,l] = xcorr(xdata-ones(mx,1)*mean(x),ydata-ones(my,1)* ...
                        mean(y));
      
    end
  elseif nargin == 3
    TN = size(y);
	my = TN(1);
    if TN==1
      xdata=subsref(x,substruct('.', 'matdata'));
      [xycov,l] = xcorr(xdata-ones(mx,1)*mean(x),y,option1);
      
	else
      xdata=subsref(x,substruct('.', 'matdata'));
      ydata=subsref(y,substruct('.', 'matdata'));

      if size(xdata,2)>1 || size(ydata,2)>1
        error('xcorr(TSMAT1,TSMAT2,nlags) only works if input tslists have 1 element')
      end

      [xycov,l] = xcorr(xdata-ones(mx,1)*mean(x),ydata-ones(my,1)*mean(y),option1);
	end
  elseif nargin == 4
	if size(xdata,2)>1 || size(ydata,2)>1
      error('xcorr(TSMAT1,TSMAT2,nlags) only works if input tsmat have 1 column')
	end
	xdata=subsref(x,substruct('.', 'matdata'));
	ydata=subsref(y,substruct('.', 'matdata'));
	my = size(ydata, 1);
	if TN(2)>1
      error('xcorr(TSMAT1,TSMAT2,nlags) only works if input tslists have 1 column')
    end
	[xycov,l] = xcorr(xdata-ones(mx,1)*mean(x),ydata-ones(my,1)*mean(y),...
                      option1,option2);
  end
  if nargout > 1
    lags = l;
  end
