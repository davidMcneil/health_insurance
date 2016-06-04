%%% Abbreviations
% hdp - high deductable plan
% reg - regular plan
% p - yearly premium
% d - yearly deductable
% c - coinsurance
% m - out-of-pocket maximum

% EDITABLE: Domain of possible medical expenses
min = 0;
step = 1;
max = 50000;
X = min:step:max;

%%% EDITABLE: Insurance plan statistics
% Premiums
hdp_p = 753 * 12;
reg_p = 957 * 12;
% Deductables
hdp_d = 6000;
reg_d = 0;
% Coinsurances
hdp_c = 1;
reg_c = 0.2;
% Max out-of-pocket
hdp_m = 7000;
reg_m = 8000;

% Insurance plans
hdp = plan(hdp_p, hdp_d, hdp_c, hdp_m);
reg = plan(reg_p, reg_d, reg_c, reg_m);

%%% Model medical expenses as truncated normal distribution (TND)
% EDITABLE: Parameters for TND
mu = 500;
sigma = 4000;
[pdf, cdf, mean, stddev] = tnd(mu, sigma, min, max);

% Generate plot for plans
hold on;
plot(X, hdp(X), '-r', 'linewidth', 3);
plot(X, reg(X), '-b', 'linewidth', 3);
grid on;
title('Health Insurance Plans');
xlabel('Medical Expenses');
ylabel('Out-of-Pocket');
legend('HDP', 'REG', 'Location', 'southeast');
set(gca, 'XTick', 0:max / 10:max);
set(gca, 'YTick', 0:1000:100000);
% saveas(gcf,'images/plan.pdf');

% Place markets on plot
zeros = X(find(hdp(X) - reg(X) == 0));
for i = 1:length(zeros)
  text(zeros(i), reg(zeros(i)), ...
       ['(' num2str(zeros(i)) ', ' num2str(reg(zeros(i))) ')'], ... 
       'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
end

% Generate plot for medical expenses distribution
figure;
plot(X, pdf(X), 'linewidth', 1);
grid on;
title(['PDF \mu = ' num2str(mu) ' ,' ...
            '\sigma = ' num2str(sigma) ' ,' ...
            '\mu_t = ' num2str(mean) ' ,' ...
            '\sigma_t = ' num2str(stddev)]);
xlabel('Medical Expenses');
ylabel('Probability');
% saveas(gcf,'images/pdf1.pdf');

figure;
plot(X, cdf(X), 'linewidth', 1);
grid on;
title('CDF');
xlabel('Medical Expenses');
ylabel('Cumulative Probabilty');
p = find(cdf(X) >= 0.1);
text(p(1), cdf(p(1)), ...
     ['(' num2str(p(1)) ', ' num2str(cdf(p(1))) ')'], ... 
     'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
p = find(cdf(X) >= 0.5);
text(p(1), cdf(p(1)), ...
     ['(' num2str(p(1)) ', ' num2str(cdf(p(1))) ')'], ... 
     'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
p = find(cdf(X) >= 0.9);
text(p(1), cdf(p(1)), ...
     ['(' num2str(p(1)) ', ' num2str(cdf(p(1))) ')'], ... 
     'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
% saveas(gcf,'images/cdf1.pdf');

hdp_expected_expenses = sum(pdf(X) .* hdp(X) .* step)
reg_expected_expenses = sum(pdf(X) .* reg(X) .* step)
reg_expected_expenses - hdp_expected_expenses
