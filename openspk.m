function remotespk = openspk(host, type)
% 
% Apre una sessione verso SPK
% RICORDARSI di chiudere la sessione con closespk
% 
% type = 0 - telnet
%        1 - ssh
% 
if nargin < 2
   error('not enough arguments');
else
  login =it.bancaditalia.speckeasy.ui.LoginForm([], 'RISC', 1);
  if length(login.getPassword()) == 0 || length(login.getUsername()) == 0 
    error('no username or password provided, quitting');
    remotespk = []
    return 
  else
    user = login.getUsername();
    pass = login.getPassword();
  end
end

if(type < 0 || type > 1) 
   error('please specify the correct transport type: 0 for ''telnet'', 1 for ''ssh''');
   remotespk=[]
   return
end

factory = it.bancaditalia.speckeasy.adapter.SpeakeasyAdapterFactory.getInstance();

remotespk = factory.createAdapter(type,user, pass, host);

disp('opening speakeasy...');
remotespk.openSession();
remotespk.openSpeakeasy();
if(remotespk.isSpeakeasyActive()) 
   disp('speakeasy ready.');
else
   error('speakeasy not active');
end
