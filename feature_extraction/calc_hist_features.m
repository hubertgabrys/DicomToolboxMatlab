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