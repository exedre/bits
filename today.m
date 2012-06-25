function ret = today() 
%TODAY Current date. 
%   T = TODAY returns the current date.
  x = clock; 
  ret = datenum(x(1),x(2),x(3)); 
