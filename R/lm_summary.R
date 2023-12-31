#'lm_summary
#'
#' @description
#' This function produces output similar to `summary()`, with an additional parameter for specifying the confidence level.
#' The result includes an extra column providing confidence intervals and an additional column indicating the significance of the p-value for each coefficient, determined by the specified confidence level.
#'
#' @param model linear model object
#' @param Clevel the confidence level for the intervals. Default is 0.95.
#' @return summary information of coefficients, residuals, and additional model information.
#' @examples
#' data(mtcars)
#' example_model <- lm(mpg ~ hp + wt, data = mtcars)
#'
#' #obtain summary of the linear model
#' lm_summary(example_model)
#' @export
lm_summary <- function(model, Clevel = 0.95) {
  # Calculate coefficients, standard errors, t-stats, and p-values
  coeff <- coef(model)
  se <- obtain_se(model)
  t_stats <- obtain_t_stats(model)
  p_values <- obtain_p_value(model)

  # Calculate confidence intervals
  z_value <- qnorm(1 - (1 - Clevel) / 2)
  lower_b <- coeff - z_value * se
  upper_b <- coeff + z_value * se

  # Determine significance
  significant <- p_values < (1 - Clevel)


  # Obtain the formula of the model
  formula <- as.character(formula(model))

  # Print the model formula
  cat("Call:\n")
  cat(formula, "\n", "\n")


  # Print the formatted coefficient table
  cat("Coefficients:\n")
  cat(sprintf("%-12s %-12s %-12s %-12s %-12s %-12s %-12s\n", "Coefficient", "Esti.", "SE", "CI", "t_Stat", "p_Value", "Signif."))
  for (i in seq_along(coeff)) {
    cat(sprintf("%-11s %-11.4f %-11.4f %-11s %-11.4f %-11s %-11s\n",
                names(coeff)[i], coeff[i], se[i],
                sprintf("(%0.3f, %0.3f)", lower_b[i], upper_b[i]),
                t_stats[i],
                format(p_values, digits = 4, scientific = TRUE)[i],
                ifelse(significant[i], "TRUE", "FALSE")))
  }

  # Obtain residuals information
  residual <- model$residuals
  min_r <- min(residual)
  q1_r <- quantile(residual, 0.25)
  median_r <- median(residual)
  q3_r <- quantile(residual, 0.75)
  max_r <- max(residual)
  residual_info <- obtain_residual_info(model)

  # Print residuals information
  cat("\nResiduals:\n")
  cat(sprintf("%-15s %-15s %-15s %-15s %-15s\n", "Min", "1Q", "Median", "3Q", "Max"))
  cat(sprintf("%-15.3f %-15.3f %-15.3f %-15.3f %-15.3f\n", min_r, q1_r, median_r, q3_r, max_r))

  cat("Residual standard error:", round(residual_info$residual_se, 4), "on", residual_info$df_resi, "degrees of freedom\n")

  # Obtain other information of the model
  r_squared_info <- obtain_r_square(model)
  f_stat_info <- obtain_f_stats(model)

  # Print other information of the model
  cat("\nMultiple R-squared:", round(r_squared_info$r_square, 4), ",\tAdjusted R-squared:", round(r_squared_info$adj_r_square, 4), "\n")
  cat("F-statistic:", round(f_stat_info$f_statistic, 4), "on", f_stat_info$df_model, "and", f_stat_info$df_resi, "DF,  p-value:", format(f_stat_info$p_value, scientific = TRUE), "\n")

  # Create a summary table with coefficients, intervals, and significance
  summary_table <- data.frame(
    Coefficient = names(coeff),
    Estimate = coeff,
    SE = se,
    CI = sprintf("(%0.4f, %0.4f)", lower_b, upper_b),
    t_Stat = t_stats,
    p_Value = format(p_values, digits = 4, scientific = TRUE),
    Significant = significant
  )

  # Return the summary table invisibly
  invisible(summary_table)
}

