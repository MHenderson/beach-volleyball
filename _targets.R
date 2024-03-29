# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline # nolint

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed. # nolint

# Set target options:
tar_option_set(
  packages = c("dplyr", "ggplot2", "here", "ragg", "readr", "stringr", "tibble", "tidyr"), # packages that your targets need to run
  format = "rds" # default storage format
  # Set other options as needed.
)

# tar_make_clustermq() configuration (okay to leave alone):
options(clustermq.scheduler = "multicore")

# tar_make_future() configuration (okay to leave alone):
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# source("other_functions.R") # Source other scripts as needed. # nolint

# Replace the target list below with your own:
list(
  tar_target(
    matches_csv,
    download_matches(here("data-raw", "vb_matches.csv")),
    format = "file"
  ),
  tar_target(
    name = vb_matches,
    command = read_csv(here("data-raw", "vb_matches.csv"), guess_max = 76000)
  ),
  tar_target(
    name = tidymatches,
    command = create_tidymatches(vb_matches)
  ),
  tar_target(
    name = p,
    command = trendplot(tidymatches %>% filter(name == "Reid Priddy") %>% filter(date > "2018-01-01"))
  ),
  tar_target(
    name = save_p,
    command = save_plot(p, here("plots", "beach-volleyball.png")),
    format = "file"
  ),
  tar_render(
    name = readme,
    "README.Rmd"
  )
)
