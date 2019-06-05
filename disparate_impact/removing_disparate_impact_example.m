function removing_disparate_impact_example()
% Implementing algorithm to remove disparate impact in data
%   Implemented part 5 of:
%   "Certifying and removing disparate impact", 
%   M. Feldman, S. A. Friedler, J. Moeller, C. Scheidegger, and S. Venkatasubramanian(2015)
%
%   You will first need to filter the data according to the sensitive attributes
%   In the example it is assumed we are looking at data where the sensitive attribute
%   can take on two different values. We treat one feature where
%   the distributions are different depending on the sensitive attribute.
%   A fix is then applied so that the feature no longer encodes any information
%   about the sensitive attribute.

%   Urban Eriksson, 2019, (https://github.com/urban-eriksson) 

Npoints = 10000;

% Generating example uniform distribution
saw1 = abs(rand(1,Npoints) + rand(1,Npoints) - 1) + 1.5;
xi_saw1_cdf = 1:0.05:3;
xi_saw1_bins = (1:0.1:3) - 0.05; 
cdf_saw1 = cdf(saw1, xi_saw1_cdf);

% Generating example Gaussian distribution
saw2 = -abs(rand(1,Npoints) + rand(1,Npoints) - 1) + 0.5;
xi_saw2_cdf = -1:0.1:1;
xi_saw2_bins = (-1:0.1:1) - 0.05; 
cdf_saw2 = cdf(saw2, xi_saw2_cdf);

% Creating plot of the initial distributions

h1 = figure(1);
set(h1,'name','Original distributions')
clf

subplot(2,2,1)
hist(saw1,xi_saw1_bins)
axis([1 3 0 2500])
title('Sawtooth distribution #1')
ylabel('Count')

subplot(2,2,2)
hist(saw2,xi_saw2_bins)
axis([-1 1 0 2500])
title('Sawtooth distribution #2')
ylabel('Count')

subplot(2,2,3)
plot(xi_saw1_cdf, cdf_saw1, 'linewidth', 1.5)
title('CDF')
ylabel('Cumulative density')
xlabel('x')

subplot(2,2,4)
plot(xi_saw2_cdf, cdf_saw2, 'linewidth', 1.5)
title('CDF')
ylabel('Cumulative density')
xlabel('x')

% The actual transformation is performed here

% Take every point in the original distribution and transform it
% to an average between the two distributions

saw1_fix = zeros(size(saw1));
for j = 1:length(saw1)
    cdfj = interp1(xi_saw1_cdf, cdf_saw1, saw1(j));
    saw1_fix(j) = (saw1(j) + inv_cdf(cdf_saw2, xi_saw2_cdf, cdfj)) / 2;
end

saw2_fix = zeros(size(saw2));
for j = 1:length(saw2)
    cdfj = interp1(xi_saw2_cdf, cdf_saw2, saw2(j));
    saw2_fix(j) = (saw2(j) + inv_cdf(cdf_saw1, xi_saw1_cdf, cdfj)) / 2;
end

% Calculating the cdfs for plotting purposes
xi_fix_cdf =  0:0.05:2;
xi_fix_bins = (0:0.1:2) - 0.05;

cdf_saw1_fix = cdf(saw1_fix, xi_fix_cdf);
cdf_saw2_fix = cdf(saw2_fix, xi_fix_cdf);

% Plotting the fixed distributions

h2 = figure(2);
set(h2,'name','Fixed distributions')
clf

subplot(2,2,1)
histogram(saw1_fix,xi_fix_bins,'FaceColor','r')
axis([0 2 0 2500])
title('Sawtooth #1 => Fixed #1')
ylabel('Count')

subplot(2,2,2)
histogram(saw2_fix,xi_fix_bins,'FaceColor','r')
axis([0 2 0 2500])
title('Sawtooth #2 => Fixed #2')
ylabel('Count')

subplot(2,2,3)
plot(xi_fix_cdf, cdf_saw1_fix, 'linewidth', 1.5,'color','r')
title('CDF')
ylabel('Cumulative density')
xlabel('x')

subplot(2,2,4)
plot(xi_fix_cdf, cdf_saw2_fix, 'linewidth', 1.5,'color','r')
title('CDF')
ylabel('Cumulative density')
xlabel('x')

% Calculation of cumulative distribution function
% x : distribution
% xi: x-values at where to calculate the cdf
function cdfi = cdf(x,xi)

if xi(end) < max(x)
    error('x-values do not cover upper end of distribution')
elseif xi(1) > min(x)
    error('x-values do not cover lower end of distribution')
end

cdfi = zeros(size(xi));
N = length(x);

for j = 1:length(xi)
    cdfi(j) = sum(x <= xi(j)) / N;
end

cdfi(xi < min(x)) = 0;
cdfi(xi > max(x)) = 1;

% Inverse linear interpolation of the cdf
function xi = inv_cdf(cdf, x, cdfi)

N = length(cdfi);
xi = zeros(size(cdfi));

for j = 1:N
    cdfi_j = cdfi(j);
    
    idx_high = find( cdf >= cdfi_j, 1);
    
    if cdf(idx_high) == 0
        % Taking nearest point to distribution
        xi(j) = x(find(cdf==0, 1, 'last'));
    elseif cdf(idx_high) == 1
        % Taking nearest point to distribution
        xi(j) = x(find(cdf==1, 1));
    else
        xi(j) = (x(idx_high-1)+x(idx_high)) / 2;
    end
end

