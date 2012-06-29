function res=horzcat(varargin)
%@tsmat/horzcat - Timeseries Horizontal concatenation.
%
%   [A B] is the horizontal concatenation of timeseries A and B.  A and B
%   must have the same number of rows.  [A,B] is the same thing.  Any
%   number of matrices can be concatenated within one pair of brackets.
%   Horizontal and vertical concatenation can be combined together as in
%   [1 2;3 4].  
%
%   [A B; C] is allowed if the number of rows of A equals the number of
%   rows of B and the number of columns of A plus the number of columns
%   of B equals the number of columns of C.  The matrices in a
%   concatenation expression can themselves by formed via a
%   concatenation as in [A B;[C D]].  These rules generalize in a
%   hopefully obvious way to allow fairly complicated constructions.
%
%   N-D arrays are concatenated along the second dimension. The first and
%   remaining dimensions must match.
%
%   C = HORZCAT(A,B) is called for the syntax '[A  B]' when A or B is an
%   object.
%
%   Y = HORZCAT(X1,X2,X3,...) is called for the syntax '[X1 X2 X3 ...]'
%   when any of X1, X2, X3, etc. is an object.
%
%   See also @tsmat/vertcat

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

    % Find non-empty arrays
    Nin=nargin;
    nonempty_ind=ones(Nin,1);
    for j=1:Nin
      if ~length(varargin{j})
	 	nonempty_ind(j,1)=0;
      end
      %input is empty array: continue
    end
    rr=find(nonempty_ind);
    nr=length(rr);

    % Get series informations
    for s=1:nr
      j=rr(s); 
      switch class(varargin{j})
       case {'tseries','tsmat'}
        ts_struc=struct(varargin{j});
        
        % Check frequency
        freq(s)=ts_struc.freq;
        if s>1
          if (freq(s)-freq(s-1))
            error(['@' mfilename('class') '\' mfilename '::Inputs do not have same frequency'])
            return
          end
        end

        % Get start and last indices
        start(s)=ts_struc.start_year+ts_struc.start_period/(1000*freq(s));
        last(s) =ts_struc.last_year +ts_struc.last_period /(1000*freq(s));

       otherwise
        error(['@' mfilename('class') '\' mfilename '::wrong input in horzcat'])
        return
      end
    end

    % Global freq
    freq=freq(end);

    % Global start_year
    pos1=find(start==min(start));pos1=pos1(1);
    start_y=floor(start(pos1(1)));
    start_p=round(1000*freq*(start(pos1)-start_y));

    % Global last_year
    pos2=find(last==max(last));pos2=pos2(1);
    last_y=floor(last(pos2));
    last_p=round(1000*freq*(last(pos2)-last_y));

    matdati=[];
    meta = [];

    for s=1:nr
      j=rr(s);

      inputj=varargin{j};

      pp.subs{1}=start_y;
      pp.subs{2}=start_p;
      pp.subs{3}=last_y;
      pp.subs{4}=last_p;
      pp.type='()';

      switch class(varargin{j})
       case 'tseries'
        matj=subsref(inputj,pp);
        mmj=matj.data;
       case 'tsmat'
        meta2 = getfullcolmeta(inputj,true);
        pp.subs{5}=':';
        matj=subsref(inputj,pp);
        mmj=matj.matdata;
      end

      clear pp
      matdati=[matdati,mmj]; % horzcat matdatas
      
      % Metadata Managing here
      meta = metafuse(meta, meta2);
    end

    res=tsmat(start_y,start_p,freq,matdati);
    res=setfullcolmeta(res,meta);

function meta = metafuse(meta1,meta2)
  if length(meta1)>0
    fnames1 = fieldnames(meta1);
  else
    meta = meta2;
    return
  end
  fnames2 = fieldnames(meta2);
  I12 = setdiff(fnames1,fnames2);
  I21 = setdiff(fnames2,fnames1);
  ncols = size(meta1,2);
  for i=1:size(I21,1)
    field = I21{i};
    xtemp=[];
    meta1 = setfield(meta1,{ncols},field,xtemp);
  end
  ncols = size(meta2,2);
  for i=1:size(I12,1)
    field = I12{i};
    xtemp=[];
    meta2 = setfield(meta2,{ncols},field,xtemp);
  end
  meta = [meta1 meta2];