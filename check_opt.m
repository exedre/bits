function [ok, arg] = check_opt( who, what, varargin )
%check_opt - verify option type and arrange correct output 
%
%   'what' is the description of values classes 'who' can take 
%   f.i.: what = { { 'char' } , { 'cell' } ]
%   
%   varargin{1} = return type 
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma   (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

    if nargin>2 
        rettype = varargin{1};
    else
        rettype = 'same';
    end

    tfunc = nan;
    ttype = nan;
    transform = nan;

    % Function to appy to results (if any)
    %
    if nargin>3        
        tfunc     = varargin{2};
        ttype     = tfunc{1};
        transform = tfunc{2};
        tfunc     = true;
    end
    
    if isa(what,'char')
        what = { what };
    end
    
    ok     = false;

    arg    = nan;
    choice = nan ;        
    type   = nan;
    
    % Test on type
    % 
    for i=1:length(what)
        choice = what{i};
        type = choice{1};
        if isa(who,type)
            ok=true;
            break;
        end
    end
    
    if ~ok % exit with type-error
        arg = 'type';
        return
    end
    
    % Test on Size
    %
    for i=1:length(what)
      choice = what{i};
      if ok & length(choice)>1 
        len = choice{2}
        if length(len)>1 
          ok = isequal( size(who) , len ); 
        else
          ok = isequal( length(who) , len );
        end
      end
    end
    
    if ~ok % exit with size-error
        arg = 'size';
        return
    end
    
    % Transform return 
    %     
    if ok
      arg = who;
      if strcmp(rettype,'char')
        if ~isa(who,'char')
          arg = char(who);
        end
        
        % Apply func to result
        if ~isnan(tfunc)
          arg = sprintf('arg = %s(''%s'')',transform,arg);
          eval( [ arg ]);
        end
            
      elseif strcmp(rettype,'cell')
        if ~isa(who,'cell')
          arg = { who };
        end

        % Apply func to result
        if ~isnan(tfunc)

          % FUNCTION datenum
          if strcmp(transform,'datenum')
            for i=1:length(arg) 
              v = arg{i}; 
              if isscalar(v)
                if ~isa(v,ttype)
                  cmd = sprintf('arg{%d} = %s(''%s'');',i,transform,v);
                  eval( [ cmd ] );
                end
              else
                w = [];
                if isa(v,'char')
                  cmd = sprintf('arg{%d} = %s(''%s'');',i,transform,v);
                  eval( [ cmd ] );
                else                                
                  for m=1:size(v,1)
                    for n=1:size(v,2)
                      if ~isa(v(m,n),ttype)
                        cmd = sprintf('w(%d,%d) = %s(''%s'');',m,n,transform,v(m,n))
                        eval( [ cmd ] );
                      end
                    end
                  end
                end                                
              end
            end
            
          % FUNCTION date2tsidx
          elseif strcmp(transform,'date2tsidx')
            freq = varargin{3};
            if isnan(freq)
              error([ mfilename '::Internal error in check_args']);
            end

            for i=1:length(arg) 
              v = arg{i};
              if isnan(v)
                arg{i}=nan;
                continue
              end

              if isscalar(v)
                if ~isa(v,ttype)
                  cmd = sprintf('arg{%d} = %s(''%s'');',i,transform,v);
                  eval( [ cmd ] );
                end
              else
                if ~isa(v,ttype)
                  cmd = sprintf('[du dy] = %s(%d,%d);',transform,freq,datenum(v));
                  eval( [ cmd ] );
                  arg{i}=[du dy];
                else
                  arg{i} = v;
                end                       
              end
            end                
          end
        end
        
      else
        % 
      end
    end
