%%% Generate a function handle for an insurance plan
% Parameters
% p - yearly premium
% d - yearly deductable
% c - coinsurance
% m - out-of-pocket maximum
% Return
% f - The input to the generated function is the yearly medical 
% expense and the output is the out-of-pocket expenses
%
% This function makes many assumptions and simplifications
%   - If deductable is greater than 0 it is treated as the max out-of-pocket
%   - All copays are ignored
%   - Only allows for one coinsurance rate for all procedures
%   - ...

function f = plan(p, d, c, m)
  % If there is a deductable make it the max
  if d > 0
    m = d;
  end
  ce = @(x) c .* x;
  f = @(x) p + ...
		      (ce(x) <= m) .* ce(x) + ...
		      (ce(x) > m) .* m ;
endfunction