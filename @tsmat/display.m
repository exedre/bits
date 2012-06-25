function display(self)
%@tsmat\display - display base information about object
%

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma   (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  str_tsmat=struct(self);
  dati=str_tsmat.matdata;
  freq=str_tsmat.freq;
  start=str_tsmat.start_year;
  disp(['Tsmat object'])
  disp(['      Size: [', num2str(size(str_tsmat.matdata)),']'])
  disp([' Frequency: ' num2str(freq)])
  
  if freq<365
    disp(['     Start: ', num2str([str_tsmat.start_year,str_tsmat.start_period])])
    disp(['       End: ', num2str([str_tsmat.last_year, ...
                        str_tsmat.last_period])])
    
  else
    datein=tsidx2date(365,str_tsmat.start_year,str_tsmat.start_period);
    datefi=tsidx2date(365,str_tsmat.last_year,str_tsmat.last_period);
    disp(['     Start: ', datestr(datein,'ddd'),' ', datestr(datein,'mmm-dd-yyyy')])
    disp(['       End: ', datestr(datefi,'ddd'),' ',datestr(datefi,['mmm-' ...
                        'dd-yyyy'])])
    
  end
% new part to see column numbers
  q='';
  b=self.meta_cols.label; 
  for i=1:length(self.meta_cols.label)
      bl=length(b{i});
      a=num2str(i);
      apadded=[a,repmat(' ',1,bl-length(a))];
    q=sprintf('%s %s',q,apadded);
  end
  disp(sprintf('    Colnumber:%s', q));



  s='';
  for i=1:length(self.meta_cols.label)
    a=self.meta_cols.label;
    s=sprintf('%s %s',s,a{i});
  end
  disp(sprintf('    Labels:%s', s));
  
    
 
