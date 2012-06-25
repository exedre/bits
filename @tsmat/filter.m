function ret=filter(self,a,TS)
%@tsmat/filter.
%
% ?!?
  ret = TS;
  TSdata= TS.matdata;
  ret.matdata=filter(self,a,TSdata);

