function res = subsref(self,s,varargin)
%@tsmat/subsref implements the indexing for the TSMAT objects.
%
%   SUBSREF allows for the indexing into TSMAT objects using integer,
%   date string, or date and time string indexing.
%   Serial Dates and Times
%   can be used as indices.
%   Additionally, SUBSREF allows the access of
%   individual components in the object using the structure syntax.
%
%   The syntax for integer indexing is the same as for any other MATLAB matrix.
%
%   For example:
%   myts=tseries(1980,1,12,randn(10,2));
%
% Creates the TSMAT monthly object with the 2 columns and 10 obs each
% starting in Jan.1980
% Possible subsref are
%  1) Integer
%   myts(2:3)=
%   tsStart: 1980
%   Frequency: 12 (monthly)
%   1980-M-2  2
%   1980-M-3  3
%   creates a TSERIES object of 2 elements, from 1980-M-1 to 1980-M-2
%   To specify a range of integers use the double colon operator.
% 2) Date(s) in 1x2 (1x4) vector format
%   myts(1980,1)
%   tsStart: 1980
%   Frequency: 12 (monthly)
%   1980-M-1  1
%   creates a TSERIES object of 2 elements, from 1980-M-1 to 1980-M-2
%   To specify a range of dates use 4 arguments .
%   (start year,start period,endyear,endperiod)
%  myts(1980,1,1980,4)=
%  tsStart: 1980
% Frequency: 12 (monthly)
% 1980-M-1  1
% 1980-M-2  2
% 1980-M-3  3
% 1980-M-4  4
%
%   To request all the dates, times, and data:
%
%      myts('::')
%
%   To access the individual components of the time series object,
%   please use the structure syntax.
%
%   For example, if you would like to get the object's description field:
%
%      myts.desc
%
%      ans =
%
%   To convert the data in a TSERIES object into a vector, please use the
%   function ts2mat function.
%
%   See also @TSMAT/ts2mat, @TSMAT/SUBSASGN.
%

