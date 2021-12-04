library(rentrez)
library(XML)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(hclust)

search_year <- function(year, term){
  query <- paste(term, "AND (", year, "[PDAT])")
  entrez_search(db="pubmed", term=query, retmax=0)$count
}
terms <- c('genomics', 'transcriptomics', 'proteomics', 'interactomics', 'epigenomics', 'metagenoics',
           'metablomics', 'immunoproteomics', 'evogenoics', 'proteogenomics', 'lipidomics')
years  <- seq(1950,2021,1)
#my_stat<-matrix(0,length(years),length(terms),byrow = T)
xmy_stat<- data.frame(years = seq(1950,2021,1))
rownames(my_stat) <- my_stat$years
#  r_search
for(t in terms){
  for(i in 1:length(years))
  {
    cat('\r', t, ': ', years[i])
    xmy_stat[i,t]<- sapply(years[i], search_year, term=t, USE.NAMES=FALSE)
  }
}

dst <- dist(t(xmy_stat[,2:ncol(xmy_stat)]))
hc <- hclust(dst)
plot(hc, hang = -1, ylab = 'nummber of articles')
