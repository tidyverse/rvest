% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/html.R
\name{html_name}
\alias{html_name}
\alias{html_attr}
\alias{html_attrs}
\title{Get name and attributes from elements}
\usage{
html_name(x)

html_attr(x, name, default = NA_character_)

html_attrs(x)
}
\arguments{
\item{x}{A document, node, or node set.}

\item{name}{Name of attribute to retrieve.}

\item{default}{A string used as a default value when the attribute does
not exist in every element.}
}
\value{
A character vector (for \code{html_attr()} and \code{html_tag()}) or
a list (\code{html_attrs()}) the same length as \code{x}
}
\description{
\code{html_name()} gets the tag name, \code{html_attr()} gets a single attribute,
and \code{html_attr()} gets all attributes.
}
\examples{
url <- "https://en.wikipedia.org/wiki/The_Lego_Movie"
movie <- read_html(url)
cast <- html_elements(movie, "tr:nth-child(8) .plainlist a")

html_name(cast)
html_attrs(cast)
html_attr(cast, "href")

# If needed, use url_absolute() to convert to complete urls
url_absolute(html_attr(cast, "href"), url)
}