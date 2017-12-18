# This R file accomanies the .Rmd blog post
# _source/my-mathematics-genealogy/2017-01-10-my-mathematics-genealogy.Rmd

data <- jsonlite::fromJSON("output.JSON")

library(igraph)
ancestry_adj_mat <- sapply(data$children, function(x) is.element(data$id, x))
ancestry_graph <- graph_from_adjacency_matrix(ancestry_adj_mat)
V(ancestry_graph)$name <- data$name

plot(make_ego_graph(ancestry_graph, 18, 1)[[1]],
     layout = layout.reingold.tilford(make_ego_graph(ancestry_graph, 18, 1)[[1]],
                                      flip.y = FALSE, circular = FALSE),
     vertex.shape = "none",
     vertex.label.cex = 0.5,
     vertex.label.degree = pi/2,
     edge.arrow.size = 0.2,
     edge.arrow.mode = "-")
