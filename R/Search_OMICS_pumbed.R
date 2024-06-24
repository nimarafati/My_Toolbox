library(rentrez)
library(XML)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(parallel)
# library(hclust)

search_year <- function(year, term){
  query <- paste(term, "AND (", year, "[PDAT])")
  entrez_search(db="pubmed", term=query, retmax=0)$count
}
# terms <- c('genomics', 'transcriptomics', 'proteomics', 'interactomics', 'epigenomics', 'metagenoics',
#            'metablomics', 'immunoproteomics', 'evogenoics', 'proteogenomics', 'lipidomics')
terms <- c(
  'Genomics', 
  'Transcriptomics', 
  'Proteomics', 
  'Metabolomics', 
  'Lipidomics', 
  'Glycomics', 
  'Phenomics', 
  'Epigenomics', 
  'Metagenomics', 
  'Microbiomics', 
  'Pharmacogenomics', 
  'Nutrigenomics', 
  'Enviromics', 
  'Interactomics', 
  'Immunoproteomics', 
  'Chemogenomics', 
  'Toxicogenomics', 
  'Radiogenomics', 
  'Cytomics', 
  'Fluxomics', 
  'Phosphoproteomics', 
  'Glycoproteomics', 
  'Metaproteomics', 
  'Paleogenomics', 
  'Neuromics', 
  'Cardiogenomics', 
  'Ecogenomics', 
  'Viromics',
  'Exomics',
  'Panomics',
  'Omics Integration' # A term used to describe the integrated analysis of datasets from different omics disciplines
)
years  <- seq(1950,2023,1)
#my_stat<-matrix(0,length(years),length(terms),byrow = T)
my_stat<- data.frame(years = seq(1950,2023,1))
rownames(my_stat) <- my_stat$years
#  r_search
for(t in terms){
  for(i in 1:length(years))
  {
    cat('\r', t, ': ', years[i])
    xmy_stat[i,t]<- sapply(years[i], search_year, term=t, USE.NAMES=FALSE)
  }
}

write.table(xmy_stat, 'Search_OMICS_pumbed_output.txt', col.names = T, row.names = F, quote = F, sep = '\t')
dst <- dist(t(xmy_stat[,2:ncol(xmy_stat)]))
hc <- stats::hclust(dst)
plot(hc, hang = -1, ylab = 'nummber of articles')

library(gganimate)
library(tidyverse)
library(gifski)

# Scale by number of papers of all omics
xmy_stat_scaled_by_publication_sum_per_year <- xmy_stat
xmy_stat_scaled_by_publication_sum_per_year[,2:32] <- xmy_stat_scaled_by_publication_sum_per_year[,2:32]/rowSums(xmy_stat_scaled_by_publication_sum_per_year[,2:32])


df_long <- xmy_stat_scaled_by_publication_sum_per_year %>%
  pivot_longer(cols = -years, names_to = "Term", values_to = "Publications")

head(df_long)
# Creating the bubble chart
p <- ggplot(df_long, aes(x = years, y = Publications, size = Publications, color = Term)) +
  geom_point(alpha = 0.7) +
  scale_size(range = c(3, 20)) + # Adjust the size range as needed
  labs(title = 'Number of Publications by Year: {closest_state}', 
       x = "Year", 
       y = "Term", 
       size = "Number of Publications") +
  theme_minimal() +
  transition_states(years, transition_length = 2, state_length = 1) +
  ease_aes('linear')

# Render the animation
animate(p, nframes = 200, width = 800, height = 600, renderer = gifski_renderer())

# To save the animation to a file, use the anim_save function
# anim_save("path/to/save/your_animation.gif", animation = p)


library(rentrez)
library(parallel)

# Define the search function
search_year <- function(year, term) {
  cat('\r ', year, ' ', term)
  query <- paste(term, "AND (", year, "[PDAT])")
  entrez_search(db = "pubmed", term = query, retmax = 0)$count
}

# Your terms and years remain the same
# terms <- c('genomics', 'transcriptomics', 'proteomics', 'interactomics', 'epigenomics', 'metagenomics',
           # 'metabolomics', 'immunoproteomics', 'evogenomics', 'proteogenomics', 'lipidomics')
terms <- c(
  'Genomics', 
  'Transcriptomics', 
  'Proteomics', 
  'Metabolomics', 
  'Lipidomics', 
  'Glycomics', 
  'Phenomics', 
  'Epigenomics', 
  'Metagenomics', 
  'Microbiomics', 
  'Pharmacogenomics', 
  'Nutrigenomics', 
  'Enviromics', 
  'Interactomics', 
  'Immunoproteomics', 
  'Chemogenomics', 
  'Toxicogenomics', 
  'Radiogenomics', 
  'Cytomics', 
  'Fluxomics', 
  'Phosphoproteomics', 
  'Glycoproteomics', 
  'Metaproteomics', 
  'Paleogenomics', 
  'Neuromics', 
  'Cardiogenomics', 
  'Ecogenomics', 
  'Viromics',
  'Exomics',
  'Panomics',
  'Omics Integration' # A term used to describe the integrated analysis of datasets from different omics disciplines
)

years <- seq(1950, 2023, 1)

# Create an empty data frame to store results
my_stat <- data.frame(years = seq(1950, 2023, 1))
rownames(my_stat) <- as.character(my_stat$years)

# Setting up parallel processing
no_cores <- 2
cl <- makeCluster(no_cores)

# Export necessary objects and functions to the cluster
clusterExport(cl, varlist = c("search_year", "years", "terms", "entrez_search"))

# Running the loop for each term in parallel
for (t in terms) {
  cat(t)
  # Using parLapply to run searches in parallel for each year
  counts <- parLapply(cl, years, search_year, term = t)
  
  # Inserting results into the data frame
  my_stat[[t]] <- unlist(counts)
}

# Stop the cluster
stopCluster(cl)

