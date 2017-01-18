#' Cria repositorio PU
#'
#' Cria repositório, clona, cria branch e roda \code{\link{pu_setup}}.
#'
#' A função só funciona se você tiver um GITHUB_PAT funcional e
#' o travis funcionando perfeitamente na máquina.
#'
#' @param name nome do repositório criado.
#' @param dir diretório em que o repo será criado.
#' @param github_pat github personal access token.
#'
#' @export
pu_create <- function(name, dir = '.', github_pat = NULL) {
  if (is.null(github_pat)) github_pat <- devtools::github_pat(TRUE)
  if (is.null(github_pat)) stop('github PAT not found.')
  if (!stringr::str_detect(name, '^pu\\.')) stop('name precisa comecar com "pu."')
  url <- sprintf('https://api.github.com/orgs/curso-r/repos?access_token=%s', github_pat)
  httr::POST(url, body = list(
    name = name, auto_init = TRUE, license_template = 'mit'
  ), encode = 'json')
  system(sprintf('git clone https://%s@github.com/curso-r/%s.git %s/%s', github_pat, name, dir, name))
  old_wd <- normalizePath(getwd())
  setwd(sprintf('%s/%s', dir, name))
  system(sprintf('git checkout --orphan content'))
  system('git rm -rf .')
  cat('<html></html>', file = 'index.html')
  system('git add -A')
  system('git commit -m "placeholder"', ignore.stdout = TRUE)
  system('git push --set-upstream origin content', ignore.stderr = TRUE, ignore.stdout = TRUE)
  system(sprintf('git checkout master'), ignore.stdout = TRUE, ignore.stderr = TRUE)
  system(sprintf('travis login --github-token "%s"', github_pat))
  Sys.sleep(5)
  system('travis enable')
  system('travis enable')
  str_travis <- 'travis encrypt GITHUB_PAT="%s"'
  tk <- system(sprintf(str_travis, github_pat), intern = TRUE)
  setwd(old_wd)
  suppressMessages(pu_setup(name, sprintf('%s/%s', dir, name)))
  arq_travis <- sprintf('%s/%s/.travis.yml', dir, name)
  txt <- readr::read_file(arq_travis)
  txt <- stringr::str_replace(txt, 'A_LONG_ENCRYPTED_STRING', tk)
  cat(txt, file = arq_travis)
  setwd(sprintf('%s/%s', dir, name))
  system('git add -A')
  system('git commit -m "setup inicial"', ignore.stdout = TRUE)
  system('git push', ignore.stderr = TRUE, ignore.stdout = TRUE)
  setwd(old_wd)
  invisible()
}


