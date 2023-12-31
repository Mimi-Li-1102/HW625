% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/help_functions.R
\name{obtain_p_value}
\alias{obtain_p_value}
\title{obtain_p_value}
\usage{
obtain_p_value(model)
}
\arguments{
\item{model}{linear model object}
}
\value{
p values corresponding to each t-statistic for the linear model
}
\description{
This function provides the p-values corresponding to the t-statistics for each coefficient in the linear model.
}
\examples{
data(mtcars)
example_model <- lm(mpg ~ hp + wt, data = mtcars)

#obtain p values
obtain_p_value(example_model)
}
