function [ret1,ret2] = TSMATCheckArithm(a,b)
%TSMATCheckArithm  checks input of arithmetics function for tsmat objects
%
% >> [ret1,ret2] = TSMATCheckArithm(a,b)
%    whit a,b  double or tsmat objects
%
% Errors:
%   TSMATCheckArithm::Inputs are not conformable
%   TSMATCheckArithm::Element must be a tsmat object
%   TSMATCheckArithm::One Input must be TSMAT
%   
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%
%

  % Defaults to input args
  ret1=a;
  ret2=b;

  % If one of the arg is double
  if any([isa(a,'double'), isa(b,'double')])
    
    % If first is double
    % ...setup a suitable tsmat 
	if isa(a,'double') 
      
      if ~isa(b,'tsmat')
        error([ mfilename '::One Input must be TSMAT'])
      end

      [Tb,Nb]=size(b.matdata);
      [Ta,Na]=size(a);
        
      if length(a)==1
        ret1=b;
        ret1=subsasgn(ret1,substruct('()',{':',1:Nb}),a);
            
      elseif and(Ta==Tb,Na==Nb)
        ret1=b;
        ret1=subsasgn(ret1,substruct('.','matdata'),a);
            
      else
        error([ mfilename '::Inputs are not conformable'])
        return
        
      end
      
	end

    % If second is double
    % ...setup a suitable tsmat 
	if isa(b,'double')

      if ~isa(a,'tsmat')
        error([ mfilename '::One Input must be TSMAT'])
      end

      [Ta,Na]=size(a.matdata);
      [Tb,Nb]=size(b);
        
      if length(b)==1
        ret2=a;
        ret2=subsasgn(ret1,substruct('()',{':',1:Na}),b);
            
      elseif and(Ta==Tb,Na==Nb)
        ret2=a;
        ret2=subsasgn(ret1,substruct('.','matdata'),b);
            
      else
        error([ mfilename '::Inputs are not conformable'])
        return
        
      end
      
	end
  end

  % Now output elements *must* be tsmat
  if ~isa(ret1,'tsmat') | ~isa(ret2,'tsmat')
    error([ mfilename '::Element must be a tsmat object'])
  end
