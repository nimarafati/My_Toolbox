# Dataframes

## (D)Selecting  columns 
Imagine you have a vector of characters (name of given columns) that you want to exclude from your dataframes. To exclude them you cannot tret them similar to numeric values by unary `-` operator. instead you should use `setdiff`:

```
df <- data.frame(A = 1:3, B = 4:6, C = 7:9)
outlier_sample <- c("A", "C")
df <- df[, !(names(df) %in% outlier_sample)]
```

or using logical indexing:
```
df <- df[, !(names(df) %in% outlier_sample)]
```

or by `dplyr`  

```
library(dplyr)
df <- df %>% select(-all_of(outlier_sample))
```

Output will be 
```
df
# Output:
#   B
# 1 4
# 2 5
# 3 6
```
