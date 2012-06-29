function self = subsasgn(self,index,val)
%@tsmat/subsasgn implements the indexing for the TSMAT object.
%
%  SUBSREF allows for the indexing into TSMAT objects using integer,
%  date string, or date and time string indexing.  
%  Serial Dates and Times
%  can be used as indices.  
%  Additionally, SUBSREF allows the access of
%  individual components in the object using the structure syntax.
%
%  The syntax for integer indexing is the same as for any other MATLAB matrix.
%
%  For example: 
%   myts=tsmat(1980,1,12,[[1:10]',[11:21]']);
%   
%  Creates the TSMAT monthly object with 2 columns having the first 10 integers starting
%   in Jan.1980 on the first column and the next 10 on the second column
%
%  Possible subsasgn are
%
%  1) Integer
%   myts(2:3,1:2)= AA where AA is with size length(2:3)xlength(1:2)
%
% 2) Date(s) in 1x2 (1x4) vector format  
%
%   See also @TSMAT/ts2mat.
%

%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni_DOT_veronese_AT_bancaditalia_DOT_it)
%           Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

%%-Main----------------------------------------------------------------------
  data  = self.matdata;
  [T,N] = size(data);
  freq  = self.freq;
  start = self.start_year;
  period= self.start_period;
  lasty = self.last_year;
  lastp = self.last_period;

  SL = length(index);

  if strcmp(class(val),'tsmat')
	val=val.matdata;
  end
	
  if length(index)>2
    error(['@' mfilename('class') '\' mfilename '::too many levels of ' ...
                        'subsasgn '])
    
  elseif length(index)==2
	% Allows to subsasgn 
    impacted_field=subsref(self,index(1));
	impacted_field=subsasgn(impacted_field,index(2),val);
	self = subsasgn(self,index(1),impacted_field);
    
  else
    switch index.type
     case '.'

      switch index.subs
       case 'matdata'
        % allow only subasng with matrix of same size
        if and(size(data,1)==size(val,1),size(data,2)==size(val,2))
          self.matdata=val;
        else 
          error(['@' mfilename('class') '\' mfilename '::Invalid subsasgn ' ...
                              'non conformable'])          
          return
        end
				
       case 'meta'
        self.meta=val;
        
       case 'meta_cols'
        self.meta_cols=val;
        
       case 'last_year'
        self.last_year=val;
       case 'last_period'
        self.last_period=val;
				
       otherwise
        error(['@' mfilename('class') '\' mfilename ':: unknown ' ...
                            'subelement'])        
      end
     case '()'
      L = length(index.subs);
            
      switch L
            
       case 2
					
        % Check for possibility of use of : in the assignment
        if strmatch(':',num2str(index.subs{1}),'exact')
          index.subs{1}=1:T;
        end

        if strmatch(':',num2str(index.subs{2}),'exact')
          index.subs{2}=1:N;
        end
        
        if or(and(length(index.subs{1})==size(val,1),length(index.subs{2})==size(val,2)),...
              length(val)==1)
          self.matdata(index.subs{1},index.subs{2})=val;
          
        else
          error(['@' mfilename('class') '\' mfilename '::Not conformable'])
          return
        end
        
        % Redefine last_year and last_period
        [ self.last_year, self.last_period ] = start2end(freq, start, period, size(self.matdata,1)-1 );
					
       case 5
        if or(index.subs{2}>freq,index.subs{4}>freq)
          error(['@' mfilename('class') '\' mfilename '::Invalid periods (>freq)'])
          return
        end

        
        if strmatch(':',num2str(index.subs{5}),'exact')
          index.subs{5}=1:N;
        end

        
        tsidx0=[self.start_year,self.start_period];
        tsidx1=[cell2mat(index.subs(1)),cell2mat(index.subs(2))];
        tsidx2=[cell2mat(index.subs(3)),cell2mat(index.subs(4))];
        from_start=tsidx_distance(self.freq,tsidx0,tsidx1)+1;
        y =tsidx_distance(self.freq,tsidx1,tsidx2);

        if from_start<=0
          %% Need to expand the series(pad it at start):
          mis_pad=NaN(-from_start+1,N);
          self.matdata=[mis_pad;self.matdata];
          from_start=1;
          self.start_year=index.subs{1};
          self.start_period=index.subs{2};
        end

					
        if or(and(length(from_start:from_start+y)==size(val,1),length(index.subs{5})==size(val,2)),...
              length(val)==1)
          % Recursively call again the subsasgn with 2 inputs now
          ind.subs{1}=from_start:from_start+y;
          ind.subs{2}=index.subs{5};
          ind.type='()';
          self=subsasgn(self,ind,val);
          %self.matdata(from_start:from_start+y,index.subs{5})=val;
          % the last_period and last_year will be taken care of
          % there
        else
          error(['@' mfilename('class') '\' mfilename '::Not conformable'])
          return
        end
		
	
       otherwise
        error(['@' mfilename('class') '\' mfilename '::Invalid subasgn'])
        return
      end
				
     otherwise
      error(['@' mfilename('class') '\' mfilename '::specify either in () or in {} format'])
        
    end

  end
