function [anno, settimana,giorno] =  date2weeks(date,varargin)
%WEEKS2DATE returns the year, and week number given specific date 
% Varargin specifies the convention used for week start (default=sunday)
% The year 
% Default start of the week is on Monday
% [ y, w ] = date2weeks(date,varargin)
%
% Example:
%
% [ y, w ] = date2weeks(datenum(2000,1,1),1)
% 
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%
% Default start of the week is on Sunday
qualeday='Sun';
if nargin==2
    qualeday=varargin{1};
end
out = isoweek_custom(date,'vec',qualeday);
[anno,settimana,giorno]=deal(out(:,1),out(:,2),out(:,3));