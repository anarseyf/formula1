
packages <- c(
  "tidyr", "knitr", "ggplot2", "tibble", "ggthemes",
  "extrafont", "fontcm", "ggnewscale", "here"
)
install.packages(setdiff(packages, rownames(installed.packages())),
  repos = "http://cran.us.r-project.org"
)

library(ggplot2)
library(dplyr)
library(tidyr)
library(knitr)
library(tibble)
library(extrafont)
library(fontcm)
library(ggthemes)
library(ggnewscale)
library(here)

# theme_set(theme_fivethirtyeight())
theme_set(theme_minimal())

theme_update(
  axis.title = element_blank(),
  axis.ticks.x = element_blank(),
  legend.position = "none",
  text = element_text(family = "sans")
)

get_alt_rows <- function(v, start_year) {
  run_lengths <- rle(v)$ lengths

  alt_rows <- data.frame(
    run = run_lengths,
    offset = cumsum(run_lengths),
    year = start_year
  ) %>%
    mutate(is_alt = (row_number() %% 2 == 0))

  alt_rows[-1, ]$year <- min_year + alt_rows[1:(nrow(alt_rows) - 1), ]$offset

  return(alt_rows %>% select(year, run, is_alt))
}

races <- read.csv("./data/races.csv") %>% mutate(date = as.Date(date))
standings <- read.csv("./data/driver_standings.csv")
drivers <- read.csv("./data/drivers.csv")
constructors <- read.csv("./data/constructors.csv")
circuits <- read.csv("./data/circuits.csv")
results <- read.csv("./data/results.csv")
qualifying <- read.csv("./data/qualifying.csv")
lap_times_1060 <- read.csv("./data/lap_times_1060.csv")

# Formula 1 World Champions

filter_by_year <- function(data) {
  # data %>% filter(year > 2000)
  data %>% filter(year > 1949)
}

last_races <- races %>%
  filter(year < 2021) %>% # 2021 season is incomplete as of today
  group_by(year) %>%
  mutate(last_race = max(round)) %>%
  filter(round == last_race) %>%
  select(year, raceId, round) %>%
  arrange(year)

constructor_mapping <- results %>%
  select(raceId, driverId, constructorId) %>%
  inner_join(races %>% select(raceId, year, round), by = "raceId") %>%
  group_by(year, driverId) %>%
  filter(round == max(round)) %>%
  select(year, driverId, constructorId) %>%
  arrange(desc(year))

standings_endofseason_leaders <- standings %>%
  filter(raceId %in% last_races$raceId) %>%
  inner_join(races %>% select(raceId, year), by = "raceId") %>%
  filter(position == 1 | position == 2) %>%
  select(year, driverId, points, position, wins) %>%
  inner_join(constructor_mapping, by = c("year", "driverId")) %>%
  arrange(year, position)

dupl <- duplicated(standings_endofseason_leaders)
championship_rivals <- standings_endofseason_leaders[!dupl, ] %>%
  select(year, driverId, constructorId, position, points, wins)

champions <- championship_rivals %>%
  filter(position == 1) %>%
  mutate(championId = driverId) %>%
  select(year, championId) %>%
  arrange(desc(year))

runners_up <- championship_rivals %>%
  filter(position == 2) %>%
  mutate(runnerupId = driverId) %>%
  select(year, runnerupId) %>%
  arrange(desc(year))


pole_sitters <- results %>%
  filter(grid == 1) %>%
  mutate(polesitterId = driverId) %>%
  select(raceId, polesitterId) %>%
  arrange(raceId)

dupl_index <- pole_sitters %>%
  select(raceId) %>%
  duplicated()

pole_sitters <- pole_sitters[!dupl_index, ]

