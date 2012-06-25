function varargout = plot(varargin)
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
%   Author: Giovanni Veronese (giovanni.veronese@bancaditalia.it)
%           Emmanuele Somma   (emmanuele.somma@bancaditalia.it)
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
  Properties='';

  dati=TimeSeries.matdata;
  s.type= '.';
  s.subs= 'dates';
  date=subsref(TimeSeries,s);
  plot_handle=plot(date,dati,Properties);

  freq=TimeSeries.freq;
  
  switch freq
   case {1,4,12}
    prd='yyyy';
   case {365;366}
    prd='dd-mmm-yyyy';
  end

  %datetick('x',prd,'keeplimits');
  datetick('x',prd);
  nome=title(namets);
  set(nome,'Interpreter','none')
  
  
  [m,n] = size(ts);
  
  descrts = ts.meta_cols.label;
  if n>1
    if str2num(version('-release'))<14
      leg_handle=legend(descrts,0);
    else
      leg_handle=legend(descrts,'Location','best');
    end;
  else 
	legend('off');
  end
  % Use Xgrid by defaults
  set(gca,'XGrid','on')

  if nargout
	varargout{1}=plot_handle;
	varargout{2}=leg_handle;
    varargout{3}=nome;
  end
