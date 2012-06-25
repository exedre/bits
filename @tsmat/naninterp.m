function ret=naninterp(TS,varargin)
%@tsmat/naninterp.
%
% ?!?
  ret = TS;
  if nargin==1
      method='cubic'
  else      
      method=varargin{1};
  end
      
  TSdata= TS.matdata;
  ret.matdata=naninterp(TSdata,method);

