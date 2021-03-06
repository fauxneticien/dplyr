% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/case_when.R
\name{case_when}
\alias{case_when}
\title{A general vectorised if}
\usage{
case_when(...)
}
\arguments{
\item{...}{A sequence of two-sided formulas. The left hand side (LHS)
determines which values match this case. The right hand side (RHS)
provides the replacement value.

The LHS must evaluate to a logical vector. The RHS does not need to be
logical, but all RHSs must evaluate to the same type of vector.

Both LHS and RHS may have the same length of either 1 or \code{n}. The
value of \code{n} must be consistent across all cases. The case of
\code{n == 0} is treated as a variant of \code{n != 1}.

These dots support \link[rlang:tidy-dots]{tidy dots} features.}
}
\value{
A vector of length 1 or \code{n}, matching the length of the logical
input or output vectors, with the type (and attributes) of the first
RHS. Inconsistent lengths or types will generate an error.
}
\description{
This function allows you to vectorise multiple \code{if} and \code{else if}
statements. It is an R equivalent of the SQL \code{CASE WHEN} statement.
}
\examples{
x <- 1:50
case_when(
  x \%\% 35 == 0 ~ "fizz buzz",
  x \%\% 5 == 0 ~ "fizz",
  x \%\% 7 == 0 ~ "buzz",
  TRUE ~ as.character(x)
)

# Like an if statement, the arguments are evaluated in order, so you must
# proceed from the most specific to the most general. This won't work:
case_when(
  TRUE ~ as.character(x),
  x \%\%  5 == 0 ~ "fizz",
  x \%\%  7 == 0 ~ "buzz",
  x \%\% 35 == 0 ~ "fizz buzz"
)

# All RHS values need to be of the same type. Inconsistent types will throw an error.
# This applies also to NA values used in RHS: NA is logical, use
# typed values like NA_real_, NA_complex, NA_character_, NA_integer_ as appropriate.
case_when(
  x \%\% 35 == 0 ~ NA_character_,
  x \%\% 5 == 0 ~ "fizz",
  x \%\% 7 == 0 ~ "buzz",
  TRUE ~ as.character(x)
)
case_when(
  x \%\% 35 == 0 ~ 35,
  x \%\% 5 == 0 ~ 5,
  x \%\% 7 == 0 ~ 7,
  TRUE ~ NA_real_
)
# This throws an error as NA is logical not numeric
\dontrun{
case_when(
  x \%\% 35 == 0 ~ 35,
  x \%\% 5 == 0 ~ 5,
  x \%\% 7 == 0 ~ 7,
  TRUE ~ NA
)
}

# case_when is particularly useful inside mutate when you want to
# create a new variable that relies on a complex combination of existing
# variables
starwars \%>\%
  select(name:mass, gender, species) \%>\%
  mutate(
    type = case_when(
      height > 200 | mass > 200 ~ "large",
      species == "Droid"        ~ "robot",
      TRUE                      ~  "other"
    )
  )

# Dots support splicing:
patterns <- list(
  x \%\% 35 == 0 ~ "fizz buzz",
  x \%\% 5 == 0 ~ "fizz",
  x \%\% 7 == 0 ~ "buzz",
  TRUE ~ as.character(x)
)
case_when(!!!patterns)
}
