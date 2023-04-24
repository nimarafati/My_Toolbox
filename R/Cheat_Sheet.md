# data.table
## := ( defined as)
To replace gene symbol with ensembl id when there is no symbol available.  
```
gene_metadata[,symbol:=ifelse(symbol=="",ens_id,symbol)]
```
# Packages
## Unload/Detach packages

```
Vectorize(detach)(name=paste0("package:", c('tidyverse', 'hrbrthemes', 'viridis')), unload=TRUE, character.only=TRUE)
```
