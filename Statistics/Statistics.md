# Clustering  
Clustering methods can be divided into two main classes:  
## Bottom-up (agglomerative)  
- Single Linkage Clustering: This approach merges clusters based on the similarity between the closest data points from different clusters.  
- Complete Linkage Clustering: It considers the similarity between the farthest data points from different clusters for merging.  
- Average Linkage Clustering: In this method, the average similarity between all pairs of data points from different clusters is used as the merging criterion.  
- Ward's Method: It aims to minimize the total within-cluster variance when merging clusters.  
## Top-down (divisive)  
- k-Means: This algorithm starts with a single cluster containing all the data points and then repeatedly partitions it into k clusters by assigning data points to the nearest cluster centroid and updating the centroids.  
- Gaussian Mixture Models (GMM): GMM assumes that the data points are generated from a mixture of Gaussian distributions and attempts to find the parameters (means, covariances, and mixture weights) that best fit the data.  
- BIRCH (Balanced Iterative Reducing and Clustering using Hierarchies): BIRCH builds a hierarchical clustering structure by recursively partitioning the data points and summarizing the clusters using compact and efficient data structures.  