race_by_race <- results %>%
  filter(position == 1) %>%
  select(raceId, driverId) %>%
  inner_join(races %>% select(year, round, raceId), by = "raceId") %>%
  select(year, round, raceId, driverId) %>%
  inner_join(champions, by = "year") %>%
  inner_join(runners_up, by = "year") %>%
  arrange(desc(year), desc(round)) %>%
  mutate(
    won_by =
      ifelse(driverId == championId, "champion",
        ifelse(driverId == runnerupId, "runnerup", "other")
      )
  ) %>%
  left_join(pole_sitters) %>%
  filter_by_year()


# results %>%
#   filter(grid == 1) %>%
#   select(raceId) %>%
#   inner_join(races %>% select(raceId, year)) %>%
#   group_by(year) %>%
#   tally() %>%
#   right_join(last_races) %>%
#   mutate(missing = round - n) %>%
#   select(year, round, missing) %>%
#   arrange(year) %>%
#   print(n=Inf) # '51-57 and '64 have duplicates? TODO


champion_names <- champions %>%
  inner_join(drivers, by = c("championId" = "driverId")) %>%
  select(year, championId, firstname, lastname) %>%
  arrange(year) %>%
  filter_by_year()

min_year <- min(champion_names$year)
max_year <- max(champion_names$year)

champion_counts <- champion_names %>%
  group_by(championId) %>%
  summarise(count = n())

champion_table <- champion_names %>%
  inner_join(champion_counts) %>%
  arrange(year) %>%
  filter_by_year()

dupl_index <- champion_table %>%
  select(championId) %>%
  duplicated()

titles_table <- champion_table[!dupl_index, ]

alt_rows <- get_alt_rows(champion_names$championId, min_year)

runnerup_names <- runners_up %>%
  inner_join(drivers, by = c("runnerupId" = "driverId")) %>%
  select(year, firstname, lastname) %>%
  filter_by_year()

champion_constructors <- champions %>%
  inner_join(constructor_mapping, by = c("year", "championId" = "driverId")) %>%
  inner_join(constructors %>% select(constructorId, name), by = "constructorId") %>%
  filter_by_year()

runnerup_constructors <- runners_up %>%
  inner_join(constructor_mapping, by = c("year", "runnerupId" = "driverId")) %>%
  inner_join(constructors %>% select(constructorId, name), by = "constructorId") %>%
  filter_by_year()

stats_table <- race_by_race %>%
  group_by(year) %>%
  summarize(
    champion_wins = sum(driverId == championId),
    champion_poles = sum(polesitterId == championId),
    runnerup_wins = sum(driverId == runnerupId),
    runnerup_poles = sum(polesitterId == runnerupId)
  )

