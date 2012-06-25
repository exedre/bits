function ret = day_then(datethen) 
%day since beginning of year of a given date (numeric or string)
%   ret = 
  
  x=datevec(datethen);
  
  ret = datenum(x(1),x(2),x(3))-datenum(x(1),1,1)+1; 
