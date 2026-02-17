print("Tejaswini 23BAD121")
# Visual Clutter Reduction (Social Media Interactions)
library(readr)
library(dplyr)
library(ggplot2)
library(scales)

df <- read_csv("social_media_interactions.csv")

df <- df %>%
  mutate(
    Platform = as.factor(Platform),
    Post_Type = as.factor(Post_Type),
    Likes = as.numeric(Likes),
    Shares = as.numeric(Shares),
    Comments = as.numeric(Comments),
    Engagement_Score = as.numeric(Engagement_Score)
  ) %>%
  filter(!is.na(Likes), !is.na(Shares), !is.na(Comments), !is.na(Engagement_Score))

# 1) Alpha blending 
p_alpha <- ggplot(df, aes(x = Likes, y = Engagement_Score, color = Platform)) +
  geom_point(alpha = 0.15, size = 1.2) +
  scale_color_brewer(palette = "Set1") +
  labs(
    title = "Alpha Blending: Likes vs Engagement Score",
    x = "Likes",
    y = "Engagement Score"
  ) +
  theme_minimal()

print(p_alpha)

# 2) Jittering 
p_jitter <- ggplot(df, aes(x = Platform, y = Engagement_Score, color = Post_Type)) +
  geom_jitter(width = 0.18, height = 0, alpha = 0.6, size = 1.2) +
  scale_color_brewer(palette = "Dark2") +
  labs(
    title = "Jittering: Engagement Score by Platform (colored by Post Type)",
    x = "Platform",
    y = "Engagement Score"
  ) +
  theme_minimal()

print(p_jitter)

# Another jitter example: Likes vs Shares (continuous), keep clutter low but visible
p_jitter2 <- ggplot(df, aes(x = Likes, y = Shares)) +
  geom_point(alpha = 0.10, size = 1) +
  geom_jitter(width = 20, height = 5, alpha = 0.10, size = 1) +
  labs(
    title = "Jittering + Alpha: Likes vs Shares",
    x = "Likes",
    y = "Shares"
  ) +
  theme_minimal()

print(p_jitter2)

# 3) Aggregation and binning

# 3A) Aggregation: average engagement by Platform and Post_Type
agg <- df %>%
  group_by(Platform, Post_Type) %>%
  summarise(
    Avg_Engagement = mean(Engagement_Score, na.rm = TRUE),
    Posts = n(),
    .groups = "drop"
  )

p_agg <- ggplot(agg, aes(x = Platform, y = Avg_Engagement, fill = Post_Type)) +
  geom_col(position = "dodge") +
  scale_fill_brewer(palette = "Dark2") +
  labs(
    title = "Aggregation: Average Engagement by Platform and Post Type",
    x = "Platform",
    y = "Average Engagement Score"
  ) +
  theme_minimal()

print(p_agg)

# 3B) Binning (1D): bin Likes and count posts per bin
df_bins <- df %>%
  mutate(Likes_Bin = cut(Likes, breaks = 20, include.lowest = TRUE))

p_bin1d <- ggplot(df_bins, aes(x = Likes_Bin)) +
  geom_bar() +
  labs(
    title = "Binning: Post Count Across Likes Bins",
    x = "Likes (binned)",
    y = "Number of Posts"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(p_bin1d)

# 3C) Binning (2D): reduce clutter using 2D bins (Likes vs Shares)
p_bin2d <- ggplot(df, aes(x = Likes, y = Shares)) +
  geom_bin2d(bins = 35) +
  scale_fill_viridis_c() +
  labs(
    title = "2D Binning: Likes vs Shares (Density Heatmap)",
    x = "Likes",
    y = "Shares",
    fill = "Count"
  ) +
  theme_minimal()

print(p_bin2d)
