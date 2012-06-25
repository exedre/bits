function LL=nanlast(x)
% to avoid in case of daily data missing values for weekends or holidays
LL=x(end,:);
if isnan(LL)
    LL=x(end-1,:);
end
if isnan(LL)
    LL=x(end-2,:);
end
if isnan(LL)
    LL=x(end-3,:);
end
if isnan(LL)
    LL=x(end-4,:);
end
if isnan(LL)
    LL=x(end-5,:);
end
if isnan(LL)
    LL=x(end-6,:);
end