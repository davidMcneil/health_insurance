%%% Generates the pdf and cdf of a truncated normal distribution
% Parameters
% mu - The mean of the untruncated gaussian
% sigma - The standard deviation of the untruncated gaussian
% a - The lower bound
% b - The upper bound
% Return
% pdf - The input to the generated function is the yearly medical 
% expense and the output is the out-of-pocket expenses

function [pdf, cdf, mean, stddev] = tnd(mu, sigma, a, b)
  % Useful functions for TND
  zeta = @(x) (x - mu) ./ sigma;
  phi = @(x) (1 / sqrt(2 * pi)) .* exp(-0.5 .* power(zeta(x), 2));
  norm_pdf = @(x) phi(x) ./ sigma;
  norm_cdf = @(x) 0.5 * (1 + erf(zeta(x) / sqrt(2)));
  Z = norm_cdf(b) - norm_cdf(a);
  % Probability and cumalative density functions
  pdf = @(x) norm_pdf(x) ./ Z;
  cdf = @(x) (norm_cdf(x) - norm_cdf(a)) ./ Z;
  % Statistical measures
  mean = mu + ((phi(a) - phi(b)) / Z) * sigma;
  stddev = sqrt(power(sigma, 2) * (1 + ...
             ((zeta(a) * phi(a) - zeta(b) * phi(b)) / Z) - ...
             power((phi(a) - phi(b)) / Z, 2)));
endfunction
