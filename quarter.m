function nquarter=quarter(dateidx)
% Converts numeric date in the quarter
  vecdate=datevec(dateidx);
  nmonth=vecdate(:,2);
  nquarter=ceil(nmonth/3);


