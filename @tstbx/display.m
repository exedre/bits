function display(d)
%DISPLAY Time Series Toolbox objects display method.

%   Author(s): E.Somma, 10-08-07
%   Copyright 2007 Banca d'Italia.  Area Ricerca.
%   $Revision: 1.1 $   $Date: 2007/08/27 10:31:29 $

%Trap current last error
[lastmsg,lastid] = lasterr;

tmp = struct(d);   %Extract the structure for display

if ~strcmp(class(d),'tstbx')  %dbtbx field is a dummy field used for
  tmp = rmfield(tmp,'tstbx'); %inheritance only, do not display it
end

%Database connection and cursor objects have properties in displayed information
if any(strcmp(class(d),{'tsmat','tsdb'}))
  flds = fieldnames(tmp);
  for i = 1:length(flds)
    try
      eval(['newtmp.' flds{i} ' = get(d,flds{i});'])
    catch
      eval(['newtmp.' flds{i} ' = tmp.' flds{i} ';'])
    end
  end
  
  tmp = newtmp;
  
end

if isequal(get(0,'FormatSpacing'),'compact')  %Display based on formatting
  disp([inputname(1) ' =']);
  disp(tmp)
else
  disp(' ')
  disp([inputname(1) ' =']);
  disp(' ')
  disp(tmp)
end

%Reset lasterr
lasterr(lastmsg,lastid);