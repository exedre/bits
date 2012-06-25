function db = tslog(db,varargin)
    if nargin==1
        if db.log==0
            db.log=1;
        else
            db.log=0;
        end
    else
        db.log = varargin{1};
    end
