function self = test_period(self)
% test_period
%
% Bank-IT Time Series Toolbox
%   Copyright 2005-2006 Claudia Miani, Emmanuele Somma, Giovanni Veronese 
%   (Servizio Studi Banca d'Italia)
%   $Revision: 1.1.1.1 $  $Date: 2007/08/01 14:16:20 $
%
%
%  Example
%  =======
%         run(gui_test_runner, 'test_assert(''test_pass'');');
%

% period.m - returns the period in the timeseries index given a matlab serial date and a frequency
assert_equals(period( datenum(1980,3,1), 12 ), 3, 'period()')
