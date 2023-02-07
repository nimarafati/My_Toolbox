# data.table
## := ( defined as)
To replace gene symbol with ensembl id when there is no symbol available.  
```
gene_metadata[,symbol:=ifelse(symbol=="",ens_id,symbol)]
```
