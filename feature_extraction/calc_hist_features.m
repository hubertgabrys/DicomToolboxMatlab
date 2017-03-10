function hist_features = calc_hist_features(dose_cube, struct_cube_msk)

dose_cube_flat = dose_cube(:);
struct_cube_msk_flat = struct_cube_msk(:);
struct_cube_flat = dose_cube_flat(struct_cube_msk_flat==1);

hist_features.mean = mean(struct_cube_flat);
hist_features.min = min(struct_cube_flat);
hist_features.max = max(struct_cube_flat);
hist_features.std = std(struct_cube_flat);
hist_features.skewness = skewness(struct_cube_flat);
hist_features.kurtosis = kurtosis(struct_cube_flat);

n_bins = 256;
N = histcounts(struct_cube_flat, n_bins);
N(N==0) = [];
p = N ./ sum(N);
hist_features.entropy = -sum(p.*log2(p));
hist_features.entropy = -sum(p.*log2(p));
hist_features.energy = sum(p .* p);

end

function s = skewness(x, flag)
if nargin < 2 || isempty(flag)
    flag = 1;
end

x0 = x - repmat(mean(x), size(x));
s2 = mean(x0.^2); % this is the biased variance estimator
m3 = mean(x0.^3);
s = m3 ./ s2.^(1.5);

% Bias correct the skewness.
if flag == 0
    n = sum(~isnan(x));
    n(n<3) = NaN; % bias correction is not defined for n < 3.
    s = s .* sqrt((n-1)./n) .* n./(n-2);
end
end


function k = kurtosis(x, flag)
if nargin < 2 || isempty(flag)
    flag = 1;
end

x0 = x - repmat(mean(x), size(x));
s2 = mean(x0.^2); % this is the biased variance estimator
m4 = mean(x0.^4);
k = m4 ./ s2.^2;

% Bias correct the kurtosis.
if flag == 0
    n = sum(~isnan(x));
    n(n<4) = NaN; % bias correction is not defined for n < 4.
    k = ((n+1).*k - 3.*(n-1)) .* (n-1)./((n-2).*(n-3)) + 3;
end
end