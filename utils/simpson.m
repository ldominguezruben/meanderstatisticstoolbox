function integral   =   simpson(intFun,loLim,upLim,varargin);
% Numerical integration using Simpson's 3/8 rule (see Numerical Recipes)
%
%% simpson.m:
%   Performs numerical integration of a specified function using Simpson's
%   rule with three points.  This approach is exact for polynomials up to
%   and including degree three (cubic).  See Numerical Recipes in FORTRAN
%   by Press et al. (1994, p. 125-126) for details.
%
%% SYNTAX:
%   integral   =   simpson(intFun,loLim,upLim,...);
%
%% INPUTS:
%   intFun  =   Function handle for the function to be integrated; see
%               MATLAB documentation for quad
%   loLim   =   Lower limit of the integral
%   upLim   =   Upper limit of the integral
%   ...     =   Additional arguments passed to intFun for evaluation
%
%% OUTPUT:
%   integral=   Numerical value of the integral over the specified interval
%
%% NOTES:
%   See Press et al. (1994) for background and the MATLAB help for quad for
%   more information on function handles
%
%% FUNCTION SUMMARY:
%   integral   =   simpson(intFun,loLim,upLim,...);

%% CREDITS:
%   Carl J. Legleiter
%   11-3-2005

%% Read in the function handle (see code for quad.m)
f   =   fcnchk(intFun);

%% Get the additional arguments to be passed to 

%% Now set up the three-point Simpson's rule - eqn. 4.1.4
h       =   (upLim - loLim)/2;
% This is the step size between "x values" where the function is evaluated
xEval   =   linspace(loLim,upLim,3);
integral    =   h*(1/3*f(xEval(1),varargin{:}) + ...
                   4/3*f(xEval(2),varargin{:}) + ...
                   1/3*f(xEval(3),varargin{:}));