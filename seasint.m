function tsy=seasint(tsx,varargin)
%SEASINT seasonal integration of timeseries
%	y=seasint(tsx,T)
%
%   seasonally integrate tsx
%
%  tsx = timeseries input data
  x=tsx.matdata;
  T = tsx.freq;
  if nargin==2
	T=varargin{1};
  end

  [nx,nc]=size(x);
  
  np=floor(nx/T);
  rx=rem(nx,T);
  y=zeros(size(x,1),N);
  for j=1:T
    index=[j:T:nx];
    y(index,:)=cumsum(x(index,:));
  end

  tsy=tsmat(tsx.start_year,tsx.start_period,tsx.freq,y);