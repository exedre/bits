function [ynormaliz stad medi] = normaliz(y)
% normalize a matrix or tsmat object
% Works for tsmat objects as well


qq=0;
if isa(y,'tsmat')
    qq=1;
    ynorm=y;
    y=y.matdata;
end
[T,N]=size(y);
   ynormaliz=NaN*y;
   stad=repmat(nanstd(y),T,1);
   medi=repmat(nanmean(y),T,1);
   ynormaliz=(y-medi)./stad;
   
   if qq
       ynorm.matdata=ynormaliz;
       ynormaliz=ynorm;
   end