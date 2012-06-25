function ret = day_today() 
%TODAY Current date since start of year in days
%   T = day_today
  x = clock; 
  ret = datenum(x(1),x(2),x(3))-datenum(x(1),1,1)+1; 
