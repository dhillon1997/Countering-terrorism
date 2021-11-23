library(tm)
library(igraph)
twitter_data = read.csv("C:\\Users\\Asus\\Desktop\\ai_project\\afghanistan.csv", header=TRUE,sep=",",encoding="UTF-8",stringsAsFactors=FALSE)
twitter_data$text = paste(substr(twitter_data$text,2,nchar(twitter_data$text)))
text = twitter_data$text
text_clean = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", text)
text_clean = gsub("@\\w+", "", text_clean)
text_clean = gsub("[[:punct:]]", "", text_clean)
text_clean = gsub("[[:digit:]]", "", text_clean)
text_clean = gsub("http\\w+", "", text_clean)
text_corpus<- Corpus(VectorSource(text_clean))
text_corpus = tm_map(text_corpus, tolower)
text_corpus = tm_map(text_corpus, stripWhitespace)
text_corpus = tm_map(text_corpus, PlainTextDocument)
text_corpus = Corpus(VectorSource(text_corpus))
tdm = TermDocumentMatrix(text_corpus)
m = as.matrix(tdm)
wf = rowSums(m)
m1 = m[wf>quantile(wf,probs=0.9), ]
m1 = m1[,colSums(m1)!=0]
m1[m1 > 1] = 1
termMatrix = m1 %*% t(m1)
library(igraph)
g = graph.adjacency(termMatrix, weighted = T, mode = "undirected")
g = simplify(g)
V(g)$label <- V(g)$name
V(g)$degree <- degree(g)
set.seed(3535)
layout1 = layout.fruchterman.reingold(g)
plot(g, layout=layout1)
V(g)$label.cex = 1.2 * V(g)$degree / max(V(g)$degree) + 0.2
V(g)$label.color = rgb(0.0, 0.0, 0.2, 0.8)
V(g)$frame.color = NA
egam = (log(E(g)$weight) + 0.3) / max(log(E(g)$weight) + 0.3)
E(g)$color = rgb(0.5, 0.5, 0.0, egam)
E(g)$width = egam
plot(g, layout=layout1)
