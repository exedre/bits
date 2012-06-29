function ret = notnanrange(self)
%@tsmat/notnanrange sets range of tsmat to common range where all columns are non NaN
% NaN can only be placed at either start or end 
% i.e. only trailing NaNs are removed

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni_DOT_veronese_AT_bancaditalia_DOT_it)
%           Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  ret=self;
  dati=ret.matdata;
  [T,N]=size(dati);
  for j=1:N
	start_j(j)= min(find(isfinite(dati(:,j))));	
      end_j(j)= max(find(isfinite(dati(:,j))));
  end

  iniz=max(start_j);
  fine=min(end_j);

  if and(iniz==1,fine==T)
	return
  end

  if iniz==T
	error(['@' mfilename('class') '\' mfilename '::one column in tsmat contains all NaNs'])
	clear ret;
	return;
  else
	s.type='()';
	s.subs={[iniz:fine],[':']};
	ret=subsref(ret,s);
  end
