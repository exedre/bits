function str=num2freq(freq)
% NUM2FREQ returns a string which represents the frequency in input
%     STR = NUM2FREQ(FREQ) returns a string as 
%         daily,business,weekly,biweekly,monthly,bimonthly,quarterly,
%         fourmonthly,semiannual,annual,biannual,four-years,eight-years or non-periodic
%     Example:
%    str = num2freq(12) returns 'annual'
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%


switch freq
    case{365,366}
     str='daily';
    case{250,251}
     str='business';
    case{52,53}
        str='weekly';
    case{26,27}
        str='biweekly';
    case{12}
        str='monthly';
    case{6}
        str='bimonthly';        
    case{4}
        str='quarterly';
    case{3}
        str='fourmonthly'
    case{2}
        str='semiannual';
    case{1}
        str='annual';
    case{.5}
        str='biannual';
    case{.25}
        str='four-years';
    case{.125}
        str='eight-years';
    case{-1}
        str='non-periodic';
end
        

     
