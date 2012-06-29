function [c,ia,ib] = intersect(a,b,flag)
%@tsmat/intersect - Overloaded for tsmat objects: intersect

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni_DOT_veronese_AT_bancaditalia_DOT_it)
%           Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  oper=mfilename;
  if nargin==2
     %default behavior: operates on labels of the tsmat 
     % (could extend it to other meta of the tsmat)
	[qq,ia,ib] = intersect(a.meta_cols.label,b.meta_cols.label);
   % disp([length(ia),length(ib)])
    % No check performend on the common dates!
    c=subsref(a,substruct('()',{':',ia})); 
    
  elseif nargin==3
      if and(isfield(a.meta_cols,flag),isfield(b.meta_cols,flag))
          %default behavior: operates on labels of the tsmat
          [qq,ia,ib] = intersect(a.meta_cols.(flag),b.meta_cols.(flag));
          c=subsref(a,substruct('()',{':',ia}));
      elseif strcmp(flag,'dates')      
          [c,ia,ib]=intersect(subsref(a,substruct('.','dates')),subsref(b,substruct('.','dates')));
          c=subsref(a,substruct('()',{ia,':'}));
      end
      
  else
    error(['@' mfilename('class') '\' mfilename '::invalid number of inputs'])
  end
