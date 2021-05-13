#By using this code you can search a term in pubmed and visualise it by year of publication
library(rentrez)
library("RColorBrewer")
library(ggplot2)
search_year <- function(year, term){
  query <- paste(term, "AND (", year, "[PDAT])")
  entrez_search(db="pubmed", term=query, retmax=0)$count
}
terms <- c('bioinformatics')
years  <- seq(1950,2020,1)
#my_stat<-matrix(0,length(years),length(terms),byrow = T)
my_stat<- data.frame(years = seq(1950,2020,1), Bioinformatics = 0)
rownames(my_stat) <- my_stat$years
for(t in 1:length(terms))
{
  r_search <- entrez_search(db="pubmed", term=terms[t])
#  r_search
  for(i in 1:length(years))
  {
    cat('\r', years[i])
    my_stat[i,t]<- sapply(years[i], search_year, term=terms[t], USE.NAMES=FALSE)
  }
}

ggplot(data = my_stat, aes(x = years, y = log10(bioinformatics))) + geom_line() + 
theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"))
