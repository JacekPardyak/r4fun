library(rgl)
library(devout)
library(devoutrgl)
library(ggrgl)
library(ggplot2)
library(dplyr)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Load the Stanford Bunny object and manually convert to a data.frame
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
obj <- rgl::readOBJ("./content/post/2022-09-18-bunny/bunny.obj")

?rgl::surface3d

verts <- t(obj$vb)
faces <- t(obj$it)

verts_df <- as_tibble(as.data.frame(verts[,-4])) %>%
  mutate(idx = seq(n()))

faces_df <- tibble(
  v1 = c(faces[,1], faces[,2]),
  v2 = c(faces[,2], faces[,3])
)


obj_df <- faces_df %>% 
  left_join(verts_df, by = c(v1 = 'idx')) %>%
  rename(x = V1, y = V2, z = V3) %>%
  left_join(verts_df, by = c(v2 = 'idx')) %>%
  rename(xend = V1, yend = V2, zend = V3)



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Draw a segment for each edge.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
p <- ggplot(obj_df) + 
  geom_segment_3d(aes(x=x, y=y, z=z, xend=xend, yend=yend, zend=zend), size = 0.2) +
  labs(
    title = "Wireframe Stanford Bunny",
    subtitle = "ggrgl::geom_segment_3d() with {devoutrgl}"
  ) + 
  theme_ggrgl() + 
  theme(legend.position = 'none') +
  coord_equal()

p

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Render Plot in 3d with {devoutrgl}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
devoutrgl::rgldev(fov = 30, view_angle = -30, zscale = 3.5)
p
invisible(dev.off())

