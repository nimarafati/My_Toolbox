# RMD
## Generate text/figures/tables in loop for report
If you have a lot of results (but similar structure, e.g. DE analysis with DE tables, or volcano plots,...) instead of copy/paste of the same chunks (of course with chaning the contrasts name) you can use a loop and save it into a list. Ultimately you use `tagList` to print after the loop.

```
contrasts <- c('Day1-Neuron-M-vs-F', 
               'Day1-Glia-M-vs-F')

render_list <- htmltools::tagList()
for(file_name in contrasts){
    file_path <- paste0('../../results/02-DE/', file_name, '/')
    render_list[[paste0(file_name, '_title')]] <- h5(file_name) 
    render_list[[paste0(file_name, 'txt1')]] <- 'Differential expression results. Table below shows list of all tested genes up and down-regulated are marked in column **diffexpressed**. ' 
    render_list[[paste0(file_name, 'txt2')]] <- paste0('The following table shows top 50 differentially expressed genes and you can find the full list in following path `results/02-DE/', file_name, '/DE_results.txt')  
    # Loading the results
    res_results <- readRDS(paste0(file_path, 'res_results.rds'))
    # Volcano plot
    p <- ggplot(data = as.data.frame(res_results$DE_table), aes(x = log2FoldChange, y = -log10(padj), color = diffexpressed,
        label = delabel)) +
      geom_point() + theme_classic() +
        scale_colour_manual(values = c('blue', 'black', 'red')) +
        geom_vline(xintercept = c(-log2FC_cutoff,log2FC_cutoff), col = 'red') +
        geom_hline(yintercept = -log10(padjust_cutoff), col = 'red') +
        ggtitle(file_name) +
        theme(plot.title = element_text(hjust = 0.5))
    render_list[[paste0(file_name, '_volcano')]] <- as_widget(ggplotly(p))
    # DE table
    DE_table <- res_results$DE_table[(res_results$DE_table$padj <= 0.05 &
                                          abs(res_results$DE_table$log2FoldChange) >= 1),
    c('gene_id', 'gene_name', 'diffexpressed', 'baseMean', 'log2FoldChange', 'pvalue', 'padj', 'lfcSE', 'stat')][1:50,]
    render_list[[paste0(file_name, '_de_table')]] <- DT::datatable(data = DE_table, rownames = FALSE,
            extensions = c('Buttons', 'Scroller'),
            options = list(dom = 'Bfrtip', buttons = c('copy', 'csv'),
                           deferRender = TRUE, scrollX = T,
                           scrollY = 200,
                           scroller = TRUE,
                           caption = paste0('DE  genes in', file_name)))
    # GO
    render_list[[paste0(file_name, '_GO')]] <- h6('GO') 
    render_list[[paste0(file_name, '_GO_txt')]] <- 'Following table shows GO enrichment analysis.  '
    ego <- read.csv(paste0(file_path, '/enrichGO/enrichGO_results.txt'), header =  T, sep = '\t')
    ego <- ego[,c('ONTOLOGY', 'ID', 'Description', 'GeneRatio', 'BgRatio',  'pvalue', 'p.adjust')]
    DT::datatable(data = ego, rownames = FALSE, 
                  extensions = c('Buttons', 'Scroller'), 
                  options = list(dom = 'Bfrtip', buttons = c('copy', 'csv'),
                                 deferRender = TRUE, scrollX = T,
                                 scrollY = 200,
                                 scroller = TRUE,
                                 caption = paste0('DE  genes in', file_name)))
    sample <- gsub(x = file_name, pattern = '-', replacement = '_')
    temp_code <- mapply(function(path, sample, analysis, patt) {
    knitr::knit_expand('figures.qmd')}, 
    c(file_path, file_path), 
    c(sample, sample),
    c('GSEA_GO', 'GSEA_KEGG'),
    c('GSEA_GO_FDR_0.05_', 'GSEA_KEGG_FDR_0.05_'))
    res <- knitr::knit_child(text = unlist(temp_code), quiet = TRUE)
    cat(res, sep = '\n')
}
tagList(render_list)
```

# Quarto
