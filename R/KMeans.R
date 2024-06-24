# # Create a synthetic dataset
set.seed(123) # For reproducibility
data <- data.frame(x = rnorm(90, mean = 0),
                   y = rnorm(90, mean = 0))
# data <- data.frame(data)
# names(data) <- c("x", "y", "z")
k <- 3 # Number of clusters

# Initial centroids (randomly selecting 3 points from the dataset in this example)
set.seed(123) # For reproducibility
initial_centroids <- data[sample(nrow(data), k), ]

# K-means clustering step-by-step

n_iterations <- k # Number of iterations to perform (for demonstration)
pdf('~/My_tools_in/My_Toolbox/R/kmeans_3.pdf', width = 10, height = 8)
for (i in 1:n_iterations) {
  # Assign points to the nearest centroid
  distances <- as.matrix(dist(rbind(data, initial_centroids)))
  distances <- distances[1:nrow(data), (nrow(data)+1):(nrow(data)+k)]
  cluster_assignment <- apply(distances, 1, which.min)
  
  # Update centroids
  new_centroids <- aggregate(data[,c("x", "y")], by = list(cluster_assignment), FUN = mean)
  new_centroids <- new_centroids[, -1] # Removing the grouping column
  
  
  # Plotting
  p <- ggplot(as.data.frame(data), aes(x = x, y = y)) +
    geom_point(aes(color = factor(cluster_assignment))) +
    geom_point(data = new_centroids, aes(x = x, y = y), color = 'black', size = 5) +
    geom_segment(data = data, aes(xend = new_centroids[cluster_assignment, "x"],
                                  yend = new_centroids[cluster_assignment, "y"],
                                  x = x, y = y), color = 'grey', alpha = 0.5) +
    labs(title = paste("Iteration:", i)) +
    theme_minimal()
  
  print(p)
  # For the next iteration
  initial_centroids <- new_centroids
}
dev.off()