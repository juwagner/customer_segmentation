###
### Analysis of the Mall-Customer data
###


###
### Initialization
###
rm(list = ls(all.names = TRUE))
gc()
library("data.table")
library("ggplot2")
library("dplyr")


###
### Data cleaning
###
customer_data <- fread("./data/Mall_Customers.csv")
str(customer_data)
head(customer_data)
customer_data[, CustomerID := NULL]
setnames(customer_data, old = names(customer_data),
         new = c("gender", "age", "income", "spending_score"))
any(is.na(customer_data))
customer_data$gender <- factor(customer_data$gender)
summary(customer_data)
saveRDS(customer_data, "./data/customer_data.rds")

###
### Data analysis
###

### gender
dt_pie <- customer_data[, .N, by = gender]
dt_pie[, prop := round(100 * N / sum(N), 2)]
dt_pie[, pos := cumsum(prop) - 0.5 * prop]
ggplot(dt_pie, aes(x = "", y = prop, fill = gender)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start = 0) +
  theme_void() +
  geom_text(aes(y = pos, label = paste0(prop, " % \n", N))) +
  scale_fill_manual("Gender", values = c("#CD534CFF", "#0073C2FF")) +
  labs(title = "Gender ratio")

### age
ggplot(customer_data, aes(x = age)) +
  geom_bar() +
  labs(title = "Age distribution")

ggplot(customer_data, aes(x = age)) +
  geom_histogram(binwidth = 5) +
  labs(title = "Age distribution - compressed")

ggplot(customer_data, aes(x = "", y = age)) +
  geom_violin() +
  geom_jitter(alpha = 0.2, width = 0.2) +
  facet_grid(cols = vars(gender)) +
  labs(title = "Age distribution by gender", x = "")

### income
ggplot(customer_data, aes(x = "", y = income)) +
  geom_violin() +
  geom_jitter(alpha = 0.2, width = 0.2) +
  labs(title = "Income distribution", x = "")

ggplot(customer_data, aes(x = "", y = income)) +
  geom_violin() +
  geom_jitter(alpha = 0.2, width = 0.2) +
  facet_grid(cols = vars(gender)) +
  labs(title = "Income distribution by gender", x = "")

ggplot(customer_data[, .("avg_income_per_age" = mean(income)), by = age],
       aes(x = age, y = avg_income_per_age)) +
  geom_point() +
  geom_line(linetype = "dashed") +
  geom_smooth(se = FALSE) +
  labs(title = "Average income per age")


### spending score
ggplot(customer_data, aes(x = spending_score)) +
  geom_histogram(binwidth = 5) +
  labs(title = "Spending score distribution - compressed")

ggplot(customer_data, aes(x = "", y = spending_score)) +
  geom_violin() +
  geom_jitter(alpha = 0.2, width = 0.2) +
  facet_grid(cols = vars(gender)) +
  labs(title = "Spending score distribution by gender", x = "")

ggplot(customer_data[, .("avg_spending_score_per_age" = mean(spending_score)),
                     by = age], aes(x = age, y = avg_spending_score_per_age)) +
  geom_point() +
  geom_line(linetype = "dashed") +
  geom_smooth(se = FALSE) +
  labs(title = "Average spending score per age")