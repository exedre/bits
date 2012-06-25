function ret = getfullcolmeta(self,varargin)
%@tsmat/getfullcolmeta: get metadata array on a tsmat column: 
%
% >> self = getfullcolmeta(self,col,k)
% where
%         self=input tsmat 
%        col=column number
%          k=name of the field to get (must be a string with no blanks'
%
% Alternate Use:
% >> self = getmeta(self,col,k,default)
% v=if field doesn't exists then return default value instead of NAN
  metacol = [];
  ncols = size(self,2);

  if nargin>1
      if varargin{1}
          if not(isempty(self.meta)) 
              fnames = fieldnames(self.meta);
              for i=1:size(fnames,1)
                  meta=getmeta(self,fnames{i});
                  if not(isempty(meta))
                      for j=1:ncols
                          %metacol = setfield(metacol,{1,j},fnames{i},{meta});
                          metacol(1,j).(fnames{i}) = {meta}; %#ok<AGROW>
                      end
                  end
              end
          end
      end
  end

  if isempty(self.meta_cols)
      base='T';
      N=size(self,2);
      for i=1:N
          colnames{i}=strcat(base,num2str(i)); %#ok<AGROW>
      end
      self=addmeta_cols(self,1:N,'label',colnames);
  end
  
  fnames = fieldnames(self.meta_cols);
    

  for i=1:size(fnames,1)
      for j=1:ncols
          meta=getcolmeta(self,j,fnames{i});
          if not(isempty(length(meta)))
              %metacol = setfield(metacol,{1,j},fnames{i},meta);
              metacol(1,j).(fnames{i}) = meta; %#ok<AGROW>
          end
      end
  end

  ret = metacol;