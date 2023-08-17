# This script loops through a list and the corresponding contrasts saves as `colname` in each slot of the list object to
# - load a table  
# - merge with another dataframe  
# - write to a new file  
# - compress (tar.gz) and remove the written file  

# Load required packages
library(foreach)
library(doParallel)

# Number of parallel workers
num_cores <- 2  # You can adjust this based on your system

# Register parallel backend
cl <- makeCluster(num_cores)
registerDoParallel(cl)

model_names <- names(contMatrix_list)

# Parallelized loop for each model
foreach(mdl = model_names, .packages = c("dplyr", "data.table")) %dopar% {
  cont_names <- colnames(contMatrix_list[[mdl]])
  
  for (cont in cont_names) {
    cont <- gsub(pattern = ' - ', replacement = '_', x = cont)
    print(cont)
    setwd(paste0('~/SMS_6625_PIG_Project/results/differential_methylation_probe_analysis/',cont))
    DMP <- read.csv('DMPs_sign_raw_P.value.txt', sep = '\t')
    DMP$Probe <- DMP$CpG
    DMP <- merge(DMP, mval_group_mean, by = 'Probe')
    DMP <- subset(DMP, select = -Probe)
    file_name <- 'DMPs_sign_raw_P.value_M_val.txt'
    write.table(DMP, file = file_name , col.names = T, row.names = F, quote = F, sep = '\t')
    tar(tarfile = paste0(file_name, '.tar.gz'), files= file_name, compression = 'gz', tar = Sys.getenv('tar'), extra_flags = 'remove-files')
    file.remove(file_name)
  }
}

# Stop parallel processing
stopCluster(cl)
