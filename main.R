getwd()
library(stringr)
library(tidyverse)
dirs <- paste0('Region_',1:8,'/')

getExtension <- function(x){
  desde <- which(strsplit(x[1], '')[[1]]== '.')
  hasta <- nchar(x)
  extension <- substr(x, desde, hasta)
  return(extension)
}


idx_to_save <- c('.dbf', '.prj', '.shp', '.shx')
years <- 2010:2020
regions <- 1:8

falta <- NULL
for (reg in 1:8) {
  # reg <- 1
  archivos <- list.files(dirs[reg], full.names = TRUE)
  for (ye in 1:length(years)) {
    # ye <- 2
    patron <- as.character(years[ye])
    idx    <- str_detect(archivos, patron)
    nombre <- paste0('Reg', reg, '_', years[ye])
    if (sum(idx) != 0) {
      extension <- getExtension(archivos[idx])
      to_change <- paste0(nombre, extension)
      idx_to_clean <- extension %in% idx_to_save
      file.rename(archivos[idx][idx_to_clean], to_change[idx_to_clean])
      zip(paste0(nombre, '.zip'), to_change[idx_to_clean])
      file.remove(c(to_change[idx_to_clean], archivos[idx][!idx_to_clean]))
    }else {
      falta <- c(falta, nombre)
    }
  }
}
write.table(falta, file = 'faltantes.txt')
