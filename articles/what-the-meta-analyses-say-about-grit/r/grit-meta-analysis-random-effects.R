# What the Meta-Analyses Say About Grit
# Synthetic random-effects synthesis of grit correlations.
# This is an educational demonstration, not a real meta-analysis.

set.seed(42)

k <- 60
sample_size <- sample(150:2500, k, replace = TRUE)

r_total_grit <- pmin(pmax(rnorm(k, mean = 0.18, sd = 0.08), -0.10), 0.45)
r_perseverance <- pmin(pmax(rnorm(k, mean = 0.22, sd = 0.08), -0.10), 0.50)
r_consistency <- pmin(pmax(rnorm(k, mean = 0.08, sd = 0.07), -0.15), 0.35)

outcome_domain <- sample(
  c("academic", "performance", "retention", "wellbeing"),
  k,
  replace = TRUE,
  prob = c(0.45, 0.25, 0.20, 0.10)
)

df <- data.frame(
  study_id = paste0("study_", sprintf("%02d", 1:k)),
  sample_size,
  r_total_grit,
  r_perseverance,
  r_consistency,
  outcome_domain
)

fisher_z <- function(r) {
  0.5 * log((1 + r) / (1 - r))
}

inverse_fisher_z <- function(z) {
  (exp(2 * z) - 1) / (exp(2 * z) + 1)
}

random_effects_meta_r <- function(r_values, n_values) {
  z_values <- fisher_z(r_values)
  vi <- 1 / (n_values - 3)

  wi_fixed <- 1 / vi
  z_fixed <- sum(wi_fixed * z_values) / sum(wi_fixed)

  q <- sum(wi_fixed * (z_values - z_fixed)^2)
  df_q <- length(z_values) - 1
  c_value <- sum(wi_fixed) - (sum(wi_fixed^2) / sum(wi_fixed))
  tau2 <- max(0, (q - df_q) / c_value)

  wi_random <- 1 / (vi + tau2)
  z_random <- sum(wi_random * z_values) / sum(wi_random)
  se_random <- sqrt(1 / sum(wi_random))

  lower_z <- z_random - 1.96 * se_random
  upper_z <- z_random + 1.96 * se_random

  data.frame(
    pooled_r = inverse_fisher_z(z_random),
    ci_lower = inverse_fisher_z(lower_z),
    ci_upper = inverse_fisher_z(upper_z),
    tau2 = tau2,
    q = q
  )
}

summary <- rbind(
  cbind(facet = "total_grit", random_effects_meta_r(df$r_total_grit, df$sample_size)),
  cbind(facet = "perseverance_of_effort", random_effects_meta_r(df$r_perseverance, df$sample_size)),
  cbind(facet = "consistency_of_interests", random_effects_meta_r(df$r_consistency, df$sample_size))
)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

write.csv(df, "data/processed/grit-meta-analysis-synthetic-studies-r.csv", row.names = FALSE)
write.csv(summary, "outputs/tables/grit-meta-analysis-random-effects-summary-r.csv", row.names = FALSE)

print(head(df))
print(round(summary, 3))
