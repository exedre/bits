function ret = TSMATCommonArithm(a,b,oper,varargin);
%TSCommonArithm - helps overloading tsmat mathematical operations
%
% >>   ret = TSMATCommonArithm(a,b,oper,varargin);
%      where a,b are tsmat objects
%        and oper is a string for the operation: e.g. '+'
%
% if first optional arg is true then operation is define on union_range
% otherwise in common_range
%
% Uses: setrange
%       tsmat ctor  
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%


  if ~isa(a,'tsmat') | ~isa(b,'tsmat')
    error([ mfilename '::arguments must be tsmats'])
  end
  
  % Find common and union for the operation
  [common_range,union_range] = setrange(a,b);
  range = common_range;
    
  % if extra arg or common range null  
  if nargin==4 | length(range)==0 
    range = union_range;
  end
  
  pp = substruct('()', {range(1), range(2), range(3), range(4), ':'} );

  % Gets tsmat data matrix
  dat_a1 = subsref(a,pp) ;
  dat_a  = dat_a1.matdata ;
  dat_b1 = subsref(b,pp) ;
  dat_b  = dat_b1.matdata ;

  % Operate on double matrices
  switch oper
    
   case {'+','plus'}
    % PLUS
    dat_c = dat_a + dat_b;
    
   case {'-','minus'}
    % MINUS
    dat_c = dat_a - dat_b;
    
   case {'.\','ldivide'}
    % LDIVIDE
    dat_c = dat_a .\ dat_b;
    
   case {'./','rdivide'}
    % RDIVIDE
    dat_c = dat_a ./ dat_b;
    
   case {'.*','times','mtimes'}
    %% mtimes equal to times
    dat_c = dat_a .* dat_b;
    
   case {'.^','power'}
   %% power 
    dat_c = dat_a .^ dat_b;
    
   case 'lt'
    dat_c = dat_a < dat_b;
    
   case 'gt'
    dat_c = dat_a > dat_b;
    
   case 'le'
    dat_c = dat_a <= dat_b;
    
   case 'ge'
    dat_c = dat_a >= dat_b;
    
   case 'ne'
    dat_c = dat_a ~= dat_b;
    
   case 'eq'
    dat_c = dat_a == dat_b;
    
  end
  
  % Resulting tsmat
  ret = tsmat(range(1),range(2), a.freq, dat_c);   

  % TODO: Metadata support