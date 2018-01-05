#' create_site
#'
#' The function create_site is meant to make reporducible workflows easier and more standardized.  It
#' many folders commonly used in projects suchs as docs, src and references.  It also creates an
#' Rmarkdown file for a notebook as well as uses knitr to spin it into a static website.  This html
#' file can be easily shared with collaborators or posted on github pages.  It is already placed in
#' the docs folder, which the user can enable a github pages website to be created from that folder
#' under the repository director.
#'
#' @seealso knitr
#' @export
#' @param github_username string of your github username to create a button to direct to your page.
#' @keywords knitr
#' @keywords purl
#' @import utils
#' @import rmarkdown
#' @importFrom knitr purl
#' @importFrom knitr spin
#' @author Kirk Gosik <kdgosik@gmail.com>



create_site <- function(github_username = "kdgosik") {

  create_these <- c("src", "references", "docs", "results",
                    "src/images", "src/html", "src/chunks")
  for( d in create_these ) dir.create(d, showWarnings = FALSE)

  try({
    ## reproducible workflow image backgroud found at the ebook The Practice of Reproducible Research
    download.file(url = "github.com/kdgosik/NotebookToSite/inst/images/cboettig.png",
                  destfile = "src/images/cboettig.png")
  })

  ## writing a simple html button file that references my github page
  html_lines <- c("<!DOCTYPE html>",
                  "<html>",
                  paste0('<a href="https://github.com/', github_username, '"><button>My Github</button></a>'),
                  "</html>")
  writeLines(html_lines, con = "src/html/github_button.html")

  ## custom css included in the Notebook file to set backgroud of downloaded image above
  customcss_lines <- c("body{",
                       " background-image: url('images/cboettig.png');",
                       "min-height: 500px;",
                       " /* Set background image to fixed (don't scroll along with the page) */",
                       " background-attachment: fixed;",
                       "background-position: right top;",
                       "/* Set the background image to no repeat */",
                       "background-repeat: no-repeat;",
                       "/* Scale the background image to be as large as possible */",
                       "background-size: cover;",
                       "}")
  writeLines(customcss_lines, "src/custom.css")

  # writes the site yaml file
  site_lines <- c('name: "Reproducible Workflows"',
                  'output_dir: "../docs"',
                  'navbar:',
                  '  title: "Reproducible Workflows"',
                  '  left:',
                  '    - text: "Home"',
                  '      href: index.html',
                  '    - text: "Notebook"',
                  '      href: Notebook.html')
  writeLines(site_lines, "src/_site.yml")

  ## create index file for website
  index_lines <- c('---',
                   'title: "Index"',
                   'output:',
                   '  html_document:',
                   '    toc: true',
                   '    toc_float: true',
                   '---')
  index_lines <- paste0("#'", index_lines)
  writeLines(index_lines, con = "src/index.R")
  spin("src/index.R", knit = FALSE, format = "Rmd")


  ## creating Notebook Rmarkdown file
  template_lines <- c('---',
                      'title: "Notebook"',
                      'output:',
                      '  html_document:',
                      '    toc: true',
                      '    toc_float: true',
                      '    css: custom.css',
                      '    includes:',
                      '      in_header: html/github_button.html',
                      '---',
                      '',
                      '## Comments',
                      'I need to add markdown comments here',
                      '[Picture Credit](https://www.practicereproducibleresearch.org/case-studies/cboettig.html)',
                      '')

  template_lines <- paste0("#'", template_lines)
  code_lines <- c('```{r NotebookSetup, include=FALSE}',
                  'knitr::opts_chunk$set(echo = TRUE)')
  template_lines <- c(template_lines, code_lines)
  writeLines(template_lines, con = "src/Notebook.R")
  spin("src/Notebook.R", knit = FALSE, format = "Rmd")


  ## output a purl version of the notebook at each documentation level
  lapply(0:2, function(i){
    new_file <- paste0("src/Notebook_DocLevel",i,".Rmd")
    file.copy("src/Notebook.Rmd", new_file, overwrite = TRUE)
    purl(new_file, documentation = i)
    r_file <- paste0("Notebook_DocLevel", i, ".R")
    file.rename(r_file, paste0("src/", r_file))
  })

  ## copy and rename the documentation 2 level R file to the Final Notebook version
  file.copy("src/Notebook_DocLevel2.R", "src/FinalNotebook.R", overwrite = TRUE)

  ## spin Final Notebook version R file into and .Rmd file
  spin("src/FinalNotebook.R", knit = FALSE, format = "Rmd")

  ## purl individual chunks of the final notbook into separate R files
  purl_chunks("src/FinalNotebook.Rmd")

  ## render all markdown files in the src folder into html files for the website
  rmarkdown::render_site(input = "src")

}
