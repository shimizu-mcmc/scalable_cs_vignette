function [ineff_factor,ess] = computeInefficiencyFactor(mcmc_draws, max_lag)
    % COMPUTEINEFFICIENCYFACTOR Computes the inefficiency factor of MCMC draws
    %
    % Inputs:
    %   - mcmc_draws: A vector of MCMC samples
    %   - max_lag: Maximum lag to consider for the autocorrelation sum
    %
    % Output:
    %   - ineff_factor: Estimated inefficiency factor
    
    if nargin < 2
        max_lag = floor(length(mcmc_draws) / 2); % Default maximum lag
    end
    
    % Compute the autocorrelations
    acf_vals = autocorr(mcmc_draws, NumLags=max_lag);
    
    % Sum of autocorrelations (with the initial term being 1)
    ineff_factor = 1 + 2 * sum(acf_vals(2:end));
    
    %Effective sample size
    ess=length(mcmc_draws)/ineff_factor;

    % Ensure inefficiency factor is at least 1
    %ineff_factor = max(1, ineff_factor);
end