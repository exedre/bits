function [common_range,union_range]=setrange(a,b)
%SETRANGE Finds common and the union range of 2 tseries or tsmat objects; 
%
%
%    COMMON_RANGE=SETRANGE(A,B) returns an 1x4 array containing the tsindexes 
%                 for start and end of the common range of 
%				  the two timeseries in input A and B
%
%    [COMMON, UNION] =SETRANGE(A,B) returns an 2x(1x4) array containing the tsindexes 
%    for start and end of the common and of the union range of the two timeseries in input A and B
%
%    Example:
%            C = SETRANGE(A,B)
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  
  if isa(a,'tsmat') & isa(b,'tsmat');
       fa=subsref(a,substruct('.','freq'));       fb=subsref(b,substruct('.','freq'));
    if fa~=fb
        error([ mfilename '::Time series do not have same frequency'])
    end

    a_s=tsidx2date(a.freq,a.start_year,a.start_period);
    a_e=tsidx2date(a.freq,a.last_year,a.last_period);
    b_s=tsidx2date(b.freq,b.start_year,b.start_period);
    b_e=tsidx2date(b.freq,b.last_year,b.last_period);

    res=[max(a_s,b_s),min(a_e,b_e)];
    [c_ys,c_ps]=date2tsidx(a.freq,res(1));
    [c_ye,c_pe]=date2tsidx(a.freq,res(2));

    res1=[min(a_s,b_s),max(a_e,b_e)];
    [u_ys,u_ps]=date2tsidx(a.freq,res1(1));
    [u_ye,u_pe]=date2tsidx(a.freq,res1(2));
    union_range=[[u_ys,u_ps],[u_ye,u_pe]];
    
    if res(1)<=res(2)
        common_range=[[c_ys,c_ps],[c_ye,c_pe]];
    else
      % No overlap
      common_range=[];
    end

  else
    error([ mfilename '::Inputs must be two tsmat'])
  end