plot_champions <- function() {
  champion_color <- "#ffaa49"
  runnerup_color <- "#5495f5"
  other_color <- "#b1b1b1"
  titles_color <- "#888888"

  rivals_color_scale <- scale_color_manual(
    values = c(
      "champion" = champion_color,
      "runnerup" = runnerup_color,
      "other" = other_color
    ),
    aesthetics = c("color", "fill")
  )

  alt_row_colors <- scale_fill_manual(values = c("white", "#dadada"))
  line_color <- "#525252"

  verticals <- c(-36, -32, -21, -13, -9, 13, 17, 28, 36)
  column_labels <- c("Titles\nwon", "Champion", "Team", "Wins\n(Poles)", "Races", "Wins\n(Poles)", "Runner-up", "Team", "") # %>% toupper()

  headers <- data.frame(column_labels, verticals)

  ggplot() +
    # Alternating rows
    geom_rect(
      data = alt_rows,
      aes(
        xmin = min(verticals) - 0.5,
        xmax = max(verticals) - 0.5,
        ymin = year - 0.5,
        ymax = year + run - 0.5,
        fill = is_alt
      ),
      # stat = "identity",
      alpha = 0.6,
    ) +
    alt_row_colors +
    new_scale_fill() +

    # Horizontal lines
    # geom_hline(yintercept = seq(min_year, max_year), color = "#5f5f5f", size = 0.5, linetype = "dotted") +
    geom_hline(yintercept = c(min_year - 0.5, max_year + 0.5), color = line_color, size = 0.3, linetype = "solid") +
    # Titles
    geom_label(
      data = titles_table,
      aes(x = verticals[1] + 1.5, y = year, label = count),
      size = 4,
      fill = titles_color,
      color = "white",
      label.r = unit(0.25, "lines"),
      family = "sans",
      fontface = "bold"
    ) +
    # Champion
    geom_text(
      data = champion_names,
      hjust = "left",
      aes(
        x = verticals[2],
        y = year,
        label = paste(firstname, lastname),
      ),
      fontface = "bold",
      family = "sans"
    ) +
    # Team
    geom_text(
      data = champion_constructors,
      mapping = aes(x = verticals[3], y = year, label = name),
      hjust = "left",
      # fontface = "italic",
      family = "sans"
    ) +
    # Wins (Poles)
    geom_text(
      data = stats_table,
      mapping = aes(x = verticals[4], y = year, label = champion_wins),
      hjust = "left",
      family = "sans",
      fontface = "bold"
    ) +
    geom_text(
      data = stats_table,
      mapping = aes(
        x = verticals[4] + 1.5, y = year,
        label = sprintf("(%d)", champion_poles)
        # label = champion_poles
      ),
      hjust = "left",
      family = "sans"
    ) +
    # Wins (race by race)
    geom_point(
      data = race_by_race,
      aes(x = round + verticals[5] - 0.5, y = year, fill = won_by, color = won_by),
      shape = 21,
      size = 3
    ) +
    rivals_color_scale +

    # Pole positions (race by race)
    geom_point(
      data = subset(race_by_race, polesitterId == championId),
      aes(x = round + verticals[5] - 0.5, y = year),
      fill = NA,
      shape = 21,
      size = 5,
      stroke = 1,
      color = champion_color
    ) +
    # Wins (Poles)
    geom_text(
      data = stats_table,
      mapping = aes(x = verticals[6], y = year, label = runnerup_wins),
      hjust = "left",
      family = "sans",
      fontface = "bold"
    ) +
    geom_text(
      data = stats_table,
      mapping = aes(
        x = verticals[6] + 1.5, y = year,
        label = sprintf("(%d)", runnerup_poles)
        # label = runnerup_poles
      ),
      hjust = "left",
      family = "sans"
    ) +
    # Runner-up
    geom_text(
      data = runnerup_names,
      mapping = aes(x = verticals[7], y = year, label = paste(firstname, lastname)),
      hjust = "left",
      family = "sans"
    ) +
    # Team
    geom_text(
      data = runnerup_constructors,
      mapping = aes(x = verticals[8], y = year, label = name),
      hjust = "left",
      # fontface = "italic",
      family = "sans"
    ) +
    # ----- end -----

    scale_y_reverse(
      breaks = seq(min_year, max_year),
      # breaks = NULL,
      expand = c(0, 0),
      sec.axis = dup_axis()
    ) +
    scale_x_continuous(
      expand = c(0, 0),
      limits = c(min(verticals) - 1, max(verticals)),
      breaks = NULL
    ) +
    theme(
      axis.ticks.x = element_blank(),
      axis.text.y = element_text(size = 11),
      panel.grid = element_blank(),
      plot.margin = unit(c(1, 0.5, 1, 0.5), "cm")
    ) +
    geom_text(
      data = headers,
      aes(x = verticals, y = min_year - 2, label = column_labels),
      fontface = "bold",
      # family = "sans",
      size = 5,
      lineheight = 0.7,
      hjust = "left",
      vjust = "top"
    ) +
    geom_vline(xintercept = verticals - 0.5, color = line_color, size = 0.3)
  # annotate("text", x = 0, y = min_year - 4, label = "Formula 1 World Champions, 1950–2020", hjust = "left")
}

plot_champions()

ggsave("champions.png", bg = "white", width = 12, height = 15)