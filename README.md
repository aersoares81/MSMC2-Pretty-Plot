# MSMC2 Pretty Plot
## R script to plot your MSMC2 results in an easy-to-read way

I wanted my MSMC2 plots to look nice, and maybe you want that too. This requires minimal edits to work. First you will need your MSMC2 results. You will also need to change `mu` and `gen` (mutation rate and generation time), and depending on your results you might want to adjust the y axis scale so your plot doesn't look "squished". The code has a lot of comments, so it shouldn't be too hard to see where you should edit things.

This was designed for plotting the results of a single individual, or the comparison of two results. I might add other scripts for multiple individuals if there's demand or interest from the community.

The example plots are for populations of the monkeyflower *Diplacus puniceus*.

### Single individual plot
![Single species/population plot](https://github.com/aersoares81/MSMC2-Pretty-Plot/blob/main/PUN-Y-BCRD.MSMC2_pretty_plot.png)

### Two individuals/comparison plot
With this script, it will automatically get the name of the population/species in the plot based on the filename. It will remove the `.txt` extension and assume the rest is the name you want to use in the plot.
![Two populations/species plots](https://github.com/aersoares81/MSMC2-Pretty-Plot/blob/main/MSMC2_comparison_plot.png)

### Multiple individuals/comparison plot
This will require further editing on the script, I didn't create a way to make it more automatic. I'm sure there is one, maybe you can contribute to the repo. :)
To plot multiple species/individuals/populations, you will need to load the additional populations/species/individuals.
You will need to add the additional populations on `# Load both populations/species.`
```
pop3 <- prepare_data("PUN-Y-BCRD.txt")
```
And in the the `# Combine into one data frame` part of the script you will also need to add the additional populations:
```
combined_data <- rbind(pop1, pop2,pop3)
```

Then the script will do the rest and plot something like this:
![Three populations/species plots](https://github.com/aersoares81/MSMC2-Pretty-Plot/blob/main/MSMC2_comparison_plot_3pops.png)
