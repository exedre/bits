function [varargout]=view_range(X)
% display the rows with first and last notnan of each colimn of a tsmat 
% Assumes that no missing exist within the rows nperiods+1:end-nperiods
% And that if NaN exist: they are at start and end of sample in contiguos
% form
% if nargout==1 -->displays meta information on start and range
[sy,sp,ey,ep,freq]=deal(X.start_year,X.start_period,X.last_year,X.last_period,X.freq);

[T,N]=size(X);
dati=X.matdata;
freq=X.freq;
for j=1:N
%     disp(j)
    iniz(j)=min(find(isfinite(dati(:,j))));
    fine(j)=max(find(isfinite(dati(:,j))));
end

start_r=cell(1,N);
last_r=cell(1,N);
[py, pp]=deal(sy,sp);
dateimp=tsidx2date(freq,py,pp);

dateend=tsidx2date(freq,ey,ep);
start_r(1:end)={datestr(dateimp,forma(freq))};
last_r(1:end)={datestr(dateend,forma(freq))};

for j=1:max(iniz)
    dateimp=tsidx2date(freq,py,pp);
    ia=find(iniz==j);
    start_r(ia)={datestr(dateimp,forma(freq))};
    [ py, pp ] = tsidx_next(freq,py,pp); 
end

for j=T:-1:min(fine);
    dateend=tsidx2date(freq,ey,ep);
    ia=find(fine==j);
    last_r(ia)={datestr(dateend,forma(freq))};
    [ ey, ep ] = tsidx_previous(freq,ey,ep);
end



% Xrich differs from original input: as it contains metadata on start/end
Xrich=X;
Xrich=addmeta_cols(Xrich,1:N,'start_date',start_r);
Xrich=addmeta_cols(Xrich,1:N,'last_date',last_r);



if nargout==0
     view_meta(Xrich,{'label','start_date','last_date'})
end
for j=1:nargout
    varargout{1}=Xrich;
    varargout{2}=start_r;
    varargout{3}=last_r;
end


function formato=forma(freq)
switch freq
    case 12
        formato='mmm-yyyy';
    case 4
        formato='QQ-yyyy';
    case 1
        formato='yyyy';
end

