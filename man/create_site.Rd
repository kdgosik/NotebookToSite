% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_site.R
\name{create_site}
\alias{create_site}
\title{create_site}
\usage{
create_site(github_username = "kdgosik")
}
\arguments{
\item{github_username}{string of your github username to create a button to direct to your page.}
}
\description{
The function create_site is meant to make reporducible workflows easier and more standardized.  It creates
many folders commonly used in projects suchs as docs, src, results and references.  It also creates an
Rmarkdown file for a notebook as well as uses knitr to spin it into a static website.  This html
file can be easily shared with collaborators or posted on github pages.  It is already placed in
the docs folder, which the user can enable a github pages website to be created from that folder
under the repository director.
}
\seealso{
knitr
}
\author{
Kirk Gosik <kdgosik@gmail.com>
}
\keyword{knitr}
\keyword{purl}
