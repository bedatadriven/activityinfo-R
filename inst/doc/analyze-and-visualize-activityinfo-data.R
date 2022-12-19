## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 4
)

## ---- message=FALSE-----------------------------------------------------------
library(activityinfo)

## -----------------------------------------------------------------------------
pat <- system.file("extdata", "schools.csv", package = "activityinfo")
schools <- read.csv(pat, stringsAsFactors = FALSE)
head(schools)

## -----------------------------------------------------------------------------
library(ggplot2)

ggplot(schools, aes(square_meters_of_school, building_value)) +
  geom_point(aes(color = as.factor(is_painted))) +
  geom_smooth(method = "lm", se = FALSE) +
  scale_y_continuous(labels = scales::dollar_format(scale = 1/1e6,
                                                    prefix = "\u20ac",
                                                    suffix = "M")) +
  scale_color_discrete(name = "The building painted",
                     breaks = c(1, 0),
                     labels = c("Yes", "No")) +
  labs(title = "Building value vs. sqm of building",
       x = "Square meters of building",
       y = "Building value") +
  theme_minimal()

## ---- message=FALSE-----------------------------------------------------------
library(quanteda)

n_tokens <- ntoken(char_tolower(schools$situation_description), remove_punct = TRUE)
n_tokens <- as.integer(n_tokens)
df <- data.frame(
  school = schools$school_name, 
  n_tokens = n_tokens,
  stringsAsFactors = FALSE
)
df

## ---- fig.height = 3----------------------------------------------------------
ggplot(df, aes(x = reorder(school, n_tokens), y = n_tokens)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  theme_minimal()

