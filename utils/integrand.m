function q  =   integrand(s,dx,dy)
%
% integrand.m:  Helper function for calculating the arc length of a
%               paremetric curve described by splines for the x and 
%               y coordinates
%

    q   =   sqrt((polyval(dx,s)).^2 + (polyval(dy,s)).^2);