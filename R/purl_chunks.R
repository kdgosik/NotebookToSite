#' purl_chunks
#'
#' The function purl_chunks takes an Rmarkdown file and returns each chunk as a
#' seperate R file.  It was found on stackoverflow at
#' (https://stackoverflow.com/questions/35855837/with-knitr-preserve-chunk-options-when-purling-chunks-into-separate-files)
#'
#' @seealso knitr
#' @export
#' @param input_file String of the input file name to the Rmarkdown file that will be purlled into seperate chunks
#' @param input_path String of the path where to place the R files of each of the chunks
#' @keywords knitr
#' @keywords purl
#' @importFrom knitr purl
#' @author Kirk Gosik <kdgosik@gmail.com>


purl_chunks <- function(input_file, input_path = "src/chunks"){

  purled <- knitr::purl(input_file)    # purl original file; save name to variable
  lines <- readLines(purled)    # read purled file into a character vector of lines
  starts <- grep('^## ----.*-+', lines)    # use grep to find header row indices
  stops <- c(starts[-1] - 1L, length(lines))   # end row indices
  # extract chunk names from headers
  names <- sub('^## ----([^-]([^,=]*[^,=-])*)[,-][^=].*', '\\1', lines[starts])
  names <- ifelse(names == lines[starts], '', paste0(names)) # clean if no chunk name
  # make nice file names with chunk number and name (if exists)
  file_names <- file.path(input_path,
                          paste0(names, '.R'))
  for(chunk in seq_along(starts)){    # loop over header rows
    # save the lines in the chunk to a file
    writeLines(append("#!/usr/bin/env Rscript",
                      lines[starts[chunk]:stops[chunk]]),
               con = file_names[chunk])
  }
  unlink(purled)    # delete purled file of entire document

}

