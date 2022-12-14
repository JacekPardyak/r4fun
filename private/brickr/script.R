library(tidyverse)
library(brickr)

'https://upload.wikimedia.org/wikipedia/commons/1/1b/R_logo.svg' %>%
  inkscaper::inx_svg2png() %>%
  png::readPNG(native = TRUE) %>%
  grid::rasterGrob(interpolate=TRUE) %>% {
    ggplot() +
      annotation_custom(., xmin=-Inf, xmax=Inf, ymin=-Inf, ymax=Inf)}

'https://upload.wikimedia.org/wikipedia/commons/1/1b/R_logo.svg' %>%
  inx_svg2png() %>%
  png::readPNG(native = FALSE) %>% 
  image_to_mosaic(
    img_size = c(72, 56), # width = 724; height = 561
    use_bricks = c('1x1'),
    #color_palette = 'bw'
    ) %>% 
  build_mosaic()
  

