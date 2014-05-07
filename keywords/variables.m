function varargout = variables( varargin )

%VARIABLES Declares one or more CVX variables.
%   VARIABLES x1 x2 x3 ..., where x1, x2, x3, etc. are valid
%   variable names, declares multiple cvx variables. It is
%   exactly equivalent to issuing a separate VARIABLE command
%   for each x1, x2, x3, ...
%        
%   VARIABLES allows the declaration of vector, matrix, and
%   array variables. However, unlike VARIABLE, structure modifiers
%   such as "symmetric", "toeplitz", etc. are NOT permitted. Thus
%   VARIABLES cannot be used with variables with structure.
%
%   Examples:
%      variables x y z;
%      variables x(100) y z(100,10);
%
%   See also VARIABLE, DUAL, DUALS.

if nargin < 1,
    error( 'CVX:ArgError', 'Incorrect syntax for VARIABLES. Type HELP VARIABLES for details.' );
elseif nargout && nargout ~= nargin,
    error( 'CVX:ArgError', 'Incorrect number of output arguments.' );
elseif ~iscellstr( varargin ),
    error( 'CVX:ArgError', 'All arguments must be strings.' );
end

global cvx___
prob = evalin( 'caller', 'cvx_problem', '[]' );
if ~isa( prob, 'cvxprob' ),
    error( 'CVX:NoProblem', 'No CVX model exists in this scope.' );
end

try

    verify( prob );
    cvx___.args = { varargin, nargin, [] };
    args = evalin( 'caller', 'cvx_parse' );

    for k = 1 : nargin,
        v = newvar( prob, args(k) );
        if nargout,
            varargout{k} = v; %#ok
        else
            assignin( 'caller', args(k).name, v );
        end
    end
    
catch exc
    
    if strncmp( exc.identifier, 'CVX:', 4 ), throw( exc );
    else rethrow( exc ); end
    
end
    

% Copyright 2005-2014 CVX Research, Inc. 
% See the file LICENSE.txt for full copyright information.
% The command 'cvx_where' will show where this file is located.
