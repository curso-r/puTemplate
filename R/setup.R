#' setup power up
#'
#' Cria o esqueleto para um power-up em uma pasta.
#'
#' @param name nome do PU, que será transformado em pu."name".
#' @param dir pasta para criar o power-up. A última parte é o nome do PU. Recomenda-se fazer na forma pu.XXX, em camelCode.
#'
#' @import devtools
#' @export
pu_setup <- function(name, dir = '.') {
  parent_dir <- normalizePath(dirname(dir), winslash = "/", mustWork = TRUE)
  zip_file <- system.file('template/proj.zip', package = 'puTemplate', mustWork = TRUE)
  utils::unzip(zip_file, exdir = dir)
  readme <- system.file('template/README.Rmd', package = 'puTemplate', mustWork = TRUE)
  rmarkdown::render(readme, output_format = rmarkdown::md_document(),
                    output_dir = dir, quiet = TRUE)
  arq_rstudio <- dir(dir, pattern = 'proj\\.Rproj', full.names = TRUE)
  file.rename(arq_rstudio, sprintf('%s/%s.Rproj', dir, name))
  invisible(TRUE)
}
