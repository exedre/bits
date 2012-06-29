function self = test_distance2tsidx(self)
%test_distance2tsidx - test distance2tsidx function
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele_DOT_somma_AT_bancaditalia_DOT_it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%
%
%  Example
%  =======
%         run(gui_test_runner, 'test_assert(''test_...'');');
%

% distance2tsidx.m - delta in years and periods to move dist periods away
%
for f=[1 2 4 6 12 52 365]
    for i=1:36
        [ a b ] = distance2tsidx(f,i);
        if a>0
            flo=floor(i/f);
            assert_equals( a, floor(i/f), sprintf('distance2tsidx error on year component for  freq %d distance %d (returns index [%d,%d]) ', f,i,a,b ))
        end
        if b>0
            mo=mod(b,f);
            assert_equals( b, mod(b, f), sprintf('distance2tsidx error on year component for  freq %d distance %d (returns index [%d,%d]) ', f,i,a,b ) )
        end
    end
end
