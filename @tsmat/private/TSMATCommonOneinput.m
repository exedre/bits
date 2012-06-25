function c = TSMATCommonOneinput(a,oper,varargin)
%TSCommonOneinput - helps overloading tsmat mathematical function 
%
%  >>  c = TSmatCommonOneinput(a,oper,varargin);
%      where a is a tsmat
%        and oper is a string representing the operation (eg. '+')
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


  
  switch oper

      case 'center'
          % CENTER (deviation from respective column mean)
          dat_c = center(a.matdata);

      case 'normaliz' 
          % Normaliz (mean 0, std 1 for each column)
          dat_c = normaliz(a.matdata);

      case 'log'
          % LOG
          dat_c = log(a.matdata);

      case 'exp'
          % EXP
          dat_c = exp(a.matdata);

      case 'sqrt'
          % SQRT
          dat_c = sqrt(a.matdata);

      case 'abs'
          % ABS
          dat_c = abs(a.matdata);
          
          case 'sign'
          % SIGN
          dat_c = sign(a.matdata);


      case 'fix'
          % FIX
          dat_c = fix(a.matdata);

      case 'floor'
          % FLOOR
          dat_c = floor(a.matdata);

      case 'ceil'
          % CEIL
          dat_c = ceil(a.matdata);

      case 'round'
          % ROUND
          dat_c = round(a.matdata);

      case 'mod'
          % MOD
          dat_c = mod(a.matdata,varargin{1});

      case 'cumsum'
          % CUMSUM
          dat_c = cumsum(a.matdata);

      case 'cumprod'
          % CUMPROD
          dat_c = cumprod(a.matdata);

      case 'delta'
          % DELTA h steps
          if nargin==1;
              h=1;
          else
              h=varargin{1};
          end
          dat_c = a.matdata(h+1:end,:)-a.matdata(1:end-h,:);
          dat_c = [repmat(NaN,h,size(a.matdata,2));dat_c];

      case 'deltap'
          % DELTAP h steps
          if nargin==1;
              h=1;
          else
              h=varargin{1};
          end
          dat_c = 100*(a.matdata(h+1:end,:)./a.matdata(1:end-h,:)-1);
          dat_c = [repmat(NaN,h,size(a.matdata,2));dat_c];

  end

  % Resulting TSMAT from inputs:
  c=a;
  c.matdata=dat_c;

  % Object maintains metadata of input