%   BITS -  Banca d'Italia Time Series
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Giovanni Veronese (giovanni.veronese@bancaditalia.it)
%           Emmanuele Somma   (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali
%           Banca d'Italia
%

%%-Main----------------------------------------------------------------------

if nargin==3
    Extend = varargin{1};
else
    Extend = false;
end

dati        = self.matdata;
[T,N]       = size(dati);
freq        = self.freq;
start       = self.start_year;
period      = self.start_period;
last_year   = self.last_year;
last_period = self.last_period;
SL          = length(s);

if length(s) > 2
    error(['@' mfilename('class') '\' mfilename '::too many levels of subsref ' ])

elseif length(s) == 2
    res = subsref(subsref(self,s(1)),s(2));

else
    switch s.type
        case '.'
            %% Subreferencing with dot (subelement access)
            %%
            switch s.subs
                case 'meta'
                    res = self.meta;
                case 'meta_cols'
                    res = self.meta_cols;
                case 'matdata'
                    res = dati;
                case 'freq'
                    res = freq;
                case 'start_year'
                    res = start;
                case 'start_period'
                    res = period;
                case 'start'
                    res = [start,period];
                case 'end'
                    res = [self.last_year,self.last_period];
                case 'range'
                    res = [start,period;self.last_year,self.last_period];
                case 'last_year'
                    res = [self.last_year];
                case 'last_period'
                    res = [self.last_period];
                case 'dates'
                    %Returns matlab dates where self is defined
                    dati   = self.matdata;
                    year   = self.start_year;
                    freq   = self.freq;
                    period = self.start_period;
                    for j=1:T
                        dates(j,1)         = tsidx2date(freq, year, period);
                        [ year, period ]   = next(self, year, period);
                    end
                    res   = dates;
                otherwise % switch L
                    error(['@' mfilename('class') '\' mfilename '::unknown tsmat subelement' ])
            end % case '.'

        case '()'
            %% Subreferencing with round brackets (slicing)
            %%
            L = length(s.subs);
            switch L
                case 2      % mysubts = myts([1:5],[2:6])

                    ssubs2 = s.subs{2};
                    if strmatch(':',num2str(s.subs{2}))
                        ssubs2    = [ 1 : size(self.matdata,2) ];
                    end

                    % Checks dati boundary
                    if strmatch(':',num2str(s.subs{1}))
                        % Takes care of behavior of s.subs{1} when
                        % subsreferencing the full sample
                        dist    = 0;
                        ssubs1    = [ 1 : size(self.matdata,1) ];
                    else
                        dist = s.subs{1}(1)-1;
                        ssubs1 = [ 1 : size(self.matdata,1) ];
                    end

                    if or(max(ssubs1) > T , max(ssubs2) > N)
                        error(['@' mfilename('class') '\' mfilename '::TS Index exceeds matrix dimensions'])
                    end
                    if and(min(ssubs1) < 1 , min(ssubs2) < 1)
                        error(['@' mfilename('class') '\' mfilename '::negative TS Index'])
                    end


                    if max(diff(ssubs1))>1
                        % We do not allow
                        % subsreferencing to non contiguos dates
                        error(['@' mfilename('class') '\' mfilename '::dates are not contiguous'])
                        % Checks dati boundary
                    elseif or(max(ssubs1) > T , max(ssubs2) > N)
                        error(['@' mfilename('class') '\' mfilename '::TS Index exceeds matrix dimensions'])
                    elseif and(min(ssubs1) < 1 , min(ssubs2) < 1)
                        error(['@' mfilename('class') '\' mfilename '::negative TS Index'])
                    end

                    % Find start tsidx of extracted ts
                    [yy,uu] = start2end(freq,start,period,dist);


                    % Get dati matrix
                    dati = dati(s.subs{1},ssubs2);
                    md = getfullcolmeta(self);
                    metadata = md(ssubs2);

                    % resulting tsmat
                    res = tsmat(yy,uu,freq,dati) ;
                    res =  setfullcolmeta(res,metadata);
                    res.meta = self.meta;

                    % Deal with metadata that may exist for some
                    % columns: resulting tsmat will inherit the
                    % correct dati in meta_cols
                    if ~isempty(self.meta_cols)
                        names   = fieldnames(self.meta_cols);
                        for j=1:length(names);
                            res.meta_cols           = setfield(res.meta_cols,names{j},{});
                            res.meta_cols.(names{j})= {self.meta_cols.(names{j}){s.subs{2}}};
                        end
                    end

                case 5      % mysubts = myts(1980,2,1981,4, 100)

                    if or( s.subs{2}>(freq+1), s.subs{4}>(freq+1) )
                        error(['@' mfilename('class') '\' mfilename '::Invalid periods (>freq)'])
                    end

                    NN=length(s.subs{5});
                    if isa(s.subs{5},'char')
                        if strcmp(':',s.subs{5})
                            NN = N;
                        else
                            error(['@' mfilename('class') '\' mfilename '::Invalid Column Subsreferencing'])
                        end
                    end

                    pre         = 0;
                    post        = 0;
                    data        = [];
                    pre_data    = [];
                    post_data   = [];
                    int_data    = [];

                    dist1       = tsidx_distance(freq,[start,period],[s.subs{1} s.subs{2}]);
                    if dist1 < 0
                        pre     = -dist1;
                        dist1   = 0;
                    end

                    dist2       = tsidx_distance(freq,[start period],[s.subs{3} s.subs{4}]);
                    if dist2 >= T
                        post    = dist2 - T+1 ;
                        dist2   = T-1;
                    end

                    if pre > 0
                        % changed from original BITS
                        if str2num(version('-release'))<14
                            pre_data    = NaN*ones(pre,NN) ;
                        else
                            pre_data    = NaN(pre,NN) ;
                        end
                    end

                    if post > 0
                        % changed from original BITS
                        if str2num(version('-release'))<14
                            post_data   = NaN*ones(post,NN) ;
                        else
                            post_data   = NaN(post,NN) ;
                        end
                    end

                    int_data    = [int_data; dati(dist1+1:dist2+1,s.subs{5})];
                    newdata     = [pre_data; int_data; post_data];
                    res         = tsmat(s.subs{1},s.subs{2},freq,newdata);

                    % Here deals with cases when subsref fully outside range of self
                    dist_start  = tsidx_distance(freq,[start,period],[s.subs{3} s.subs{4}])<0;
                    dist_end    = tsidx_distance(freq,[last_year,last_period],[s.subs{1} s.subs{2}])>0;

                    if any( [ dist_start, dist_end ] )
                        % either ts starts after last date required
                        % or ts ends before first date required
                        addT    = tsidx_distance(freq,[s.subs{1} s.subs{2}],[s.subs{3} s.subs{4}])+1;

                        % changed from original BITS
                        if str2num(version('-release'))<14
                            data    = NaN*ones(addT,NN);
                        else
                            data    = NaN(addT,NN);
                        end

                        res = tsmat(s.subs{1},s.subs{2},self.freq,data);
                        disp('no data in tsrange')

                    end

                    %% Deal with metadata that may exist for some
                    %% columns: resulting tsmat will inherit the
                    %% correct data in meta_cols
                    if ~isempty(self.meta_cols)
                        names   = fieldnames(self.meta_cols);
                        for j=1:length(names);
                            res.meta_cols           = setfield(res.meta_cols,names{j},{});
                            res.meta_cols.(names{j})= {self.meta_cols.(names{j}){s.subs{5}}};
                        end
                    end

                otherwise % switch L of ()
                    error(['@' mfilename('class') '\' mfilename '::wrong tsmat subsreferencing'])
            end

        case '{}'

            % Subsrefencing with curly brackets (leading/lagging)
            % Lead (positive index)/Lag (negative index)tseries by integer value
            tipo=class(s.subs{1});
           % keyboard
            switch tipo

                case 'cell'
                    % subsref with cell of strings: TBD
                    % pointer to specific columns matching the inputs

                    
                case 'double'
                    % subsref with integer: lead(positive)/lags(negative)
                    L = length(s.subs);



                    switch L

                        case 1
                            missi   = repmat(NaN,abs(s.subs{1}),N);

                            if  s.subs{1}>0
                                % Lead of the time series: start is moved back
                                [yy,pp] = start2end(self.freq,self.start_year,self.start_period,-s.subs{1});
                                dati    = [self.matdata;missi];
                                % NaN padded at the end
                            else
                                % Lag of the time series: start is the same, NaN
                                % padded at the start
                                yy      = self.start_year;pp=self.start_period;
                                dati    = [missi;self.matdata];
                            end
                            res = tsmat(yy,pp,self.freq,dati); ;

                        otherwise % switch L
                            error(['@' mfilename('class') '\' mfilename ['::when using {} ' ...
                                'format: specify lead or lag in as an integer']])

                    end
            end
        otherwise % switch s.type
            error(['@' mfilename('class') '\' mfilename '::specify either in () format'])
    end
end
