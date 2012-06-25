function [newdates,newticks]=adddates(datainiz,numbers,tipo)
% newdates=adddates(datainiz,numbers,tipo)
% easy to get ticks and xticks
newdates=NaN(length(numbers),1);
for j=1:length(numbers)
    newdates(j,1)=addtodate(datainiz,numbers(j),tipo);
end
newticks=datestr(newdates);