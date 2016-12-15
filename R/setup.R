#' setup power up
#'
#' Cria o esqueleto para um power-up em uma pasta
#'
#' @param path pasta para criar o power-up. A última parte é o nome do power-up. Recomenda-se fazer na forma puXXX, em camelCode.
#' @param rstudio criar arquivo .Rproj?
#'
#' @import devtools
#'
#' @export
pu_setup <- function(path = '.', rstudio = TRUE) {
  parent_dir <- normalizePath(dirname(path), winslash = "/",
                              mustWork = TRUE)
  dir.create(file.path(path, 'figure'), showWarnings = FALSE)
  dir.create(file.path(path, 'data'), showWarnings = FALSE)
  dir.create(file.path(path, 'R'), showWarnings = FALSE)
  if (rstudio) {
    proj <- system.file('template/proj.Rproj', package = 'puTemplate', mustWork = TRUE)
    file.copy(proj, sprintf('%s/%s.Rproj', path, basename(path)))
    ugi(c(".Rproj.user", ".Rhistory", ".RData"), directory = path)
  }
  readme <- system.file('template/README.Rmd', package = 'puTemplate', mustWork = TRUE)
  rmarkdown::render(readme,
                    output_format = rmarkdown::md_document(),
                    output_dir = path, quiet = TRUE)
  invisible(TRUE)
}

#' copia de use_git_ignore
#'
#' @param ignores lista dos ignores a serem adicionados.
#' @param directory diretorios.
#' @param pkg objeto do tipo pacote.
#'
#' @export
ugi <- devtools:::use_git_ignore
