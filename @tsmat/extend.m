function self=extend(self,a,varargin)
%@tsmat\extend - extend a timeseries with another
%
% Example: TODO
%
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2012 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma   (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%

  join_date = nan;
  fill_date = nan;

  if nargin==3
    join_date = varargin{1};
  end

  if nargin==4
    fill_date = varargin{2};
  end

  % 
  sp=0;
  sp = sp+(tsidxgt(self.start_year,self.start_period,a.start_year,a.start_period)==1);
  sp = sp+(tsidxgt(self.start_year,self.start_period,a.last_year,a.last_period)==1)*2;
  sp = sp+(tsidxgt(self.last_year, self.last_period, a.start_year,a.start_period)==1)*4;
  sp = sp+(tsidxgt(self.last_year, self.last_period, a.last_year,a.last_period)==1)*8;

  if self.start_year == a.start_year & self.start_period == a.start_period & ...
     self.last_year == a.last_year & self.last_period == a.last_period  ...          
      sp = 5;
  end
  switch sp
   case 15,
    % second series is before first invert
    self = extend(a,self,join_date,fill_date);
    return 
    
   case 13,
    self = extend(a, self, [ a.start_year a.start_period ], fill_date);
    return 
    
   case 12,
    d0 = tsidx_distance(self.freq,[self.start_year,self.start_period],[a.start_year,a.start_period]);
    d  = tsidx_distance(self.freq,[self.start_year,self.start_period],[a.last_year,a.last_period])+1;
    [sx sq] = start2end(self.freq,self.start_year,self.start_period,d);
    xts0 = tsmat(self.start_year,self.start_period,self.freq,self.matdata(1:d0,1:end));
    xts1 = extend(xts0,a);
    xts2 = tsmat(sx,sq,self.freq,self.matdata(d+1:end,1:end));
    self = extend(xts1,xts2,[a.last_year a.last_period],fill_date);
    return 
    
   case 5,
    self = a;
    return
    
   case 4,
    %
   case 0,
    %
   otherwise,
    error(['@' mfilename('class') '\' mfilename '::Overlapping status not correct'])
    
  end
        
  if and(isnan(fill_date),not(isa(a,'tsmat')))
    error 'NaN extending series and fill date not entered'
  end
 
  % Append some nan data upto fill_date
  if not(and(isnan(fill_date), (isa(a,'tsmat'))))
    if isa(fill_date,'logical') & fill_date 
      fill_date = tsidx2date(a.freq,a.start_year,a.start_period)-1;
    end
    if fill_date < tsidx2date(self.freq,self.last_year,self.last_period)
      error "FillDateBeforeLastDate"
    end
    
    % How many nan should I add? Let's see
    %  why this?  date = addtodate(fill_date,1,'day') % This' the day after fill_date
    date = fill_date;
    [ year, period ] = date2tsidx(self.freq,date); % and his tsidx 
    
    % The distance from the ts start date to fill_date
    [   dy,     du ] = distance2tsidx(self.freq, tsidx_distance( self.freq, [self.last_year, self.last_period], [year, period]) ) ;
    
    
    % How many nan?
    %dn = (dy*self.freq+du+1)-length(self.matdata);
    dn = tsidx_distance( self.freq, [self.last_year, self.last_period], [year, period]);
    self.matdata(size(self.matdata,1)+1:size(self.matdata,1)+dn,:)=nan;
    
    % So we've the new last date
    self.last_year = year;
    self.last_period = period;
  end
  
  if not(isa(a,'tsmat'))
    return
  end
  
  %   if not self.is_compatible(TS):
  %       raise "SeriesNotCompatible"
 
  if isnan(join_date)
    join_date = tsidx2date(a.freq,a.start_year,a.start_period);
    year = a.start_year;
    period = a.start_period;
  else
    if isa(join_date,'double')
      if size(join_date,2) == 2
        year = join_date(1);
        period = join_date(2) ;
      else
        [ year, period ] = date2tsidx(self.freq,join_date);
      end
    end
  end
  
  [   dy,     du ] = distance2tsidx(self.freq, tsidx_distance( self.freq, [self.start_year, self.start_period], [year, period]));
  dn = tsidx_distance( self.freq, [self.start_year, self.start_period], [year, period]);
  join_year = year;
  join_period = period;
  [ year , period ] = next( self, self.last_year, self.last_period, false );
  if year+(period)/1000 < join_year+join_period/1000
    error "TimeseriesCannotBeLinked"
  end

  matdata = self.matdata(1:dn,:);
  
  if size(join_date,2) == 2
    year = join_date(1);
    period = join_date(2) ;
  else
    [ year, period ] = date2tsidx(self.freq,join_date);
  end
  [   dy,     du ] = distance2tsidx(self.freq, tsidx_distance( self.freq, [a.start_year, a.start_period], [year, period]));
  ndn = dy*a.freq+du+1;
  
  self.last_year = a.last_year ;
  self.last_period = a.last_period ;
  
  l=size(a);
  matdata(dn+1:dn+l-ndn+1,:) = a.matdata(ndn:end,:) ;
  self.matdata = matdata; 
  
