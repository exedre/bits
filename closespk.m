function closespk(remotespk) 

if remotespk.isOpen() == 1
    disp('closing speakeasy...');
    remotespk.closeSpeakeasy();
    remotespk.closeSession();
    disp('closed.');
else 
    disp('speakeasy is already closed');
end
