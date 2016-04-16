function varargout = fit_powerlaw(grid,sizes)
% *** function [alpha,Rsq] = fit_powerlaw(grid,sizes)
%
%     Fits a power law to the distribution of avalanche sizes.
%     The fit is performed with a simple least-squares regression
%     on the rank-frequency distribution of log-transformed data
%     (which becomes approximately linear). The rank-frequency
%     data, which also follows a power law, is chosen for the
%     fit because it is less noisy in the tail.
%
%     Input:
%       'grid' is the grid size on which the avalanches were
%          generated (e.g. 8). 'grid' must be a scalar.
%       'sizes' is a vector of avalanche sizes. The vector must
%          have a minimum length of 5.
%
%     Output:
%       if no output argument is specified, fit_powerlaw returns
%          a plot on log-log scale of avalanche size distribution
%          with superimposed fitted curve.
%       'alpha' returns the value of alpha, the scaling exponent
%          of the power law and slope of the fitted curve.
%       'Rsq' returns the value of R squared, the goodness-of-fit
%         measure for the power law fit.


%  Discrete power law equation (approximation of the continuous
%  case):
%
%       P(x) = k * (x/xmin).^alpha ,  for xmin <= x <= cutoff.
%
%  with the following parameters:
%
%       k       normalization constant (so that probabilities
%               sum up to 1). It is equal to (alpha-1)/xmin.
%       xmin    lower-bound x value (so that the probability
%               density does not go to infinity). It is fixed
%               to 1, which is the smallest possible avalanche
%               size.
%       alpha   scaling exponent that gives the slope of the
%               the function when plotted on log-log axes (a
%               power law function is a line in log-log space).
%       cutoff  upper-bound cutoff on x values for the power law
%               fit. This is imposed somewhat arbitrarily because
%               the long tail of the distribution is noisy (an
%               artifact due to limited grid size), therefore
%               the fit of the power law is best for values below
%               the cutoff.

if isscalar(grid)
  if xor(size(sizes,1)==1, size(sizes,2)==1)
     if length(sizes)>=5
         
cutoff = grid^2;    % can be changed arbitrarily to improve fit

% ------- PREPARE DATA ----------------------------------------- %
%  retrieve probabilities of binned avalanche sizes (bin size of 1):
Pr = histcounts(sizes,'BinWidth',1,'Normalization','probability')';
%  create vector of bin indices:
xPr = (1:length(Pr))';
%  get rid of empty bins:
nonzerofilter = find(Pr~=0);
Pr = Pr(nonzerofilter);
xPr = xPr(nonzerofilter);

% ------- LEAST-SQUARES ESTIMATION OF PARAMETERS --------------- %
%  Note that the power law will be fitted only for values of
%  avalanche size below the cutoff.

%  log-transform the probabilities corresponding to size values
%  below cutoff
xPr_cutoff = xPr(xPr<=cutoff);
yLog = log(Pr(xPr_cutoff));
N = length(yLog); % number of datapoints to be fitted

%  create rank-frequency distribution
rank = log(1:N)';
frequency = sort(yLog,'descend');

%  perform linear regression on rank-frequency data: X*B = Y
%  B is a vector containing two regression coefficients. B(1) is
%  the estimated intercept, B(2) is the estimated slope.
X = [ones(N,1), rank]; % matrix of predictors
Y = frequency;
B = X\Y;

%  the slope B(2), estimated from the rank-frequency fit, will also
%  be our estimator for the parameter alpha of the power law that
%  models the original avalanche size data.
alpha = B(2);
%  the normalizing constant k is easily derived from alpha:
k = -alpha-1;

% --- PLOT OF AVALANCHE SIZE DISTRIBUTION AND FITTED CURVE ----- %
yHat = k*xPr_cutoff.^alpha;  % power law equation

if nargout==0
figure;
dataPlot = loglog(Pr,'.');
set(dataPlot,'MarkerSize',12);
%  superimpose fitted power law curve
hold on
fittedLine = loglog(xPr_cutoff,yHat,'r');
title('Distribution of avalanche sizes');
xlabel('size');
ylabel('P(size)');
leg = legend(fittedLine,'y = kx^\alpha');
set(leg,'FontSize',14);
legend('boxoff')
htext = text(10^2.2,10^-1,['\alpha = ',num2str(round(alpha,2))]);
set(htext,'FontSize',14);
set(gca,'FontSize',14);
set(fittedLine,'LineWidth',1.5);
%  mark the cutoff
hold on
cutoffLine = loglog([cutoff,cutoff],[yHat(xPr==cutoff),min(Pr)],'--r');
set(cutoffLine,'LineWidth',1.5);
end

% -------- R SQUARED GOODNESS-OF-FIT OF THE MODEL -------------- %
if nargout>0
  varargout{1} = alpha;
  if nargout==2
    %  predicted y values (power law equation, log-transformed)
    yHat_log = log(k) + alpha*log(xPr_cutoff);
    Rsq = 1 - sum((yLog - yHat_log).^2)/sum((yLog - mean(yLog)).^2);
    varargout{2} = Rsq;
  end
end

     else
         error('Vector of sizes must have at least 5 elements')
     end
  else
    error('Input argument ''sizes'' must be a vector')
  end
else
    error('Input argument ''grid'' must be a scalar')
end

end