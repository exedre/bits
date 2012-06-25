function [t,namelist,r] = spkload(rs, obj, archivio,patt)
%
% *** VERSIONE TEMPORANEA PRE-PRE-PRE-ALPHA***
% input : 
%       nomeserie - nome della serie da caricare 
%       archivio - directory su RISC dove si trova il file
%                  speakeasy della serie
%       username - username RISC
%       password - password RISC
%       hostname - DNS RISC (introdurre un default, tanto sara'
%                            sempre stux19 o stux20)
% output :
%       un tsmat della serie richiesta.
%  
%  TODO: 
%  - finire l'adapter per SSH (aka migliorare
%  - implementare le sessioni (non e' pensabile di riconnettersi
%    per ogni serie. Quindi un .m che inizializza la sessione
%    ed uno che la chiuda (Con Telnet funziona, SSH no)
%  - Implementare una Dialog per la Login interattiva
%
% $Id: spkload.m,v 1.3 2007/10/03 12:01:22 m024000 Exp $
%

remotespk = rs;
r = rs;
created = 0;
namelist= [];
if remotespk.isClosed() ==  1
  disp('speakeasy session timed out, reopening...')
  host = rs.getHostname();
  remotespk = openspk(host);
  created = 1;
end

if nargin == 2
% sto cercando di caricare tutto un archivio
    archivio = obj;    
    listaj = remotespk.getArch(archivio);
    t=cell(listaj.size(),1);       
    % questa zozzeria del -1 e' necessaria perche' Java conta da 0 (zero)
    namelist = {listaj.size()};
    for i=0: (listaj.size()-1)
        jts = listaj.get(i);
        disp(jts.getLabel());
        disp(jts.getStart());
        disp(jts.getPrd());
        disp(jts.getFreq());
%        disp(jts.getData());
        nomeMatlab = java2char(jts.getLabel());
%        disp(nomeMatlab);
        ts = tsmat(jts.getStart(), jts.getPrd(), jts.getFreq(), jts.getData(), nomeMatlab);        

        namelist{i+1} = nomeMatlab;
        t{i+1} = ts;
    end
    

elseif nargin == 3
    %    it.bancaditalia.legacy.adapter.TelnetSpeakeasyAdapterImpl(user, ...
    %						  pass, host);


    jts = remotespk.getTS(obj, archivio);
    nomeMatlab = java2char(jts.getLabel());
    namelist = {nomeMatlab};
    t = tsmat(jts.getStart(), jts.getPrd(), jts.getFreq(), ...
	  jts.getData(), nomeMatlab);

    
end

if nargout == 2 && created == 1 
   disp('being nargout=1, freeing speakeasy..');
   remotespk.closeSession();
   remotespk=0;
   disp('speakeasy closed...');
elseif nargout==2  
  r = remotespk;      
end
end

function c = java2char(input) 
    if isjava(input) 
        a = [];
        for i = 0:(input.length()-1)
            a = [a input.charAt(i)] ;       
        end
        c = a;
    else
        error('input non e'' una stringa java');
    end
end

	  
