function descript=view_meta(ts,varargin);
% Full or partial description of the metadata in a tsmat object
% varargin is, one input, cell array of strings with names of meta_cols
% if no varargin full meta_col are displayed
[T,N]=size(ts);
pp=ts.meta_cols;
if nargin==1
    ncols=length(fieldnames(ts.meta_cols));
    buone=fieldnames(ts.meta_cols);
elseif nargin==2
    ncols=isfield(ts.meta_cols,varargin{1});
    selez=find(ncols);
    for j=1:length(selez)
        buone{j}=varargin{1}{selez(j)};
    end
    if ~exist('buone')
        error('tsmat meta_cols has no such field')
    end
else
    error('tsmat meta_cols has no such field')
end

stringhe=repmat(' | ',N,1);
ordine  =(1:N )';
% display rownumber
descript=num2str(ordine);
head    =['N',repmat(' ',1,size(descript,2)-1)];


for j=1:length(buone)

 %   disp(j)
    pippo=pp.(buone{j});
    try
        qq=char(pippo);
    catch
        for r=1:length(pippo)
            switch class(pippo{r})
                case 'char'
                    % va bene
                case 'double'
                    pippo{r}=num2str(pippo{r});
            end
        end
    qq=char(pippo');
    %         numeri=cell2mat(pippo');
    %         if size(numeri,1)<size(numeri,2)
    %             numeri=numeri';
    %         end
    %         qq=num2str(numeri);
    end
descript=cat(2,descript,stringhe,qq);
L=size(qq,2);
H=buone{j}; LH=size(H,2);
header = H(1,1:min(L,LH));
header =[ header,repmat(' ',1,L-LH)];
head=cat(2,head,' | ',header);

end

descript=[head;descript];