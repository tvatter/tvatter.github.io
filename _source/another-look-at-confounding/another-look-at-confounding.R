# This R file accomanies the .Rmd blog post
# _source/another-look-at-confounding/2017-03-29-another-look-at-confounding.Rmd

require(igraph)

el <- matrix( c("Z", "X", "Z", "Y"), nc = 2, byrow = TRUE)
g <- graph_from_edgelist(el)
plot(g, ylim = c(-1,1)*3, xlim = c(-1,1)*3,
     layout=layout_as_tree, 
     edge.width=3,
     edge.color="black",
     vertex.size=100,
     vertex.label.cex=2,
     vertex.color= "white", 
     vertex.label.color= "black")


n <- 1e4
z <- rnorm(n)*2
x <- z + rnorm(n)
y <- abs(z)  + rnorm(n)
cor(x,y)
cor(x[z>0],y[z>0])
cor(x[z<0],y[z<0])