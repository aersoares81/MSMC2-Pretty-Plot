#!/usr/bin/env Rscript

if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}
library(ggplot2)
library(scales)

# CHANGE THIS ACCORDING TO YOUR SPECIES
# THESE ARE CRITICAL PARAMETERS
mu <- 1.5e-8 
gen <- 1    

# This will get the name of the population/species automatically
# It will remove the .txt from the file name and assume the rest is the name of
# the population/species.
prepare_data <- function(file_path) {
  # Automatically extract the filename without the directory or extension
  # e.g., "data/Yoruba.txt" becomes "Yoruba"
  pop_name <- gsub(".txt$", "", basename(file_path))
  
  df <- read.table(file_path, header = TRUE)
  df <- df[df$left_time_boundary > 0, ]
  
  data.frame(
    t_years = df$left_time_boundary / mu * gen,
    Ne = (1 / df$lambda) / (2 * mu),
    Population = pop_name
  )
}

# Load both populations/species. These are placeholder results that I used to create the example plots
pop1 <- prepare_data("PUN-Y-BCRD.txt")
pop2 <- prepare_data("PUN-R-JMC.txt")

# Combine into one data frame
combined_data <- rbind(pop1, pop2)

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
p <- ggplot(combined_data, aes(x = t_years, y = Ne, color = Population)) +
  # geom_step creates the classic MSMC look
  geom_step(size = 1) +
  
  # Set the x-axis to a logarithmic scale with custom labels
  # You have to manually add more breaks otherwise it will only show 'big numbers'
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
# You will need to adjust this depending on your results so it's not too squished
# This can crop the plot if not careful
  scale_y_continuous(limits = c(0, 500000), labels = scales::comma) +
  
  # Color palette -- you can google other nice color combinations/palettes
  # This way, if you add more populations/species, it will automatically assign colors to them
  scale_color_brewer(palette = "Set1") +
  
  labs(
    title = "Comparative Demographic History",
    x = "Years Ago (log scale)",
    y = "Effective Population Size (Ne)",
    color = "Population"
  ) +
  
# I didn't experiment with other themes, maybe you want to?
  theme_classic() +
  # You can customize placement of text, font size, etc.
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    legend.position = "bottom",
    panel.grid.major = element_line(color = "gray90", linetype = "dotted"),
    panel.grid.minor = element_line(color = "gray", linetype = "dotted")
  )

ggsave("MSMC2_comparison_plot.pdf", plot = p, width = 8, height = 5)
print("Plot saved as MSMC2_comparison_plot.pdf")
