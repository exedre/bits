function [shade_handle] = shade(dateshade,varargin)
%SHADE- add shading to a plot with a tsmat
%
% >>   [shade_handle] = shade( dateshade)
%
% where 
%       dateshade 4x1 array with [sy,sp,ey,ep]
%       [shade_handle] a 1x1 handle to the shading patch
%
%   BITS -  Banca d'Italia Time Series 
%   Copyright 2005-2008 Banca d'Italia - Area Ricerca Economica e Relazioni Internazionali
%
%   Author: Emmanuele Somma (emmanuele.somma@bancaditalia.it)
%           Area Ricerca Economica e Relazioni Internazionali 
%           Banca d'Italia
%
fmt=[];
if nargin==2
    fmt=varargin{1}
end
ylim=get(gca,'ylim');
xlim=get(gca,'xlim');

%pp=rmfield(get(gca),{'Type','TightInset','CurrentPoint','BeingDeleted','Children'});


x =datenum(dateshade,fmt);  
vert = [x(1) ylim(1); x(2) ylim(1); x(2) ylim(2);x(1) ylim(2)];
%set(pp,'ClimMode','manual')
shade_handle=patch(vert(:,1),vert(:,2),'g');

set(shade_handle,'FaceAlpha',0.15,'Linestyle','none');
set(shade_handle,'EdgeAlpha',0.15);


%set(gca,pp)
% That's all folks