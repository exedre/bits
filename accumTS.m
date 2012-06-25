%% accumTS- aggregate data to users specified columns of data

function [dataout] = accumTS(datain,fn)
    % Aggregate values using the user specified function.
    [b1, a1,n1] = unique(datain(:,1),'rows');
    N=size(datain(:,2:end),2);
    datiagg=NaN(length(b1),N);
    for q=1:N
    datiagg(:,q) = [accumarray(n1,datain(:,q+1),[],fn)];
    end
    dataout=[b1,datiagg];



%% EXAMPLE BY GIO

%aa=[randn(10,1)>0,(1:10)'];

%[dataout] = accumTS(aa,@sum)