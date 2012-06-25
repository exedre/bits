function out_index=rebase_index(values,base,freq)
% rebase_index : calculates the index for a set of values with a given base
% inputs :
%          values    =set of values in a tsmat
%          baseperiod=[year and period] to be used as baseperiod
%          freq      = monthly, quarterly or annual (12,4,1)


if ~isa(values,'tsmat')
    error('first argument must be a tsmat!')
end
out_index=values;
out_index.matdata=NaN(size(out_index,1),size(out_index,2));

freq_tsmat=values.freq;

baseyear=base(1);
baseperiod=base(2);
fact=freq_tsmat/freq;
if fact>1
%    bp=[baseperiod*freq,(fact-1)*baseperiod+1];
    bp=[(baseperiod-1)*fact+1,fact*baseperiod];
else
    bp=[base(2),base(2)];
end
livbase=nanmean(values(baseyear(1),bp(1),baseyear(1),bp(2),:));

[T,N]=size(values);
livbase=repmat(livbase,T,1);

out_index.matdata=100*values.matdata ./livbase;


