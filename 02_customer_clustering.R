###
### Clustering methods
###


###
### Initialization
###
rm(list = ls(all.names = TRUE))
gc()
library("data.table")
library("ggplot2")
#library(dplyr)
#library("plotly")
library("dendextend")
#library("purrr")

library(factoextra)

###
### Preprocessing
###
customer_data <- readRDS("./data/customer_data.rds")
input_data <- customer_data
input_data[, gender := NULL]

cor(input_data)

input_data <- apply(input_data, 2 , function(x){
  (x - min(x)) / (max(x) - min(x))
})


###
### K-means clustering
###

### elbow
# set.seed(42)
# n_centers <- 1:10
# tot_withinss <- map_dbl(n_centers, function(k){
#   model <- kmeans(input_data, centers = k, nstart = 25)
#   model$tot.withinss
# })
# plot(n_centers, tot_withinss, type = "b")
fviz_nbclust(input_data, kmeans, method = "wss", nstart = 25)
kmeans_model_4 <- kmeans(input_data, centers = 4, nstart = 25)
fviz_cluster(kmeans_model_4, data = input_data,
             geom = "point",
             ellipse.type = "convex")

### silhouette
fviz_nbclust(input_data, kmeans, method = "silhouette", nstart = 25)
kmeans_model_9 <- kmeans(input_data, centers = 9, nstart = 25)
fviz_cluster(kmeans_model_9, data = input_data,
             geom = "point",
             ellipse.type = "convex")

### k-means model
customer_data$kmeans_cluster <- factor(kmeans_model_4$cluster)

ggplot(customer_data, aes(x = spending_score, y = income, color = kmeans_cluster)) +
  geom_point()

ggplot(customer_data, aes(x = age, y = income, color = kmeans_cluster)) +
  geom_point()

ggplot(customer_data, aes(x = age, y = spending_score, color = kmeans_cluster)) +
  geom_point()

# plot_ly(x = customer_data$age, y = customer_data$spending_score,
#         z = customer_data$income, color=customer_data$kmeans_cluster,
#         type = "scatter3d", mode = "markers") %>%
#   layout(scene = list(xaxis = list(title = "age"),
#                       yaxis = list(title = "spending_score"),
#                       zaxis = list(title = "income")))

### restricted k-means model
fviz_nbclust(input_data[, 2:3], kmeans, method = "wss", nstart = 25)
kmeans_model_restricted_5 <- kmeans(input_data[, 2:3], centers = 5, nstart = 25)
fviz_cluster(kmeans_model_restricted_5, data = input_data[, 2:3],
             geom = "point",
             ellipse.type = "convex")