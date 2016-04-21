function [varargout] = fit_powerlaw(sizes)
% *** function fit_powerlaw
% 
%      Fits a power law to the distribution of avalanche sizes.
%      The fit is performed with a simple least-squares regression
%      on the rank-frequency distribution of log-transformed data
%      (which becomes approximately linear). The fit uses rank-ordered
%      data, rather than raw data, because its distribution is less
%      noisy in the tail, and therefore can give a more robust
%      estimate of the parameters.
% 
%      Input:
%        'sizes' is a vector of sizes of the avalanches.
% 
%      Output:
%       if no output argument is specified, fit_powerlaw returns
%          a plot on log-log scale of avalanche size distribution
%          with superimposed fitted curve.
%       'alpha' returns the value of alpha, the scaling exponent
%          of the power law and slope of the fitted curve.
%       'Rsq' returns the value of R squared, the goodness-of-fit
%         measure for the power law fit.
% 
%      Discrete power law equation (approximation of the continuous
%      case):
%
%         P(x) = k * (x/xmin).^alpha ,  for x >= xmin.
%
%      with the following parameters:
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
%
%                             * * *
%      For an in-depth discussion of this and other more
%      sophisticated statistical methods for fitting power laws,
%      see these two papers:
%         arXiv:cond-mat/0412004 [cond-mat.stat-mech]
%         arXiv:0706.1062 [physics.data-an]


%  check for correct input ('sizes' must be a vector)
if xor(size(sizes,1)==1, size(sizes,2)==1)

% ------- PREPARE DATA ----------------------------------------- %
%  get rid of sizes below xmin=1
sizes = sizes(sizes>=1);
% 1. Data for the distribution plot:
%  retrieve probabilities of binned avalanche sizes (bin size of 1):
Pr = histcounts(sizes,'BinWidth',1,'Normalization','probability')';
%  create vector of bin indices:
x = (1:length(Pr))';
%  get rid of empty bins:
Pr = Pr(Pr~=0);
x = x(Pr~=0);

% 2. Data for the fitting:
%  log-transform the probability values
logPr = log(Pr);
N = length(logPr);  % number of datapoints to be fitted

% ------- LEAST-SQUARES ESTIMATION OF PARAMETERS --------------- %
%  create rank-frequency distribution
rank = log(1:N)';
frequency = sort(logPr,'descend');

%  perform linear regression on rank-frequency data:
%                       X*B = Y
%  B is a vector containing the  two regression coefficients.
%  The first element of B is the estimated intercept, the second
%  element is the estimated slope.
X = [ones(N,1), rank];  % matrix of predictors
Y = frequency;
%  efficient command for computing the least-squares solution,
%  equivalent to B = inv(X'*X)*X'*Y
B = X\Y;                

%  the slope B(2), estimated from the rank-frequency fit, will
%  also be our estimator for the parameter alpha of the power law
%  that models the original avalanche size data.
alpha = B(2);
%  the normalizing constant k is easily derived from alpha:
k = -alpha-1;

% --- PLOT OF AVALANCHE SIZE DISTRIBUTION AND FITTED CURVE ----- %
yFit = k*x.^alpha;  % power law equation

if nargout==0
    figure;
    dataPlot = loglog(Pr,'.');
    set(dataPlot,'MarkerSize',12);
    %  superimpose fitted power law curve
    hold on
    fittedLine = loglog(x,yFit,'r');
    title('Distribution of avalanche sizes');
    xlabel('size');
    ylabel('P(size)');
    %  create fake plot for adding second legend entry without icon
    fake = loglog(1,0.1,'w','visible','off');
    leg = legend([fittedLine,fake],...
        'y = kx^\alpha',['\alpha = ',num2str(round(alpha,2))]);
    set(leg,'FontSize',14);
    legend('boxoff')
    set(gca,'FontSize',14);
    set(fittedLine,'LineWidth',1.5);
end

% -------- OPTIONAL ARGUMENTS: ALPHA AND R SQUARED -------------- %
if nargout>0
  varargout{1} = alpha;
  if nargout==2
    %  predicted y values (power law equation, log-transformed)
    yFit_log = log(k) + alpha*log(x);
    Rsq = 1 - sum((logPr - yFit_log).^2)/sum((logPr - mean(logPr)).^2);
    varargout{2} = Rsq;
  end
end

else
    error('Input argument ''sizes'' must be a vector')
end

end