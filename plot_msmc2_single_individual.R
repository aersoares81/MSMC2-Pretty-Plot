#!/usr/bin/env Rscript

# Install and load the ggplot2 package
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}
library(ggplot2)
library(scales) # Needed for the scales::comma function on the y-axis

# CHANGE THIS ACCORDING TO YOUR SPECIES
# THESE ARE CRITICAL PARAMETERS
mu <- 1.25e-8 # Mutation rate per base pair per year
gen <- 30    # Generation time in years

# Load the MSMC2 results for a single individual
species <- read.table("species_output.final.txt", header = TRUE)

# Filter out rows where 'left_time_boundary' is zero
species <- species[species$left_time_boundary > 0, ]

# Calculate time in years and effective population size (Ne)
plot_data <- data.frame(
  t_years = species$left_time_boundary / mu * gen,
  Ne = (1 / species$lambda) / (2 * mu)
)

# --- Custom labeling function ---
# Function to create readable time labels with "kya" and "Mya"
time_labels <- function(x) {
  labels <- sapply(x, function(years) {
    # Handle missing values
    if (is.na(years)) {
      return("")
    }
    
    if (years >= 1e6) {
      paste0(years / 1e6, " Mya")
    } else if (years >= 1e3) {
      paste0(years / 1e3, " kya")
    } else {
      paste0(years, " ya")
    }
  })
  return(labels)
}

# USING GGPLOT2 TO CREATE THE PLOT
p <- ggplot(plot_data, aes(x = t_years, y = Ne)) +
  
  # Use geom_step for a step-like line plot -- I like it, I think it's the "classic smc" look
  geom_step(color = "red", size = 1) +
  
  # Set the x-axis to a logarithmic scale with custom labels
  # You have to manually add more breaks otherwise it will only show 'big numbers'
  # You will have to manually edit this to look good with different species
  # This might requite some tinkering depending on the timing of your plot,
  # but I think it really helps legibility on publications
  scale_x_continuous(
    trans = "log10", 
    breaks = c(1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000, 
               1000000, 2000000, 5000000, 10000000, 20000000, 50000000, 100000000),
    labels = time_labels,
    minor_breaks = c(1500, 3000, 4000, 6000, 7000, 8000, 9000, 
                     15000, 30000, 40000, 60000, 70000, 80000, 90000,
                     150000, 300000, 400000, 600000, 700000, 800000, 900000,
                     1500000, 3000000, 4000000, 6000000, 7000000, 8000000, 9000000,
                     15000000, 30000000, 40000000, 60000000, 70000000, 80000000, 90000000)
  ) +
  
  # Set the y-axis limits and use natural numbers for the tick labels -- again, a personal preference
  scale_y_continuous(limits = c(0, 3500000), labels = scales::comma) +
  
  # Add labels and a title
  labs(
    title = "Species X Demographic History",
    x = "Years Ago (log scale)",
    y = "Effective Population Size (Ne)"
  ) +
  
  # I didn't experiment with other themes, maybe you want to?
  theme_classic() +
  
  # Customize the plot appearance
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5),
    axis.title.x = element_text(size = 12),
    axis.title.y = element_text(size = 12),
    panel.grid.major = element_line(color = "gray", linetype = "dotted"),
    panel.grid.minor = element_line(color = "gray", linetype = "dotted")
  )

# Save the plot -- change the size if you want to
ggsave("MSMC2_pretty_plot.pdf", plot = p, width = 8, height = 5, units = "in", dpi = 300)
print("Plot saved as MSMC2_pretty_plot.pdf")
