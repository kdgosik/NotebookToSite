#' update_site
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
#' @keywords knitr
#' @keywords purl
#' @import utils
#' @import rmarkdown
#' @importFrom knitr purl
#' @importFrom knitr spin
#' @author Kirk Gosik <kdgosik@gmail.com>


## This will be a seperate function to update the site

## needs updated!!!

update_site <- function() {

  ## check if an index file exists for the website, if not create one
  if( !{file.exists("src/index.Rmd")} ) {
    index_lines <- c('---',
                     'title: "Index"',
                     'output:',
                     '  html_document:',
                     '    toc: true',
                     '    toc_float: true',
                     '---')
    index_lines <- paste0("#'", index_lines)
    writeLines(index_lines, con = "src/index.R")
    knitr::spin("src/index.R", knit = FALSE, format = "Rmd")
  }


  ## check if a Notebook exists for website, if not creat one
  if( !{file.exists("src/Notebook.Rmd")} ) {
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
    knitr::spin("src/Notebook.R", knit = FALSE, format = "Rmd")
  }

  ## output a purl version of the notebook at each documentation level
  lapply(0:2, function(i){
    new_file <- paste0("src/Notebook_DocLevel",i,".Rmd")
    file.copy("src/Notebook.Rmd", new_file, overwrite = TRUE)
    knitr::purl(new_file, documentation = i)
    r_file <- paste0("Notebook_DocLevel", i, ".R")
    file.rename(r_file, paste0("src/", r_file))
  })

  ## copy and rename the documentation 2 level R file to the Final Notebook version
  file.copy("src/Notebook_DocLevel2.R", "src/FinalNotebook.R", overwrite = TRUE)

  ## spin Final Notebook version R file into and .Rmd file
  knitr::spin("src/FinalNotebook.R", knit = FALSE, format = "Rmd")

  ## purl individual chunks of the final notbook into separate R files
  purl_chunks("src/FinalNotebook.Rmd")

  ## render all markdown files in the src folder into html files for the website
  rmarkdown::render_site(input = "src")

}
