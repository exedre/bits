function out = q2m(a,opt)
% q2m: quarterly to monthly trasformation
% out     = q2m(a,opt)
% a       = quarterly time series
% opt  ='step'  , repeat 3 times the quarterly number
%          'miss'  , place the quarterly number at last month of each
%                     quarter, NaN in the 1st and second month
% out = monthly time series 

qstart=a.start;
qdata=a.matdata;
% Compute start year and month for the monthly time series
mstart=[qstart(1),qstart(2)*3-2];
switch opt
	case 'step'
	   matr = [1;1;1];
       newdata=kron(qdata,matr);
    case 'miss'
        matr = [NaN;NaN;1];
        newdata=kron(qdata,matr);
    case 'misscenter'
        matr = [NaN;1;NaN];
        newdata=kron(qdata,matr);
    case 'interp'
        matr = [NaN;NaN;1];
        newdata_withnan=kron(qdata,matr);
        T      = size(newdata_withnan,1);
%        boni   = find(isfinite(newdata));
    for jj=1:size(newdata_withnan,2)
        [boni]= find(isfinite(newdata_withnan(:,jj)));
        newdata(:,jj)= interp1(boni,newdata_withnan(boni,jj),(1:T)');
    end
end

      out = tsmat(mstart(1),mstart(2),12,newdata);



