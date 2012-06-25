function [tss]=fiscal_year(ts,varargin)
% ANNUAL aggregation of a monthly tsmat/tseries object with fiscal year
% (April to March)
%    [Y]=fiscal_year(TS,opt1,opt2)
%    with  opt1='nopad' {default}
%    returns a Tsxm temporally aggregated series 
%    where ts (n x m) is a tseries of high frequency data
%    Optional type of temporal aggregation  is like 
%	 'sum' for sum (flow), 
%    'ave' for average (index) (which is the default) and 
%    'stock' for last element (stock) 
%
%	See also:  aggrts.m,consolidator.m


%   Copyright 2005-2006 Claudia Miani, Emmanuele Somma, Giovanni Veronese (Servizio Studi Banca d'Italia)
%   $Revision: 1.2 $  $Date: 2006/11/08 10:47:24 $

% Lead the timeseries by 3 months (so that march is december of previous
% year)
ts1=ts{3};

tss=annual(ts1,'nopad',varargin{1});
