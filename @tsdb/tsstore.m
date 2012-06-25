function db = tsstore(db,varargin)
% TSDB\TSSTORE - stores timeseries into data base
%
% Store timeseries into database provided that
% timeseries has a 'label' metadata not null
%
% It stores on a 'release' key. Release is computed as follow:
%
% - The 'release' metadata for the column or
% - The 'release' metadata for the tsmat or
% - Today
%
% 'release' metadata can be an integer (number of seconds from 1/1/1970)
% or a string representing a data (in datestr format).
% The key is the 
%
% Saving it outputs a code for each ts saved:
%   '.' new ts and release added 
%   ':' ts exists - new release
%   '!' release for ts exists - merge
%   '|' release for ts exists - substitute
%
%
%
%   Copyright 2005-2012 Emmanuele Somma    (Servizio Studi Banca d'Italia)
%                       emmanuele.somma@bancaditalia.it - esomma@ieee.org
%

% First Phase: Know if tsmat has right metadatas

conn = db.conn;
lwidth=50; % Left Width

% say to user if logging is on 
if db.log
    disp('Active Logging affects performance (use db=log(db,0) to deactivate)')
    fd=fopen(db.logname,'w'); % erase logfile
    fclose(fd);
end

try
    if strcmpi(db.db, 'mysql') 
        exec(db.conn,'start transaction');
    end
    for t=1:nargin-1  
      
        if isa(varargin{t},'tsmat') %#ok<ALIGN>
            ts=varargin{t};
        
            start_y = ts.start_year;
            start_p = ts.start_period;
            freq    = ts.freq;
            nseries = size(ts.matdata,2);
            % nobs    = size(ts.matdata,1);
        
            % Release management
            release1 = getmeta(ts,'release',today); % if not
            if isa(release1,'char')
                release1 = datenum(release1);
            end
            
            if(isempty(release1)) 
                trace('microdb.tsstore','Warning: one series has no release meta')
                release1=-1;
            end
            ts=addmeta(ts,'release',release1);

            version    = 1  ;  %%
            resolution = 10 ;  %% 

            % Prints heading
            if db.log
                nbar=floor(nseries/lwidth);
                % npoint = min(lwidth/nseries);
                if nbar>1
                    for i=1:lwidth
                        fprintf(1,'*');
                    end
                end
                fprintf(1,'%d\n',nbar);
                for i=1:mod(nseries,lwidth)
                    fprintf(1,'*');
                end
                fprintf(1,'\n');
                n=0;
            end
            %%

            for i=1:nseries %#ok<ALIGN>

                releas = getcolmeta(ts,i,'release',release1);
                
                if isa(releas,'cell')
                    releas=releas{1};
                end
                
                if(isempty(releas)) 
                    trace('microdb.tsstore','Warning: one series has no release meta');
                    releas = today();
                end
                el = getcolmeta(ts,i,'label');

                if isempty(el)     %% if labels not present break the loop
                    break
                end

                if isempty(el{1})
                    if db.log
                        fprintf(1,'o');   %% outputs 'o' if no label found and element not saved
                    end
                    continue
                end

                %% 
               
                label = deblank(cast(el,'char'));

                %% If label in database
                ID = InfoID(db,label);
                if isinf(ID)               %
                    continue
                end

                if isnan(ID)               % label not exists = Insert New Series ('.')
                    if db.log
                        fprintf(1,'.');
                    end
                    ID  = InsertInfo(db,label,freq);
                    VID = InsertRelease(db,releas,ID,start_y,start_p,version,resolution);
                    InsertData(db,i,ID,VID,ts);
                    InsertMetadata(db,i,ID,VID,ts);
                else                       % label exists    = Update/Merge series 
                    % Update INFO Table
                    ID = UpdateInfo(db,ID,label,freq);
                    % Update RELEASE Table
                    tsm = ts(1:end,i);
                    VID = ReleaseID(db,releas,ID);
                    if isnan(VID)
                        if db.log
                            fprintf(1,':');        
                        end
                        flog(db,'Inserting new release')
                        VID = InsertRelease(db,releas,ID,start_y,start_p,version,resolution);
                    else
                        % There is already a release in the DB
                        sstart_y = start_y;
                        sstart_p = start_p;
                        if merge(db)==1
                            % User wants to merge so I...
                            fprintf(1,'|');        
                            % ... first get old ts metadata from DB
                            [VID,ostart_y,ostart_p] = GetRelease(db,releas,ID);
                            sstart_y = min(start_y,ostart_y);
                            sstart_p = min(start_p,ostart_p);
                            tsm = ts(1:end,i);
                            l1 = tsm.meta_cols.label;
                            % ... then load ts
                            tsIN = tsload(db, { l1{1} }, releas);
                            % ... and extend ts
                            tsm = extend(tsIN,tsm,nan,true);
                            clear tsIN
                        else
                            % I've to remove it
                            if db.log
                                fprintf(1,'!');
                            end
                        end
                        DeleteData(db,ID,VID);
                        VID = UpdateRelease(db,VID,ID,releas,sstart_y,sstart_p,version,resolution);
                        DeleteMetadata(db,ID,VID);
                    end
                    InsertData(db,1,ID,VID,tsm);
                    InsertMetadata(db,1,ID,VID,tsm);                  
                end                      
            %% EOL if over left width 
            if db.log
                n=n+1;
                if n==lwidth                
                    fprintf('\n');
                    n=0;
                end
            end
        end
        if db.log
            fprintf('\n');
        end
     
    else
        disp('Argument n. ',t,' is not a tsmat');
        rollback(conn);        
    end
    end
    commit(db.conn);
catch er
    disp(er.message);
    rollback(db.conn);
    rethrow(er);
end

%%% Supporting functions -

function ID=InsertInfo(db,label,freq)
    flog(db,sprintf('Insert Info: %s  ',label));
    %ID = LastID(db)+1;
    %xexport(1,1)={ID};
    xexport(1,1)={label};
    xexport(1,2)={freq};
    col_names = {  'Name', 'Freq' };
    fastinsert(db.conn, 'series', col_names, xexport);
    clear xexport;
    ID = LastID(db, 'series','id');

function VID = UpdateRelease(db,VID,ID, release, start_y,start_p,version, resolution)   
    flog(db,sprintf('Update Release: (%d,%d) ',VID,ID));
    xexport(1,1)={VID};
    xexport(1,2)={ID};
    xexport(1,3)={release};
    xexport(1,4)={start_y} ;
    xexport(1,5)={start_p} ;
    xexport{1,6}=version;
    xexport{1,7}=resolution;
    col_names = { 'VID', 'ID', 'Rel', 'Start_year', 'Start_period', 'Version', 'Resolution' };
    where = sprintf('where VID=%d and ID = %d',VID,ID)            ;
    xupdate(db.conn, 'version', col_names, xexport, where);
    clear xexport            ;
    %VID = ReleaseID(db,release,ID);

function [VID, start_y,start_p, version, resolution] = GetRelease(db,release,ID)
    flog(db,sprintf('Get Release: %d on %d ',release,ID));
    query = sprintf('select VID,Start_year, Start_period, version,resolution from version where Rel=%d and ID=%d',release, ID);
    curs = exec(db.conn,query);
    curs = fetch(curs,1);
    if rows(curs) > 0
        VID = curs.Data{1};
        start_y = curs.Data{2};
        start_p = curs.Data{3};
        version = curs.Data{4};
        resolution = curs.Data{5};
    else
        VID = nan;
        start_y = nan;
        start_p = nan;
        version = nan;
        resolution = nan;
    end

function VID = InsertRelease(db,release,ID, start_y, start_p, version, resolution)
    flog(db,sprintf('Inserting Release: %d on %d ',release,ID));
    %VID = LastVID(db)+resolution;
    %xexport(1,1)={VID};
    xexport(1,1)={ID};
    xexport(1,2)={release};
    xexport(1,3)={start_y} ;
    xexport(1,4)={start_p} ;
    xexport{1,5}=version;
    xexport{1,6}=resolution;
    %col_names = { 'VID', 'ID', 'Rel', 'Start_year', 'Start_period', 'Version', 'Resolution' };
    col_names = { 'ID', 'Rel', 'Start_year', 'Start_period', 'Version', 'Resolution' }; 
    fastinsert(db.conn, 'version', col_names, xexport);
    clear xexport            ;
    %VID = ReleaseID(db,release,ID);
    VID = LastID(db, 'version', 'vid');
    
    
function VID = ReleaseID(db, release, ID)
    flog(db,sprintf('ReleaseID: %d on %d ',release,ID));
    query = sprintf('select VID from version where Rel=%d and ID=%d',release, ID);
    setdbprefs('DataReturnFormat','cellarray');
    curs = exec(db.conn,query);
    curs = fetch(curs,1);
    if rows(curs) > 0
        VID = curs.Data{1};
    else
        VID = nan;
    end

function ID = InfoID(db, label)
    flog(db,sprintf('InfoID: %s ',label));
    ID = inf;
    if not(isempty(label))
        query = strcat('select ID from series where Name=''',label, '''');
        curs = exec(db.conn,query);
        setdbprefs('DataReturnFormat','cellarray');
        curs = fetch(curs,1);
        if rows(curs) > 0
            ID = curs.Data{1};
        else
            ID = nan;
        end    
    end

function xupdate(conn, tab, col_names, xexport, where)
    try 
        update(conn, tab, col_names, xexport, where);
    catch lasterror
%         if strcmp(lasterror,'Error:Commit/Rollback Problems')==0
%         else
             rethrow(lasterror)
%         end
    end

function ID = UpdateInfo(db,ID,label,freq)
    % Update INFO Table
    flog(db,sprintf('Updating INFO: %d ',ID));
    xexport(1,1)={label}   ;
    xexport(1,2)={freq}    ;        
    col_names = { 'Name' 'Freq' };
    where = sprintf('where ID = %d',ID)            ;
    xupdate(db.conn, 'series', col_names, xexport, where);
    %ID = InfoID(db,label);

function InsertMetadata(db,i,ID,VID,ts)
    flog(db,sprintf('Inserting Metadata (ID,VID) = (%d,%d) ',ID,VID));
    allmeta = getfullcolmeta(ts,true);
    meta = allmeta(i);
    mnames = fieldnames(meta);
    nmeta = size(mnames,1)    ;
    for j=1:nmeta
       value = meta.(mnames{j});    
       if isempty(value) 
           continue
       end
       MID = MetaID(db,mnames{j});
       TID = FindTID(value);
       if isinf(MID)
           continue
       end
       if isnan(MID)
           MID = InsertMetaName(db, mnames{j}, TID);
       end
       XID = InsertMeta(db,ID,VID,MID);
       PutMetaValue(db,XID,TID,value);
    end

function XID = PutMetaValue(db,XID,TID,value)
    flog(db,sprintf('Inserting PutValue: %d',XID));
    EXID = MetaValueXID(db,XID,TID);
    if isnan(EXID)
        XID = InsertMetaValue(db,XID,TID,value);
    else
        XID = UpdateMetaValue(db,XID,TID,value);
    end

function XID = UpdateMetaValue(db,XID,TID,value)
    flog(db,sprintf('Updating MetaValue: %d/%d ',XID,TID));
    v = TIDCast(TID,value);
    xexport(1,1)={XID}   ;
    xexport(1,2)={v}    ;        
    col_names = { 'XID'  'VALUE' };
    where = sprintf('where XID = %d',XID)            ;
    if TID==0
        meta = 'metastr';
    elseif TID==1
        meta = 'metanum';
    else
        error 'TID not supported'
    end
    xupdate(db.conn, meta, col_names, xexport, where);
    XID = MetaValueXID(db,XID,TID);


function XID = InsertMetaValue(db,XID,TID,value)
    flog(db,sprintf('Inserting MetaValue: %d',XID));   
    v = TIDCast(TID,value);
    xexport(1,1)={XID};
    xexport(1,2)={v};
    col_names = { 'XID'  'VALUE' };
    if TID==0
        meta = 'metastr';
    elseif TID==1
        meta = 'metanum';
    else
        error 'TID not supported'
    end
    fastinsert(db.conn, meta, col_names, xexport);
    clear xexport            ;

function XID = InsertMeta(db,ID,VID,MID)
    flog(db,sprintf('Inserting Meta: %d,%d,%d',ID,VID,MID));
    xexport(1,1)={ID};
    xexport(1,2)={VID};
    xexport(1,3)={MID};
    col_names = { 'ID'  'VID' 'MID' };
    fastinsert(db.conn, 'meta', col_names, xexport);
    clear xexport            ;
    XID = LastID(db, 'meta', 'xid');
    
function TID = FindTID(elem)
    TID = 1; % defaults to numeric
    nels = size(elem,2);
    for j=1:nels
        if isempty(elem)
            continue
        end
        if isa(elem{j},'char')            
            TID = 0;
            break
        end
    end
    
function out = TIDCast(TID,in)
        if TID==0
            out = cast(in,'char');
        elseif TID==1
            if isa(in,'cell')
                try
                    out = cast(in{1},'double');
                catch %#ok<CTCH>
                    out = NaN;
                end
            elseif isa(in,'double')
                out = cast(in,'double');
            end
        else
            error 'TID not supported'
        end
        
function [MID,TID] = MetaID(db, label)
    flog(db,sprintf('MetaID: %s ',label));
    MID = inf;
    TID = inf;
    if not(isempty(label))
        query = strcat('select MID,TID from metaname where Name=''',label, '''');
        curs = exec(db.conn,query);
        setdbprefs('DataReturnFormat','cellarray');
        curs = fetch(curs,1);
        if rows(curs) > 0
            MID = curs.Data{1};
            TID = curs.Data{2};
        else
            MID = nan;
            TID = nan;
        end
    end

%function XID = MetaXID(db, ID,VID,MID)
%    flog(db,sprintf('MetaXID: %d,%d,%d',ID,VID,MID));
%    XID = inf;
%    setdbprefs('DataReturnFormat','cellarray');
%    query = sprintf('select XID from meta where ID=%d and VID=%d and MID=%d ',ID,VID,MID);
%    curs = exec(db.conn,query);
%    curs = fetch(curs,1);
%    if rows(curs) > 0
%       XID = curs.Data{1};
%    else
%        XID = nan;
%    end    
    
function XID = MetaValueXID(db, XID,TID)
    flog(db,sprintf('MetaValueXID: %d/%d',XID,TID));
    if TID==0
        meta = 'metastr';
    elseif TID==1
        meta = 'metanum';
    else
        error 'TID not supported'
    end
    setdbprefs('DataReturnFormat','cellarray');
    query = sprintf('select XID from %s where XID=%d',meta,XID);
    curs = exec(db.conn,query);
    curs = fetch(curs,1);
    if rows(curs) > 0
        XID = curs.Data{1};
    else
        XID = nan;
    end    

function [ MID, TID ] = InsertMetaName(db,name,TID)
    flog(db,sprintf('Inserting Meta Name: %s TID=%d ',name,TID));     
    %xexport(1,1)={MID};
    xexport(1,1)={name};
    xexport(1,2)={TID};
    col_names = { 'Name'  'TID' };
    fastinsert(db.conn, 'metaname', col_names, xexport);
    clear xexport            ;    
    MID = LastID(db, 'metaname', 'mid');   
    
function InsertData(db,i,ID,VID,ts)
    flog(db,sprintf('Inserting Data (ID,VID) = (%d,%d) ',ID,VID));
    nobs    = size(ts.matdata,1);
    xexport=cell(nobs, 4);
    for j=1:nobs        
        xexport(j,1) = {ID};
        xexport(j,2) = {VID};
        xexport(j,3) = {j};
        xexport{j,4} = ts.matdata(j,i);
    end
    col_names = { 'ID', 'VID', 'SEQ', 'VALUE' };
    fastinsert(db.conn, 'data', col_names, xexport);
    clear xexport;
       
        
function DeleteData(db, ID,VID)
    query = sprintf('delete from data where VID=%d and ID=%d',VID,ID);
    exec(db.conn,query);

function DeleteMetadata(db, ID,VID)
    query = sprintf('delete from metanum where VID=%d and ID=%d',VID,ID);
    exec(db.conn,query);
    query = sprintf('delete from metastr where VID=%d and ID=%d',VID,ID);
    exec(db.conn,query);
    query = sprintf('delete from meta where VID=%d and ID=%d',VID,ID);
    exec(db.conn,query);

function flog(db,var)
    if db.log
        fd = fopen(db.logname,'a');
        fprintf(fd,strcat('tsstore::',var,'\n'));
        fclose(fd);        
    end

function ret = xquery(conn,query)
    setdbprefs('DataReturnFormat','numeric');
    curs = exec(conn,query);
    curs = fetch(curs);
    if rows(curs) > 0
        ret = curs.Data{:};
    else
        ret = nan;
    end
function ret = zquery(conn,query)
        ret = xquery(conn,query);
        if isnan(ret)
            ret = 0;
        end
        
function ret = LastID(db, table_name, id_field)
    if(strcmpi(db.db, 'mysql')) 
        ret = zquery(db.conn, 'select last_insert_id()');
    else
        ret = zquery(db.conn, ['SELECT CURRVAL(pg_get_serial_sequence(''' table_name ''',''' id_field '''))']);
    end    
        
%function ret = LastVID(db)
%   if(strcmpi(db.db, 'mysql')) 
%        ret = LastID(db, ' ');
%   else
%        ret = zquery(db.conn, 'select nextval(''version_seq'')');        
%   end
    
%function ret = LastXID(db)
%   if(strcmpi(db.db, 'mysql')) 
%        ret = LastID(db);
%   else
%        ret = zquery(db.conn, 'select nextval(''meta_seq'')');
%   end
%    
%function ret = LastMID(db)
%   if(strcmpi(db.db, 'mysql')) 
%        ret = LastID(db);
%   else
%        ret = zquery(db.conn, 'select nextval(''metaname_seq'')');
%   end
    
        
