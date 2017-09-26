function E = nms( E, r, s )
% NMS Perform nonmaximum suppression on a contour probability map.
%   This function has been taken from Piotr Dollar's older version of the
%   structured edge detection code and adapted so that it only depends on
%   MATLAB code, for portability. It can be used for any type of
%   contour-like response map (e.g., edges, medial axes, etc.).
%
%   E = NMS(E,r) Suppress locations where edge is stronger in the
%   orthogonal direction by first computing a very approximate orienation
%   map. 
%   r: controls the size of the neighborhood in which we perform nonmaximum 
%       suppression. 
%   s: controls the size of the rectangular image border in which we
%       suppress responses to avoid noisy estimates. 
%
% Originally written by Piotr Dollar.
% Stavros Tsogkas <tsogkas@cs.toronto.edu>
% Last update: September 2017


if nargin < 2, r = 3; end
if nargin < 3, s = 1; end

O = contourOrient(E,r);
E1=padarray(E,[r+1 r+1],'replicate');
Dx=cos(O); Dy=sin(O);
[ht,wd]=size(E1);
[cs,rs]=meshgrid(r+2:wd-r-1,r+2:ht-r-1);
for i=-r:r,
    if(i==0), continue; end
    cs0=i*Dx+cs; dcs=cs0-floor(cs0); cs0=floor(cs0);
    rs0=i*Dy+rs; drs=rs0-floor(rs0); rs0=floor(rs0);
    E2 = (1-dcs).*(1-drs) .* E1(rs0+0+(cs0-1)*ht);
    E2 = E2 + dcs.*(1-drs) .* E1(rs0+0+(cs0-0)*ht);
    E2 = E2 + (1-dcs).*drs .* E1(rs0+1+(cs0-1)*ht);
    E2 = E2 + dcs.*drs .* E1(rs0+1+(cs0-0)*ht);
    E(E*1.01<E2) = 0;
end
% suppress noisy estimates near boundaries
for r=1:s, E([r end-r+1],:,:)=E([r end-r+1],:,:)*(r-1)/s; end
for r=1:s, E(:,[r end-r+1],:)=E(:,[r end-r+1],:)*(r-1)/s; end


% -------------------------------------------------------------------------
function O = contourOrient( E, r )
% -------------------------------------------------------------------------
% Compute very approximate orientation map from contour map. We have replaced
% convTri with the slightly slower equivalent code to reduce dependencies.
% E2=convTri(E,r);
% ----------------------------------------------
if(r<=1) 
    p=12/r/(r+2)-2; f=[1 p 1]/(2+p); 
    r=1;
else
    f=[1:r, r+1, r:-1:1]/(r+1)^2; 
end
E2 = padarray(E,[r r],'symmetric','both');
E2 = convn(convn(E2,f,'valid'),f','valid');
% ----------------------------------------------
f=[-1 2 -1];
Dx=conv2(E2,f,'same'); Dy=conv2(E2,f','same');
F=conv2(E2,[1 0 -1; 0 0 0; -1 0 1],'same')>0;
Dy(F)=-Dy(F); O=mod(atan2(Dy,Dx),pi);