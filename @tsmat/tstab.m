function tstab(varargin)
%@tsmat/tstab - tabulate output tsmat with description and releases

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni_DOT_veronese_AT_bancaditalia_DOT_it)
%           Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  descript=[];

  % If the last argument is a string and exists a field
  % with this name then use that metadata as description
  %
  lastargin=nargin;

    if (nargin>1)
    	lastargin=nargin;
        if isa(varargin{lastargin},'char') 
            ts=varargin{1};
            if isfield(ts.meta_cols,varargin{lastargin})
                descript=ts.meta_cols.(varargin{1});
                lastargin=lastargin-1;            
            else
                error(['@' mfilename('class') '\' mfilename '::first tsmat has not such field']);
            end
        end
    end

  tsmatr=[];
  for i=1:lastargin
    tsmatr = [tsmatr varargin{i}];
  end
  
  str_tsmat=struct(tsmatr);
  dati=str_tsmat.matdata;

  freq=str_tsmat.freq;
  year = str_tsmat.start_year;
  period = str_tsmat.start_period;
  start=[year,period];

  disp(['tsStart: ' num2str(start)])
  if isfield(tsmatr.meta,'release')
    rel = tsmatr.meta.release;
    if isa(rel,'char')
      disp(['tsRelease:', rel]);
    elseif isa(rel,'numeric')
      rel = datestr(rel);
      disp(['tsRelease: ', rel]);
    end
  end
  disp(['Frequency: ' num2str(freq),' (',num2freq(freq),')'])
  

  switch freq
   case -1
    prd='N';
   case .125
    prd='8Y';
   case{.25}
    prd='4Y';
   case .5
    prd='2Y';
   case 1
    prd='Y';
   case 2
    prd='S';
   case 3
    prd='4m';
    case 4
     prd='Q';
   case 12
    prd='M';
   case{26,27}
    prd='2W';
   case{52,53}
    prd='W';
   case{250,251}
    prd='BD';
   case{365,366}
    prd='D';
  end
  

  disp(['Date ', descript]);
%  kk=size(dati,2);
  if freq==365
    dat = tsidx2date(freq,year,period);
    s   = cat(2,datestr((dat:dat+size(dati,1)-1)','ddd-'),datestr((dat:dat+size(dati,1)-1)','dd-mmm-yyyy'));
  else
    s = '';
  end
  pad = 10+length(prd)+length(s);
  formato = ['%' num2str(pad) 's'];
  % Print Label
  if isfield(tsmatr.meta_cols,'label')
    l=tsmatr.meta_cols.label;       
    fprintf('%s',blanks(pad));
   
    for j=1:size(l,2)
      fprintf(formato,l{j});
    end
    fprintf('\n')
  end
  
  % Print Release
  if isfield(tsmatr.meta_cols,'release')
    r=tsmatr.meta_cols.release;
    rels = cell(length(r));
    for i=1:length(r)
        if isa(r{i},'numeric')
            rx=r{i};
            rels{i}=datestr(rx(1,1),20);
        elseif isa(r{i},'string')
          rels{i}=r{i};
        elseif isnan(r{i})
          rels{i}='NaN';
        else
          rels{i}='Unknown';
        end
    end
    fprintf('%s',blanks(pad));
    for j=1:size(rels,2)
      fprintf(formato,rels{j})
    end
    fprintf('\n')
  end
    
  
  
  % soglia per la visualizzazione di 4 decimali;
  soglia = 10000;
  
  %calcolo il formato per colonna
 
  formato = cell(1,size(dati,2));
  for x = 1:size(dati,2)
      media = nanmean(dati(:,x));
      if(media>soglia) 
          formato{x} = ['%' num2str(pad) '.1f'];
      else
          formato{x} = ['%' num2str(pad) '.4f'];
      end
  end
  
  
  
  for j=1:size(dati,1)
    d = dati(j,:);
    if freq==365
        sf=s(j,:);
    else
        sf='';
    end
   
    
    fprintf('%d-%s-%03d %s',year,prd,period,sf); 
    
    for rig = 1:size(d,2);
        fprintf(formato{rig},d(rig));     
    end
    fprintf('\n');
    [ year, period ] = tsidx_next(freq, year, period);
  end
