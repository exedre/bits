function varargout = plotts(varargin)
%@tsmat/plot - overloaded plotting facility for tsmat objects
% 2nd input can be a specific field name of the ts metadata
% 
% Example 1:
%    hh=plot(X) 
%    Input:
%    X=Tsmat object
%    Output:
%    hh = column vector of handles to lineseries objects, one
%    handle per plotted line
%
% Example 2:
%    [hh,rr]=plot(X,namefield) 
%    Input:
%    X=Tsmat object
%    namefield= string with name of column metadata field 
%    Output:
%    hh = column vector of handles to lineseries objects, one
%    handle per plotted line
%    rr = column vector of handles to legend text objects, one
%    handle per plotted line
%    

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni_DOT_veronese_AT_bancaditalia_DOT_it)
%           Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  ts=varargin{1};
  namets=inputname(1);
  descrts=[];
  leg_handle=[];
  if length(ts.meta_cols)
	if nargin==1
      namets=inputname(1);
	elseif nargin==2
      % if specific meta description desired
      if isfield(ts.meta_cols,varargin{2})
        if str2num(version('-release'))<14
          descrts=char(getfield(ts.meta_cols,varargin{2})); 
        else
          descrts=getfield(ts.meta_cols,varargin{2}); 
        end;
      end
	end
  end

  TimeSeries=ts;
  freq=TimeSeries.freq;

  Properties='';

  dati=TimeSeries.matdata;
  
  offset=182*(freq==1)+14*(freq==12)+45*(freq==4)+91*(freq==2)
      
 

  date=TimeSeries.dates;
  
  plot_handle=plot(date+offset,dati,Properties);


  
  switch freq
      case 1
          nuovi=datestr(date,'yyyy');
      case 12
          prd='yyyy';
          nuovi=datestr(date,prd);
        %  nuovi(month(date)~=6,:)='';
%          quali=union(find(month(date)==1),find(month(date)==12));
         %  quali=find(month(date)==12);
          set(gca,'Xtick',date)
          primo=min(find(month(date)==6));
          nuovi(setdiff(1:size(nuovi,1),primo:12:end),:)=' ';
          set(gca,'Xticklabel',nuovi);
          set(gca,'Xlim',[min(date),max(date)])
          %set(gca,'XMinorTick','on')
          %axis('tight')
      case {365;366}
          prd='dd-mmm-yyyy';
  end
  

set(gca,'Xgrid','off')
ax1=gca;


ax2=ticklabel(gca);

primi=min(find(month(date)==1));
set(ax1,'XTick',date(primi:12:end),'Xgrid','on','XMinorTick','on')

aa1=get(ax1,'xlim');
aa2=get(ax2,'xlim');
%set(ax1,'xlim',[aa1(1),aa1(2)+30])
%set(ax2,'xlim',[aa2(1),aa2(2)+30])
%set(ax2,'XMinorTick','on')




if nargout
	varargout{1}=plot_handle;
	varargout{2}=leg_handle;
    varargout{3}=[ax1,ax2];
    
  end
