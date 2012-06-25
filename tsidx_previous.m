function [nyear,nperiod]=tsidx_previous(freq,year,period)
% TSIDX_PREVIOUS returns the previous index fro the given frequency
%    [ PY, PP ] = TSIDX_PREVIOUS(FREQ,Y,P] returns year and period of previous observation

%   Copyright 2005-2006 Claudia Miani, Emmanuele Somma, Giovanni Veronese (Servizio Studi Banca d'Italia)
%   $Revision: 1.2 $  $Date: 2007/11/27 16:35:39 $

if freq>=1 & period>ifreq(freq,year)
    error([ mfilename '::PeriodOutsideFrequency'])
elseif freq<1 & period ~= 1
    error([ mfilename '::PeriodNotOneOnDecimalFrequency'])
end

nyear=year;
nperiod=period;
npy=ifreq(freq,nyear-1);

if freq<1
    nyear =nyear - fix(1/freq);
else
    nperiod=nperiod-1;
    if nperiod==0
        nyear=nyear-1;
        nperiod=npy;
    end
end
